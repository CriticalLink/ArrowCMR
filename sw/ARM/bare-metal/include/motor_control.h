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

/*=============  D E F I N E S  =============*/
typedef enum {    
  eMC_START,
  eMC_STOP            
} MC_EVENT;

/*=============  EXTERNAL FUNCTIONS  =============*/
void aMcInit(void);
void aMcCmd(MC_EVENT);
void sMcTask(void);
void sMcAlgorithm(void);

/*=============  EXTERNAL VARIABLES  =============*/

