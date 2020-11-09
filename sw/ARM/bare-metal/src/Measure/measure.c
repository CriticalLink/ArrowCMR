/*****************************************************************************
Copyright (c) 2019 - Analog Devices Inc. All Rights Reserved.
This software is proprietary & confidential to Analog Devices, Inc.
and its licensors.
******************************************************************************
File Name : measure.c

Generation Date: 2019-01-09
Generated By: Jens Sorensen

Description:

*****************************************************************************/
/*=============  I N C L U D E S   =============*/
#include "measure.h"
#include "motor_control.h"
#include <stdio.h>

#include <alt_interrupt.h>
#include <alt_generalpurpose_io.h>

/*=============  D E F I N E S   =============*/

/* SINC definements */
#define SINC_DATA_IRQ_BASE 0xFF203000
#define SINC_DATA_IRQ_ID ALT_INT_INTERRUPT_F2S_FPGA_IRQ5
#define REG_IRQ_EN 32
#define REG_IRQ_ACK 33
#define REG_IRQ_PEN 33

#define BITM_SINC0_DATA_IRQ 0x00000001
#define BITM_SINC1_DATA_IRQ 0x00000002

#define SINC_BASE 0xFF203000

#define SINC_RESET 0
#define SINC0_DATA_LATEST 1
#define SINC_DECIMATION_RATE 2
#define SINC_MCLK_DIV 3
#define SINC_SCALE 4
#define SINC1_DATA_LATEST 5
#define SINC_EN_CNT 6
#define SINC_CFG 7
#define SINC_IRQ_RATE 8
#define SINC0_DATA_SYNCED 9
#define SINC1_DATA_SYNCED 10
#define SINC_ENABLE_MCLK 11

#define SINC0_TRIP_FIL_OUT 12
#define SINC1_TRIP_FIL_OUT 13
#define SINC0_TRIP 14
#define SINC1_TRIP 15
#define SINC_TRIP_RESET	16
#define SINC_TRIP_DEC_RATE 17
#define SINC_TRIP_EN 18
#define SINC_TRIP_LMAX 19
#define SINC_TRIP_LMIN 20
#define SINC_TRIP_LCNT 21
#define SINC_TRIP_LWIN 22

void SINC_FLUSH_TRIP_IP_mWriteReg(uint32_t base, uint32_t offset, uint32_t val) { 
	volatile uint32_t* reg = (volatile uint32_t*)(base);
	reg[offset] = val;
}

uint32_t SINC_FLUSH_TRIP_IP_mReadReg(uint32_t base, uint32_t offset) {
	volatile uint32_t* reg = (volatile uint32_t*)(base);
	return reg[offset];
}

/*=============  P R O T O T Y P E S  =============*/
void SetupSINC(void);
void SetupSincDataIrq(void);

/*=============  D A T A  =============*/
uint32_t Sinc0DataEvent = 0u;
uint32_t Sinc1DataEvent = 0u;

uint16_t sinc0_synced, sinc1_synced, sinc0_latest, sinc1_latest;

uint16_t sinc0_trip_fil_out, sinc1_trip_fil_out;
uint8_t sinc0_trip, sinc1_trip;

/*=============  C O D E  ===============*/

void SincDataIsr(uint32_t icciar, void* context){
/*****************************************************************************
  Function: SincDataIsr

  Parameters: None

  Returns: None

  Notes:

*****************************************************************************/
	uint32_t pending;


	pending = SINC_FLUSH_TRIP_IP_mReadReg(SINC_DATA_IRQ_BASE, REG_IRQ_PEN);

	if (pending & BITM_SINC0_DATA_IRQ)
	{

	  Sinc0DataEvent++;

	  alt_gpio_port_datadir_set(ALT_GPIO_PORTB, ALT_GPIO_BIT15, ALT_GPIO_BIT15);
      sinc0_latest = (uint16_t)SINC_FLUSH_TRIP_IP_mReadReg(SINC_BASE, SINC0_DATA_LATEST);
	  sinc1_latest = (uint16_t)SINC_FLUSH_TRIP_IP_mReadReg(SINC_BASE, SINC1_DATA_LATEST);
	  sinc1_synced = (uint16_t)SINC_FLUSH_TRIP_IP_mReadReg(SINC_BASE, SINC1_DATA_SYNCED);
	  sinc0_synced = (uint16_t)SINC_FLUSH_TRIP_IP_mReadReg(SINC_BASE, SINC0_DATA_SYNCED);

	  sinc0_trip_fil_out = (uint16_t)SINC_FLUSH_TRIP_IP_mReadReg(SINC_BASE, SINC0_TRIP_FIL_OUT); // Just for debugging. Not used for anyhting
	  sinc1_trip_fil_out = (uint16_t)SINC_FLUSH_TRIP_IP_mReadReg(SINC_BASE, SINC1_TRIP_FIL_OUT); // Just for debugging. Not used for anyhting

	  sinc0_trip = (uint8_t)SINC_FLUSH_TRIP_IP_mReadReg(SINC_BASE, SINC0_TRIP); // Just for debugging. Not used for anyhting
	  sinc1_trip = (uint8_t)SINC_FLUSH_TRIP_IP_mReadReg(SINC_BASE, SINC1_TRIP); // Just for debugging. Not used for anyhting
	  alt_gpio_port_datadir_set(ALT_GPIO_PORTB, ALT_GPIO_BIT15, 0);

	  sMcAlgorithm();

      // Clear IRQ before we leave, as sMcAlgorithm call takes a long time and IRQ may reset before we exit, which can starve other IRQs
      SINC_FLUSH_TRIP_IP_mWriteReg(SINC_DATA_IRQ_BASE, REG_IRQ_ACK, BITM_SINC0_DATA_IRQ);
	  return;
	}

	if (pending & BITM_SINC1_DATA_IRQ)
	{
	  Sinc1DataEvent++;

	  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_DATA_IRQ_BASE, REG_IRQ_ACK, BITM_SINC1_DATA_IRQ);
	  return;
	}

}

