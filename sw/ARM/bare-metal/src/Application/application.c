/*****************************************************************************
Copyright (c) 2019 - Analog Devices Inc. All Rights Reserved.
This software is proprietary & confidential to Analog Devices, Inc.
and its licensors.
******************************************************************************
File Name : application.c 

Generation Date: 2019-01-09
Generated By: Jens Sorensen 

Description: 

*****************************************************************************/
/*=============  I N C L U D E S   =============*/
#include <application.h>
#include <motor_control.h>
#include <PMSMctrl.h>          // Header file of auto generated code
#include <ADIMonitor.h>
#include "platform.h"

/*=============  P R O T O T Y P E S  =============*/
// Local functions
void StateFcnFault(void);
void StateFcnStopped(void);
void StateFcnRunning(void);

/*=============  D A T A  =============*/
APP_STATE_TYPE app_state=sMOTOR_STOPPED;
void (*state_function)(void);  // Pointer to current state function
PLATFORM_TYPE platform_id=LV_PLATFORM;

/*=============  C O D E  =============*/

void aAppInit(void){   
/*****************************************************************************
  Function: aAppInit

  Parameters: None
 
  Returns: None
  
  Notes:  

*****************************************************************************/ 
  state_function = &StateFcnStopped;
  aAdiMonitorInit();
  aMcInit();
}

void aAppCmd(APP_EVENT event){
/*****************************************************************************
  Function: aAppCmd

  Parameters: Application event
 
  Returns: None
  
  Notes:  

*****************************************************************************/ 
  switch(event){
   case eAPP_START:          
          if(app_state==sMOTOR_STOPPED || app_state==sMOTOR_FAULT){ // Motor stopped and start commmand
            aMcCmd(eMC_START);
            app_state = sMOTOR_RUNNING;
            state_function = &StateFcnRunning;
          }
          break;
   case eAPP_STOP:     
          if(app_state==sMOTOR_RUNNING){ // Motor running and stop commmand or undervoltage while running 
            aMcCmd(eMC_STOP);
            app_state = sMOTOR_STOPPED;
            state_function = &StateFcnStopped;
          }             
          break;       
   case eAPP_FAULT:  
            aMcCmd(eMC_STOP);
            PMSMctrl_P.SYSTEM_CMD = 0;
            app_state = sMOTOR_FAULT;
            state_function = &StateFcnFault;
        break;        
   default:
        break;     
  }   
}

void sAppTask(void){   
/*****************************************************************************
  Function: sAppTask

  Parameters: None
 
  Returns: None
  
  Notes:  

*****************************************************************************/ 
  static uint16_T led_cnt;
  
  led_cnt++;

  state_function();
}

void StateFcnRunning(void){
/*****************************************************************************
  Function: StateFcnRunning

  Parameters: None
 
  Returns: None
  
  Notes:  

*****************************************************************************/ 
  //sMeasureTask();
  //sFilterTaskSlow();
  sMcTask();
}   

void StateFcnStopped(void){
/*****************************************************************************
  Function: StateFcnStopped

  Parameters: None
 
  Returns: None
  
  Notes:  

*****************************************************************************/ 
  //sMeasureTask();
  //sFilterTaskSlow();
  sMcTask();
}       
  
void StateFcnFault(void){
/*****************************************************************************
  Function: StateFcnFault

  Parameters: None
 
  Returns: None
  
  Notes:  

*****************************************************************************/ 
  //sMeasureTask();
  //sFilterTaskSlow();
  sMcTask();
}
/* End Of File */
