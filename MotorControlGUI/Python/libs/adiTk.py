# -*- coding: utf-8 -*-
"""
Created on Fri Aug 14 10:12:03 2020

@brief: Library of ADI-styled Tkinter frames
@description:
    Module containing modifications of the base Tkinter building blocks:
        - Window
        - Frame
    
    As well as new templates which inherit from these blocks:
        - adiConnectFrame : For connection through serial port
        - adiSpeedReferenceFrame:
        - adiCanvasFrame
        - adiOptionsFrame

@author: Tom Sharkey
@last-modified: 2020-11-09
"""

import inspect
import logging
import math
import platform
import random
import sys
import threading
import time
import tkinter as tk
import tkinter.ttk as ttk
import traceback

import matplotlib.figure as fig
import numpy as np
import serial
import serial.tools.list_ports
from matplotlib.backends.backend_tkagg import FigureCanvasTkAgg

from .adiStyle import AdiStyle
from .adiWidgets import Button, Text, OptionMenu, Label, Scale, Entry, Radiobutton, Checkbutton, ToolTip, createToolTip

# Create or get the logger
logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)
file_handler = logging.FileHandler('logfile.log')
formatter = logging.Formatter('%(asctime)s : %(levelname)s : %(name)s :%(funcName)20s(): %(message)s')
file_handler.setFormatter(formatter)
logger.addHandler(file_handler)

VERSION = "0.1.0"


class AdiWindow(tk.Tk):
    """Tkinter Window with prebuilt adi icon
    and title description. Invoking program also gives
    a function (close_cb) to be called on window close."""

    ADI_ICON = 'app.ico'

    def __init__(self, name, close_cb):
        self.close_cb = close_cb

        tk.Tk.__init__(self)
        self.iconbitmap(self.ADI_ICON)
        self.title(name + ' ' + chr(169) + ' Analog Devices 2021')
        self.protocol('WM_DELETE_WINDOW', self._releaseAndQuit)

        self.configure(bg=AdiStyle.COLOR_BG)
        version_string = "ADI Motor Control GUI, v." + VERSION
        self.version_tag = tk.Label(self, text=version_string, bg='white')
        self.version_tag.grid(row=100, column=0, sticky='w', columnspan=4)  # always at bottom of window

    def _releaseAndQuit(self):
        """Called when the user closes the main application window.
        It closes both the GUI and the command line windows."""
        # call the callback
        self.close_cb()


class AdiFrame(tk.Frame):
    """ADI basic frame, with attached 'name' label."""

    def __init__(self, parent, name, row=0, column=0, rowspan=1, columnspan=1, padx=0, pady=0,
                 bg=AdiStyle.COLOR_BG, relief="sunken"):
        self.row = row
        self.column = column
        self.rowspan = rowspan
        self.columnspan = columnspan
        self.bg = bg
        self.relief = relief
        self.padx = padx
        self.pady = pady

        tk.Frame.__init__(
            self,
            parent,
            relief=self.relief,
            borderwidth=1.2,
            bg=bg,
        )
        temp = tk.Label(
            self,
            font=AdiStyle.FONT_HEADER,
            text=name,
            bg=AdiStyle.COLOR_BG,
        )
        temp.grid(
            row=0,
            column=0,
            columnspan=2,
            sticky='W'
        )
        temp = tk.Frame(
            self,
            bg=AdiStyle.COLOR_BG,
            relief=tk.FLAT,
        )
        temp.grid(
            row=1,
            column=0,
            padx=10,
            pady=10,
        )

        self.container = tk.Frame(
            self,
            bg=AdiStyle.COLOR_BG,
            relief=tk.FLAT,
        )
        self.container.grid(
            row=1,
            column=1,
            padx=5,
            pady=5,
        )

    def show(self):
        self.grid(
            row=self.row,
            column=self.column,
            rowspan=self.rowspan,
            columnspan=self.columnspan,
            sticky="nsew",
            padx=self.padx,
            pady=self.pady,
        )

    def hide(self):
        self.grid_forget()

    @staticmethod
    def _add(elem, row, column, columnspan=1, sticky="we", padx=0, pady=0):
        """Inserts widget into frame using grid. Configures
        widget with default font and background colour."""
        try:
            elem.configure(font=AdiStyle.FONT_BODY)
        except tk.TclError:
            pass
        try:
            elem.configure(bg=AdiStyle.COLOR_BG)
        except tk.TclError:
            pass
        elem.grid(
            row=row,
            column=column,
            columnspan=columnspan,
            sticky=sticky,
            padx=padx,
            pady=pady,
        )