void aMeasureInit(void){
/*****************************************************************************
  Function: aMeasureInit

  Parameters: None

  Returns: None

  Notes: Setup of Measurement system.

*****************************************************************************/
  SetupSINC();
  SetupSincDataIrq();
}

void SetupSINC(void){
/*****************************************************************************
  Function: SetupSINC

  Parameters: None

  Returns: None

  Notes: Setup of SINC filter.

*****************************************************************************/
  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_RESET, 1);
  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_DECIMATION_RATE, 128);
  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_MCLK_DIV, 4);
  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_SCALE, 5);

  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_EN_CNT, 8464);
  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_CFG, 1);
  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_IRQ_RATE, 3);
  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_ENABLE_MCLK, 1);

  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_RESET, 0);

  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_TRIP_RESET, 1);
  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_TRIP_EN, 0);
  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_TRIP_DEC_RATE, 7);
  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_TRIP_LMAX, 272);
  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_TRIP_LMIN, 72);
  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_TRIP_LCNT, 4);
  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_TRIP_LWIN, 8);
  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_TRIP_RESET, 0);
}

void EnableSincTrip(void){
/*****************************************************************************
  Function: SetupSINC

  Parameters: None

  Returns: None

  Notes: Enable trip signal from SINC filter

*****************************************************************************/
  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_TRIP_RESET, 1);
  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_TRIP_RESET, 0);
  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_TRIP_EN, 1);
}

void ClearSincTrip(void){
/*****************************************************************************
  Function: SetupSINC

  Parameters: None

  Returns: None

  Notes: Trip signals from SINC filter are sticky. Call this function to clear a
  trip. Note, in case of a trip it is also necessary to clear the trip in the PWM timer

*****************************************************************************/
  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_TRIP_RESET, 1);
  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_BASE, SINC_TRIP_RESET, 0);
}

void SetupSincDataIrq(void){
/*****************************************************************************
  Function: SetupSincDataIrq

  Parameters: None

  Returns: None

  Notes:

*****************************************************************************/
  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_DATA_IRQ_BASE, REG_IRQ_EN, 0x00000000);

  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_DATA_IRQ_BASE, REG_IRQ_ACK, 0xFFFFFFFF);

  alt_int_isr_register(SINC_DATA_IRQ_ID, SincDataIsr, NULL);
  int target = 0x1; /* 1 = CPU0, 2=CPU1 */ 
  alt_int_dist_target_set(SINC_DATA_IRQ_ID, target);
  alt_int_dist_enable(SINC_DATA_IRQ_ID);

  SINC_FLUSH_TRIP_IP_mWriteReg(SINC_DATA_IRQ_BASE, REG_IRQ_EN, 0x1);
}

uint16_t GetSincData(uint8_t channel){
/*****************************************************************************
  Function: GetSincData

  Parameters: None

  Returns: None

  Notes: Read data from SINC filter

*****************************************************************************/
  uint16_t data = 0;

  if(channel==0)
	data = (uint16_t)SINC_FLUSH_TRIP_IP_mReadReg(SINC_BASE, SINC0_DATA_SYNCED);
  else if(channel==1)
	data = (uint16_t)SINC_FLUSH_TRIP_IP_mReadReg(SINC_BASE, SINC1_DATA_SYNCED);
  return data;
}
