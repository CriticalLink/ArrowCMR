/*****************************************************************************
Copyright (c) 2019 - Analog Devices Inc. All Rights Reserved.
This software is proprietary & confidential to Analog Devices, Inc.
and its licensors.
******************************************************************************
File Name : measure.h

Generation Date: 2019-01-09
Generated By: Jens Sorensen

Description:

*****************************************************************************/
#include <stdint.h>
/*=============  D E F I N E S  =============*/


/*=============  EXTERNAL FUNCTIONS  =============*/
void aMeasureInit(void);
uint16_t GetSincData(uint8_t);
void EnableSincTrip(void);
void ClearSincTrip(void);

void SetupSincOptFlush(void);
void SetupSincNonOptFlush(void);
void SetupSincOptContinious(void);
void SetupSincNonOptContinious(void);

/*=============  EXTERNAL VARIABLES  =============*/