class AdiConnectFrame(AdiFrame):
    """Provides widgets to connect to serial port,
    from list of connected serial ports."""

    def __init__(self, parent, connect_cb, disconnect_cb, serial, name="connection", row=0, column=0):

        # record variables
        self.parent = parent
        self.connect_cb = connect_cb
        self.disconnect_cb = disconnect_cb
        self.serial = serial
        self.available_ports = self.serial.discoverPorts()        
        if len(self.available_ports) == 0:
            self.available_ports = ["No Devices Found"]
            print(f"{self.available_ports}")
        self.comSelected = tk.StringVar()

        # init parent
        AdiFrame.__init__(
            self,
            parent,
            name,
            row,
            column,
        )

        # row 0: serial port
        self.serialFrame = tk.Frame(
            self.container,
            borderwidth=0,
            bg=AdiStyle.COLOR_BG,
        )

        temp = Label(
            self.serialFrame,
            font=AdiStyle.FONT_BODY,
            bg=AdiStyle.COLOR_BG,
            text="Port:"
        )
        self._add(temp, 1, 0)

        self.comSelect = OptionMenu(
            self.serialFrame,
            self.comSelected,
            *self.available_ports
        )
        self.comSelect.bind("<Button-1>", self.update_ports)
        self._add(self.comSelect, 1, 1)

        self.serial_button = Button(
            self.serialFrame,
            text='connect',
            command=self.connect,
        )
        self._add(self.serial_button, 1, 2)

        self.serialFrame.grid(
            row=2,
            column=1,
            sticky="ew",
        )

    def connect(self):
        try:
            if self.serial.connected:
                self.serial_button.configure(
                    text="Connect",
                    bg=AdiStyle.COLOR_BG,
                )
                self.disconnect_cb()  # ensure proper shutdown of motor
                self.serial.disconnect()  # must be called last while so cb has serial connection
            else:
                assert (len(self.comSelected.get()) != 0)
                self.serial.connect(self.comSelected.get())
                self.serial_button.configure(
                    text="Disconnect",
                    bg=AdiStyle.COLOR_NOERROR,
                )
                self.connect_cb()  # connects motor and begins serial and plotting threads
        except AssertionError:
            print("Please enter a COM port to connect to")
        except:
            traceback.print_exc()

    def update_ports(self, *args):
        self.available_ports = self.serial.discoverPorts()
        if len(self.available_ports) == 0:
            self.available_ports = ["No Devices Found"]
            print(f"{self.available_ports}")            
        self.comSelected.set('')
        self.comSelect['menu'].delete(0, 'end')
        for port in self.available_ports:
            self.comSelect['menu'].add_command(label=port, command=tk._setit(self.comSelected, port))


class AdiSpeedReferenceFrame(AdiFrame):
    """Template with scale, entry box and buttons
    for controlling motor start/stop and speed"""

    def __init__(self, parent, motor, start_cb, stop_cb, name="speed reference", row=0, column=0, rowspan=1):

        self.start_cb = start_cb
        self.stop_cb = stop_cb
        self.rpm_val = tk.IntVar()
        self.rpm_val.set(0)
        self.rpm_val.trace_add("write", self._on_update_entry)  # triggers function on entry box write
        self.started = False
        self.motor = motor
        self.parent = parent

        AdiFrame.__init__(
            self,
            parent,
            name,
            row,
            column,
            rowspan
        )

        self.temp = tk.Frame(
            self.container,
            background="white",
            width=50,
        )

        self.scaleFrame = tk.Frame(
            self.container,
            borderwidth=0,
            background="white",
        )

        self.slider = Scale(
            self.scaleFrame,
            from_=3000,
            to=0,
            orient="vertical",
            command=self._on_move_slider,
        )
        self.s = ttk.Style()
        self.s.configure("Vertical.TScale", background="white")

        self._add(self.slider, 0, 1, columnspan=3, sticky='n')

        self.slider_entry = Entry(
            self.scaleFrame,
            textvariable=self.rpm_val,
            width=5,
        )
        self._add(self.slider_entry, 1, 1, sticky='w')

        temp = Label(
            self.scaleFrame,
            font=AdiStyle.FONT_BODY,
            bg="white",
            text="[RPM]",
            padx=5,
            pady=5,
        )
        self._add(temp, 1, 2, sticky='e')

        self.start_button = Button(
            self.scaleFrame,
            text='Start',
            command=self.start_stop_motor,
            state="disabled",
        )
        self._add(self.start_button, 2, 1, columnspan=2)

        self.temp.grid(
            row=0,
            column=0,
            sticky='w',
        )

        self.scaleFrame.grid(
            row=1,
            column=2,
            sticky='w',
        )

    def start_stop_motor(self, *args):
        try:
            assert (self.parent.serial_queue.serial_conn is not None)
            if not self.started:
                self.start_button['text'] = "Stop"
                self.motor.start()
                self.started = True
                self.start_cb()
            else:
                self.start_button['text'] = "Start"
                self.motor.stop()
                self.started = False
                self.stop_cb()
        except AssertionError:
            print("Cannot start motor without a serial connection")

    def set_motor_speed(self, *args):
        speed = int(self.slider_entry.get())
        self.motor.setSpeed(speed)

    def _on_move_slider(self, *args):
        """Auto updates entry box when slider is moved"""
        try:
            self.slider_entry.delete(0, "end")
            self.slider_entry.insert(0, int(self.slider.get()))
        except:
            traceback.print_exc()

    def _on_update_entry(self, *args):
        """Auto updates slider when entry is changed"""
        try:
            val = self.slider_entry.get()
            if val != '':
                self.slider.set(int(val))
                self.set_motor_speed()
        except:
            print("Please enter a valid integer for motor speed [RPM]")


