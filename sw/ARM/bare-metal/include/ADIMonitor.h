/*****************************************************************************
Copyright (c) 2018 - Analog Devices Inc. All Rights Reserved.
This software is proprietary & confidential to Analog Devices, Inc.
and its licensors.
******************************************************************************
File Name : adimonitor.c

Generation Date: 2018-11-27
Generated By: Jens Sorensen

Description: This file implements ADIMonitor for Xilinx Zynq. The code executes
on one of the A9s.

*****************************************************************************/

#include <hwlib.h>
/*=============  D E F I N E S  =============*/

/*=============  EXTERNAL FUNCTIONS  =============*/
ALT_STATUS_CODE aAdiMonitorInit(void);
void AdiMonitor(void);
void TrigAdiMonitor(void);  // Call this function to trigger ADIMonitor in SINGLE mode
void checkTxBuffer();
void checkRxUart(void);
/*=============  EXTERNAL VARIABLES  =============*/


