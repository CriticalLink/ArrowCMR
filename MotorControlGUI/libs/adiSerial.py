# -*- coding: utf-8 -*-
"""
Created on Mon Aug 17 10:23:20 2020

@brief: Serial class for communication over COM port.
@description: Serial connection manager with convenience
methods for connecting to serial, discovering ports
and sending data as a stream of bytes.

@author: Tom Sharkey
@last-modified: 2020-11-09
"""

import logging
import queue
import struct
import threading
import time
import traceback

import numpy as np
import pandas as pd
import serial
import serial.tools.list_ports

# constants
START_KEY = 170
START_BYTE = 255
TRANSMIT_STATE = 65

# Create or get the logger
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)
file_handler = logging.FileHandler('logfile.log')
formatter = logging.Formatter('%(asctime)s : %(levelname)s : %(name)s :%(funcName)20s(): %(message)s')
file_handler.setFormatter(formatter)
logger.addHandler(file_handler)


class SerialQueue(threading.Thread):
    """
    @brief: rx threaded queue for continuous serial communication
    @description: A variety of serial connector objects that uses a queue and thread
    structure to continuously receive data, and place data in a formatted queue, dataQ.
    This queue can be read from to plot data.
    """

    def __init__(self, parent, dataQ):
        self.connected = False
        self.comPort = None
        self.baudrate = parent.config['baudrate']
        self.serial_conn = None
        self.parent = parent

        # queueing commands out and raw data in
        self.enabled = False
        self.first = True
        self.serial_rx_queue = queue.Queue()
        self.raw = list()
        self.dataQ = dataQ  # formatted rx data for plotting

        self.TOTAL = parent.config['total']
        self.type = "float"

        threading.Thread.__init__(self, daemon=True)

    def __str__(self):
        return f"serialQueue object on {self.comPort}@{self.baudrate}"

    # serial connection & start continuous rx
    def connect(self, comPort):
        logger.info('connect')
        print("Connected to serialQ")
        self.comPort = comPort
        try:
            self.serial_conn = serial.Serial(
                self.comPort,
                baudrate=self.baudrate
            )
        except serial.SerialException:
            traceback.print_exc()
            self.disable()
        else:
            self.connected = True

    def disconnect(self):
        logger.info("disconnect")
        if self.connected:
            self.disable()
            self.serial_conn.close()
            self.connected = False
            self.comPort = ''

    def enable(self):
        self.enabled = True

    def disable(self):
        self.enabled = False
        self.sendAsBytes([START_BYTE, TRANSMIT_STATE, 0])  # stop sending data message

    def getRaw(self):
        """Look at raw incoming data, useful for debugging"""
        print(f"Raw: {len(self.raw)}, {self.raw[-10:]}")

    def getByte(self):
        if not self.serial_rx_queue.empty():
            rx_byte = self.serial_rx_queue.get()
            return rx_byte
        else:
            print("Queue is empty")

    def updateTotal(self, total):
        self.TOTAL = total

    def sendAsBytes(self, data):
        try:
            assert (self.serial_conn is not None)
            assert (self.connected)
            # print(f"Sending data: {data}")
            databytes = bytearray(data)
            self.serial_conn.write(databytes)
            logger.debug(f"Sending command over serial: raw:{data}, bytes:{databytes}")
        except AssertionError:
            print("You must connect to a serial port before configuring the motor")

    @staticmethod
    def discoverPorts():
        """Automatically discovers available comports when SerialConnector
        object is created. Returns names as list.
        Current implementation is Windows only"""
        ports = serial.tools.list_ports.comports(include_links=False)
        available_ports = []
        for port in sorted(ports):
            available_ports.append(port.device)
        return available_ports

    def run(self):
        while True:
            if self.enabled:
                # Check for bytes to receive from serial
                try:
                    while self.serial_conn.inWaiting() > 0:
                        rx_buffer_inwaiting = self.serial_conn.inWaiting()
                        self.serial_rx_queue.put(self.serial_conn.read(rx_buffer_inwaiting))
                except serial.SerialException:
                    traceback.print_exc()
                    self.disable()

                # Place stream of rx bytes in raw
                try:
                    if not self.serial_rx_queue.empty():
                        while not self.serial_rx_queue.empty():
                            for i, byte in enumerate(list(self.getByte())):
                                self.raw.append(byte)

                        # TODO: Define this as a separate function to improve readability
                        if START_KEY in self.raw:
                            index = self.raw.index(START_KEY)
                            # check for full dataframe after index (0xAA)
                            if len(self.raw[index:]) >= self.TOTAL:
                                dataframe = self.raw[index + 1:self.TOTAL + 1]  # grab data excluding index
                                formatted_data = bytesToNum(dataframe, self.type)  # one var or many
                                self.raw = self.raw[index + self.TOTAL + 1:]
                                with threading.Lock():
                                    self.dataQ.put(formatted_data)
                                logger.debug(f"dataQ: {self.dataQ.qsize()}")
                                # TODO: Call this message using motor enable
                                message = [START_BYTE, TRANSMIT_STATE, 1]  # request more data
                                self.sendAsBytes(message)
                except:
                    traceback.print_exc()