class AdiCanvasFrame(AdiFrame):
    """Template holding the updating plot for Serial data. Contains update func
    which allows the plot to be updated when new data is available"""

    def __init__(self, parent, name="plotting frame", row=0, column=0, rowspan=2, columnspan=2, padx=0, pady=0):
        AdiFrame.__init__(
            self,
            parent,
            name,
            row,
            column,
            rowspan,
            columnspan,
            padx,
            pady,
        )

        self.parent = parent
        self.f = fig.Figure(dpi=100, tight_layout=True)  # matplotlib figure to embed in tkinter
        self.a = self.f.add_subplot(111)  # axes object to plot data
        self.canvas = FigureCanvasTkAgg(  # canvas to draw lines on given figure
            self.f,
            self,
        )

        # Create initial lists for Phase U and V data
        # Updating lists is cheaper than recreating them
        self.x_data = np.array([0])
        self.y_data = np.array([0])
        line, = self.a.plot(self.x_data, self.y_data, label="Phase U")
        line2, = self.a.plot(self.x_data, self.y_data, label="Phase V")

        # create dictionary to update plotted lines by name
        self.lines = {
            "Phase U": line,
            "Phase V": line2,
        }

        self.a.legend(loc='upper right', fontsize=8)
        self.a.set_xlabel("Time (s)")
        self.a.set_ylabel("Motor Current (A)")
        self.a.set_title("Motor Phase Currents", size="large")
        self.a.set_yscale('linear')

        if self.parent.time_ylim:
            self.a.set_ylim((self.parent.time_y_lo, self.parent.time_y_hi))

        self.canvas.draw()
        self.canvas.get_tk_widget().grid(
            row=0,
            column=0,
            padx=0,
            )

        self.fft = False  # initialise plot to show time data
        self.saved_frames = 0  # used to track "frozen" data frames, for comparison of modes

    def __str__(self):
        return f'Plotting {len(self.lines)} lines of data on Figure {self.f}'

    @staticmethod
    def full_fft(yt, timestep):  # timestep will be motor.step
        signal = np.array(yt, dtype=float)
        n = signal.size
        scaling_factor = 2 / n  # scaling fft data as we are only looking at positive frequency
        fourier = np.fft.fft(signal)
        fftmagnitude = abs(fourier)
        fftmagnitude *= scaling_factor
        frequency = np.fft.fftfreq(n, d=timestep)
        return frequency[:n // 2], fftmagnitude[:n // 2]  # return only positive freq, mag of fft

    def update_data(self, name, x_data, y_data):
        """Update a line within plot given a name and new data"""
        try:
            assert (len(x_data) == len(y_data))
            if name not in self.lines:  # if new line, create dict entry
                line, = self.a.plot([0], [0])  # create new line on plot
                line.set_label(name)
                self.lines[name] = line  # add new entry to dict
            data = self.lines[name]  # grab reference of line to update

            if not self.fft:
                data.set_data(x_data, y_data)
            else:
                delta = x_data[0]  # timestep always lowest value (same as step size)
                xf, yf = self.full_fft(y_data, delta)
                data.set_data(xf, yf)

            # data must be relimited and scaled after setting data
            self.a.relim()
            self.a.autoscale_view()
            self.f.canvas.draw_idle()
        except AssertionError:
            logger.error(f"Cannot plot X {len(x_data)} and Y {len(y_data)}")
            print(f"Cannot plot X {len(x_data)} and Y {len(y_data)}")

    def save_frame(self):
        x1, y1 = self.lines["Phase U"].get_data(orig=True)
        x2, y2 = self.lines["Phase V"].get_data(orig=True)
        if self.parent.options_frame.cur_mode:
            mode = int(self.parent.options_frame.cur_mode[-1])
        name1 = "Frame" + str(self.saved_frames + 1) + " Mode" + str(mode) + ": U"
        name2 = "Frame" + str(self.saved_frames + 1) + " Mode" + str(mode) + ": V"

        line1, = self.a.plot(x1, y1)  # create new line on plot
        line2, = self.a.plot(x2, y2)
        line1.set_label(name1)
        line2.set_label(name2)
        self.a.legend(loc='upper right', fontsize=8)

        self.lines[name1] = line1  # add new entry to dict
        self.lines[name2] = line2

        self.saved_frames += 1

    def clear_frames(self):
        old_frames = []
        for key in self.lines:
            if key in ["Phase U", "Phase V"]:
                self.lines[key].set_data([0], [0])
            else:
                old_frames.append(key)

        # must use separate loop as dict key cannot be deleted while accessing
        for key in old_frames:
            self.lines[key].remove()
            del self.lines[key]

        self.a.legend(loc='upper right', fontsize=8)
        self.saved_frames = 0

    def toggle_fft(self):
        self.fft = not self.fft
        print(f"FFT: {self.fft}")


class AdiOptionsFrame(AdiFrame):
    """Template which provides set "modes" for
    motor operation and options for enabling plot, showing
    raw data, logging data and down sampling."""

    def __init__(self, parent, motor, toggle_plot, log_data, send_down_samp,
                 toggle_fft, _hold_data, _clear_data,
                 name="options frame", row=3, column=0):

        # GUI defaults
        self.cur_mode = "Mode1"
        self.mode_button_width = 10

        # tkinter variables for tracking buttons pressed / unpressed
        self.show_plot = tk.IntVar()
        self.log = tk.IntVar()
        self.plot_fft = tk.IntVar()
        self.down_sample_factor = tk.StringVar()  # reference to text entry

        # reference to motor object
        self.parent = parent
        self.motor = motor

        # Binding function callbacks
        self.toggle_plot = toggle_plot
        self.toggle_fft = toggle_fft
        self.log_data = log_data
        self.send_down_samp = send_down_samp        
        self._hold_data = _hold_data
        self._clear_data = _clear_data

        AdiFrame.__init__(
            self,
            parent,
            name,
            row,
            column,
        )

        mode_commands = {  # one variable set by all buttons, cur_mode
            # Text : (function, tooltip)
            "Mode1": (
                self.close_loop_optimum,
                "Closed loop FOC with optimum settings of flushing SINC filter"
            ),
            "Mode2": (
                self.open_loop_optimum,
                "Open loop control with optimum settings of flushing SINC filter"
            ),
            "Mode3": (
                self.close_loop_non_optimum,
                "Open loop control with optimum settings of continuously operating SINC filter"
            ),
            "Mode4": (
                self.open_loop_non_optimum,
                "Open loop control with non-optimum settings of continuously operating SINC filter"
            )
        }

        check_options = {
            # Text:         (function, tk variable),
            "Enable Plot": (self._toggle_plot, self.show_plot,
                            "Begin plotting float data from SINC filter current phases U and V"),
            "Log Data": (self._log_data, self.log,
                         "Log the last data frame (two-phases) to Excel, out.xlsx in the current directory"),
            "FFT": (self._toggle_fft, self.plot_fft,
                    "Plot fft data of the SINC filter"),
        }

        # loop through modes and create/display corresponding radio button
        # only one mode is selected at a time
        self.mode_buttons = []
        self.options_checked = []
        for index, (mode, (command, description)) in enumerate(mode_commands.items()):
            button = Radiobutton(
                self,
                text=mode,
                indicatoron=0,
                value=mode,
                command=command,
                variable=self.cur_mode,
                width=self.mode_button_width,
            )
            createToolTip(button, description)
            self.mode_buttons.append(button)
            self._add(button, row=index + 1, column=1)

        self.mode_buttons[0].invoke()

        self.temp = tk.Frame(
            self,
            background="white",
            width=20,
        )

        self.temp.grid(
            row=0,
            column=2,
            sticky='w',
        )

        # loop through check options and create/display check button
        last = 0
        for index, (text, (command, variable, description)) in enumerate(check_options.items(), 1):
            checkButton = Checkbutton(
                self,
                text=text,
                command=command,
                variable=variable,
            )
            createToolTip(checkButton, description)
            self.options_checked.append(checkButton)
            self._add(checkButton, row=index, column=3, sticky='w')
            last = index + 1  # keep track of last row used

        style = ttk.Style()
        style.configure("TCheckbutton", background="white")  # modify background of ttk widget

        self.hold_data_frame = tk.Frame(self,
                                        background="white")
        self.hold_data_frame.grid(
            row=last,
            column=3,
        )

        self.hold_data = Button(
            self.hold_data_frame,
            text="Hold Frame",
            command=self.hold_data,
        )
        self._add(self.hold_data, row=0, column=0, padx=(0, 2), pady=(0, 2))

        self.clear_data = Button(
            self.hold_data_frame,
            text="Clear Frames",
            command=self.clear_data,
        )
        self._add(self.clear_data, row=0, column=1, padx=(0, 5), pady=(0, 2))

        self.down_sample_frame = tk.Frame(self,
                                          background="white")
        self.down_sample_frame.grid(
            row=last + 1,
            column=3,

        )

        self.down_sample = Entry(
            self.down_sample_frame,
            textvariable=self.down_sample_factor,
            width=2,
        )
        self.down_sample.insert(0, "1")
        self._add(self.down_sample, row=0, column=0, sticky='w')
        createToolTip(self.down_sample,
                      "Down samples current reading, allows for plotting"
                      " over larger time scale")

        sampling_label = Label(
            self.down_sample_frame,
            text="Down Sample",
            width=12,
            font=("Helvetica", 12)

        )
        self._add(sampling_label, row=0, column=1, sticky="w")

        self.submit_sampling = Button(
            self.down_sample_frame,
            text="Submit",
            command=self.send_down_sample,
        )
        self._add(self.submit_sampling, row=0, column=2, padx=(0, 2))

    def _toggle_plot(self):
        self.toggle_plot()  # function passed by parent application

    def _log_data(self):
        print("Log Data")
        self.log_data()

    def _toggle_fft(self):
        self.toggle_fft()

    def send_down_sample(self):
        try:
            assert len(self.down_sample_factor.get()) != 0
            print(f'Sending down sample: {self.down_sample.get()}')
            down_sample = int(self.down_sample_factor.get())
            self.send_down_samp(down_sample)
        except AssertionError as ae:
            print("Please enter an integer down sample value")

    def close_loop_optimum(self):
        if not self.motor.isRunning():
            self.motor.configure(mode_cmd=0)
            self.cur_mode = "Mode1"
            self.parent.motor_frame.slider.configure(from_=self.parent.config["rpm_max"])
            print("Setting motor mode = 1")

    def open_loop_optimum(self):
        if not self.motor.isRunning():
            self.motor.configure(mode_cmd=1)
            self.cur_mode = "Mode2"
            self.parent.motor_frame.slider.configure(from_=self.parent.config["rpm_max_2"])
            print("Setting motor mode = 2")

    def close_loop_non_optimum(self):
        if not self.motor.isRunning():
            self.motor.configure(mode_cmd=3)
            self.cur_mode = "Mode3"
            self.parent.motor_frame.slider.configure(from_=self.parent.config["rpm_max_2"])
            print("Setting motor mode = 3")

    def open_loop_non_optimum(self):
        if not self.motor.isRunning():
            self.motor.configure(mode_cmd=4)
            self.cur_mode = "Mode4"
            self.parent.motor_frame.slider.configure(from_=self.parent.config["rpm_max_2"])
            print("Setting motor mode = 4")

    def _toggle_modes(self):
        if self.motor.started:
            for button in self.mode_buttons:
                button.configure(state=ENABLED)
        else:
            for button in self.mode_buttons:
                button.configure(state=DISABLED)

    def hold_data(self):
        print("Holding current frame")
        self._hold_data()

    def clear_data(self):
        print("Clearing held frames")
        self._clear_data()
