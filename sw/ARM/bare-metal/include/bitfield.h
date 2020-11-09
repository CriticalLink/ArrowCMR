/*******************************************************************************
Copyright (c) 2016 - Analog Devices Inc. All Rights Reserved.
This software is proprietary & confidential to Analog Devices, Inc.
and its licensors.
********************************************************************************
File Name: bitfield.h

Generation Date: 2016-10-14
Generated By: Christian Aaen
*******************************************************************************/

#ifndef UTIL_BITFIELD_H_
#define UTIL_BITFIELD_H_

#include <stdint.h>

#define BIT32(n)                ((uint32_t) 1 << (n))
#define BIT_LSHIFT32(x, s)      ((uint32_t) (x) << (s))
#define BIT_RSHIFT32(x, s)      ((uint32_t) (x) >> (s))
#define BIT_SET32(x, mask)      ((x) |= (uint32_t) (mask))
#define BIT_CLEAR32(x, mask)    ((x) &= ~((uint32_t) (mask)))
#define BIT_TOGGLE32(x, mask)   ((x) ^= (uint32_t) (mask))

#ifdef BITFIELD_DEFAULT_32_BIT
#define BIT(n)                  BIT32(n)
#define BIT_LSHIFT(x, s)        BIT_LSHIFT32(x, s)
#define BIT_RSHIFT(x, s)        BIT_RSHIFT32(x, s)
#define BIT_SET(x, mask)        BIT_SET32(x, mask)
#define BIT_CLEAR(x, mask)      BIT_CLEAR32(x, mask)
#define BIT_TOGGLE(x, mask)     BIT_TOGGLE32(x, mask)
#endif

#endif
