/*****************************************************************************
Copyright (c) 2019 - Analog Devices Inc. All Rights Reserved.
This software is proprietary & confidential to Analog Devices, Inc.
and its licensors.
******************************************************************************
File Name : pwm.c

Generation Date: 2019-01-09
Generated By: Jens Sorensen

Description:

*****************************************************************************/

/*=============  I N C L U D E S   =============*/
#include <pwm.h>
#include "motor_control.h"
#include <stdio.h>
#include "platform.h"

#include <alt_interrupt.h>
#include <alt_generalpurpose_io.h>

/*=============  D E F I N E S   =============*/
#define PWM_IRQ_BASE 0xFF201000
#define PWM_IRQ_ID ALT_INT_INTERRUPT_F2S_FPGA_IRQ4	
#define REG_IRQ_EN 16 
#define REG_IRQ_ACK 17 
#define REG_IRQ_PEN 17 

#define BITM_PWM_SYNC_IRQ 0x00000002
#define BITM_PWM_TRIP_IRQ 0x00000001
#define BITM_PWM_TRIP_STAT 0x00000070
#define BITM_PWM_TRIP_LVL 0x00000080
#define BITP_PWM_TRIP_STAT 4
#define BITP_PWM_TRIP_LVL 7

#define REG_ENABLE_SYNC 0
#define REG_RESET_SYNC 1 
#define REG_MASTER_CNT_MAX 2 
#define REG_ENABLE_PWM 3
#define REG_RESET_PWM 4 
#define REG_DEAD_TIME 5 
#define REG_TON_A 6
#define REG_TOFF_A 7 
#define REG_TON_B 8 
#define REG_TOFF_B 9
#define REG_TON_C 10 
#define REG_TOFF_C 11
#define REG_TRIP_CLEAR 12
#define REG_PWM_STATUS 13 

/* 	Define the base memory address of PWM IP core */
#define PWM_BASE 0xFF201000

#define LED_PIN	0	/* The MIO connected to the PS is GPIO 50 */
#define LED_CNT_MAX 5000

#define PWM_CNT_MAX 10000  	// f_pwm=100M/PWM_CNT_MAX
#define DEAD_TIME 100  		// t_deadtime=DEAD_TIME/100M

void PWM_IP_mWriteReg(uint32_t base, uint32_t offset, uint32_t val) { 
	volatile uint32_t* reg = (volatile uint32_t*)(base);
	reg[offset] = val;
}

uint32_t PWM_IP_mReadReg(uint32_t base, uint32_t offset) {
	volatile uint32_t* reg = (volatile uint32_t*)(base);
	return reg[offset];
}

/*=============  P R O T O T Y P E S  =============*/
void SetupPwmIrq(void);

/*=============  D A T A  =============*/
uint8_t trip_pending = 0u;
uint32_t SyncEvent = 0u;
uint32_t TripEvent = 0u;

/*=============  C O D E  ==================*/

void PwmIsr(uint32_t icciar, void* context) {
/*****************************************************************************
  Function: PwmIsr

  Parameters: None

  Returns: None

  Notes:

*****************************************************************************/
	static bool irq_led = false;
	static uint32_t led_count = 0;
	uint32_t pending;

	pending = PWM_IP_mReadReg(PWM_IRQ_BASE, REG_IRQ_PEN);

	if (pending & BITM_PWM_SYNC_IRQ)
	{
	  led_count++;

	  if(led_count==LED_CNT_MAX){
		irq_led = !irq_led;
		// LED2
                if (irq_led) {
                  alt_gpio_port_datadir_set(ALT_GPIO_PORTB, GPIO_LED2, 0);
                } else {
                  alt_gpio_port_datadir_set(ALT_GPIO_PORTB, GPIO_LED2, GPIO_LED2);
                }
		led_count=0;
	  }

	  SyncEvent++;
	  
	  if(GetMode() == MODE4)
	    sMcAlgorithm();

	  PWM_IP_mWriteReg(PWM_IRQ_BASE, REG_IRQ_ACK, BITM_PWM_SYNC_IRQ);

	  return;
	}

	if (pending & BITM_PWM_TRIP_IRQ)
	{
	  TripEvent++;
	  trip_pending = 1;
	  PWM_IP_mWriteReg(PWM_IRQ_BASE, REG_IRQ_EN, 0x2);
	  PWM_IP_mWriteReg(PWM_IRQ_BASE, REG_IRQ_ACK, BITM_PWM_TRIP_IRQ);
	  return;
	}
}

void InitPWM(void){
/*****************************************************************************
  Function: InitPWM

  Parameters: None

  Returns: None

  Notes:

*****************************************************************************/
  //TODO: Get LED working
  //XGpioPs_SetDirectionPin(&xilInstance.gpio, LED_PIN, 1);
  //XGpioPs_SetOutputEnablePin(&xilInstance.gpio, LED_PIN, 1);

  PWM_IP_mWriteReg(PWM_BASE, REG_RESET_SYNC, 1);
  PWM_IP_mWriteReg(PWM_BASE, REG_RESET_PWM, 1);

  PWM_IP_mWriteReg(PWM_BASE, REG_MASTER_CNT_MAX, PWM_CNT_MAX);
  PWM_IP_mWriteReg(PWM_BASE, REG_DEAD_TIME, DEAD_TIME);

  PWM_IP_mWriteReg(PWM_BASE, REG_RESET_SYNC, 0);
  PWM_IP_mWriteReg(PWM_BASE, REG_RESET_PWM, 0);

  PWM_IP_mWriteReg(PWM_BASE, REG_ENABLE_SYNC, 1);

  SetupPwmIrq();
}

