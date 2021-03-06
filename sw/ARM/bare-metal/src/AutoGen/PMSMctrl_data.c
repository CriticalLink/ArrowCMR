/*
 * Sponsored Third Party Support License -- for use only to support
 * products interfaced to MathWorks software under terms specified in your
 * company's restricted use license agreement.
 *
 * File: PMSMctrl_data.c
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

#include "PMSMctrl.h"
#include "PMSMctrl_private.h"

/* Block parameters (default storage) */
Parameters_PMSMctrl PMSMctrl_P = {
  /* Variable: Kiw
   * Referenced by: '<S70>/Integral Gain'
   */
  0.12F,

  /* Variable: Kpw
   * Referenced by: '<S78>/Proportional Gain'
   */
  0.005F,

  /* Variable: MBC_ID
   * Referenced by: '<S1>/SYS_CMD1'
   */
  2.01507267E+10F,

  /* Variable: POS_REF
   * Referenced by: '<S1>/SPEED_REF1'
   */
  0.0F,

  /* Variable: SPD_FF
   * Referenced by: '<S1>/SPEED_REF2'
   */
  0.0F,

  /* Variable: SpdSlewRateNeg
   * Referenced by: '<S40>/Saturation'
   */
  -1.0F,

  /* Variable: SpdSlewRatePos
   * Referenced by: '<S40>/Saturation'
   */
  1.0F,

  /* Variable: iabcOffset
   * Referenced by: '<S10>/Constant'
   */
  { 32768.0F, 32768.0F, 32768.0F },

  /* Variable: iabcScale
   * Referenced by: '<S10>/Gain'
   */
  0.000207519537F,

  /* Variable: iqMax
   * Referenced by:
   *   '<S66>/DeadZone'
   *   '<S80>/Saturation'
   */
  2.0F,

  /* Variable: iqMin
   * Referenced by:
   *   '<S66>/DeadZone'
   *   '<S80>/Saturation'
   */
  -2.0F,

  /* Variable: vdcOffset
   * Referenced by: '<S10>/Constant1'
   */
  0.0F,

  /* Variable: vdcScale
   * Referenced by: '<S10>/Gain1'
   */
  0.001589F,

  /* Variable: MAX_RPM
   * Referenced by:
   *   '<S12>/MAX_RPM'
   *   '<S16>/MAX_RPM'
   *   '<S90>/MAX_RPM'
   */
  3000,

  /* Variable: SPEED_REF
   * Referenced by: '<S1>/SPEED_REF'
   */
  1000,

  /* Variable: VF_MAX_RATE
   * Referenced by: '<S90>/VF_MAX_RATE'
   */
  10,

  /* Variable: MOTOR_CFG
   * Referenced by: '<S1>/SYS_CMD2'
   */
  6U,

  /* Variable: POS_RST
   * Referenced by: '<S1>/POS_RST'
   */
  0U,

  /* Variable: ROT_DIR
   * Referenced by: '<S1>/ROT_DIR'
   */
  0U,

  /* Variable: SYSTEM_CMD
   * Referenced by: '<S1>/SYS_CMD'
   */
  1U,

  /* Variable: VF_BOOST
   * Referenced by: '<S1>/VF_BOOST'
   */
  2U,

  /* Variable: VF_CTRL
   * Referenced by: '<S1>/VF_CTRL'
   */
  0U,

  /* Variable: VF_GAIN
   * Referenced by: '<S1>/VF_GAIN'
   */
  22U
};

/* Constant parameters (default storage) */
const ConstParam_PMSMctrl PMSMctrl_ConstP = {
  /* Pooled Parameter (Mixed Expressions)
   * Referenced by:
   *   '<S1>/VF_GAIN1'
   *   '<S1>/Manual Switch'
   *   '<S2>/Switch2'
   *   '<S9>/Switch1'
   *   '<S9>/Switch2'
   *   '<S10>/sinc_cmd'
   *   '<S10>/Switch1'
   *   '<S16>/Switch4'
   *   '<S16>/Switch6'
   *   '<S18>/Switch1'
   *   '<S18>/Switch2'
   *   '<S19>/Switch'
   *   '<S19>/Switch1'
   */
  1U
};

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
