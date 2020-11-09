/*
 * Sponsored Third Party Support License -- for use only to support
 * products interfaced to MathWorks software under terms specified in your
 * company's restricted use license agreement.
 *
 * File: PMSMctrl_data.c
 *
 * Code generated for Simulink model 'PMSMctrl'.
 *
 * Model version                  : 1.2742
 * Simulink Coder version         : 9.0 (R2018b) 24-May-2018
 * C/C++ source code generated on : Tue Oct 15 10:57:10 2019
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
   * Referenced by: '<S86>/Integral Gain'
   */
  0.02F,

  /* Variable: Kpw
   * Referenced by: '<S113>/Proportional Gain'
   */
  0.001F,

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
   * Referenced by: '<S39>/Saturation'
   */
  -2.0F,

  /* Variable: SpdSlewRatePos
   * Referenced by: '<S39>/Saturation'
   */
  2.0F,

  /* Variable: iabcOffset
   * Referenced by: '<S8>/Constant'
   */
  { 32768.0F, 32768.0F, 32768.0F },

  /* Variable: iabcScale
   * Referenced by: '<S8>/Gain'
   */
  0.000190734863F,

  /* Variable: iqMax
   * Referenced by:
   *   '<S69>/DeadZone'
   *   '<S117>/Saturation'
   */
  2.0F,

  /* Variable: iqMin
   * Referenced by:
   *   '<S69>/DeadZone'
   *   '<S117>/Saturation'
   */
  -2.0F,

  /* Variable: vdcOffset
   * Referenced by: '<S8>/Constant1'
   */
  0.0F,

  /* Variable: vdcScale
   * Referenced by: '<S8>/Gain1'
   */
  0.001589F,

  /* Variable: MAX_RPM
   * Referenced by:
   *   '<S10>/MAX_RPM'
   *   '<S14>/MAX_RPM'
   *   '<S140>/MAX_RPM'
   */
  2000,

  /* Variable: SPEED_REF
   * Referenced by: '<S1>/SPEED_REF'
   */
  1000,

  /* Variable: VF_MAX_RATE
   * Referenced by: '<S140>/VF_MAX_RATE'
   */
  10,

  /* Variable: MOTOR_CFG
   * Referenced by: '<S1>/SYS_CMD2'
   */
  4U,

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
  32U
};

/* Constant parameters (default storage) */
const ConstParam_PMSMctrl PMSMctrl_ConstP = {
  /* Pooled Parameter (Mixed Expressions)
   * Referenced by:
   *   '<S1>/VF_GAIN1'
   *   '<S1>/Manual Switch'
   *   '<S2>/Switch2'
   *   '<S7>/Switch1'
   *   '<S7>/Switch2'
   *   '<S8>/sinc_cmd'
   *   '<S8>/Switch1'
   *   '<S14>/Manual Switch'
   *   '<S16>/Switch1'
   *   '<S16>/Switch2'
   *   '<S17>/Switch'
   *   '<S17>/Switch1'
   */
  1U
};

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
