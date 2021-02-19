# -*- coding: utf-8 -*-
"""
Created on Tue Aug 14 10:02:01 2020

@brief: Attach extra functionality to tk widgets.

@author: Tom Sharkey
@last-modified: 2020-11-09
"""

import threading
import tkinter as tk
import tkinter.ttk as ttk

from libs import adiStyle


class GuiFactory:
    # ======================== singleton pattern ===============================

    _instance = None
    _init = False

    def __new__(cls, *args, **kwargs):
        if not cls._instance:
            cls._instance = super(GuiFactory, cls).__new__(cls, *args, **kwargs)
        return cls._instance

    def __init__(self):
        # don't re-initialize an instance (needed because singleton)
        if self._init:
            return
        self._init = True

        self.dataLock = threading.Lock()
        self.recycleBin = []

    # ======================== return pattern ==================================

    def recycle(self, elem):

        with self.dataLock:
            self.recycleBin += [elem]

    def getRecycled(self, typeWanted):

        # try to find a recycles element
        with self.dataLock:
            for i in range(len(self.recycleBin)):
                if type(self.recycleBin[i]) == typeWanted:
                    returnVal = self.recycleBin.pop(i)
                    return returnVal


class FactoryElem:

    def removeGui(self):
        self.grid_forget()
        GuiFactory().recycle(self)


class Button(FactoryElem, tk.Button):

    def __init__(self, *args, **kwargs):
        # initialize the parent classes
        FactoryElem.__init__(self)
        tk.Button.__init__(self, *args, **kwargs)


class Checkbutton(FactoryElem, ttk.Checkbutton):

    def __init__(self, *args, **kwargs):
        # initialize the parent classes
        FactoryElem.__init__(self)
        ttk.Checkbutton.__init__(self, *args, **kwargs)


class OptionMenu(FactoryElem, tk.OptionMenu):

    def __init__(self, *args, **kwargs):
        # initialize the parent classes
        FactoryElem.__init__(self)
        tk.OptionMenu.__init__(self, *args, **kwargs)


class Radiobutton(FactoryElem, tk.Radiobutton):

    def __init__(self, *args, **kwargs):
        # initialize the parent classes
        FactoryElem.__init__(self)
        tk.Radiobutton.__init__(self, *args, **kwargs)


class Scale(FactoryElem, ttk.Scale):

    def __init__(self, *args, **kwargs):
        # initialize the parent classes
        FactoryElem.__init__(self)
        ttk.Scale.__init__(self, *args, **kwargs)


class Entry(FactoryElem, tk.Entry):

    def __init__(self, *args, **kwargs):
        # initialize the parent classes
        FactoryElem.__init__(self)
        tk.Entry.__init__(self, *args, **kwargs)


class Text(FactoryElem, tk.Text):
    BLINK_ITERATIONS = 2
    BLINK_PERIOD_MS = 50
    RESIZE_PERIOD = 100

    def __init__(self, *args, **kwargs):

        # store the class' parameters
        try:
            self.returnAction = kwargs['returnAction']
        except KeyError:
            self.returnAction = None
        else:
            del kwargs['returnAction']
        try:
            self.autoResize = kwargs['autoResize']
        except KeyError:
            self.autoResize = False
        else:
            del kwargs['autoResize']

        # initialize the parent classes
        FactoryElem.__init__(self)
        tk.Text.__init__(self, *args, **kwargs)

        # local variables
        self.blinkIterationsRemaining = 0
        self.blinkActive = False
        self.blinkDefaultColor = self.cget("bg")

        # have pressing Tab move focus on the next field, not write \t
        self.bind('<Tab>', self._focusNext)
        self.bind('<Shift-Tab>', self._focusPrevious)

        # have a return (pressing the Enter key) call a function, not write \n
        self.bind('<Return>', self._returnPressed)

        # have right-clicking paste the contents to the clipboard
        self.bind('<Button-3>', self._pasteClipboard)

        # resize the field to it content
        if self.autoResize:
            self.after(self.RESIZE_PERIOD, self._autoResize)

    # ======================== public ==========================================

    # ======================== private =========================================

    def _returnPressed(self, event):
        if self.returnAction:
            self.returnAction()
        return 'break'

    def _focusNext(self, event):
        self.tk_focusNext().focus_set()
        return 'break'

    def _focusPrevious(self, event):
        self.tk_focusPrev().focus_set()
        return 'break'

    def _pasteClipboard(self, event):
        try:
            self.insert(tk.CURRENT, self.clipboard_get().replace('-', ''))
            self._blink()
        except tk.TclError:
            # can happen if not pasting a text
            pass

    def _autoResize(self):

        # determine the new width
        newwidth = len(self.get(1.0, tk.END)) + 2
        if newwidth > adiStyle.TEXTFIELD_ENTRY_LENGTH_MAX:
            newwidth = adiStyle.TEXTFIELD_ENTRY_LENGTH_MAX
        elif newwidth < adiStyle.TEXTFIELD_ENTRY_LENGTH_DEFAULT:
            newwidth = adiStyle.TEXTFIELD_ENTRY_LENGTH_DEFAULT

        # apply new width
        self.configure(width=newwidth)

        # schedule next resize event
        if self.autoResize:
            self.after(self.RESIZE_PERIOD, self._autoResize)

    def _blink(self):
        if not self.blinkIterationsRemaining:
            self.blinkDefaultColor = self.cget("bg")
            self.blinkIterationsRemaining = self.BLINK_ITERATIONS
            self._blinkIteration()

    def _blinkIteration(self):

        # change the state of the label
        if self.blinkIterationsRemaining:
            if self.blinkActive:
                self.configure(bg=self.blinkDefaultColor)
                self.blinkActive = False
                self.blinkIterationsRemaining -= 1
            else:
                self.configure(bg=adiStyle.COLOR_PRIMARY2_LIGHT)
                self.blinkActive = True

        # arm next iteration
        if self.blinkIterationsRemaining:
            self.after(self.BLINK_PERIOD_MS, self._blinkIteration)


