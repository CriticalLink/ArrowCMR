/*
 * Sponsored Third Party Support License -- for use only to support
 * products interfaced to MathWorks software under terms specified in your
 * company's restricted use license agreement.
 *
 * File: PMSMctrl_private.h
 *
 * Code generated for Simulink model 'PMSMctrl'.
 *
 * Model version                  : 1.2816
 * Simulink Coder version         : 9.2 (R2019b) 18-Jul-2019
 * C/C++ source code generated on : Wed Mar 10 12:04:11 2021
 *
 * Target selection: ert.tlc
 * Embedded hardware selection: ARM Compatible->ARM Cortex
 * Code generation objectives: Unspecified
 * Validation result: Not run
 */

#ifndef RTW_HEADER_PMSMctrl_private_h_
#define RTW_HEADER_PMSMctrl_private_h_
#include "rtwtypes.h"
#ifndef UCHAR_MAX
#include <limits.h>
#endif

#if ( UCHAR_MAX != (0xFFU) ) || ( SCHAR_MAX != (0x7F) )
#error Code was generated for compiler with different sized uchar/char. \
Consider adjusting Test hardware word size settings on the \
Hardware Implementation pane to match your compiler word sizes as \
defined in limits.h of the compiler. Alternatively, you can \
select the Test hardware is the same as production hardware option and \
select the Enable portable word sizes option on the Code Generation > \
Verification pane for ERT based targets, which will disable the \
preprocessor word size checks.
#endif

#if ( USHRT_MAX != (0xFFFFU) ) || ( SHRT_MAX != (0x7FFF) )
#error Code was generated for compiler with different sized ushort/short. \
Consider adjusting Test hardware word size settings on the \
Hardware Implementation pane to match your compiler word sizes as \
defined in limits.h of the compiler. Alternatively, you can \
select the Test hardware is the same as production hardware option and \
select the Enable portable word sizes option on the Code Generation > \
Verification pane for ERT based targets, which will disable the \
preprocessor word size checks.
#endif

#if ( UINT_MAX != (0xFFFFFFFFU) ) || ( INT_MAX != (0x7FFFFFFF) )
#error Code was generated for compiler with different sized uint/int. \
Consider adjusting Test hardware word size settings on the \
Hardware Implementation pane to match your compiler word sizes as \
defined in limits.h of the compiler. Alternatively, you can \
select the Test hardware is the same as production hardware option and \
select the Enable portable word sizes option on the Code Generation > \
Verification pane for ERT based targets, which will disable the \
preprocessor word size checks.
#endif

#if ( ULONG_MAX != (0xFFFFFFFFU) ) || ( LONG_MAX != (0x7FFFFFFF) )
#error Code was generated for compiler with different sized ulong/long. \
Consider adjusting Test hardware word size settings on the \
Hardware Implementation pane to match your compiler word sizes as \
defined in limits.h of the compiler. Alternatively, you can \
select the Test hardware is the same as production hardware option and \
select the Enable portable word sizes option on the Code Generation > \
Verification pane for ERT based targets, which will disable the \
preprocessor word size checks.
#endif

#ifdef __cplusplus

extern "C" {

#endif

  extern void s_focDesignerVectorControl_Start_wrapper(void);
  extern void s_focDesignerVectorControl_Outputs_wrapper(const real32_T
    *i_ref_dq,
    const real32_T *i_dq,
    const int32_T *en,
    const real32_T *v_ref_lim_dq,
    const int32_T *dq_is_lim,
    real32_T *v_ref_dq);
  extern void s_focDesignerVectorControl_Terminate_wrapper(void);

#ifdef __cplusplus

}
#endif

extern void SVPWM_float_Outputs_wrapper(const real32_T *u0,
  const real32_T *u1,
  const real32_T *u2,
  const uint8_T *u3,
  real32_T *y0,
  real32_T *y1,
  real32_T *y2);
extern real32_T rt_roundf(real32_T u);
extern void mul_wide_u32(uint32_T in0, uint32_T in1, uint32_T *ptrOutBitsHi,
  uint32_T *ptrOutBitsLo);
extern uint32_T mul_u32_loSR(uint32_T a, uint32_T b, uint32_T aShift);
extern void mul_wide_s32(int32_T in0, int32_T in1, uint32_T *ptrOutBitsHi,
  uint32_T *ptrOutBitsLo);
extern int32_T mul_s32_sr32(int32_T a, int32_T b);
extern int32_T mul_s32_hiSR(int32_T a, int32_T b, uint32_T aShift);

#endif                                 /* RTW_HEADER_PMSMctrl_private_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
