# -*- coding: utf-8 -*-
"""
Created on Fri Aug 21 10:22:44 2020

@brief: Command line interface for motor control.
@description: Contains base CLI class with methods
for registering "commands" for use on the command line.
MotorCli extends this class with specific commands for
motor control.

@author: Tom Sharkey
@last-modified: 2020-11-09
"""

# !/usr/bin/python

import csv
import logging
import os
import queue
import sys
import threading
import time
import traceback
from datetime import timedelta

from .adiMotor import LVMotor
from .adiSerial import SerialQueue, DataReader

# Create or get the logger
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)
file_handler = logging.FileHandler('cli_logfile.log')
formatter = logging.Formatter('%(asctime)s : %(levelname)s : %(name)s :%(funcName)20s(): %(message)s')
file_handler.setFormatter(formatter)
logger.addHandler(file_handler)


class AdiCli(threading.Thread):
    """Thread which handles CLI commands entered by the user."""

    CMD_LEVEL_USER = "user"
    CMD_LEVEL_SYSTEM = "system"
    CMD_LEVEL_ALL = [
        CMD_LEVEL_USER,
        CMD_LEVEL_SYSTEM,
    ]

    def __init__(self, app_name=None, quit_cb=None, versions=None):

        # store params
        logger.debug(f"Starting cli thread")
        self.config = self.read_from_csv()
        self.app_name = app_name
        if not self.app_name:
            self.app_name = sys.argv[0]  # C:\one\two\three.py
            self.app_name = os.path.basename(self.app_name)  # three.py
            self.app_name = self.app_name.split('.')[0]  # three
        self.quit_cb = quit_cb
        self.versions = versions

        # local variables
        self.commandLock = threading.Lock()
        self.commands = []
        self.goOn = True
        self.dataQ = queue.Queue()
        self.serial = SerialQueue(self, self.dataQ)

        # initialize parent class
        threading.Thread.__init__(self)

        # give this thread a name
        self.name = 'AdiCli'

        # print banner
        print('{0} - (c) Analog Devices'.format(self.app_name))
        if self.versions:
            print('  running versions:')
            length = max([len(k) for k in self.versions.keys()])
            for (k, v) in versions.items():
                while len(k) < length:
                    k += ' '
                if type(v) in [tuple, list]:
                    v = '.'.join([str(e) for e in v])
                print('    - {0}: {1}'.format(k, v))

        # register system commands (user commands registered by child object)
        self._registerCommand_internal(
            self.CMD_LEVEL_SYSTEM,
            'help',
            'h',
            'print this menu',
            [],
            self._handleHelp,
        )
        self._registerCommand_internal(
            self.CMD_LEVEL_SYSTEM,
            'info',
            'i',
            'information about this application',
            [],
            self._handleInfo,
        )
        self._registerCommand_internal(
            self.CMD_LEVEL_SYSTEM,
            'quit',
            'q',
            'quit this application',
            [],
            self._handleQuit,
        )
        self._registerCommand_internal(
            self.CMD_LEVEL_SYSTEM,
            'uptime',
            'ut',
            'how long this application has been running',
            [],
            self._handleUptime,
        )

        self.start()

    def run(self):

        self.startTime = time.time()

        try:
            while self.goOn:

                # CLI stops here each time a user needs to call a command
                params = input('> ')
                params = params.split()
                if len(params) < 1:
                    continue

                # print usage
                if len(params) == 2 and params[1] == '?':
                    if not self._printUsageFromName(params[0]):
                        if not self._printUsageFromAlias(params[0]):
                            print(' unknown command or alias \'' + params[0] + '\'')
                    continue

                # find this command
                found = False
                with self.commandLock:
                    for command in self.commands:
                        if command['name'] == params[0] or command['alias'] == params[0]:
                            found = True
                            cmdParams = command['params']
                            cmdCallback = command['callback']
                            break

                # call its callback or print error message
                if found:
                    if len(params[1:]) == len(cmdParams):
                        cmdCallback(params[1:])
                    else:
                        if not self._printUsageFromName(params[0]):
                            self._printUsageFromAlias(params[0])
                else:
                    print(' unknown command or alias \'' + params[0] + '\'')

        except Exception as err:
            output = []
            output += ['===== crash in thread {0} ====='.format(self.name)]
            output += ['\nerror:\n']
            output += [str(err)]
            output += ['\ncall stack:\n']
            output += [traceback.format_exc()]
            output = '\n'.join(output)
            print(output)
            logger.critical(f"Output {output}")
            raise

    @staticmethod
    def read_from_csv():
        config = {}
        with open('motor_vars.csv', newline='') as csvfile:
            spamreader = csv.reader(csvfile, delimiter=',', quotechar='|')
            for row in spamreader:
                for k, v in [row]:
                    if k == "step":
                        v = float(v)
                    else:
                        v = int(v)
                    config[k] = v
        return config

    # ======================== public ==========================================

    def registerCommand(self, name, alias, description, params, callback):
        self._registerCommand_internal(
            self.CMD_LEVEL_USER,
            name,
            alias,
            description,
            params,
            callback,
        )

    # ======================== private =========================================

    def _registerCommand_internal(self, cmdLevel, name, alias, description, params, callback):

        assert cmdLevel in self.CMD_LEVEL_ALL
        assert isinstance(name, str)
        assert isinstance(alias, str)
        assert isinstance(description, str)
        assert isinstance(params, list)
        for p in params:
            assert isinstance(p, str)
        assert callable(callback)

        if self._doesCommandExist(name):
            raise SystemError("command {0} already exists".format(name))

        with self.commandLock:
            self.commands.append(
                {
                    'cmdLevel': cmdLevel,
                    'name': name,
                    'alias': alias,
                    'description': description,
                    'params': params,
                    'callback': callback,
                }
            )

    def _printUsageFromName(self, commandname):
        return self._printUsage(commandname, 'name')

    def _printUsageFromAlias(self, commandalias):
        return self._printUsage(commandalias, 'alias')

    def _printUsage(self, name, paramType):

        usageString = None

        with self.commandLock:
            for command in self.commands:
                if command[paramType] == name:
                    usageString = []
                    usageString += ['usage: {0}'.format(name)]
                    usageString += [" <{0}>".format(p) for p in command['params']]
                    usageString = ''.join(usageString)

        if usageString:
            print(usageString)
            return True
        else:
            return False

    def _doesCommandExist(self, cmdName):

        returnVal = False

        with self.commandLock:
            for cmd in self.commands:
                if cmd['name'] == cmdName:
                    returnVal = True

        return returnVal

    # === command handlers (system commands only, a child object creates more)

    def _handleHelp(self, params):
        output = []
        output += ['Available commands:']

        with self.commandLock:
            for command in self.commands:
                output += [' - {0} ({1}): {2}'.format(
                    command['name'],
                    command['alias'],
                    command['description']
                )]

        print('\n'.join(output))

    def _handleInfo(self, params):
        output = []
        output += ['This is application "{0}".'.format(self.app_name)]
        output += ['Current time is "{0}".'.format(time.ctime())]
        output += ['']
        output += ['{0} threads running:'.format(threading.activeCount())]
        threadNames = [t.getName() for t in threading.enumerate()]
        threadNames.sort()
        for t in threadNames:
            output += ['- {0}'.format(t)]
        output += ['This is thread {0}.'.format(threading.currentThread().getName())]

        print('\n'.join(output))

    def _handleQuit(self, params):

        # call the quit callback
        if self.quit_cb:
            self.quit_cb()

        # kill this thread
        self.goOn = False

    def _handleUptime(self, params):

        upTime = timedelta(seconds=time.time() - self.startTime)

        print('Running since {0} ({1} ago)'.format(
            time.strftime("%m/%d/%Y %H:%M:%S", time.localtime(self.startTime)),
            upTime,
        ))