class Label(FactoryElem, tk.Label):
    BLINK_ITERATIONS = 2
    BLINK_PERIOD_MS = 50

    def __new__(cls, *args, **kwargs):
        returnVal = GuiFactory().getRecycled(cls)
        if not returnVal:
            returnVal = super(Label, cls).__new__(cls)
        return returnVal

    def __init__(self, *args, **kwargs):

        # initialize the parent classes
        FactoryElem.__init__(self)
        tk.Label.__init__(self, *args, **kwargs)

        # have right-clicking copy the contents to the clipboard
        self.unbind('<Button-3>')
        self.bind('<Button-3>', self._copyClipboard)

        # local variables
        self.blinkIterationsRemaining = 0
        self.blinkActive = False
        self.blinkDefaultColor = self.cget("bg")

    # ======================== public ==========================================

    # ======================== private =========================================

    def _copyClipboard(self, event):
        self.clipboard_clear()
        self.clipboard_append(self.cget("text"))
        self._blink()

    def _blink(self):
        if not self.blinkIterationsRemaining:
            self.blinkDefaultColor = self.cget("bg")
            self.blinkIterationsRemaining = self.BLINK_ITERATIONS
            self._blinkIteration()

    def _blinkIteration(self):

        # change the state of the label
        if self.blinkIterationsRemaining:
            if self.blinkActive:
                self.configure(bg=self.blinkDefaultColor)
                self.blinkActive = False
                self.blinkIterationsRemaining -= 1
            else:
                self.configure(bg=adiStyle.COLOR_PRIMARY2_LIGHT)
                self.blinkActive = True

        # arm next iteration
        if self.blinkIterationsRemaining:
            self.after(self.BLINK_PERIOD_MS, self._blinkIteration)


class ToolTip(FactoryElem):
    """Creates a toplevel label when mouse enters attached widget"""

    def __init__(self, widget):
        self.widget = widget
        self.tipwindow = None
        self.id = None
        self.x = self.y = 0

        FactoryElem.__init__(self)

    def showtip(self, text):
        """Display text in tooltip window"""

        self.text = text
        if self.tipwindow or not self.text:
            return
        x, y, cx, cy = self.widget.bbox("insert")
        x = x + self.widget.winfo_rootx() + 27
        y = y + cy + self.widget.winfo_rooty() + 27
        self.tipwindow = tk.Toplevel(self.widget)
        self.tipwindow.wm_overrideredirect(1)
        self.tipwindow.wm_geometry("+%d+%d" % (x, y))
        label = Label(self.tipwindow, text=self.text, justify='left',
                      background="#ffffe0", relief='raised', borderwidth=1,
                      font=("tahoma", "8", "normal"))
        label.pack(ipadx=1)

    def hidetip(self):
        tw = self.tipwindow
        self.tipwindow = None
        if tw:
            tw.destroy()


def createToolTip(widget, text):
    """Convenience method for calling tooltip with widget and text"""
    toolTip = ToolTip(widget)

    def enter(event):
        # widget.after(500, None)
        toolTip.showtip(text)

    def leave(event):
        toolTip.hidetip()

    widget.bind('<Enter>', enter)
    widget.bind('<Leave>', leave)
