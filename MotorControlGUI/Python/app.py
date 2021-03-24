# -*- coding: utf-8 -*-
"""
Created on Tue Aug  4 17:13:54 2020

@brief: GUI application for motor control and plotting.
@description:  Python GUI built for motor control, without serial
port functionality implemented. Allows user to select COM port as source
of data, and plots the data in an animated plot.

@author: Tom Sharkey
@version 2020-29-01-008
@last-modified 2021-29-01
"""

import csv
import queue as queue
import threading
import tkinter as tk
import traceback

import matplotlib.pyplot as plt
import matplotlib.style

from libs.adiMotor import LVMotor
from libs.adiSerial import SerialQueue, DataPlotter
from libs.adiStyle import AdiStyle
from libs.adiTk import AdiWindow, \
    AdiConnectFrame, \
    AdiSpeedReferenceFrame, \
    AdiOptionsFrame, \
    AdiCanvasFrame

matplotlib.use("TkAgg")
plt.style.use("ggplot")


class GUI(AdiWindow):
    """Acts as Base Window for the GUI and as the "controller".
    Variables in this class are used to control ALL child frames
    contained within the window."""

    def __init__(self):
        AdiWindow.__init__(self, "ADI Motor Control GUI", self._closeCb)
        self.read_from_csv("motor_vars.csv")

        # ~~~~~~~~~~~~~~~~~~~~~~ VARIABLES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
        # Tkinter variables keeping track of mode, comport, rpm
        # Radio and Checkbutton variables
        self.mode_name = tk.StringVar()
        self.com_select = tk.StringVar()
        self.rpm_val = tk.IntVar()
        self.dataQ = queue.Queue()
        self.data_event = threading.Event()

        self.streaming = False
        self.logging = False
        self.threading = False

        self.saved_frames = 2

        # imported variables required application wide - motor vars
        # motor settings
        self.config = self.read_from_csv('motor_vars.csv')  # default configuration dict
        self.iscale = self.config["iscale"]
        self.rot_dir = self.config["rot_dir"]
        self.vf_gain = self.config["vf_gain"]
        self.vf_boost = self.config["vf_boost"]
        self.vf_max = self.config["vf_max"]
        self.i_max = self.config["i_max"]
        self.rpm_max = self.config["rpm_max"]
        self.rate_lim = self.config["rate_lim"]
        self.mode_cmd = self.config["mode_cmd"]

        # default serial baudrate
        self.baudrate = self.config["baudrate"]

        # float and raw addresses from config file
        self.buffer_size = self.config["buffer_size"]
        self.buffer_num = self.config["buffer_num"]
        self.float_bytes = self.config["float_bytes"]  # buffer size for floats default
        self.raw_bytes = self.config["raw_bytes"]

        # axis settings
        self.fft_ylim = self.config["fft_lim"]
        self.fft_y_lo = self.config["fft_y_lo"]
        self.fft_y_hi = self.config["fft_y_hi"]
        self.time_ylim = self.config["time_lim"]
        self.time_y_lo = self.config["time_y_lo"]
        self.time_y_hi = self.config["time_y_hi"]

        # set defaults
        self.mode_name.set("Mode " + str(self.mode_cmd))
        self.mode = self.mode_name.get()
        self.rpm_val.set(0)

        # ~~~~~~~~~~~~~~~~~~~~~~ FRAMES ~~~~~~~~~~~~~~~~~~~~~~~~~~~~ #
        # Connection frame for selecting and connecting to COM port
        self.serial_queue = SerialQueue(self, self.dataQ, self.data_event)
        self.connect_frame = AdiConnectFrame(self,
                                             self._connectionFrameCb_connected,
                                             self._connectionFrameCb_disconnected,
                                             self.serial_queue,
                                             name="Serial Connection",
                                             row=0, column=0)
        self.connect_frame.show()

        # Motor frame for adjusting motor speed via Entrybox or by adjusting scale
        self.motor = LVMotor(self, self.serial_queue)  # motor object with serial_queue reference for sending cmds
        self.motor_frame = AdiSpeedReferenceFrame(self, self.motor,
                                                  self._motorStartCb,
                                                  self._motorStopCb,
                                                  name="Motor Control",
                                                  row=1, column=0)
        self.motor_frame.show()

        # Canvas frame for plotting data based on function callback
        self.canvas_frame = AdiCanvasFrame(self, name="", row=0, column=1, rowspan=3, columnspan=3)
        self.canvas_frame.show()

        self.plotter = DataPlotter(self, self.dataQ,
                                   self.canvas_frame,
                                   self.motor,
                                   self.data_event)

        self.options_frame = AdiOptionsFrame(self, self.motor,
                                             self._toggle_plot,
                                             self._log_data,
                                             self._send_down_samp,    
                                             self._toggle_fft,
                                             self._hold_data,
                                             self._clear_data,
                                             name="Options",
                                             row=2, column=0)
        self.options_frame.show()

    # ~~~~~~~~~~~~~~~~~~~~~~~~~~~ CALLBACKS ~~~~~~~~~~~~~~~~~~~~~~~~~~ #
    #  callback functions used to give application specific
    #  functionality to generalised ADI Tkinter frames
    def _connectionFrameCb_connected(self):
        """Executed when serial connection has been established
        Used to make on the fly changes to other parts of the GUI."""
        self.motor.downSample(1)
        self.motor.configure(mode_cmd=0)
        self.motor.bufferSetup(self.float_bytes * self.buffer_num, self.buffer_size)
        self.motor.sendRxSetup(self.motor.float_addrs, type="float")        
        self.motor_frame.start_button.configure(state="normal")  # enable motor start button

        if not self.threading:
            self.threading = True
            self.serial_queue.start()
            self.plotter.start()

    def _connectionFrameCb_disconnected(self):
        self.motor_frame.start_button.configure(state="disabled")
        self.motor.stop()

    def _closeCb(self):
        """Called when the top level window "GUI" is closed
        Ensures the correct closing of serial port."""
        try:
            if tk.messagebox.askokcancel("Quit", "Do you want to quit?"):
                if self.serial_queue.connected:
                    self.motor.stop()
                    self.serial_queue.disconnect()

                root.destroy()
        except:  # make sure window is destroyed if program ends in error
            root.destroy()
            traceback.print_exc()

    def _motorStartCb(self):
        for button in self.options_frame.mode_buttons:
            button.configure(state='disabled')

    def _motorStopCb(self):
        for button in self.options_frame.mode_buttons:
            button.configure(state='normal')

    def _toggle_plot(self):
        """Callback function for enable plot radiobutton.
        Allows function to be redefined for each application."""        
        if self.serial_queue.connected:
            if not self.streaming:                
                self.motor.sendRxSetup(self.motor.float_addrs, type="float")  
                self.motor.enable()
                self.serial_queue.enable()
                self.plotter.enable()
                self.streaming = True
                self.first_frame = True

                # Deactivate motor motor commands when plotting data
                self.motor_frame.start_button["state"] = "disabled"
                self.motor_frame.start_button["bg"] = AdiStyle.COLOR_DISABLED
                self.options_frame.options_checked[1].configure(state="disabled")
                self.options_frame.submit_sampling.configure(state="disabled")

            else:
                self.serial_queue.disable()
                self.plotter.disable()
                self.streaming = False

                # Reactivate motor commands when not plotting data
                self.motor_frame.start_button["state"] = "normal"
                self.motor_frame.start_button["bg"] = "white"
                self.options_frame.options_checked[1].configure(state="normal")
                self.options_frame.submit_sampling.configure(state="normal")

    def _toggle_fft(self):
        print("Toggling to FFT")
        self.canvas_frame.toggle_fft()
        if not self.canvas_frame.fft:
            self.canvas_frame.a.set_xlabel("Time (s)")
            self.canvas_frame.fft = False
            self.canvas_frame.a.set_ylabel("Motor Current (A)")
            self.canvas_frame.a.set_title("Motor Phase Current", size="large")
            self.canvas_frame.a.set_yscale('linear')
            if self.time_ylim:
                self.canvas_frame.a.set_ylim((self.time_y_lo, self.time_y_hi))
        else:
            self.canvas_frame.fft = True
            self.canvas_frame.a.set_xlabel("Frequency (Hz)")
            self.canvas_frame.a.set_ylabel("Motor current (A)")
            self.canvas_frame.a.set_title("Motor Phase Current (FFT)", size="large")
            self.canvas_frame.a.set_yscale('log')
            if self.fft_ylim:
                self.canvas_frame.a.set_ylim((self.fft_y_lo, self.fft_y_hi))

    def _log_data(self):
        """Callback function for log data radiobutton"""
        if self.serial_queue.connected and not self.logging:
            self.plotter.start_logging()
            self.logging = True
        else:
            self.plotter.stop_logging()
            self.logging = False

    def _send_down_samp(self, down_samp):
        if self.serial_queue.connected:
            self.motor.downSample(down_samp)
        else:
            print("Must connect to serial before updating settings")

 #   def _show_raw_data(self, bRaw=True):
 #       if bRaw:
 #           self.motor.updateX(self.buffer_size, self.buffer_num, self.raw_bytes, type="int")
 #           self.motor.bufferSetup(self.raw_bytes * self.buffer_num, self.buffer_size)
 #           self.motor.sendRxSetup(self.motor.raw_addrs, type="uint16")

 #           self.canvas_frame.a.set_ylabel("Raw Current (-)")
 #           self.canvas_frame.a.set_title("Motor Phase Current", size="large")
 #       else:
 #           self.motor.updateX(self.buffer_size, self.buffer_num, self.float_bytes, type="float")
 #           self.motor.bufferSetup(self.float_bytes * self.buffer_num, self.buffer_size)
 #           self.motor.sendRxSetup(self.motor.float_addrs)

 #           self.canvas_frame.a.set_xlabel("Time (s)")
 #           self.canvas_frame.a.set_ylabel("Motor Current (A)")
 #           self.canvas_frame.a.set_title("Motor Phase Current", size="large")

    def _hold_data(self):
        self.canvas_frame.save_frame()

    def _clear_data(self):
        self.canvas_frame.clear_frames()

    @staticmethod
    def read_from_csv(file):
        config = {}
        with open(file, newline='') as csvfile:
            reader = csv.reader(csvfile, delimiter=',')
            for row in reader:
                for k, v, type, desc in [row]:
                    if type == "float":
                        v = float(v)
                    elif type == "string":
                        v = v
                    elif type == "bool":
                        v = True if v == "True" else False
                    else:
                        v = int(v)
                    config[k] = v
        return config


try:
    root = GUI()
    root.mainloop()
except:
    print("Program ended in an error")
    traceback.print_exc()