class MotorCli(AdiCli):
    """Template extending base CLI with motor control specific commands.
    Creates a motor object which manages motor state."""

    def __init__(self, dataQ, app_name=None, quit_cb=None, versions=None):
        AdiCli.__init__(
            self,
            app_name=app_name,
            quit_cb=quit_cb,
            versions=versions,
        )

        self.dataQ = dataQ
        self.serial = SerialQueue(self, self.dataQ)
        self.motor = LVMotor(self, self.serial)
        self.reader = DataReader(self, dataQ)

        self._registerCommand_internal(
            self.CMD_LEVEL_SYSTEM,
            'connect',
            'c',
            'connect via serial port',
            ["enter serial port here: COM1"],
            self._handleConnect,
        )

        self._registerCommand_internal(
            self.CMD_LEVEL_SYSTEM,
            'disconnect',
            'dc',
            'disconnect from serial port',
            [],
            self._handleDisconnect,
        )

        self._registerCommand_internal(
            self.CMD_LEVEL_SYSTEM,
            'configuration',
            'conf',
            'send default configuration over serial',
            [],
            self._handleConfig,
        )

        self._registerCommand_internal(
            self.CMD_LEVEL_SYSTEM,
            'start',
            'start',
            'begin operation of the motor',
            [],
            self._handleStart,
        )

        self._registerCommand_internal(
            self.CMD_LEVEL_SYSTEM,
            'stop',
            'stop',
            'stop the motor',
            [],
            self._handleStop,
        )

        self._registerCommand_internal(
            self.CMD_LEVEL_SYSTEM,
            'list ports',
            'lp',
            'list available serial ports',
            [],
            self._listPorts,
        )

        self._registerCommand_internal(
            self.CMD_LEVEL_SYSTEM,
            'speed',
            's',
            'sends speed param',
            ['enter motor speed here [0-3000]'],
            self._handleSpeed,
        )

        self._registerCommand_internal(
            self.CMD_LEVEL_SYSTEM,
            'buffer setup',
            'buf',
            'sends buffer setup parameters',
            [],
            self._handleBuffers,
        )

        self._registerCommand_internal(
            self.CMD_LEVEL_SYSTEM,
            'trigger setup',
            'trig',
            'sends trigger delay and type parameters',
            ['[trig_delay (ms)]'],
            self._handleTrig,
        )

        self._registerCommand_internal(
            self.CMD_LEVEL_SYSTEM,
            'address setup',
            'addr',
            'sets address for float parameter',
            [],
            self._handleAddress,
        )

        self._registerCommand_internal(
            self.CMD_LEVEL_SYSTEM,
            'Enable Plot',
            'enable',
            'Enables streaming of plotting data',
            [],
            self._enablePlot,
        )

        self._registerCommand_internal(
            self.CMD_LEVEL_SYSTEM,
            'print read data',
            'disp',
            'Prints latest data to screen',
            [],
            self._handleRead,
        )

        self._registerCommand_internal(
            self.CMD_LEVEL_SYSTEM,
            'print raw inc data',
            'raw',
            'Prints raw rx array last 10 values and len',
            [],
            self._handleRaw,
        )

    def _handleConnect(self, params):
        com = params[0].upper()
        self.serial.connect(com)
        logger.debug(f"Connecting to {com} on cli")
        print(f"connecting to serial: {self.serial}")

    def _handleDisconnect(self, params):
        self.serial.disconnect()
        logger.debug(f"Disconnecting on cli")
        print(f"disconnecting from serial: {self.serial}")

    def _handleConfig(self, params):
        self.motor.configure()
        logger.debug(f"Configuring motor")

    def _handleStart(self, params):
        self.motor.start()

    def _handleStop(self, params):
        self.motor.stop()

    def _handleSpeed(self, params):
        self.speed = int(params[0])
        self.motor.setSpeed(self.speed)
        logger.debug(f"Setting speed {self.speed} cli")

    def _handleBuffers(self, params):
        self.num = 8
        self.len = 200
        self.motor.bufferSetup(self.num, self.len)

    def _handleTrig(self, params):
        self.delay = int(params[0])
        self.motor.triggerSetup(self.delay)

    def _handleAddress(self, params):
        self.a1 = "0x00114598"
        self.a2 = "0x0011413c"
        addresses = [self.a1, self.a2]
        self.motor.sendRxSetup(addresses, type="float", num_buffers=8, len_buffers=200)

    def _enablePlot(self, params):
        self.motor.enable()  # sends message to begin plotting
        self.serial.start()
        self.serial.enable()
        self.reader.start()
        self.reader.enable()

    def _handleRead(self, params):
        self.reader.latestData()

    def _handleRaw(self, params):
        self.serial.getRaw()

    def _listPorts(self, params):
        ports = self.serial.discover_ports()
        print("available ports: ")
        for port in ports:
            print(f"  - {port}")
