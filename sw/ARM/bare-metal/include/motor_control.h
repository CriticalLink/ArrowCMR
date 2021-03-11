/*****************************************************************************
Copyright (c) 2013 - Analog Devices Inc. All Rights Reserved.
This software is proprietary & confidential to Analog Devices, Inc.
and its licensors.
******************************************************************************
File Name : motor_control.h 

Generation Date: 2013-09-12
Generated By: Jens Sorensen 

Description: 

*****************************************************************************/
#include <stdint.h>

/*=============  D E F I N E S  =============*/
typedef enum {    
  eMC_START,
  eMC_STOP            
} MC_EVENT;

typedef enum {
  MODE0=0,  // Closed loop FOC
  MODE1=1,  // Open loop
  MODE2=2,  // Position Control
  MODE3=3,  // Open loop, continuous SINC, correct alignment
  MODE4=4,  // Open loop, continuous SINC, incorrect alignment
  MODE5=5,	// Current loop step response
  MODE6=6   // Speed loop step response
} MODE_TYPE;

/*=============  EXTERNAL FUNCTIONS  =============*/
void aMcInit(void);
void aMcCmd(MC_EVENT);
void sMcTask(void);
void sMcAlgorithm(void);
void aMcModeHandler(uint8_t);
MODE_TYPE GetMode(void);

/*=============  EXTERNAL VARIABLES  =============*/