void EnablePWM(void){
/*****************************************************************************
  Function: EnablePWM

  Parameters: None

  Returns: None

  Notes:

*****************************************************************************/
  PWM_IP_mWriteReg(PWM_BASE, REG_ENABLE_PWM, 1);
}

void DisablePWM(void){
/*****************************************************************************
  Function: DisablePWM

  Parameters: None

  Returns: None

  Notes:

*****************************************************************************/
  PWM_IP_mWriteReg(PWM_BASE, REG_ENABLE_PWM, 0);
}

uint8_t GetPwmTripPinLevel(void){
/*****************************************************************************
  Function: GetPwmTripPinLevel

  Parameters: None

  Returns: None

  Notes: Gets the level of the external trip pin

*****************************************************************************/
  uint32_t level_read=0;
  uint8_t level=0;

  level_read = PWM_IP_mReadReg(PWM_BASE, REG_PWM_STATUS);

  level = (uint8_t)((level_read & BITM_PWM_TRIP_LVL) >> BITP_PWM_TRIP_LVL);

  return level;
}

uint8_t GetPwmTripSource(void){
/*****************************************************************************
  Function: GetPwmTripSource

  Parameters: None

  Returns: None

  Notes: Gets the source of the trip.

*****************************************************************************/
  uint32_t status_read=0;
  uint8_t source=0;

  status_read = PWM_IP_mReadReg(PWM_BASE, REG_PWM_STATUS);

  source = (uint8_t)((status_read & BITM_PWM_TRIP_STAT) >> BITP_PWM_TRIP_STAT);

  return source;
}

uint8_t GetPwmTripStatus(void){
/*****************************************************************************
  Function: CheckPwmTripStatus

  Parameters: None

  Returns: None

  Notes:

*****************************************************************************/
  return trip_pending;
}

void ClearPwmTrip(void){
/*****************************************************************************
  Function: pwmClearTrip

  Parameters: None

  Returns: None

  Notes:

*****************************************************************************/
  uint8_t delay=0;

  trip_pending = 0;

  PWM_IP_mWriteReg(PWM_BASE, REG_TRIP_CLEAR, 1);
  delay=delay+1;
  delay=delay+1;
  delay=delay+1;
  delay=delay+1;
  delay=delay+1;
  PWM_IP_mWriteReg(PWM_BASE, REG_TRIP_CLEAR, 0);

  PWM_IP_mWriteReg(PWM_IRQ_BASE, REG_IRQ_EN, 0x3);
}

void SetDuty(duty_type *ref){
/*****************************************************************************
  Function: SetDuty

  Parameters: None

  Returns: None

  Notes:

*****************************************************************************/
  uint32_t temp_a, temp_b, temp_c;

  temp_a = ((uint32_t)ref->duty_a * PWM_CNT_MAX) >> 17;
  temp_b = ((uint32_t)ref->duty_b * PWM_CNT_MAX) >> 17;
  temp_c = ((uint32_t)ref->duty_c * PWM_CNT_MAX) >> 17;

  PWM_IP_mWriteReg(PWM_BASE, REG_TON_A, (PWM_CNT_MAX>>1)-temp_a);
  PWM_IP_mWriteReg(PWM_BASE, REG_TOFF_A, (PWM_CNT_MAX>>1)+temp_a);
  PWM_IP_mWriteReg(PWM_BASE, REG_TON_B, (PWM_CNT_MAX>>1)-temp_b);
  PWM_IP_mWriteReg(PWM_BASE, REG_TOFF_B, (PWM_CNT_MAX>>1)+temp_b);
  PWM_IP_mWriteReg(PWM_BASE, REG_TON_C, (PWM_CNT_MAX>>1)-temp_c);
  PWM_IP_mWriteReg(PWM_BASE, REG_TOFF_C, (PWM_CNT_MAX>>1)+temp_c);
}

void SetupPwmIrq(void){
/*****************************************************************************
  Function: SetupPwmIrq

  Parameters: None

  Returns: None

  Notes:

*****************************************************************************/
  PWM_IP_mWriteReg(PWM_IRQ_BASE, REG_IRQ_EN, 0x00000000);

  PWM_IP_mWriteReg(PWM_IRQ_BASE, REG_IRQ_ACK, 0xFFFFFFFF);

  alt_int_isr_register(PWM_IRQ_ID, PwmIsr, NULL);
  int target = 0x1; /* 1 = CPU0, 2=CPU1 */ 
  alt_int_dist_target_set(PWM_IRQ_ID, target);
#ifdef SET_IRQ_PRIORITY
  // Configure the IRQ priority
  alt_int_dist_priority_set(PWM_IRQ_ID, MOTOR_PWM_IRQ_PRIORITY);
#endif
  alt_int_dist_enable(PWM_IRQ_ID);

  PWM_IP_mWriteReg(PWM_IRQ_BASE, REG_IRQ_EN, 0x3);
}