class DataPlotter(threading.Thread):
    def __init__(self, parent, dataQ, canvas_frame, motor):
        self.enabled = False
        self.dataQ = dataQ
        self.logging = False
        self.canvas_frame = canvas_frame
        self.motor = motor
        self.first_frame = True
        threading.Thread.__init__(self, daemon=True)

    def __str__(self):
        return f"DataPlotter Object with:\n -DataQ: {self.dataQ}\n "

    def run(self):
        # i = 0
        # start_time = time.time()
        while True:
            time.sleep(0.3)
            if self.enabled:
                try:
                    if not self.dataQ.empty():
                        # print(self.dataQ.qsize())
                        y = self.dataQ.get()
                        if y is None:
                            print("Skipping plot")
                            continue
                        if self.logging:
                            data = {"Phase U": y[::2],
                                    "Phase V": y[1::2]}
                            log = pd.DataFrame(data)
                            log.index = log.index + 1  # to start index at 1
                            log.to_csv('out.csv')
                        x = self.motor.getX()
                        time_sec = False
                        # if max(x) > 0.5:
                        #     print(f"Showing last x {x[-1]}, and max {max(x)}")
                        #     time_sec = True

                        # # print(f"T value: {x}")

                        self.canvas_frame.update_data("Phase U", x, y[::2])  # even members of dataQ frame
                        self.canvas_frame.update_data("Phase V", x, y[1::2])  # odd members of dataQ frame

                        # i += 1
                        # if i == 30:
                        #     uptime = time.time() - start_time
                        #     print(f"FPS: {(i / uptime)}")
                except:
                    traceback.print_exc()

    def start_logging(self):
        self.logging = True

    def stop_logging(self):
        self.logging = False

    def enable(self):
        self.enabled = True

    def disable(self):
        self.enabled = False  # ends tx rx thread


class DataReader(threading.Thread):
    """Simple Queue reader for use with CLI"""

    def __init__(self, parent, dataQ):
        self.logging = False
        self.enabled = False
        self.dataQ = dataQ
        self.y = []

        threading.Thread.__init__(self, daemon=True)

        raw_size = 1600
        BUFF_SIZE = raw_size // 8
        DOWN_SAMP_FACTOR = 1
        step = DOWN_SAMP_FACTOR * 0.0001
        self.t = np.arange(0.0001, (BUFF_SIZE + 1 / 4) * step, step)

    def run(self):
        while True:
            if self.enabled:
                try:
                    if not self.dataQ.empty():
                        self.y = self.dataQ.get()
                except:
                    traceback.print_exc()

    def start_logging(self):
        self.logging = True

    def stop_logging(self):
        self.logging = False

    def enable(self):
        print(f"Enabling dataReader {self}")
        self.enabled = True

    def disable(self):
        self.enabled = False  # ends tx rx thread

    def latestData(self):
        """Prints latest data frame - used for debug"""
        print(f"Data reader data: {self}")
        print(self.y)


def bytesToNum(data, type):
    output = None
    if type == "int":
        output = bytesToInt(data)
    elif type == "float":
        output = bytesToFloat(data)
    return output


def bytesToInt(data, signed=False):
    output = []
    out_bytes = []
    step = 2
    for j in range(0, len(data), step):
        output.append((int.from_bytes(data[j:j + step], byteorder='little', signed=signed)))
        out_bytes.append(data[j:j + step])
    return output


def bytesToFloat(data):
    try:
        output = []
        out_bytes = []
        step = 4
        for j in range(0, len(data), step):
            [x] = struct.unpack('f', bytearray(data[j:j + step]))
            output.append(x)
            out_bytes.append(data[j:j + step])
        return output
    except:
        pass
