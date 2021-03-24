# -*- coding: utf-8 -*-
"""
Created on Tue Aug 18 10:02:01 2020
@brief: Control the state and speed of adiMotor

@description: Capture commands from the user, via GUI or
CLI, and translate them to serial command. Constants are
used to construct commands.

@author: Tom Sharkey
@last-modified: 2020-11-09
"""
import logging
import traceback

import time

import numpy as np

# Create or get the logger
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)
file_handler = logging.FileHandler('logfile.log')
formatter = logging.Formatter('%(asctime)s : %(levelname)s : %(name)s :%(funcName)20s(): %(message)s')
file_handler.setFormatter(formatter)
logger.addHandler(file_handler)

# motor command bytes
START_BYTE = 255
SET_BUFFER_NUM = 53
SET_BUFFER_LENGTH = 64
SET_SINGLE_TRIG = 203
SET_AUTO_TRIG = 201
SET_TRIG_DELAY = 204
SET_VAR_ADR = 54
TRANSMIT_STATE = 65
SET_DOWN_SAMPLING = 52
CONFIG = 70
SYS_CMD = 80
START = 81
STOP = 82
SET_SPEED = 90


class LVMotor:
    """Low voltage motor state and speed control.
    Initialised with "serial" reference to send commands."""

    def __init__(self, parent, serial_queue):
        self.parent = parent
        self.speed = 0
        self.started = False
        self.serial_queue = serial_queue

        # initialise motor plotting params from parent config file
        self.buffer_num = self.parent.config["buffer_num"]
        self.nBytes = self.parent.config["float_bytes"]
        self.buffer_size = self.parent.config["buffer_size"]
        self.total_buffer = self.parent.config["total"]
        self.down_samp_factor = self.parent.config["down_sample"]
        self.step = self.down_samp_factor * self.parent.config["step"]
        self.t = np.arange(self.step, (self.buffer_size + 1 / 4) * self.step, self.step)

        # motor current addresses
        self.float_addrs = [self.parent.config["float_address1"], self.parent.config["float_address2"]]
        self.raw_addrs = [self.parent.config["raw_address1"], self.parent.config["raw_address2"]]

        # motor variables
        self.iscale = self.parent.config["iscale"]
        self.rot_dir = self.parent.config["rot_dir"]
        self.rpm_max = self.parent.config["rpm_max"]

    def __str__(self):
        return f"Motor object with characteristics:\n" \
               + f" -running: {self.isRunning()}\n" \
               + f" -serial_queue: {self.serial_queue}\n" \
               + f" -speed: {self.speed}\n" \
               + f" -mode: {self.parent.mode_cmd}\n"

    def isRunning(self) -> bool:
        return self.speed != 0

    def getX(self):
        return self.t

    def updateX(self, buffer_size=200, buffer_num=2, nBytes=8, type="float"):
        self.buffer_size = buffer_size
        self.buffer_num = buffer_num
        self.nBytes = nBytes

        self.total_buffer = self.buffer_size * self.nBytes * self.buffer_num
        self.step = self.down_samp_factor * self.parent.config["step"]  # step always predefined
        self.t = np.arange(self.step, (self.buffer_size + 1 / 4) * self.step, self.step)
        self.serial_queue.type = type
        self.serial_queue.updateTotal(self.total_buffer)

    def enable(self):
        self.serial_queue.sendAsBytes([START_BYTE, TRANSMIT_STATE, 1])        

    def start(self):
        try:
            assert (self.serial_queue.serial_conn is not None)
            if self.serial_queue.connected:
                self.started = True
                self.setSpeed(speed=0)
                self.serial_queue.sendAsBytes([START_BYTE, SYS_CMD, START])
                print("Starting motor")
        except AssertionError:
            traceback.print_exc()

    def stop(self):
        try:
            assert (self.serial_queue.serial_conn is not None)
            if self.serial_queue.connected:
                self.started = False
                command = [START_BYTE, SYS_CMD, STOP]
                self.setSpeed(speed=0)  # ensure motor has no speed
                self.serial_queue.sendAsBytes(command)
                print("Stopping motor")
        except AssertionError:
            traceback.print_exc()

    def setSpeed(self, speed=0):
        try:
            assert (speed >= 0)
            assert (speed <= self.parent.config["rpm_max"])
            if not self.parent.streaming:
                speed_hi, speed_lo = bytesHiLo(speed)
                command = [START_BYTE, SET_SPEED, speed_hi, speed_lo]
                logger.debug(f"Speed set message {command}")
                self.serial_queue.sendAsBytes(command)
            else:
                print("Disable plot to set speed reference")
        except AssertionError:
            logger.error(f"Speed set outside of 0-3000 range {speed}")
        
    def configure(self, mode_cmd=0):
        try:
            assert (self.serial_queue.serial_conn is not None)
            """Send configuration command to motor"""
            self.parent.vf_gain = self.parent.config["vf_gain"]
            self.parent.vf_boost = self.parent.config["vf_boost"]
            self.parent.vf_max = self.parent.config["vf_max"]
            self.parent.i_max = round((self.parent.config["i_max"] / self.parent.config["iscale"]) * (2 ** 16))
            self.parent.rate_lim = self.parent.config["rate_lim"]
            self.parent.mode_cmd = mode_cmd
            if mode_cmd == 0:
                self.parent.rpm_max = self.parent.config["rpm_max"]
            else:
                self.parent.rpm_max = self.parent.config["rpm_max_2"]  # default rpm max for all other modes

            # convert i and rpm max to 2 byte format
            i_max_hi, i_max_lo = bytesHiLo(self.parent.i_max)
            rpm_max_hi, rpm_max_lo = bytesHiLo(self.parent.rpm_max)

            config = [
                START_BYTE,
                CONFIG,
                self.parent.vf_gain,
                self.parent.vf_boost,
                i_max_hi,
                i_max_lo,
                rpm_max_hi,
                rpm_max_lo,
                self.parent.rate_lim,
                self.parent.mode_cmd,
                self.parent.rot_dir,
            ]

            logger.debug(f"Sending configuration message {config}")
            self.serial_queue.sendAsBytes(config)
        except AssertionError:
            print("Cannot configure motor mode without a serial connection (Mode 1 by default)")

    def bufferSetup(self, num_buffers=8, len_buffers=200):
        print(f"Calling buffer setup with num_buffers {num_buffers} and len_buffers {len_buffers}")
        self.parent.total = num_buffers * len_buffers
        len_hi, len_lo = bytesHiLo(len_buffers)

        self.serial_queue.sendAsBytes([START_BYTE, TRANSMIT_STATE, 0])

        self.serial_queue.sendAsBytes([START_BYTE, SET_BUFFER_NUM, num_buffers])
        
        self.serial_queue.sendAsBytes([START_BYTE, SET_BUFFER_LENGTH, len_hi, len_lo])
        self.serial_queue.sendAsBytes([START_BYTE, SET_DOWN_SAMPLING, self.down_samp_factor])
        
    def triggerSetup(self, trig_delay=100, trig_type=SET_AUTO_TRIG):
        print(f"Calling trigger setup with trig_delay {trig_delay} and trig_type {trig_type}")
        td_hi, td_lo = bytesHiLo(trig_delay)
        self.serial_queue.sendAsBytes([START_BYTE, SET_TRIG_DELAY, 0, td_lo, td_hi])
        self.serial_queue.sendAsBytes([START_BYTE, trig_type])

    def downSample(self, down_samp_factor=1):
        self.parent.down_sample = down_samp_factor
        self.down_samp_factor = down_samp_factor
        self.serial_queue.sendAsBytes([START_BYTE, SET_DOWN_SAMPLING, down_samp_factor])
        self.step = self.down_samp_factor * self.parent.config["step"]  # step always predefined
        self.t = np.arange(self.step, (self.buffer_size + 1 / 4) * self.step, self.step)

    def sendRxSetup(self, addresses, type="float"):
        if type == "uint8":
            for index, address in enumerate(addresses):
                gen = genNextAddress(address)
                add = next(gen)
                self.serial_queue.sendAsBytes([START_BYTE, SET_VAR_ADR, index] + add)

        elif type == "uint16":
            self.serial_queue.sendAsBytes([START_BYTE, TRANSMIT_STATE, 0])
            for index, address in enumerate(addresses):
                print(f"Sending rx for channel{index * 2} @address: {address}")
                logger.debug(f"Sending rx for channel{index * 4} @address: {address}")
                gen = genNextAddress(address)
                for i in range(2):
                    add = next(gen)
                    self.serial_queue.sendAsBytes([START_BYTE, SET_VAR_ADR, (index * 2) + i] + add)
            time.sleep(0.1)        
            for index, address in enumerate(addresses):                
                gen = genNextAddress(address)
                for i in range(2):
                    add = next(gen)
                    self.serial_queue.sendAsBytes([START_BYTE, SET_VAR_ADR, (index * 2) + i] + add)

        if type == "float":
            self.serial_queue.sendAsBytes([START_BYTE, TRANSMIT_STATE, 0])
            for index, address in enumerate(addresses):
                print(f"Sending rx for channel{index * 4} @address: {address}")
                logger.debug(f"Sending rx for channel{index * 4} @address: {address}")
                gen = genNextAddress(address)
                for i in range(4):
                    add = next(gen)
                    self.serial_queue.sendAsBytes([START_BYTE, SET_VAR_ADR, (index * 4) + i] + add)
            time.sleep(0.1)
            for index, address in enumerate(addresses):                                
                gen = genNextAddress(address)
                for i in range(4):
                    add = next(gen)
                    self.serial_queue.sendAsBytes([START_BYTE, SET_VAR_ADR, (index * 4) + i] + add)       
        self.serial_queue.sendAsBytes([START_BYTE, SET_DOWN_SAMPLING, self.down_samp_factor])              

# helpers
def genNextAddress(address):
    """Yields next address from initial address given (up one byte).
    Used to quickly generate addresses for use with uint16 and float.

    @example
        input -> "0x00114574"

        output (next()) -> "0x00114574"
        output (next()) -> "0x00114575"
        output (next()) -> "0x00114576"
        output (next()) -> "0x00114577"
    """
    temp = address[-8:]  # get last 8 chars
    j = 0  # tracks number of "next" calls
    while True:
        output = []
        for i in range(0, len(temp), 2):
            cur = temp[i:i + 2]
            dec = int(cur, 16)
            output.append(dec)
        output[-1] += j
        j += 1
        yield output


def bytesHiLo(word):
    """Converts from 16-bit word to 8-bit bytes, hi & lo"""
    if word > 255:  # more than 1 byte
        word_hi, word_lo = word >> 8, word & 0xFF  # high byte and low byte
    else:
        word_hi, word_lo = 0, word  # make sure two bytes always sent
    return word_hi, word_lo
