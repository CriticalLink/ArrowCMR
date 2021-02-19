# -*- coding: utf-8 -*-
"""
Created on Fri Aug 14 11:03:08 2020

@brief: Style sheet for ADI tkinter widgets and frames.

@author: Tom Sharkey
"""

import platform


class AdiStyle:
    COLOR_BG = '#ffffff'

    COLOR_PRIMARY1 = '#003745'
    COLOR_PRIMARY2 = '#00aeda'
    COLOR_PRIMARY2_LIGHT = '#11cfff'

    COLOR_SECONDARY1 = '#00456b'
    COLOR_SECONDARY2 = '#00535e'
    COLOR_SECONDARY3 = '#008b98'
    COLOR_SECONDARY4 = '#008aad'

    COLOR_ERROR = 'red'
    COLOR_WARNING = 'orange'
    COLOR_WARNING_NOTWORKING = 'orange'
    COLOR_WARNING_FORMATTING = 'yellow'
    COLOR_NOERROR = 'green'
    COLOR_DISABLED = '#f2e6e6'

    if platform.system() in ['Windows']:
        FONT_HEADER = ('Helvetica', '8', 'bold')
        FONT_BODY = ('Helvetica', '8')
    else:
        FONT_HEADER = 'TkDefaultFont'
        FONT_BODY = 'TkDefaultFont'
