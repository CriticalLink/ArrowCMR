/*
 * Sponsored Third Party Support License -- for use only to support
 * products interfaced to MathWorks software under terms specified in your
 * company's restricted use license agreement.
 *
 * File: PMSMctrl.c
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

/* Named constants for MATLAB Function: '<S9>/MATLAB Function1' */
#define PMSMctrl_EncoderPulses         (10000.0F)

/* Named constants for MATLAB Function: '<S16>/MATLAB Function' */
#define PMSMctrl_GainMax               (1.0F)

/* Named constants for MATLAB Function: '<S18>/MATLAB Function1' */
#define PMSMctrl_MaxAmplitude          (1.15F)

/* Exported block signals */
real32_T pos_ref_ui;                   /* '<S13>/Switch4' */
real32_T position_ref;                 /* '<S12>/Switch3' */
real32_T pos_unaligned;                /* '<S9>/Switch2' */
real32_T pos_aligned;                  /* '<S9>/Sum6' */
real32_T theta_enc_mul;                /* '<S9>/Gain3' */
real32_T speed_ff;                     /* '<S1>/SPEED_REF2' */
real32_T Nref;                         /* '<S12>/MAX_RPM' */
real32_T speed_ref;                    /* '<S13>/Switch3' */
real32_T speed_ref_lim;                /* '<S40>/Sum' */
real32_T spd_fil_calc;                 /* '<S1>/Rate Transition1' */
real32_T spd_raw_n_by_m;               /* '<S9>/Product1' */
real32_T spd_fil_n_by_m;               /* '<S22>/Discrete State-Space' */
real32_T spd_raw_n_by_1;               /* '<S9>/Product3' */
real32_T spd_fil_n_by_1;               /* '<S9>/Gain4' */
real32_T speed_fil;                    /* '<S17>/Switch2' */
real32_T iq_ref;                       /* '<S16>/Switch4' */
real32_T theta_vf;                     /* '<S89>/Data Type Conversion' */
real32_T theta_enc;                    /* '<S9>/Gain1' */
real32_T id;                           /* '<S91>/Fcn2' */
real32_T iq;                           /* '<S91>/Fcn1' */
real32_T n_by_m_fil_debug;             /* '<S9>/Gain10' */
real32_T n_by_m_raw_debug;             /* '<S9>/Gain2' */
real32_T ia_sar;                       /* '<S32>/Gain3' */
real32_T ib_sar;                       /* '<S32>/Gain6' */
real32_T ic_sar;                       /* '<S32>/Gain7' */
real32_T ic_sinc;                      /* '<S33>/Gain10' */
real32_T ia_sinc;                      /* '<S33>/Gain8' */
real32_T ib_sinc;                      /* '<S33>/Gain9' */
real32_T Vdc;                          /* '<S10>/Gain1' */
real32_T spd_raw_calc;                 /* '<S1>/Rate Transition2' */
real32_T speed_raw;                    /* '<S17>/Switch1' */
real32_T theta_speed;                  /* '<S2>/Rate Transition1' */
real32_T w_step;                       /* '<S16>/MATLAB Function2' */
real32_T iq_ref_step;                  /* '<S16>/MATLAB Function1' */
real32_T speed_debug;                  /* '<S15>/MATLAB Function' */
real32_T pos_offset;                   /* '<S9>/MATLAB Function3' */
real32_T speed_meas_raw_n_by_1;        /* '<S9>/MATLAB Function2' */
real32_T speed_meas_raw_n_by_m;        /* '<S9>/MATLAB Function1' */
uint16_T theta_qep_cnt;                /* '<S10>/Data Type Conversion3' */

/* Block signals (default storage) */
BlockIO_PMSMctrl PMSMctrl_B;

/* Block states (default storage) */
D_Work_PMSMctrl PMSMctrl_DWork;

/* External inputs (root inport signals with default storage) */
ExternalInputs_PMSMctrl PMSMctrl_U;

/* External outputs (root outports fed by signals with default storage) */
ExternalOutputs_PMSMctrl PMSMctrl_Y;

/* Real-time model */
RT_MODEL_PMSMctrl PMSMctrl_M_;
RT_MODEL_PMSMctrl *const PMSMctrl_M = &PMSMctrl_M_;
void mul_wide_u32(uint32_T in0, uint32_T in1, uint32_T *ptrOutBitsHi, uint32_T
                  *ptrOutBitsLo)
{
  uint32_T outBitsLo;
  uint32_T in0Lo;
  uint32_T in0Hi;
  uint32_T in1Lo;
  uint32_T in1Hi;
  uint32_T productHiLo;
  uint32_T productLoHi;
  in0Hi = in0 >> 16U;
  in0Lo = in0 & 65535U;
  in1Hi = in1 >> 16U;
  in1Lo = in1 & 65535U;
  productHiLo = in0Hi * in1Lo;
  productLoHi = in0Lo * in1Hi;
  in0Lo *= in1Lo;
  in1Lo = 0U;
  outBitsLo = (productLoHi << 16U) + in0Lo;
  if (outBitsLo < in0Lo) {
    in1Lo = 1U;
  }

  in0Lo = outBitsLo;
  outBitsLo += productHiLo << 16U;
  if (outBitsLo < in0Lo) {
    in1Lo++;
  }

  *ptrOutBitsHi = (((productLoHi >> 16U) + (productHiLo >> 16U)) + in0Hi * in1Hi)
    + in1Lo;
  *ptrOutBitsLo = outBitsLo;
}

uint32_T mul_u32_loSR(uint32_T a, uint32_T b, uint32_T aShift)
{
  uint32_T result;
  uint32_T u32_chi;
  mul_wide_u32(a, b, &u32_chi, &result);
  return u32_chi << (32U - aShift) | result >> aShift;
}

void mul_wide_s32(int32_T in0, int32_T in1, uint32_T *ptrOutBitsHi, uint32_T
                  *ptrOutBitsLo)
{
  uint32_T absIn0;
  uint32_T absIn1;
  uint32_T in0Lo;
  uint32_T in0Hi;
  uint32_T in1Hi;
  uint32_T productHiLo;
  uint32_T productLoHi;
  absIn0 = in0 < 0 ? ~(uint32_T)in0 + 1U : (uint32_T)in0;
  absIn1 = in1 < 0 ? ~(uint32_T)in1 + 1U : (uint32_T)in1;
  in0Hi = absIn0 >> 16U;
  in0Lo = absIn0 & 65535U;
  in1Hi = absIn1 >> 16U;
  absIn0 = absIn1 & 65535U;
  productHiLo = in0Hi * absIn0;
  productLoHi = in0Lo * in1Hi;
  absIn0 *= in0Lo;
  absIn1 = 0U;
  in0Lo = (productLoHi << 16U) + absIn0;
  if (in0Lo < absIn0) {
    absIn1 = 1U;
  }

  absIn0 = in0Lo;
  in0Lo += productHiLo << 16U;
  if (in0Lo < absIn0) {
    absIn1++;
  }

  absIn0 = (((productLoHi >> 16U) + (productHiLo >> 16U)) + in0Hi * in1Hi) +
    absIn1;
  if ((in0 != 0) && ((in1 != 0) && ((in0 > 0) != (in1 > 0)))) {
    absIn0 = ~absIn0;
    in0Lo = ~in0Lo;
    in0Lo++;
    if (in0Lo == 0U) {
      absIn0++;
    }
  }

  *ptrOutBitsHi = absIn0;
  *ptrOutBitsLo = in0Lo;
}

int32_T mul_s32_sr32(int32_T a, int32_T b)
{
  uint32_T u32_chi;
  uint32_T u32_clo;
  mul_wide_s32(a, b, &u32_chi, &u32_clo);
  return (int32_T)u32_chi;
}

int32_T mul_s32_hiSR(int32_T a, int32_T b, uint32_T aShift)
{
  uint32_T u32_chi;
  uint32_T u32_clo;
  mul_wide_s32(a, b, &u32_chi, &u32_clo);
  return (int32_T)u32_chi >> aShift;
}

real32_T rt_roundf(real32_T u)
{
  real32_T y;
  if ((real32_T)fabs(u) < 8.388608E+6F) {
    if (u >= 0.5F) {
      y = (real32_T)floor(u + 0.5F);
    } else if (u > -0.5F) {
      y = 0.0F;
    } else {
      y = (real32_T)ceil(u - 0.5F);
    }
  } else {
    y = u;
  }

  return y;
}

/* Model step function for TID0 */
void PMSMctrl_step0(void)              /* Sample time: [0.0001s, 0.0s] */
{
  real32_T multi_out;
  int32_T ref;
  uint32_T cnt_temp;
  real32_T cosOut;
  int16_T tmp;
  uint32_T qY;
  int32_T u0;
  int32_T u1;
  static const int16_T b[6] = { 90, 330, 30, 210, 150, 270 };

  static const int16_T c[6] = { 240, 300, 0, 60, 120, 180 };

  /* Update the flag to indicate when data transfers from
   *  Sample time: [0.0001s, 0.0s] to Sample time: [0.001s, 0.0s]  */
  (PMSMctrl_M->Timing.RateInteraction.TID0_1)++;
  if ((PMSMctrl_M->Timing.RateInteraction.TID0_1) > 9) {
    PMSMctrl_M->Timing.RateInteraction.TID0_1 = 0;
  }

  /* Constant: '<S1>/VF_GAIN' */
  PMSMctrl_B.VF_GAIN = PMSMctrl_P.VF_GAIN;

  /* Constant: '<S1>/VF_BOOST' */
  PMSMctrl_B.VF_BOOST = PMSMctrl_P.VF_BOOST;

  /* Constant: '<S1>/ROT_DIR' */
  PMSMctrl_B.ROT_DIR = PMSMctrl_P.ROT_DIR;

  /* Switch: '<S12>/Switch2' incorporates:
   *  Constant: '<S12>/SpdMul1'
   *  Constant: '<S12>/SpdMul2'
   */
  if (PMSMctrl_B.ROT_DIR >= 1) {
    PMSMctrl_B.Switch2_f = (-1);
  } else {
    PMSMctrl_B.Switch2_f = 1;
  }

  /* End of Switch: '<S12>/Switch2' */

  /* Constant: '<S1>/VF_CTRL' */
  PMSMctrl_B.VF_CTRL = PMSMctrl_P.VF_CTRL;

  /* RelationalOperator: '<S6>/Compare' incorporates:
   *  Constant: '<S6>/Constant'
   */
  PMSMctrl_B.Compare = (uint8_T)(PMSMctrl_B.VF_CTRL == 2);

  /* Switch: '<S13>/Switch4' incorporates:
   *  Constant: '<S12>/id_ref1'
   *  Constant: '<S13>/id_ref1'
   *  Constant: '<S1>/SPEED_REF1'
   *  Switch: '<S12>/Switch3'
   */
  if (PMSMctrl_B.Compare > ((uint8_T)0U)) {
    pos_ref_ui = PMSMctrl_P.POS_REF;
    position_ref = pos_ref_ui;
  } else {
    pos_ref_ui = 0.0F;
    position_ref = 0;
  }

  /* End of Switch: '<S13>/Switch4' */

  /* Product: '<S12>/Product1' */
  PMSMctrl_B.Product1 = (real32_T)PMSMctrl_B.Switch2_f * position_ref;

  /* UnitDelay: '<S35>/Unit  Delay' */
  PMSMctrl_B.y1 = PMSMctrl_DWork.UnitDelay_DSTATE;

  /* Sum: '<S35>/Sum1' */
  PMSMctrl_B.Sum1 = PMSMctrl_B.Product1 - PMSMctrl_B.y1;

  /* Saturate: '<S35>/Saturation' */
  if (PMSMctrl_B.Sum1 > 2.25F) {
    PMSMctrl_B.Deltau_limit = 2.25F;
  } else if (PMSMctrl_B.Sum1 < (-2.25F)) {
    PMSMctrl_B.Deltau_limit = (-2.25F);
  } else {
    PMSMctrl_B.Deltau_limit = PMSMctrl_B.Sum1;
  }

  /* End of Saturate: '<S35>/Saturation' */

  /* Sum: '<S35>/Sum' */
  PMSMctrl_B.y = PMSMctrl_B.Deltau_limit + PMSMctrl_B.y1;

  /* MATLAB Function: '<S10>/MATLAB Function2' incorporates:
   *  Inport: '<Root>/SPORT_cnt'
   */
  /* MATLAB Function 'PMSMctrl/InputScaling/MATLAB Function2': '<S30>:1' */
  if ((PMSMctrl_DWork.cnt_old == MAX_uint32_T) && (PMSMctrl_U.SPORT_cnt !=
       MAX_uint32_T)) {
    /* '<S30>:1:20' */
    /* '<S30>:1:21' */
    PMSMctrl_DWork.cnt_old = PMSMctrl_U.SPORT_cnt;
  }

  if (PMSMctrl_U.SPORT_cnt != MAX_uint32_T) {
    /* '<S30>:1:24' */
    cnt_temp = PMSMctrl_DWork.cnt_old;
    qY = cnt_temp - PMSMctrl_U.SPORT_cnt;
    if (qY > cnt_temp) {
      qY = 0U;
    }

    if (qY > 5000U) {
      /* '<S30>:1:25' */
      /* '<S30>:1:26' */
      ref = PMSMctrl_DWork.turn_cnt;
      if (ref > 2147483646) {
        ref = MAX_int32_T;
      } else {
        ref++;
      }

      PMSMctrl_DWork.turn_cnt = ref;
    } else {
      cnt_temp = PMSMctrl_U.SPORT_cnt;
      qY = cnt_temp - PMSMctrl_DWork.cnt_old;
      if (qY > cnt_temp) {
        qY = 0U;
      }

      if (qY > 5000U) {
        /* '<S30>:1:27' */
        /* '<S30>:1:28' */
        ref = PMSMctrl_DWork.turn_cnt;
        if (ref < -2147483647) {
          ref = MIN_int32_T;
        } else {
          ref--;
        }

        PMSMctrl_DWork.turn_cnt = ref;
      }
    }

    /* '<S30>:1:30' */
    multi_out = (real32_T)PMSMctrl_DWork.turn_cnt * PMSMctrl_EncoderPulses +
      (real32_T)PMSMctrl_U.SPORT_cnt;
  } else {
    /* '<S30>:1:32' */
    multi_out = 0.0F;
  }

  /* '<S30>:1:35' */
  PMSMctrl_DWork.cnt_old = PMSMctrl_U.SPORT_cnt;

  /* '<S30>:1:37' */
  PMSMctrl_B.pos_multi = 6.28318548F * multi_out / PMSMctrl_EncoderPulses;

  /* End of MATLAB Function: '<S10>/MATLAB Function2' */

  /* DataTypeConversion: '<S10>/Data Type Conversion6' incorporates:
   *  Inport: '<Root>/QEP_cnt'
   */
  PMSMctrl_B.DataTypeConversion6 = (int32_T)PMSMctrl_U.QEP_cnt;

  /* DataTypeConversion: '<S10>/Data Type Conversion5' */
  PMSMctrl_B.DataTypeConversion5 = (real32_T)PMSMctrl_B.DataTypeConversion6;

  /* Gain: '<S10>/Gain6' */
  PMSMctrl_B.Gain6 = 0.000628318521F * PMSMctrl_B.DataTypeConversion5;

  /* MATLAB Function: '<S9>/MATLAB Function4' incorporates:
   *  Inport: '<Root>/hall_state'
   */
  /* MATLAB Function 'PMSMctrl/EncInterface/MATLAB Function4': '<S27>:1' */
  /* '<S27>:1:47' */
  /* '<S27>:1:71' */
  if (!PMSMctrl_DWork.AngleStartTable_not_empty) {
    /* '<S27>:1:30' */
    /* '<S27>:1:47' */
    multi_out = 6.28318548F / (4.0F * 360.0F);
    for (ref = 0; ref < 6; ref++) {
      PMSMctrl_DWork.AngleStartTable[ref] = multi_out * (real32_T)b[ref];
    }

    PMSMctrl_DWork.AngleStartTable_not_empty = true;
  }

  if (!PMSMctrl_DWork.AngleTable_not_empty) {
    /* '<S27>:1:54' */
    /* '<S27>:1:71' */
    multi_out = 6.28318548F / (4.0F * 360.0F);
    for (ref = 0; ref < 6; ref++) {
      PMSMctrl_DWork.AngleTable[ref] = multi_out * (real32_T)c[ref];
    }

    PMSMctrl_DWork.AngleTable_not_empty = true;
  }

  if (PMSMctrl_DWork.OffsetState == 0) {
    /* '<S27>:1:78' */
    /* '<S27>:1:79' */
    PMSMctrl_DWork.HallIn = PMSMctrl_U.hall_state;
    if (PMSMctrl_DWork.HallIn == 1) {
      /* '<S27>:1:81' */
      /* '<S27>:1:82' */
      PMSMctrl_DWork.AbsAngle = PMSMctrl_DWork.AngleStartTable[0];
    } else if (PMSMctrl_DWork.HallIn == 2) {
      /* '<S27>:1:83' */
      /* '<S27>:1:84' */
      PMSMctrl_DWork.AbsAngle = PMSMctrl_DWork.AngleStartTable[1];
    } else if (PMSMctrl_DWork.HallIn == 3) {
      /* '<S27>:1:85' */
      /* '<S27>:1:86' */
      PMSMctrl_DWork.AbsAngle = PMSMctrl_DWork.AngleStartTable[2];
    } else if (PMSMctrl_DWork.HallIn == 4) {
      /* '<S27>:1:87' */
      /* '<S27>:1:88' */
      PMSMctrl_DWork.AbsAngle = PMSMctrl_DWork.AngleStartTable[3];
    } else if (PMSMctrl_DWork.HallIn == 5) {
      /* '<S27>:1:89' */
      /* '<S27>:1:90' */
      PMSMctrl_DWork.AbsAngle = PMSMctrl_DWork.AngleStartTable[4];
    } else if (PMSMctrl_DWork.HallIn == 6) {
      /* '<S27>:1:91' */
      /* '<S27>:1:92' */
      PMSMctrl_DWork.AbsAngle = PMSMctrl_DWork.AngleStartTable[5];
    } else {
      /* '<S27>:1:94' */
      PMSMctrl_DWork.AbsAngle = PMSMctrl_DWork.AngleStartTable[5];
    }

    /* '<S27>:1:98' */
    PMSMctrl_DWork.AbsAngle -= PMSMctrl_B.Gain6;

    /* '<S27>:1:101' */
    PMSMctrl_DWork.OffsetState = 1U;
  } else if (PMSMctrl_DWork.OffsetState == 1) {
    /* '<S27>:1:103' */
    if (PMSMctrl_U.hall_state != PMSMctrl_DWork.HallIn) {
      /* '<S27>:1:104' */
      /* '<S27>:1:105' */
      switch (PMSMctrl_U.hall_state) {
       case 6:
        if (PMSMctrl_DWork.HallIn == 2) {
          /* '<S27>:1:107' */
          /* '<S27>:1:108' */
          PMSMctrl_DWork.AbsAngle = PMSMctrl_DWork.AngleTable[1];
        } else {
          /* '<S27>:1:110' */
          PMSMctrl_DWork.AbsAngle = PMSMctrl_DWork.AngleTable[0];
        }
        break;

       case 2:
        if (PMSMctrl_DWork.HallIn == 3) {
          /* '<S27>:1:113' */
          /* '<S27>:1:114' */
          PMSMctrl_DWork.AbsAngle = PMSMctrl_DWork.AngleTable[2];
        } else {
          /* '<S27>:1:116' */
          PMSMctrl_DWork.AbsAngle = PMSMctrl_DWork.AngleTable[1];
        }
        break;

       case 3:
        if (PMSMctrl_DWork.HallIn == 1) {
          /* '<S27>:1:119' */
          /* '<S27>:1:120' */
          PMSMctrl_DWork.AbsAngle = PMSMctrl_DWork.AngleTable[3];
        } else {
          /* '<S27>:1:122' */
          PMSMctrl_DWork.AbsAngle = PMSMctrl_DWork.AngleTable[2];
        }
        break;

       case 1:
        if (PMSMctrl_DWork.HallIn == 5) {
          /* '<S27>:1:125' */
          /* '<S27>:1:126' */
          PMSMctrl_DWork.AbsAngle = PMSMctrl_DWork.AngleTable[4];
        } else {
          /* '<S27>:1:128' */
          PMSMctrl_DWork.AbsAngle = PMSMctrl_DWork.AngleTable[3];
        }
        break;

       case 5:
        if (PMSMctrl_DWork.HallIn == 4) {
          /* '<S27>:1:131' */
          /* '<S27>:1:132' */
          PMSMctrl_DWork.AbsAngle = PMSMctrl_DWork.AngleTable[5];
        } else {
          /* '<S27>:1:134' */
          PMSMctrl_DWork.AbsAngle = PMSMctrl_DWork.AngleTable[4];
        }
        break;

       default:
        if (PMSMctrl_DWork.HallIn == 6) {
          /* '<S27>:1:137' */
          /* '<S27>:1:138' */
          PMSMctrl_DWork.AbsAngle = PMSMctrl_DWork.AngleTable[0];
        } else {
          /* '<S27>:1:140' */
          PMSMctrl_DWork.AbsAngle = PMSMctrl_DWork.AngleTable[5];
        }
        break;
      }

      /* '<S27>:1:143' */
      PMSMctrl_DWork.OffsetState = 2U;

      /* '<S27>:1:147' */
      PMSMctrl_DWork.AbsAngle -= PMSMctrl_B.Gain6;
    }

    /* '<S27>:1:152' */
    PMSMctrl_DWork.HallIn = PMSMctrl_U.hall_state;
  } else {
    /* '<S27>:1:154' */
    PMSMctrl_DWork.HallIn = PMSMctrl_U.hall_state;
  }

  /* '<S27>:1:156' */
  PMSMctrl_B.y_k = PMSMctrl_DWork.AbsAngle;

  /* End of MATLAB Function: '<S9>/MATLAB Function4' */

  /* Switch: '<S9>/Switch2' incorporates:
   *  Constant: '<S9>/sinc_cmd1'
   */
  if (((uint8_T)0U) >= ((uint8_T)1U)) {
    /* Sum: '<S9>/Sum4' incorporates:
     *  Constant: '<S9>/Constant2'
     */
    PMSMctrl_B.Sum4_dt = 0.0F + PMSMctrl_B.pos_multi;
    pos_unaligned = PMSMctrl_B.Sum4_dt;
  } else {
    /* Sum: '<S9>/Sum3' */
    PMSMctrl_B.Sum3_n = PMSMctrl_B.Gain6 + PMSMctrl_B.y_k;
    pos_unaligned = PMSMctrl_B.Sum3_n;
  }

  /* End of Switch: '<S9>/Switch2' */

  /* MATLAB Function: '<S9>/MATLAB Function3' incorporates:
   *  Constant: '<S1>/POS_RST'
   */
  /* MATLAB Function 'PMSMctrl/EncInterface/MATLAB Function3': '<S26>:1' */
  if ((PMSMctrl_P.POS_RST == 1) && (PMSMctrl_DWork.pos_rst_old == 0)) {
    /* '<S26>:1:14' */
    /* '<S26>:1:15' */
    PMSMctrl_DWork.position_offset = pos_unaligned;
  }

  /* '<S26>:1:18' */
  PMSMctrl_DWork.pos_rst_old = PMSMctrl_P.POS_RST;

  /* '<S26>:1:20' */
  pos_offset = PMSMctrl_DWork.position_offset;

  /* End of MATLAB Function: '<S9>/MATLAB Function3' */

  /* Sum: '<S9>/Sum6' */
  pos_aligned = pos_unaligned - pos_offset;

  /* Gain: '<S9>/Gain3' */
  theta_enc_mul = 1.0F * pos_aligned;

  /* Switch: '<S12>/Switch1' incorporates:
   *  Constant: '<S12>/id_ref2'
   */
  if (PMSMctrl_B.Compare > ((uint8_T)0U)) {
    PMSMctrl_B.Switch1 = theta_enc_mul;
  } else {
    PMSMctrl_B.Switch1 = 0.0F;
  }

  /* End of Switch: '<S12>/Switch1' */

  /* Sum: '<S12>/Sum' */
  PMSMctrl_B.Sum = PMSMctrl_B.y - PMSMctrl_B.Switch1;

  /* Gain: '<S12>/Pos Loop Gain' */
  PMSMctrl_B.PosLoopGain = 40.0F * PMSMctrl_B.Sum;

  /* Constant: '<S1>/SPEED_REF2' */
  speed_ff = PMSMctrl_P.SPD_FF;

  /* Switch: '<S12>/Switch4' incorporates:
   *  Constant: '<S12>/id_ref3'
   */
  if (PMSMctrl_B.Compare > ((uint8_T)0U)) {
    /* ManualSwitch: '<S1>/Manual Switch' incorporates:
     *  Constant: '<S1>/Constant1'
     */
    if (((uint8_T)1U) == 1) {
      PMSMctrl_B.ManualSwitch = speed_ff;
    } else {
      PMSMctrl_B.ManualSwitch = 0.0F;
    }

    /* End of ManualSwitch: '<S1>/Manual Switch' */
    PMSMctrl_B.Switch4 = PMSMctrl_B.ManualSwitch;
  } else {
    PMSMctrl_B.Switch4 = 0.0F;
  }

  /* End of Switch: '<S12>/Switch4' */

  /* Sum: '<S12>/Sum1' */
  PMSMctrl_B.Sum1_n = PMSMctrl_B.PosLoopGain + PMSMctrl_B.Switch4;

  /* UnitDelay: '<S34>/Unit  Delay' */
  PMSMctrl_B.y1_d = PMSMctrl_DWork.UnitDelay_DSTATE_i;

  /* Sum: '<S34>/Sum1' */
  PMSMctrl_B.Sum1_m = PMSMctrl_B.Sum1_n - PMSMctrl_B.y1_d;

  /* Saturate: '<S34>/Saturation' */
  if (PMSMctrl_B.Sum1_m > 2.25F) {
    PMSMctrl_B.Deltau_limit_g = 2.25F;
  } else if (PMSMctrl_B.Sum1_m < (-2.25F)) {
    PMSMctrl_B.Deltau_limit_g = (-2.25F);
  } else {
    PMSMctrl_B.Deltau_limit_g = PMSMctrl_B.Sum1_m;
  }

  /* End of Saturate: '<S34>/Saturation' */

  /* Sum: '<S34>/Sum' */
  PMSMctrl_B.y_i = PMSMctrl_B.Deltau_limit_g + PMSMctrl_B.y1_d;

  /* Saturate: '<S12>/MAX_RPM' */
  ref = PMSMctrl_P.MAX_RPM;
  if (PMSMctrl_B.y_i > ref) {
    Nref = (real32_T)ref;
  } else if (PMSMctrl_B.y_i < (-3000.0F)) {
    Nref = (-3000.0F);
  } else {
    Nref = PMSMctrl_B.y_i;
  }

  /* End of Saturate: '<S12>/MAX_RPM' */

  /* Switch: '<S13>/Switch3' incorporates:
   *  Switch: '<S13>/Switch2'
   */
  if (PMSMctrl_B.Compare > ((uint8_T)0U)) {
    speed_ref = Nref;
  } else {
    if (PMSMctrl_B.Compare > ((uint8_T)0U)) {
      /* Switch: '<S13>/Switch2' incorporates:
       *  Constant: '<S13>/id_ref2'
       */
      PMSMctrl_B.Switch2_b = 0;
    } else {
      /* Switch: '<S13>/Switch2' incorporates:
       *  Constant: '<S1>/SPEED_REF'
       */
      PMSMctrl_B.Switch2_b = PMSMctrl_P.SPEED_REF;
    }

    speed_ref = PMSMctrl_B.Switch2_b;
  }

  /* End of Switch: '<S13>/Switch3' */

  /* Switch: '<S19>/Switch' incorporates:
   *  Constant: '<S19>/fstop'
   *  Constant: '<S1>/SYS_CMD'
   */
  if (PMSMctrl_P.SYSTEM_CMD >= ((uint8_T)1U)) {
    PMSMctrl_B.Switch = speed_ref;
  } else {
    PMSMctrl_B.Switch = 0;
  }

  /* End of Switch: '<S19>/Switch' */

  /* Saturate: '<S90>/MAX_RPM' */
  ref = PMSMctrl_P.MAX_RPM;
  if (PMSMctrl_B.Switch > ref) {
    PMSMctrl_B.MAX_RPM = (real32_T)ref;
  } else if (PMSMctrl_B.Switch < 0.0F) {
    PMSMctrl_B.MAX_RPM = 0.0F;
  } else {
    PMSMctrl_B.MAX_RPM = PMSMctrl_B.Switch;
  }

  /* End of Saturate: '<S90>/MAX_RPM' */

  /* Gain: '<S90>/Gain1' */
  multi_out = (real32_T)fmod((real32_T)floor(256.0F * PMSMctrl_B.MAX_RPM),
    4.294967296E+9);
  PMSMctrl_B.Gain1_j = multi_out < 0.0F ? -(int32_T)(uint32_T)-multi_out :
    (int32_T)(uint32_T)multi_out;

  /* UnitDelay: '<S90>/Unit Delay1' */
  PMSMctrl_B.UnitDelay1 = PMSMctrl_DWork.UnitDelay1_DSTATE;

  /* Sum: '<S90>/Sum2' */
  PMSMctrl_B.Sum2_p = PMSMctrl_B.Gain1_j - PMSMctrl_B.UnitDelay1;

  /* Saturate: '<S90>/VF_MAX_RATE' */
  u0 = PMSMctrl_B.Sum2_p;
  u1 = (-10);
  ref = PMSMctrl_P.VF_MAX_RATE;
  if (u0 > ref) {
    PMSMctrl_B.VF_MAX_RATE = ref;
  } else if (u0 < u1) {
    PMSMctrl_B.VF_MAX_RATE = u1;
  } else {
    PMSMctrl_B.VF_MAX_RATE = u0;
  }

  /* End of Saturate: '<S90>/VF_MAX_RATE' */

  /* Sum: '<S90>/Sum4' */
  PMSMctrl_B.Sum4_o = PMSMctrl_B.VF_MAX_RATE + PMSMctrl_B.UnitDelay1;

  /* Gain: '<S90>/Gain2' */
  PMSMctrl_B.Gain2_d = (int16_T)mul_s32_hiSR(1073741824, PMSMctrl_B.Sum4_o, 6U);

  /* RelationalOperator: '<S5>/Compare' incorporates:
   *  Constant: '<S5>/Constant'
   */
  PMSMctrl_B.Compare_l = (uint8_T)(PMSMctrl_B.VF_CTRL == 1);

  /* MATLAB Function: '<S16>/MATLAB Function1' */
  /* MATLAB Function 'PMSMctrl/SpeedControl/MATLAB Function1': '<S42>:1' */
  if (PMSMctrl_DWork.sample_count_f <= 100) {
    /* '<S42>:1:9' */
    /* '<S42>:1:10' */
    ref = -1;
  } else {
    /* '<S42>:1:12' */
    ref = 1;
  }

  if (PMSMctrl_DWork.sample_count_f == 200) {
    /* '<S42>:1:15' */
    /* '<S42>:1:16' */
    PMSMctrl_DWork.sample_count_f = 0U;
  }

  /* '<S42>:1:19' */
  cnt_temp = PMSMctrl_DWork.sample_count_f + 1U;
  if (cnt_temp > 65535U) {
    cnt_temp = 65535U;
  }

  PMSMctrl_DWork.sample_count_f = (uint16_T)cnt_temp;

  /* '<S42>:1:21' */
  iq_ref_step = (real32_T)ref;

  /* End of MATLAB Function: '<S16>/MATLAB Function1' */

  /* RelationalOperator: '<S7>/Compare' incorporates:
   *  Constant: '<S7>/Constant'
   */
  PMSMctrl_B.Compare_g = (uint8_T)(PMSMctrl_B.VF_CTRL == 3);

  /* RelationalOperator: '<S4>/Compare' incorporates:
   *  Constant: '<S4>/Constant'
   */
  PMSMctrl_B.Compare_p = (uint8_T)(PMSMctrl_B.VF_CTRL == 0);

  /* Switch: '<S16>/Switch3' incorporates:
   *  Constant: '<S16>/id_ref1'
   */
  if (PMSMctrl_B.Compare_p > ((uint8_T)0U)) {
    /* Switch: '<S16>/Switch2' incorporates:
     *  Constant: '<S16>/SpdMul1'
     *  Constant: '<S16>/SpdMul2'
     */
    if (PMSMctrl_B.ROT_DIR >= 1) {
      PMSMctrl_B.Switch2_fn = (-1);
    } else {
      PMSMctrl_B.Switch2_fn = 1;
    }

    /* End of Switch: '<S16>/Switch2' */
    PMSMctrl_B.Switch3_h = PMSMctrl_B.Switch2_fn;
  } else {
    PMSMctrl_B.Switch3_h = 1;
  }

  /* End of Switch: '<S16>/Switch3' */

  /* Switch: '<S16>/Switch5' incorporates:
   *  Constant: '<S16>/SpdMul7'
   *  Constant: '<S1>/SYS_CMD'
   */
  if (PMSMctrl_P.SYSTEM_CMD > ((uint8_T)0U)) {
    PMSMctrl_B.Switch5 = speed_ref;
  } else {
    PMSMctrl_B.Switch5 = 0.0F;
  }

  /* End of Switch: '<S16>/Switch5' */

  /* MATLAB Function: '<S16>/MATLAB Function2' */
  /* MATLAB Function 'PMSMctrl/SpeedControl/MATLAB Function2': '<S43>:1' */
  if (PMSMctrl_DWork.sample_count <= 2000) {
    /* '<S43>:1:9' */
    /* '<S43>:1:10' */
    multi_out = PMSMctrl_B.Switch5;
  } else {
    /* '<S43>:1:12' */
    multi_out = 0.0F;
  }

  if (PMSMctrl_DWork.sample_count == 4000) {
    /* '<S43>:1:15' */
    /* '<S43>:1:16' */
    PMSMctrl_DWork.sample_count = 0U;
  }

  /* '<S43>:1:19' */
  cnt_temp = PMSMctrl_DWork.sample_count + 1U;
  if (cnt_temp > 65535U) {
    cnt_temp = 65535U;
  }

  PMSMctrl_DWork.sample_count = (uint16_T)cnt_temp;

  /* '<S43>:1:21' */
  w_step = multi_out;

  /* End of MATLAB Function: '<S16>/MATLAB Function2' */

  /* Switch: '<S16>/Switch' incorporates:
   *  Constant: '<S16>/SpdMul3'
   *  Constant: '<S1>/SYS_CMD'
   */
  if (PMSMctrl_P.SYSTEM_CMD > ((uint8_T)0U)) {
    /* RelationalOperator: '<S8>/Compare' incorporates:
     *  Constant: '<S8>/Constant'
     */
    PMSMctrl_B.Compare_k = (uint8_T)(PMSMctrl_B.VF_CTRL == 4);

    /* Switch: '<S16>/Switch6' */
    if (PMSMctrl_B.Compare_k >= ((uint8_T)1U)) {
      PMSMctrl_B.w_ref = w_step;
    } else {
      PMSMctrl_B.w_ref = speed_ref;
    }

    /* End of Switch: '<S16>/Switch6' */
    PMSMctrl_B.Switch_n = PMSMctrl_B.w_ref;
  } else {
    PMSMctrl_B.Switch_n = 0;
  }

  /* End of Switch: '<S16>/Switch' */

  /* Saturate: '<S16>/MAX_RPM' */
  ref = PMSMctrl_P.MAX_RPM;
  if (PMSMctrl_B.Switch_n > ref) {
    PMSMctrl_B.MAX_RPM_j = (real32_T)ref;
  } else if (PMSMctrl_B.Switch_n < (-3000.0F)) {
    PMSMctrl_B.MAX_RPM_j = (-3000.0F);
  } else {
    PMSMctrl_B.MAX_RPM_j = PMSMctrl_B.Switch_n;
  }

  /* End of Saturate: '<S16>/MAX_RPM' */

  /* Product: '<S16>/Product1' */
  PMSMctrl_B.Product1_b = (real32_T)PMSMctrl_B.Switch3_h * PMSMctrl_B.MAX_RPM_j;

  /* DataTypeConversion: '<S16>/Data Type Conversion' */
  PMSMctrl_B.DataTypeConversion = PMSMctrl_B.Product1_b;

  /* UnitDelay: '<S40>/Unit  Delay' */
  PMSMctrl_B.y1_h = PMSMctrl_DWork.UnitDelay_DSTATE_e;

  /* Sum: '<S40>/Sum1' */
  PMSMctrl_B.Sum1_j = PMSMctrl_B.DataTypeConversion - PMSMctrl_B.y1_h;

  /* Saturate: '<S40>/Saturation' */
  if (PMSMctrl_B.Sum1_j > PMSMctrl_P.SpdSlewRatePos) {
    PMSMctrl_B.Deltau_limit_h = PMSMctrl_P.SpdSlewRatePos;
  } else if (PMSMctrl_B.Sum1_j < PMSMctrl_P.SpdSlewRateNeg) {
    PMSMctrl_B.Deltau_limit_h = PMSMctrl_P.SpdSlewRateNeg;
  } else {
    PMSMctrl_B.Deltau_limit_h = PMSMctrl_B.Sum1_j;
  }

  /* End of Saturate: '<S40>/Saturation' */

  /* Sum: '<S40>/Sum' */
  speed_ref_lim = PMSMctrl_B.Deltau_limit_h + PMSMctrl_B.y1_h;

  /* RateTransition: '<S1>/Rate Transition1' */
  if (PMSMctrl_M->Timing.RateInteraction.TID0_1 == 1) {
    spd_fil_calc = PMSMctrl_DWork.RateTransition1_Buffer0;
  }

  /* End of RateTransition: '<S1>/Rate Transition1' */

  /* Abs: '<S17>/Abs' */
  PMSMctrl_B.Abs = (real32_T)fabs(speed_ref_lim);

  /* MATLAB Function: '<S9>/MATLAB Function1' incorporates:
   *  Inport: '<Root>/N_by_M'
   */
  /* MATLAB Function 'PMSMctrl/EncInterface/MATLAB Function1': '<S24>:1' */
  if (PMSMctrl_U.N_by_M == MAX_uint32_T) {
    /* '<S24>:1:17' */
    /* '<S24>:1:18' */
    multi_out = 0.0F;
  } else if (PMSMctrl_U.N_by_M == 0U) {
    /* '<S24>:1:19' */
    /* '<S24>:1:20' */
    multi_out = 0.0F;
  } else {
    /* '<S24>:1:22' */
    multi_out = 2.4E+10F / ((real32_T)PMSMctrl_U.N_by_M * PMSMctrl_EncoderPulses);
  }

  /* '<S24>:1:25' */
  speed_meas_raw_n_by_m = multi_out;

  /* End of MATLAB Function: '<S9>/MATLAB Function1' */

  /* DataTypeConversion: '<S9>/Data Type Conversion5' incorporates:
   *  Inport: '<Root>/ROT_DIR_meas'
   */
  PMSMctrl_B.DataTypeConversion5_j = PMSMctrl_U.ROT_DIR_meas;

  /* Product: '<S9>/Product1' */
  spd_raw_n_by_m = speed_meas_raw_n_by_m * PMSMctrl_B.DataTypeConversion5_j;

  /* DiscreteStateSpace: '<S22>/Discrete State-Space' */
  {
    spd_fil_n_by_m = 0.0952381F*PMSMctrl_DWork.DiscreteStateSpace_DSTATE;
    spd_fil_n_by_m += 0.0476190485F*spd_raw_n_by_m;
  }

  /* MATLAB Function: '<S9>/MATLAB Function2' incorporates:
   *  Inport: '<Root>/N_by_1'
   */
  /* MATLAB Function 'PMSMctrl/EncInterface/MATLAB Function2': '<S25>:1' */
  if (PMSMctrl_U.N_by_1 == MAX_uint32_T) {
    /* '<S25>:1:17' */
    /* '<S25>:1:18' */
    multi_out = 0.0F;
  } else if (PMSMctrl_U.N_by_1 == 0U) {
    /* '<S25>:1:19' */
    /* '<S25>:1:20' */
    multi_out = 0.0F;
  } else {
    /* '<S25>:1:22' */
    multi_out = 6.0E+9F / ((real32_T)PMSMctrl_U.N_by_1 * PMSMctrl_EncoderPulses);
  }

  /* '<S25>:1:25' */
  speed_meas_raw_n_by_1 = multi_out;

  /* End of MATLAB Function: '<S9>/MATLAB Function2' */

  /* Product: '<S9>/Product3' */
  spd_raw_n_by_1 = PMSMctrl_B.DataTypeConversion5_j * speed_meas_raw_n_by_1;

  /* Gain: '<S9>/Gain4' */
  spd_fil_n_by_1 = 1.0F * spd_raw_n_by_1;

  /* Switch: '<S17>/Switch3' */
  if (PMSMctrl_B.Abs >= 0.0F) {
    PMSMctrl_B.Switch3 = spd_fil_n_by_m;
  } else {
    PMSMctrl_B.Switch3 = spd_fil_n_by_1;
  }

  /* End of Switch: '<S17>/Switch3' */

  /* Switch: '<S17>/Switch2' */
  if (PMSMctrl_B.Abs >= 1000.0F) {
    speed_fil = spd_fil_calc;
  } else {
    speed_fil = PMSMctrl_B.Switch3;
  }

  /* End of Switch: '<S17>/Switch2' */

  /* Sum: '<S16>/Sum2' */
  PMSMctrl_B.Sum2 = speed_ref_lim - speed_fil;

  /* MATLAB Function: '<S16>/MATLAB Function' */
  /* MATLAB Function 'PMSMctrl/SpeedControl/MATLAB Function': '<S41>:1' */
  /* '<S41>:1:24' */
  multi_out = (real32_T)fabs(speed_ref_lim);
  if (multi_out < 3000.0F) {
    /* '<S41>:1:26' */
    /* '<S41>:1:27' */
    multi_out = PMSMctrl_GainMax;
  } else {
    /* '<S41>:1:29' */
    multi_out = (PMSMctrl_GainMax - 0.1F) * 3000.0F / multi_out + 0.1F;
  }

  /* '<S41>:1:32' */
  /* '<S41>:1:34' */
  PMSMctrl_B.y_o = multi_out * PMSMctrl_B.Sum2;

  /* End of MATLAB Function: '<S16>/MATLAB Function' */

  /* Gain: '<S78>/Proportional Gain' */
  PMSMctrl_B.ProportionalGain = PMSMctrl_P.Kpw * PMSMctrl_B.y_o;

  /* DiscreteIntegrator: '<S73>/Integrator' incorporates:
   *  Constant: '<S1>/SYS_CMD'
   */
  if ((PMSMctrl_P.SYSTEM_CMD > 0) && (PMSMctrl_DWork.Integrator_PrevResetState <=
       0)) {
    PMSMctrl_DWork.Integrator_DSTATE = 0.0F;
  }

  PMSMctrl_B.Integrator = PMSMctrl_DWork.Integrator_DSTATE;

  /* End of DiscreteIntegrator: '<S73>/Integrator' */

  /* Gain: '<S67>/Derivative Gain' */
  PMSMctrl_B.DerivativeGain = 0.0F * PMSMctrl_B.y_o;

  /* DiscreteIntegrator: '<S68>/Filter' incorporates:
   *  Constant: '<S1>/SYS_CMD'
   */
  if ((PMSMctrl_P.SYSTEM_CMD > 0) && (PMSMctrl_DWork.Filter_PrevResetState <= 0))
  {
    PMSMctrl_DWork.Filter_DSTATE = 0.0F;
  }

  PMSMctrl_B.Filter = PMSMctrl_DWork.Filter_DSTATE;

  /* End of DiscreteIntegrator: '<S68>/Filter' */

  /* Sum: '<S68>/SumD' */
  PMSMctrl_B.SumD = PMSMctrl_B.DerivativeGain - PMSMctrl_B.Filter;

  /* Gain: '<S76>/Filter Coefficient' */
  PMSMctrl_B.FilterCoefficient = 2.0F * PMSMctrl_B.SumD;

  /* Sum: '<S82>/Sum' */
  PMSMctrl_B.Sum_i = (PMSMctrl_B.ProportionalGain + PMSMctrl_B.Integrator) +
    PMSMctrl_B.FilterCoefficient;

  /* Switch: '<S16>/Switch4' incorporates:
   *  Saturate: '<S80>/Saturation'
   */
  if (PMSMctrl_B.Compare_g >= ((uint8_T)1U)) {
    /* Switch: '<S16>/Switch1' incorporates:
     *  Constant: '<S16>/SpdMul4'
     *  Constant: '<S1>/SYS_CMD'
     */
    if (PMSMctrl_P.SYSTEM_CMD > ((uint8_T)0U)) {
      PMSMctrl_B.Switch1_a = iq_ref_step;
    } else {
      PMSMctrl_B.Switch1_a = 0.0F;
    }

    /* End of Switch: '<S16>/Switch1' */
    iq_ref = PMSMctrl_B.Switch1_a;
  } else {
    if (PMSMctrl_B.Sum_i > PMSMctrl_P.iqMax) {
      /* Saturate: '<S80>/Saturation' */
      PMSMctrl_B.Saturation_b = PMSMctrl_P.iqMax;
    } else if (PMSMctrl_B.Sum_i < PMSMctrl_P.iqMin) {
      /* Saturate: '<S80>/Saturation' */
      PMSMctrl_B.Saturation_b = PMSMctrl_P.iqMin;
    } else {
      /* Saturate: '<S80>/Saturation' */
      PMSMctrl_B.Saturation_b = PMSMctrl_B.Sum_i;
    }

    iq_ref = PMSMctrl_B.Saturation_b;
  }

  /* End of Switch: '<S16>/Switch4' */

  /* SignalConversion generated from: '<S20>/S-Function' incorporates:
   *  Constant: '<S1>/Constant'
   */
  PMSMctrl_B.TmpSignalConversionAtSFunctionI[0] = 0.0F;
  PMSMctrl_B.TmpSignalConversionAtSFunctionI[1] = iq_ref;

  /* DataTypeConversion: '<S10>/Data Type Conversion7' incorporates:
   *  Inport: '<Root>/iab_sinc'
   */
  PMSMctrl_B.DataTypeConversion7[0] = PMSMctrl_U.ibc_sinc[0];
  PMSMctrl_B.DataTypeConversion7[1] = PMSMctrl_U.ibc_sinc[1];

  /* MATLAB Function: '<S10>/MATLAB Function1' incorporates:
   *  Constant: '<S1>/SYS_CMD'
   */
  /* MATLAB Function 'PMSMctrl/InputScaling/MATLAB Function1': '<S29>:1' */
  if ((PMSMctrl_P.SYSTEM_CMD == 0) && (PMSMctrl_DWork.SysCmd_old == 1)) {
    /* '<S29>:1:39' */
    /* '<S29>:1:40' */
    PMSMctrl_DWork.ia_acc = 0.0F;

    /* '<S29>:1:41' */
    PMSMctrl_DWork.ib_acc = 0.0F;
  }

  if (PMSMctrl_P.SYSTEM_CMD == 0) {
    /* '<S29>:1:44' */
    /* '<S29>:1:45' */
    PMSMctrl_DWork.ia_acc += PMSMctrl_B.DataTypeConversion7[0];

    /* '<S29>:1:46' */
    PMSMctrl_DWork.ib_acc += PMSMctrl_B.DataTypeConversion7[1];

    /* '<S29>:1:47' */
    ref = PMSMctrl_DWork.sample + 1;
    if (ref > 32767) {
      ref = 32767;
    }

    PMSMctrl_DWork.sample = (int16_T)ref;
  }

  if (PMSMctrl_DWork.sample == 50.0) {
    /* '<S29>:1:50' */
    /* '<S29>:1:51' */
    PMSMctrl_DWork.CurOff[0] = PMSMctrl_DWork.ia_acc / (real32_T)50.0;

    /* '<S29>:1:52' */
    PMSMctrl_DWork.CurOff[1] = PMSMctrl_DWork.ib_acc / (real32_T)50.0;

    /* '<S29>:1:53' */
    PMSMctrl_DWork.ia_acc = 0.0F;

    /* '<S29>:1:54' */
    PMSMctrl_DWork.ib_acc = 0.0F;

    /* '<S29>:1:55' */
    PMSMctrl_DWork.sample = 0;
  }

  /* '<S29>:1:58' */
  PMSMctrl_DWork.SysCmd_old = PMSMctrl_P.SYSTEM_CMD;

  /* '<S29>:1:60' */
  PMSMctrl_B.y_j[0] = PMSMctrl_DWork.CurOff[0];

  /* Sum: '<S10>/Sum4' */
  multi_out = (real32_T)fmod((real32_T)floor(PMSMctrl_B.DataTypeConversion7[0]),
    65536.0);
  cosOut = (real32_T)fmod((real32_T)floor(PMSMctrl_B.y_j[0]), 65536.0);
  PMSMctrl_B.Sum4[0] = (int16_T)((multi_out < 0.0F ? (int32_T)(int16_T)-(int16_T)
    (uint16_T)-multi_out : (int32_T)(int16_T)(uint16_T)multi_out) - (cosOut <
    0.0F ? (int32_T)(int16_T)-(int16_T)(uint16_T)-cosOut : (int32_T)(int16_T)
    (uint16_T)cosOut));

  /* Gain: '<S10>/Gain4' */
  PMSMctrl_B.Gain4[0] = (-0.5F) * PMSMctrl_B.Sum4[0];

  /* Gain: '<S10>/Gain5' */
  PMSMctrl_B.Gain5[0] = 0.000390625F * PMSMctrl_B.Gain4[0];

  /* Gain: '<S10>/Gain7' */
  PMSMctrl_B.Gain7[0] = (-1.0F) * PMSMctrl_B.Gain5[0];

  /* MATLAB Function: '<S10>/MATLAB Function1' */
  PMSMctrl_B.y_j[1] = PMSMctrl_DWork.CurOff[1];

  /* Sum: '<S10>/Sum4' */
  multi_out = (real32_T)fmod((real32_T)floor(PMSMctrl_B.DataTypeConversion7[1]),
    65536.0);
  cosOut = (real32_T)fmod((real32_T)floor(PMSMctrl_B.y_j[1]), 65536.0);
  PMSMctrl_B.Sum4[1] = (int16_T)((multi_out < 0.0F ? (int32_T)(int16_T)-(int16_T)
    (uint16_T)-multi_out : (int32_T)(int16_T)(uint16_T)multi_out) - (cosOut <
    0.0F ? (int32_T)(int16_T)-(int16_T)(uint16_T)-cosOut : (int32_T)(int16_T)
    (uint16_T)cosOut));

  /* Gain: '<S10>/Gain4' */
  PMSMctrl_B.Gain4[1] = (-0.5F) * PMSMctrl_B.Sum4[1];

  /* Gain: '<S10>/Gain5' */
  PMSMctrl_B.Gain5[1] = 0.000390625F * PMSMctrl_B.Gain4[1];

  /* Gain: '<S10>/Gain7' */
  PMSMctrl_B.Gain7[1] = (-1.0F) * PMSMctrl_B.Gain5[1];

  /* Sum: '<S10>/Sum3' */
  PMSMctrl_B.Sum3 = (0.0F - PMSMctrl_B.Gain7[0]) - PMSMctrl_B.Gain7[1];

  /* MATLAB Function: '<S10>/MATLAB Function' incorporates:
   *  Constant: '<S1>/SYS_CMD'
   *  Inport: '<Root>/iabc_adc'
   */
  /* MATLAB Function 'PMSMctrl/InputScaling/MATLAB Function': '<S28>:1' */
  if ((PMSMctrl_P.SYSTEM_CMD == 0) && (PMSMctrl_DWork.SysCmd_old_m == 1)) {
    /* '<S28>:1:41' */
    /* '<S28>:1:42' */
    PMSMctrl_DWork.ia_acc_m = 0.0F;

    /* '<S28>:1:43' */
    PMSMctrl_DWork.ib_acc_j = 0.0F;

    /* '<S28>:1:44' */
    PMSMctrl_DWork.ic_acc = 0.0F;
  }

  if (PMSMctrl_P.SYSTEM_CMD == 0) {
    /* '<S28>:1:47' */
    /* '<S28>:1:48' */
    PMSMctrl_DWork.ia_acc_m += (real32_T)PMSMctrl_U.iabc_adc[0];

    /* '<S28>:1:49' */
    PMSMctrl_DWork.ib_acc_j += (real32_T)PMSMctrl_U.iabc_adc[1];

    /* '<S28>:1:50' */
    PMSMctrl_DWork.ic_acc += (real32_T)PMSMctrl_U.iabc_adc[2];

    /* '<S28>:1:51' */
    ref = PMSMctrl_DWork.sample_o + 1;
    if (ref > 32767) {
      ref = 32767;
    }

    PMSMctrl_DWork.sample_o = (int16_T)ref;
  }

  if (PMSMctrl_DWork.sample_o == 50.0) {
    /* '<S28>:1:54' */
    /* '<S28>:1:55' */
    multi_out = rt_roundf(PMSMctrl_DWork.ia_acc_m / (real32_T)50.0);
    if (multi_out < 32768.0F) {
      if (multi_out >= -32768.0F) {
        tmp = (int16_T)multi_out;
      } else {
        tmp = MIN_int16_T;
      }
    } else {
      tmp = MAX_int16_T;
    }

    ref = tmp - 32767;
    if (ref < -32768) {
      ref = -32768;
    }

    PMSMctrl_DWork.CurOff_p[0] = (int16_T)ref;

    /* '<S28>:1:56' */
    multi_out = rt_roundf(PMSMctrl_DWork.ib_acc_j / (real32_T)50.0);
    if (multi_out < 32768.0F) {
      if (multi_out >= -32768.0F) {
        tmp = (int16_T)multi_out;
      } else {
        tmp = MIN_int16_T;
      }
    } else {
      tmp = MAX_int16_T;
    }

    ref = tmp - 32767;
    if (ref < -32768) {
      ref = -32768;
    }

    PMSMctrl_DWork.CurOff_p[1] = (int16_T)ref;

    /* '<S28>:1:57' */
    multi_out = rt_roundf(PMSMctrl_DWork.ic_acc / (real32_T)50.0);
    if (multi_out < 32768.0F) {
      if (multi_out >= -32768.0F) {
        tmp = (int16_T)multi_out;
      } else {
        tmp = MIN_int16_T;
      }
    } else {
      tmp = MAX_int16_T;
    }

    ref = tmp - 32767;
    if (ref < -32768) {
      ref = -32768;
    }

    PMSMctrl_DWork.CurOff_p[2] = (int16_T)ref;

    /* '<S28>:1:58' */
    PMSMctrl_DWork.ia_acc_m = 0.0F;

    /* '<S28>:1:59' */
    PMSMctrl_DWork.ib_acc_j = 0.0F;

    /* '<S28>:1:60' */
    PMSMctrl_DWork.ic_acc = 0.0F;

    /* '<S28>:1:61' */
    PMSMctrl_DWork.sample_o = 0;
  }

  /* '<S28>:1:64' */
  PMSMctrl_DWork.SysCmd_old_m = PMSMctrl_P.SYSTEM_CMD;

  /* '<S28>:1:66' */
  PMSMctrl_B.y_a[0] = PMSMctrl_DWork.CurOff_p[0];

  /* Sum: '<S10>/Sum5' incorporates:
   *  Inport: '<Root>/iabc_adc'
   */
  PMSMctrl_B.Sum5_p[0] = (int16_T)((PMSMctrl_U.iabc_adc[0] - PMSMctrl_B.y_a[0]) >>
    1);

  /* DataTypeConversion: '<S10>/Data Type Conversion' */
  PMSMctrl_B.DataTypeConversion_p[0] = (real32_T)PMSMctrl_B.Sum5_p[0] * 2.0F;

  /* Sum: '<S10>/Sum1' incorporates:
   *  Constant: '<S10>/Constant'
   */
  PMSMctrl_B.Sum1_o[0] = PMSMctrl_B.DataTypeConversion_p[0] -
    PMSMctrl_P.iabcOffset[0];

  /* Gain: '<S10>/Gain' */
  PMSMctrl_B.Gain[0] = PMSMctrl_P.iabcScale * PMSMctrl_B.Sum1_o[0];

  /* MATLAB Function: '<S10>/MATLAB Function' */
  PMSMctrl_B.y_a[1] = PMSMctrl_DWork.CurOff_p[1];

  /* Sum: '<S10>/Sum5' incorporates:
   *  Inport: '<Root>/iabc_adc'
   */
  PMSMctrl_B.Sum5_p[1] = (int16_T)((PMSMctrl_U.iabc_adc[1] - PMSMctrl_B.y_a[1]) >>
    1);

  /* DataTypeConversion: '<S10>/Data Type Conversion' */
  PMSMctrl_B.DataTypeConversion_p[1] = (real32_T)PMSMctrl_B.Sum5_p[1] * 2.0F;

  /* Sum: '<S10>/Sum1' incorporates:
   *  Constant: '<S10>/Constant'
   */
  PMSMctrl_B.Sum1_o[1] = PMSMctrl_B.DataTypeConversion_p[1] -
    PMSMctrl_P.iabcOffset[1];

  /* Gain: '<S10>/Gain' */
  PMSMctrl_B.Gain[1] = PMSMctrl_P.iabcScale * PMSMctrl_B.Sum1_o[1];

  /* MATLAB Function: '<S10>/MATLAB Function' */
  PMSMctrl_B.y_a[2] = PMSMctrl_DWork.CurOff_p[2];

  /* Sum: '<S10>/Sum5' incorporates:
   *  Inport: '<Root>/iabc_adc'
   */
  PMSMctrl_B.Sum5_p[2] = (int16_T)((PMSMctrl_U.iabc_adc[2] - PMSMctrl_B.y_a[2]) >>
    1);

  /* DataTypeConversion: '<S10>/Data Type Conversion' */
  PMSMctrl_B.DataTypeConversion_p[2] = (real32_T)PMSMctrl_B.Sum5_p[2] * 2.0F;

  /* Sum: '<S10>/Sum1' incorporates:
   *  Constant: '<S10>/Constant'
   */
  PMSMctrl_B.Sum1_o[2] = PMSMctrl_B.DataTypeConversion_p[2] -
    PMSMctrl_P.iabcOffset[2];

  /* Gain: '<S10>/Gain' */
  PMSMctrl_B.Gain[2] = PMSMctrl_P.iabcScale * PMSMctrl_B.Sum1_o[2];

  /* Switch: '<S10>/Switch1' */
  PMSMctrl_B.Switch1_l[0] = PMSMctrl_B.Sum3;
  PMSMctrl_B.Switch1_l[1] = PMSMctrl_B.Gain7[0];
  PMSMctrl_B.Switch1_l[2] = PMSMctrl_B.Gain7[1];

  /* Switch: '<S19>/Switch2' incorporates:
   *  Constant: '<S19>/SpdMul1'
   *  Constant: '<S19>/SpdMul2'
   */
  if (PMSMctrl_B.ROT_DIR >= 1) {
    PMSMctrl_B.Switch2_g = (-1);
  } else {
    PMSMctrl_B.Switch2_g = 1;
  }

  /* End of Switch: '<S19>/Switch2' */

  /* Product: '<S19>/Product1' */
  PMSMctrl_B.Product1_g = PMSMctrl_B.Gain2_d * PMSMctrl_B.Switch2_g;

  /* Gain: '<S89>/Gain1' */
  PMSMctrl_B.Gain1_f = (int16_T)mul_s32_sr32(1891631104, PMSMctrl_B.Product1_g);

  /* UnitDelay: '<S89>/Unit Delay' */
  PMSMctrl_B.UnitDelay = PMSMctrl_DWork.UnitDelay_DSTATE_h;

  /* Sum: '<S89>/Sum1' */
  PMSMctrl_B.Sum1_m1 = (int16_T)(PMSMctrl_B.Gain1_f + PMSMctrl_B.UnitDelay);

  /* Gain: '<S89>/Gain' */
  PMSMctrl_B.Gain_h = (int16_T)((25736 * PMSMctrl_B.Sum1_m1) >> 23);

  /* DataTypeConversion: '<S89>/Data Type Conversion' */
  theta_vf = (real32_T)PMSMctrl_B.Gain_h * 0.03125F;

  /* MATLAB Function: '<S10>/MATLAB Function3' incorporates:
   *  Inport: '<Root>/SPORT_cnt'
   */
  /* MATLAB Function 'PMSMctrl/InputScaling/MATLAB Function3': '<S31>:1' */
  if (PMSMctrl_U.SPORT_cnt != MAX_uint32_T) {
    /* '<S31>:1:5' */
    /* '<S31>:1:6' */
    cnt_temp = PMSMctrl_U.SPORT_cnt;
  } else {
    /* '<S31>:1:8' */
    cnt_temp = 0U;
  }

  /* '<S31>:1:11' */
  PMSMctrl_B.cnt_out = cnt_temp;

  /* End of MATLAB Function: '<S10>/MATLAB Function3' */

  /* Gain: '<S10>/Gain2' incorporates:
   *  Inport: '<Root>/QEP_cnt'
   */
  PMSMctrl_B.Gain2 = mul_u32_loSR(3518437120U, PMSMctrl_U.QEP_cnt, 27U);

  /* DataTypeConversion: '<S10>/Data Type Conversion3' */
  theta_qep_cnt = (uint16_T)PMSMctrl_B.Gain2;

  /* MATLAB Function: '<S9>/MATLAB Function' incorporates:
   *  Inport: '<Root>/hall_state'
   */
  /* MATLAB Function 'PMSMctrl/EncInterface/MATLAB Function': '<S23>:1' */
  if (PMSMctrl_DWork.OffsetState_b == 0) {
    /* '<S23>:1:81' */
    /* '<S23>:1:82' */
    PMSMctrl_DWork.HallIn_m = PMSMctrl_U.hall_state;
    if (PMSMctrl_DWork.HallIn_m == 1) {
      /* '<S23>:1:84' */
      /* '<S23>:1:85' */
      PMSMctrl_DWork.AbsAngle_d = PMSMctrl_DWork.AngleStartTable_i[0];
    } else if (PMSMctrl_DWork.HallIn_m == 2) {
      /* '<S23>:1:86' */
      /* '<S23>:1:87' */
      PMSMctrl_DWork.AbsAngle_d = PMSMctrl_DWork.AngleStartTable_i[1];
    } else if (PMSMctrl_DWork.HallIn_m == 3) {
      /* '<S23>:1:88' */
      /* '<S23>:1:89' */
      PMSMctrl_DWork.AbsAngle_d = PMSMctrl_DWork.AngleStartTable_i[2];
    } else if (PMSMctrl_DWork.HallIn_m == 4) {
      /* '<S23>:1:90' */
      /* '<S23>:1:91' */
      PMSMctrl_DWork.AbsAngle_d = PMSMctrl_DWork.AngleStartTable_i[3];
    } else if (PMSMctrl_DWork.HallIn_m == 5) {
      /* '<S23>:1:92' */
      /* '<S23>:1:93' */
      PMSMctrl_DWork.AbsAngle_d = PMSMctrl_DWork.AngleStartTable_i[4];
    } else if (PMSMctrl_DWork.HallIn_m == 6) {
      /* '<S23>:1:94' */
      /* '<S23>:1:95' */
      PMSMctrl_DWork.AbsAngle_d = PMSMctrl_DWork.AngleStartTable_i[5];
    } else {
      /* '<S23>:1:97' */
      PMSMctrl_DWork.AbsAngle_d = PMSMctrl_DWork.AngleStartTable_i[5];
    }

    if (theta_qep_cnt > PMSMctrl_DWork.AbsAngle_d) {
      /* '<S23>:1:100' */
      /* '<S23>:1:101' */
      cnt_temp = (uint32_T)(65535 - theta_qep_cnt) + PMSMctrl_DWork.AbsAngle_d;
      if (cnt_temp > 65535U) {
        cnt_temp = 65535U;
      }

      PMSMctrl_DWork.AbsAngle_d = (uint16_T)cnt_temp;
    } else {
      /* '<S23>:1:103' */
      ref = PMSMctrl_DWork.AbsAngle_d;
      qY = (uint32_T)ref - theta_qep_cnt;
      if (qY > (uint32_T)ref) {
        qY = 0U;
      }

      ref = (int32_T)qY;
      PMSMctrl_DWork.AbsAngle_d = (uint16_T)ref;
    }

    /* '<S23>:1:106' */
    PMSMctrl_DWork.OffsetState_b = 1U;
  } else if (PMSMctrl_DWork.OffsetState_b == 1) {
    /* '<S23>:1:108' */
    if (PMSMctrl_U.hall_state != PMSMctrl_DWork.HallIn_m) {
      /* '<S23>:1:109' */
      /* '<S23>:1:110' */
      switch (PMSMctrl_U.hall_state) {
       case 6:
        if (PMSMctrl_DWork.HallIn_m == 2) {
          /* '<S23>:1:112' */
          /* '<S23>:1:113' */
          PMSMctrl_DWork.AbsAngle_d = PMSMctrl_DWork.AngleTable_m[1];
        } else {
          /* '<S23>:1:115' */
          PMSMctrl_DWork.AbsAngle_d = PMSMctrl_DWork.AngleTable_m[0];
        }
        break;

       case 2:
        if (PMSMctrl_DWork.HallIn_m == 3) {
          /* '<S23>:1:118' */
          /* '<S23>:1:119' */
          PMSMctrl_DWork.AbsAngle_d = PMSMctrl_DWork.AngleTable_m[2];
        } else {
          /* '<S23>:1:121' */
          PMSMctrl_DWork.AbsAngle_d = PMSMctrl_DWork.AngleTable_m[1];
        }
        break;

       case 3:
        if (PMSMctrl_DWork.HallIn_m == 1) {
          /* '<S23>:1:124' */
          /* '<S23>:1:125' */
          PMSMctrl_DWork.AbsAngle_d = PMSMctrl_DWork.AngleTable_m[3];
        } else {
          /* '<S23>:1:127' */
          PMSMctrl_DWork.AbsAngle_d = PMSMctrl_DWork.AngleTable_m[2];
        }
        break;

       case 1:
        if (PMSMctrl_DWork.HallIn_m == 5) {
          /* '<S23>:1:130' */
          /* '<S23>:1:131' */
          PMSMctrl_DWork.AbsAngle_d = PMSMctrl_DWork.AngleTable_m[4];
        } else {
          /* '<S23>:1:133' */
          PMSMctrl_DWork.AbsAngle_d = PMSMctrl_DWork.AngleTable_m[3];
        }
        break;

       case 5:
        if (PMSMctrl_DWork.HallIn_m == 4) {
          /* '<S23>:1:136' */
          /* '<S23>:1:137' */
          PMSMctrl_DWork.AbsAngle_d = PMSMctrl_DWork.AngleTable_m[5];
        } else {
          /* '<S23>:1:139' */
          PMSMctrl_DWork.AbsAngle_d = PMSMctrl_DWork.AngleTable_m[4];
        }
        break;

       default:
        if (PMSMctrl_DWork.HallIn_m == 6) {
          /* '<S23>:1:142' */
          /* '<S23>:1:143' */
          PMSMctrl_DWork.AbsAngle_d = PMSMctrl_DWork.AngleTable_m[0];
        } else {
          /* '<S23>:1:145' */
          PMSMctrl_DWork.AbsAngle_d = PMSMctrl_DWork.AngleTable_m[5];
        }
        break;
      }

      /* '<S23>:1:148' */
      PMSMctrl_DWork.OffsetState_b = 2U;
      if (theta_qep_cnt > PMSMctrl_DWork.AbsAngle_d) {
        /* '<S23>:1:150' */
        /* '<S23>:1:151' */
        cnt_temp = (uint32_T)(65535 - theta_qep_cnt) + PMSMctrl_DWork.AbsAngle_d;
        if (cnt_temp > 65535U) {
          cnt_temp = 65535U;
        }

        PMSMctrl_DWork.AbsAngle_d = (uint16_T)cnt_temp;
      } else {
        /* '<S23>:1:153' */
        ref = PMSMctrl_DWork.AbsAngle_d;
        qY = (uint32_T)ref - theta_qep_cnt;
        if (qY > (uint32_T)ref) {
          qY = 0U;
        }

        ref = (int32_T)qY;
        PMSMctrl_DWork.AbsAngle_d = (uint16_T)ref;
      }
    }

    /* '<S23>:1:158' */
    PMSMctrl_DWork.HallIn_m = PMSMctrl_U.hall_state;
  } else {
    /* '<S23>:1:160' */
    PMSMctrl_DWork.HallIn_m = PMSMctrl_U.hall_state;
  }

  /* '<S23>:1:163' */
  PMSMctrl_B.y_i5 = PMSMctrl_DWork.AbsAngle_d;

  /* End of MATLAB Function: '<S9>/MATLAB Function' */

  /* Switch: '<S9>/Switch1' incorporates:
   *  Constant: '<S9>/sinc_cmd'
   */
  if (((uint8_T)0U) >= ((uint8_T)1U)) {
    /* Gain: '<S10>/Gain3' */
    PMSMctrl_B.Gain3 = mul_u32_loSR(3518437120U, PMSMctrl_B.cnt_out, 27U);

    /* DataTypeConversion: '<S10>/Data Type Conversion4' */
    PMSMctrl_B.DataTypeConversion4 = (uint16_T)PMSMctrl_B.Gain3;

    /* Sum: '<S9>/Sum1' incorporates:
     *  Constant: '<S9>/Constant1'
     */
    PMSMctrl_B.Sum1_p = (uint16_T)((uint32_T)((uint16_T)0U) +
      PMSMctrl_B.DataTypeConversion4);
    PMSMctrl_B.Switch1_e = PMSMctrl_B.Sum1_p;
  } else {
    /* Sum: '<S9>/Sum2' */
    PMSMctrl_B.Sum2_l = (uint16_T)((uint32_T)theta_qep_cnt + PMSMctrl_B.y_i5);

    /* Sum: '<S9>/Sum5' incorporates:
     *  Constant: '<S9>/sinc_cmd2'
     */
    PMSMctrl_B.Sum5 = (uint16_T)((uint32_T)PMSMctrl_B.Sum2_l + ((uint16_T)0U));
    PMSMctrl_B.Switch1_e = PMSMctrl_B.Sum5;
  }

  /* End of Switch: '<S9>/Switch1' */

  /* DataTypeConversion: '<S9>/Data Type Conversion1' */
  PMSMctrl_B.DataTypeConversion1 = PMSMctrl_B.Switch1_e;

  /* Gain: '<S9>/Gain1' */
  theta_enc = 9.58738E-5F * PMSMctrl_B.DataTypeConversion1;

  /* Switch: '<S2>/Switch2' */
  if (PMSMctrl_B.Compare_l >= ((uint8_T)1U)) {
    PMSMctrl_B.Switch2 = theta_vf;
  } else {
    PMSMctrl_B.Switch2 = theta_enc;
  }

  /* End of Switch: '<S2>/Switch2' */

  /* DataTypeConversion: '<S3>/Data Type Conversion1' */
  PMSMctrl_B.DataTypeConversion1_h = PMSMctrl_B.Switch2;

  /* Trigonometry: '<S3>/sine_cosine2' */
  cosOut = PMSMctrl_B.DataTypeConversion1_h;
  multi_out = (real32_T)sin(cosOut);
  cosOut = (real32_T)cos(cosOut);
  PMSMctrl_B.sine_cosine2_o1 = multi_out;
  PMSMctrl_B.sine_cosine2_o2 = cosOut;

  /* Product: '<S91>/Product' incorporates:
   *  Constant: '<S91>/K1'
   */
  PMSMctrl_B.Product = PMSMctrl_B.sine_cosine2_o1 * 0.5F;

  /* Product: '<S91>/Product1' incorporates:
   *  Constant: '<S91>/K2'
   */
  PMSMctrl_B.Product1_i = PMSMctrl_B.sine_cosine2_o2 * 0.866025388F;

  /* Sum: '<S91>/Sum' */
  PMSMctrl_B.sinwt2pi3 = (0.0F - PMSMctrl_B.Product) - PMSMctrl_B.Product1_i;

  /* Product: '<S91>/Product3' incorporates:
   *  Constant: '<S91>/K1'
   */
  PMSMctrl_B.Product3 = PMSMctrl_B.sine_cosine2_o2 * 0.5F;

  /* Product: '<S91>/Product2' incorporates:
   *  Constant: '<S91>/K2'
   */
  PMSMctrl_B.Product2 = PMSMctrl_B.sine_cosine2_o1 * 0.866025388F;

  /* Sum: '<S91>/Sum1' */
  PMSMctrl_B.coswt2pi3 = PMSMctrl_B.Product2 - PMSMctrl_B.Product3;

  /* Sum: '<S91>/Sum2' */
  PMSMctrl_B.sinwt2pi3_m = (0.0F - PMSMctrl_B.sinwt2pi3) -
    PMSMctrl_B.sine_cosine2_o1;

  /* Sum: '<S91>/Sum3' */
  PMSMctrl_B.coswt2pi3_g = (0.0F - PMSMctrl_B.coswt2pi3) -
    PMSMctrl_B.sine_cosine2_o2;

  /* Fcn: '<S91>/Fcn2' */
  id = ((PMSMctrl_B.Switch1_l[0] * PMSMctrl_B.sine_cosine2_o1 +
         PMSMctrl_B.Switch1_l[1] * PMSMctrl_B.sinwt2pi3) + PMSMctrl_B.Switch1_l
        [2] * PMSMctrl_B.sinwt2pi3_m) * 0.666666687F;

  /* SignalConversion generated from: '<S20>/Vector Concatenate' */
  PMSMctrl_B.VectorConcatenate[0] = id;

  /* Fcn: '<S91>/Fcn1' */
  iq = ((PMSMctrl_B.Switch1_l[0] * PMSMctrl_B.sine_cosine2_o2 +
         PMSMctrl_B.Switch1_l[1] * PMSMctrl_B.coswt2pi3) + PMSMctrl_B.Switch1_l
        [2] * PMSMctrl_B.coswt2pi3_g) * 0.666666687F;

  /* SignalConversion generated from: '<S20>/Vector Concatenate' */
  PMSMctrl_B.VectorConcatenate[1] = iq;

  /* DataTypeConversion: '<S20>/Data Type Conversion' incorporates:
   *  Constant: '<S1>/SYS_CMD'
   */
  PMSMctrl_B.DataTypeConversion_f = PMSMctrl_P.SYSTEM_CMD;

  /* Memory: '<S20>/Memory' */
  PMSMctrl_B.Memory[0] = PMSMctrl_DWork.Memory_PreviousInput[0];

  /* Gain: '<S20>/Gain2' */
  PMSMctrl_B.Gain2_m[0] = 12.0F * PMSMctrl_B.Memory[0];

  /* Memory: '<S20>/Memory' */
  PMSMctrl_B.Memory[1] = PMSMctrl_DWork.Memory_PreviousInput[1];

  /* Gain: '<S20>/Gain2' */
  PMSMctrl_B.Gain2_m[1] = 12.0F * PMSMctrl_B.Memory[1];

  /* Memory: '<S20>/Memory' */
  PMSMctrl_B.Memory[2] = PMSMctrl_DWork.Memory_PreviousInput[2];

  /* Gain: '<S20>/Gain2' */
  PMSMctrl_B.Gain2_m[2] = 12.0F * PMSMctrl_B.Memory[2];

  /* SignalConversion generated from: '<S20>/Vector Concatenate1' */
  PMSMctrl_B.v_dq[0] = PMSMctrl_B.Gain2_m[0];

  /* SignalConversion generated from: '<S20>/Vector Concatenate1' */
  PMSMctrl_B.v_dq[1] = PMSMctrl_B.Gain2_m[1];

  /* Memory: '<S20>/Memory1' */
  PMSMctrl_B.Memory1[0] = PMSMctrl_DWork.Memory1_PreviousInput[0];
  PMSMctrl_B.Memory1[1] = PMSMctrl_DWork.Memory1_PreviousInput[1];

  /* S-Function (s_focDesignerVectorControl): '<S20>/S-Function' */
  s_focDesignerVectorControl_Outputs_wrapper
    (&PMSMctrl_B.TmpSignalConversionAtSFunctionI[0],
     &PMSMctrl_B.VectorConcatenate[0], &PMSMctrl_B.DataTypeConversion_f,
     &PMSMctrl_B.v_dq[0], &PMSMctrl_B.Memory1[0], &PMSMctrl_B.SFunction[0]);

  /* Switch: '<S18>/Switch2' incorporates:
   *  Constant: '<S18>/zero_duty'
   *  Constant: '<S1>/SYS_CMD'
   */
  if (PMSMctrl_P.SYSTEM_CMD >= ((uint8_T)1U)) {
    /* Switch: '<S18>/Switch1' incorporates:
     *  Constant: '<S19>/Constant'
     *  Constant: '<S19>/Constant1'
     *  Constant: '<S20>/Constant1'
     */
    if (PMSMctrl_B.Compare_l >= ((uint8_T)1U)) {
      /* Switch: '<S19>/Switch1' incorporates:
       *  Constant: '<S19>/fstop1'
       */
      if (PMSMctrl_P.SYSTEM_CMD >= ((uint8_T)1U)) {
        PMSMctrl_B.Switch1_ou = PMSMctrl_B.VF_BOOST;
      } else {
        PMSMctrl_B.Switch1_ou = (uint16_T)0;
      }

      /* End of Switch: '<S19>/Switch1' */

      /* Sum: '<S19>/Sum' */
      PMSMctrl_B.Sum_a = (int16_T)((PMSMctrl_B.Switch1_ou + PMSMctrl_B.Gain2_d) >>
        1);

      /* Product: '<S19>/Product' */
      PMSMctrl_B.Product_i = PMSMctrl_B.VF_GAIN * PMSMctrl_B.Sum_a;

      /* DataTypeConversion: '<S19>/Data Type Conversion' */
      PMSMctrl_B.DataTypeConversion_m = (real32_T)PMSMctrl_B.Product_i * 2.0F;

      /* Gain: '<S19>/gain2' */
      PMSMctrl_B.gain2 = 1.52587891E-5F * PMSMctrl_B.DataTypeConversion_m;
      PMSMctrl_B.Switch1_o[0] = 0.0F;
      PMSMctrl_B.Switch1_o[1] = PMSMctrl_B.gain2;
      PMSMctrl_B.Switch1_o[2] = 0.0F;
    } else {
      /* Gain: '<S20>/Gain' */
      PMSMctrl_B.Gain_b[0] = 0.0833333358F * PMSMctrl_B.SFunction[0];
      PMSMctrl_B.Gain_b[1] = 0.0833333358F * PMSMctrl_B.SFunction[1];
      PMSMctrl_B.Switch1_o[0] = PMSMctrl_B.Gain_b[0];
      PMSMctrl_B.Switch1_o[1] = PMSMctrl_B.Gain_b[1];
      PMSMctrl_B.Switch1_o[2] = 0.0F;
    }

    /* End of Switch: '<S18>/Switch1' */
    PMSMctrl_B.Switch2_m[0] = PMSMctrl_B.Switch1_o[0];
    PMSMctrl_B.Switch2_m[1] = PMSMctrl_B.Switch1_o[1];
    PMSMctrl_B.Switch2_m[2] = PMSMctrl_B.Switch1_o[2];
  } else {
    PMSMctrl_B.Switch2_m[0] = 0.0F;
    PMSMctrl_B.Switch2_m[1] = 0.0F;
    PMSMctrl_B.Switch2_m[2] = 0.0F;
  }

  /* End of Switch: '<S18>/Switch2' */

  /* MATLAB Function: '<S18>/MATLAB Function1' */
  /* MATLAB Function 'PMSMctrl/Switch/MATLAB Function1': '<S88>:1' */
  /* '<S88>:1:15' */
  multi_out = (real32_T)sqrt(PMSMctrl_B.Switch2_m[0] * PMSMctrl_B.Switch2_m[0] +
    PMSMctrl_B.Switch2_m[1] * PMSMctrl_B.Switch2_m[1]);
  if (multi_out > PMSMctrl_MaxAmplitude) {
    /* '<S88>:1:17' */
    /* '<S88>:1:18' */
    /* '<S88>:1:19' */
    /* '<S88>:1:20' */
    PMSMctrl_B.vector_lim[0] = PMSMctrl_B.Switch2_m[0] * PMSMctrl_MaxAmplitude /
      multi_out;
    PMSMctrl_B.vector_lim[1] = PMSMctrl_B.Switch2_m[1] * PMSMctrl_MaxAmplitude /
      multi_out;
    PMSMctrl_B.vector_lim[2] = 0.0F;

    /* '<S88>:1:21' */
    PMSMctrl_B.dq_is_lim[0] = 1;
    PMSMctrl_B.dq_is_lim[1] = 1;
  } else {
    /* '<S88>:1:23' */
    PMSMctrl_B.vector_lim[0] = PMSMctrl_B.Switch2_m[0];
    PMSMctrl_B.vector_lim[1] = PMSMctrl_B.Switch2_m[1];
    PMSMctrl_B.vector_lim[2] = PMSMctrl_B.Switch2_m[2];

    /* '<S88>:1:24' */
    PMSMctrl_B.dq_is_lim[0] = 0;
    PMSMctrl_B.dq_is_lim[1] = 0;
  }

  /* End of MATLAB Function: '<S18>/MATLAB Function1' */

  /* Product: '<S21>/Product' incorporates:
   *  Constant: '<S21>/K1'
   */
  /* '<S88>:1:27' */
  PMSMctrl_B.Product_m = PMSMctrl_B.sine_cosine2_o1 * 0.5F;

  /* Product: '<S21>/Product1' incorporates:
   *  Constant: '<S21>/K2'
   */
  PMSMctrl_B.Product1_n = PMSMctrl_B.sine_cosine2_o2 * 0.866025388F;

  /* Sum: '<S21>/Sum' */
  PMSMctrl_B.sinwt2pi3_a = (0.0F - PMSMctrl_B.Product_m) - PMSMctrl_B.Product1_n;

  /* Product: '<S21>/Product3' incorporates:
   *  Constant: '<S21>/K1'
   */
  PMSMctrl_B.Product3_h = PMSMctrl_B.sine_cosine2_o2 * 0.5F;

  /* Product: '<S21>/Product2' incorporates:
   *  Constant: '<S21>/K2'
   */
  PMSMctrl_B.Product2_b = PMSMctrl_B.sine_cosine2_o1 * 0.866025388F;

  /* Sum: '<S21>/Sum1' */
  PMSMctrl_B.coswt2pi3_n = PMSMctrl_B.Product2_b - PMSMctrl_B.Product3_h;

  /* Sum: '<S21>/Sum2' */
  PMSMctrl_B.sinwt2pi3_h = (0.0F - PMSMctrl_B.sinwt2pi3_a) -
    PMSMctrl_B.sine_cosine2_o1;

  /* Sum: '<S21>/Sum3' */
  PMSMctrl_B.coswt2pi3_c = (0.0F - PMSMctrl_B.coswt2pi3_n) -
    PMSMctrl_B.sine_cosine2_o2;

  /* Fcn: '<S21>/Fcn2' */
  PMSMctrl_B.Va = (PMSMctrl_B.vector_lim[0] * PMSMctrl_B.sine_cosine2_o1 +
                   PMSMctrl_B.vector_lim[1] * PMSMctrl_B.sine_cosine2_o2) +
    PMSMctrl_B.vector_lim[2];

  /* Fcn: '<S21>/Fcn4' */
  PMSMctrl_B.Vb = (PMSMctrl_B.vector_lim[0] * PMSMctrl_B.sinwt2pi3_a +
                   PMSMctrl_B.vector_lim[1] * PMSMctrl_B.coswt2pi3_n) +
    PMSMctrl_B.vector_lim[2];

  /* Fcn: '<S21>/Fcn5' */
  PMSMctrl_B.Vc = (PMSMctrl_B.vector_lim[0] * PMSMctrl_B.sinwt2pi3_h +
                   PMSMctrl_B.vector_lim[1] * PMSMctrl_B.coswt2pi3_c) +
    PMSMctrl_B.vector_lim[2];

  /* S-Function (SVPWM_float): '<S14>/SVmod' incorporates:
   *  Constant: '<S1>/VF_GAIN1'
   */
  SVPWM_float_Outputs_wrapper(&PMSMctrl_B.Va, &PMSMctrl_B.Vb, &PMSMctrl_B.Vc,
    &PMSMctrl_ConstP.pooled21, &PMSMctrl_B.SVmod_o1, &PMSMctrl_B.SVmod_o2,
    &PMSMctrl_B.SVmod_o3 );

  /* Sum: '<S11>/Sum' incorporates:
   *  Constant: '<S11>/Constant'
   */
  PMSMctrl_B.Sum_c[0] = PMSMctrl_B.SVmod_o1 + 1.0F;
  PMSMctrl_B.Sum_c[1] = PMSMctrl_B.SVmod_o2 + 1.0F;
  PMSMctrl_B.Sum_c[2] = PMSMctrl_B.SVmod_o3 + 1.0F;

  /* Gain: '<S11>/Gain' */
  PMSMctrl_B.Gain_c[0] = 32768.0F * PMSMctrl_B.Sum_c[0];

  /* Saturate: '<S11>/Saturation' */
  multi_out = PMSMctrl_B.Gain_c[0];
  if (multi_out > 65535.0F) {
    multi_out = 65535.0F;
  } else {
    if (multi_out < 0.0F) {
      multi_out = 0.0F;
    }
  }

  PMSMctrl_B.Saturation[0] = multi_out;

  /* DataTypeConversion: '<S11>/Data Type Conversion' */
  multi_out = (real32_T)fmod((real32_T)floor(PMSMctrl_B.Saturation[0]), 65536.0);
  PMSMctrl_B.DataTypeConversion_n[0] = (uint16_T)(multi_out < 0.0F ? (int32_T)
    (uint16_T)-(int16_T)(uint16_T)-multi_out : (int32_T)(uint16_T)multi_out);

  /* Gain: '<S11>/Gain' */
  PMSMctrl_B.Gain_c[1] = 32768.0F * PMSMctrl_B.Sum_c[1];

  /* Saturate: '<S11>/Saturation' */
  multi_out = PMSMctrl_B.Gain_c[1];
  if (multi_out > 65535.0F) {
    multi_out = 65535.0F;
  } else {
    if (multi_out < 0.0F) {
      multi_out = 0.0F;
    }
  }

  PMSMctrl_B.Saturation[1] = multi_out;

  /* DataTypeConversion: '<S11>/Data Type Conversion' */
  multi_out = (real32_T)fmod((real32_T)floor(PMSMctrl_B.Saturation[1]), 65536.0);
  PMSMctrl_B.DataTypeConversion_n[1] = (uint16_T)(multi_out < 0.0F ? (int32_T)
    (uint16_T)-(int16_T)(uint16_T)-multi_out : (int32_T)(uint16_T)multi_out);

  /* Gain: '<S11>/Gain' */
  PMSMctrl_B.Gain_c[2] = 32768.0F * PMSMctrl_B.Sum_c[2];

  /* Saturate: '<S11>/Saturation' */
  multi_out = PMSMctrl_B.Gain_c[2];
  if (multi_out > 65535.0F) {
    multi_out = 65535.0F;
  } else {
    if (multi_out < 0.0F) {
      multi_out = 0.0F;
    }
  }

  PMSMctrl_B.Saturation[2] = multi_out;

  /* DataTypeConversion: '<S11>/Data Type Conversion' */
  multi_out = (real32_T)fmod((real32_T)floor(PMSMctrl_B.Saturation[2]), 65536.0);
  PMSMctrl_B.DataTypeConversion_n[2] = (uint16_T)(multi_out < 0.0F ? (int32_T)
    (uint16_T)-(int16_T)(uint16_T)-multi_out : (int32_T)(uint16_T)multi_out);

  /* Outport: '<Root>/cnt_a' */
  PMSMctrl_Y.cnt_a = PMSMctrl_B.DataTypeConversion_n[0];

  /* Outport: '<Root>/cnt_b' */
  PMSMctrl_Y.cnt_b = PMSMctrl_B.DataTypeConversion_n[1];

  /* Outport: '<Root>/cnt_c' */
  PMSMctrl_Y.cnt_c = PMSMctrl_B.DataTypeConversion_n[2];

  /* RateTransition: '<S2>/Rate Transition1' incorporates:
   *  RateTransition: '<S1>/Rate Transition2'
   */
  if (PMSMctrl_M->Timing.RateInteraction.TID0_1 == 1) {
    PMSMctrl_DWork.RateTransition1_Buffer = PMSMctrl_B.Switch2;
    spd_raw_calc = PMSMctrl_DWork.RateTransition2_Buffer0;
  }

  /* End of RateTransition: '<S2>/Rate Transition1' */

  /* Gain: '<S9>/Gain10' */
  n_by_m_fil_debug = 1.0F * spd_fil_n_by_m;

  /* Gain: '<S9>/Gain2' */
  n_by_m_raw_debug = 1.0F * spd_raw_n_by_m;

  /* Gain: '<S32>/Gain3' */
  ia_sar = 1.0F * PMSMctrl_B.Gain[0];

  /* Gain: '<S32>/Gain6' */
  ib_sar = 1.0F * PMSMctrl_B.Gain[1];

  /* Gain: '<S32>/Gain7' */
  ic_sar = 1.0F * PMSMctrl_B.Gain[2];

  /* Gain: '<S33>/Gain10' */
  ic_sinc = 1.0F * PMSMctrl_B.Gain7[1];

  /* Gain: '<S33>/Gain8' */
  ia_sinc = 1.0F * PMSMctrl_B.Sum3;

  /* Gain: '<S33>/Gain9' */
  ib_sinc = 1.0F * PMSMctrl_B.Gain7[0];

  /* DataTypeConversion: '<S10>/Data Type Conversion1' incorporates:
   *  Inport: '<Root>/Vdc_adc'
   */
  PMSMctrl_B.DataTypeConversion1_j = PMSMctrl_U.Vdc_adc;

  /* Sum: '<S10>/Sum2' incorporates:
   *  Constant: '<S10>/Constant1'
   */
  PMSMctrl_B.Sum2_h = PMSMctrl_B.DataTypeConversion1_j - PMSMctrl_P.vdcOffset;

  /* Gain: '<S10>/Gain1' */
  Vdc = PMSMctrl_P.vdcScale * PMSMctrl_B.Sum2_h;

  /* Gain: '<S66>/ZeroGain' */
  PMSMctrl_B.ZeroGain = 0.0F * PMSMctrl_B.Sum_i;

  /* DeadZone: '<S66>/DeadZone' */
  if (PMSMctrl_B.Sum_i > PMSMctrl_P.iqMax) {
    PMSMctrl_B.DeadZone = PMSMctrl_B.Sum_i - PMSMctrl_P.iqMax;
  } else if (PMSMctrl_B.Sum_i >= PMSMctrl_P.iqMin) {
    PMSMctrl_B.DeadZone = 0.0F;
  } else {
    PMSMctrl_B.DeadZone = PMSMctrl_B.Sum_i - PMSMctrl_P.iqMin;
  }

  /* End of DeadZone: '<S66>/DeadZone' */

  /* RelationalOperator: '<S66>/NotEqual' */
  PMSMctrl_B.NotEqual = (PMSMctrl_B.ZeroGain != PMSMctrl_B.DeadZone);

  /* Signum: '<S66>/SignPreSat' */
  multi_out = PMSMctrl_B.DeadZone;
  if (multi_out < 0.0F) {
    PMSMctrl_B.SignPreSat = -1.0F;
  } else if (multi_out > 0.0F) {
    PMSMctrl_B.SignPreSat = 1.0F;
  } else {
    PMSMctrl_B.SignPreSat = multi_out;
  }

  /* End of Signum: '<S66>/SignPreSat' */

  /* DataTypeConversion: '<S66>/DataTypeConv1' */
  multi_out = (real32_T)fmod((real32_T)floor(PMSMctrl_B.SignPreSat), 256.0);
  PMSMctrl_B.DataTypeConv1 = (int8_T)(multi_out < 0.0F ? (int32_T)(int8_T)
    -(int8_T)(uint8_T)-multi_out : (int32_T)(int8_T)(uint8_T)multi_out);

  /* Gain: '<S70>/Integral Gain' */
  PMSMctrl_B.IntegralGain = PMSMctrl_P.Kiw * PMSMctrl_B.y_o;

  /* Signum: '<S66>/SignPreIntegrator' */
  multi_out = PMSMctrl_B.IntegralGain;
  if (multi_out < 0.0F) {
    PMSMctrl_B.SignPreIntegrator = -1.0F;
  } else if (multi_out > 0.0F) {
    PMSMctrl_B.SignPreIntegrator = 1.0F;
  } else {
    PMSMctrl_B.SignPreIntegrator = multi_out;
  }

  /* End of Signum: '<S66>/SignPreIntegrator' */

  /* DataTypeConversion: '<S66>/DataTypeConv2' */
  multi_out = (real32_T)fmod((real32_T)floor(PMSMctrl_B.SignPreIntegrator),
    256.0);
  PMSMctrl_B.DataTypeConv2 = (int8_T)(multi_out < 0.0F ? (int32_T)(int8_T)
    -(int8_T)(uint8_T)-multi_out : (int32_T)(int8_T)(uint8_T)multi_out);

  /* RelationalOperator: '<S66>/Equal1' */
  PMSMctrl_B.Equal1 = (PMSMctrl_B.DataTypeConv1 == PMSMctrl_B.DataTypeConv2);

  /* Logic: '<S66>/AND3' */
  PMSMctrl_B.AND3 = (PMSMctrl_B.NotEqual && PMSMctrl_B.Equal1);

  /* Switch: '<S66>/Switch' incorporates:
   *  Constant: '<S66>/Constant1'
   */
  if (PMSMctrl_B.AND3) {
    PMSMctrl_B.Switch_b = 0.0F;
  } else {
    PMSMctrl_B.Switch_b = PMSMctrl_B.IntegralGain;
  }

  /* End of Switch: '<S66>/Switch' */
  /* Switch: '<S17>/Switch1' incorporates:
   *  Switch: '<S17>/Switch4'
   */
  if (PMSMctrl_B.Abs >= 1000.0F) {
    speed_raw = spd_raw_calc;
  } else {
    if (PMSMctrl_B.Abs >= 0.0F) {
      /* Switch: '<S17>/Switch4' */
      PMSMctrl_B.Switch4_b = spd_raw_n_by_m;
    } else {
      /* Switch: '<S17>/Switch4' */
      PMSMctrl_B.Switch4_b = spd_raw_n_by_1;
    }

    speed_raw = PMSMctrl_B.Switch4_b;
  }

  /* End of Switch: '<S17>/Switch1' */

  /* Sum: '<S91>/Sum4' */
  PMSMctrl_B.tmpForInput[0] = PMSMctrl_B.Switch1_l[0];
  PMSMctrl_B.tmpForInput[1] = PMSMctrl_B.Switch1_l[1];
  PMSMctrl_B.tmpForInput[2] = PMSMctrl_B.Switch1_l[2];
  PMSMctrl_B.tmpForInput[3] = PMSMctrl_B.sine_cosine2_o1;
  PMSMctrl_B.tmpForInput[4] = PMSMctrl_B.sine_cosine2_o2;
  PMSMctrl_B.tmpForInput[5] = PMSMctrl_B.sinwt2pi3;
  PMSMctrl_B.tmpForInput[6] = PMSMctrl_B.coswt2pi3;
  PMSMctrl_B.tmpForInput[7] = PMSMctrl_B.sinwt2pi3_m;
  PMSMctrl_B.tmpForInput[8] = PMSMctrl_B.coswt2pi3_g;
  cosOut = -0.0F;
  for (ref = 0; ref < 9; ref++) {
    cosOut += PMSMctrl_B.tmpForInput[ref];
  }

  PMSMctrl_B.Sum4_d = cosOut;

  /* End of Sum: '<S91>/Sum4' */

  /* Gain: '<S91>/Gain1' */
  PMSMctrl_B.Gain1 = 0.333333343F * PMSMctrl_B.Sum4_d;

  /* Constant: '<S1>/SYS_CMD1' */
  PMSMctrl_B.SYS_CMD1 = PMSMctrl_P.MBC_ID;

  /* Constant: '<S1>/SYS_CMD2' */
  PMSMctrl_B.SYS_CMD2 = PMSMctrl_P.MOTOR_CFG;

  /* Update for UnitDelay: '<S35>/Unit  Delay' */
  PMSMctrl_DWork.UnitDelay_DSTATE = PMSMctrl_B.y;

  /* Update for UnitDelay: '<S34>/Unit  Delay' */
  PMSMctrl_DWork.UnitDelay_DSTATE_i = PMSMctrl_B.y_i;

  /* Update for UnitDelay: '<S90>/Unit Delay1' */
  PMSMctrl_DWork.UnitDelay1_DSTATE = PMSMctrl_B.Sum4_o;

  /* Update for UnitDelay: '<S40>/Unit  Delay' */
  PMSMctrl_DWork.UnitDelay_DSTATE_e = speed_ref_lim;

  /* Update for DiscreteStateSpace: '<S22>/Discrete State-Space' */
  {
    real32_T xnew[1];
    xnew[0] = 0.90476197F*PMSMctrl_DWork.DiscreteStateSpace_DSTATE;
    xnew[0] += 0.952381F*spd_raw_n_by_m;
    (void) memcpy(&PMSMctrl_DWork.DiscreteStateSpace_DSTATE, xnew,
                  sizeof(real32_T)*1);
  }

  /* Update for DiscreteIntegrator: '<S73>/Integrator' incorporates:
   *  Constant: '<S1>/SYS_CMD'
   */
  PMSMctrl_DWork.Integrator_DSTATE += 0.0001F * PMSMctrl_B.Switch_b;
  PMSMctrl_DWork.Integrator_PrevResetState = (int8_T)(PMSMctrl_P.SYSTEM_CMD > 0);

  /* Update for DiscreteIntegrator: '<S68>/Filter' incorporates:
   *  Constant: '<S1>/SYS_CMD'
   */
  PMSMctrl_DWork.Filter_DSTATE += 0.0001F * PMSMctrl_B.FilterCoefficient;
  PMSMctrl_DWork.Filter_PrevResetState = (int8_T)(PMSMctrl_P.SYSTEM_CMD > 0);

  /* Update for UnitDelay: '<S89>/Unit Delay' */
  PMSMctrl_DWork.UnitDelay_DSTATE_h = PMSMctrl_B.Sum1_m1;

  /* Update for Memory: '<S20>/Memory' */
  PMSMctrl_DWork.Memory_PreviousInput[0] = PMSMctrl_B.vector_lim[0];
  PMSMctrl_DWork.Memory_PreviousInput[1] = PMSMctrl_B.vector_lim[1];
  PMSMctrl_DWork.Memory_PreviousInput[2] = PMSMctrl_B.vector_lim[2];

  /* Update for Memory: '<S20>/Memory1' */
  PMSMctrl_DWork.Memory1_PreviousInput[0] = PMSMctrl_B.dq_is_lim[0];
  PMSMctrl_DWork.Memory1_PreviousInput[1] = PMSMctrl_B.dq_is_lim[1];
}

/* Model step function for TID1 */
void PMSMctrl_step1(void)              /* Sample time: [0.001s, 0.0s] */
{
  real32_T temp;
  real32_T y;

  /* RateTransition: '<S2>/Rate Transition1' */
  theta_speed = PMSMctrl_DWork.RateTransition1_Buffer;

  /* Outputs for Atomic SubSystem: '<S1>/SpeedCalc' */
  /* MATLAB Function: '<S15>/MATLAB Function' */
  /* MATLAB Function 'PMSMctrl/SpeedCalc/MATLAB Function': '<S37>:1' */
  if (!PMSMctrl_DWork.u_old_not_empty) {
    /* '<S37>:1:14' */
    /* '<S37>:1:15' */
    PMSMctrl_DWork.u_old = theta_speed;
    PMSMctrl_DWork.u_old_not_empty = true;
  }

  /* '<S37>:1:18' */
  temp = theta_speed - PMSMctrl_DWork.u_old;
  if ((real32_T)fabs(temp) > 3.1415926535897931) {
    /* '<S37>:1:20' */
    /* '<S37>:1:21' */
    if (temp < 0.0F) {
      y = -1.0F;
    } else if (temp > 0.0F) {
      y = 1.0F;
    } else {
      y = temp;
    }

    temp -= y * 3.14159274F * 2.0F;
  }

  /* '<S37>:1:24' */
  PMSMctrl_DWork.u_old = theta_speed;

  /* '<S37>:1:26' */
  speed_debug = temp;

  /* End of MATLAB Function: '<S15>/MATLAB Function' */

  /* Gain: '<S15>/Gain3' */
  PMSMctrl_B.Gain3_p = 2387.32422F * speed_debug;

  /* DiscreteStateSpace: '<S36>/Discrete State-Space' */
  {
    PMSMctrl_B.DiscreteStateSpace = 0.666666627F*
      PMSMctrl_DWork.DiscreteStateSpace_DSTATE_f;
    PMSMctrl_B.DiscreteStateSpace += 0.333333313F*PMSMctrl_B.Gain3_p;
  }

  /* MATLAB Function: '<S15>/MATLAB Function1' */
  /* MATLAB Function 'PMSMctrl/SpeedCalc/MATLAB Function1': '<S38>:1' */
  if (PMSMctrl_B.Gain3_p > 0.0F) {
    /* '<S38>:1:18' */
    /* '<S38>:1:19' */
    PMSMctrl_DWork.old_sign = 1.0F;
  } else {
    if (PMSMctrl_B.Gain3_p < 0.0F) {
      /* '<S38>:1:20' */
      /* '<S38>:1:21' */
      PMSMctrl_DWork.old_sign = -1.0F;
    }
  }

  /* '<S38>:1:26' */
  PMSMctrl_B.y_oa = PMSMctrl_DWork.old_sign;

  /* End of MATLAB Function: '<S15>/MATLAB Function1' */

  /* Update for DiscreteStateSpace: '<S36>/Discrete State-Space' */
  {
    real32_T xnew[1];
    xnew[0] = 0.333333343F*PMSMctrl_DWork.DiscreteStateSpace_DSTATE_f;
    xnew[0] += 0.666666687F*PMSMctrl_B.Gain3_p;
    (void) memcpy(&PMSMctrl_DWork.DiscreteStateSpace_DSTATE_f, xnew,
                  sizeof(real32_T)*1);
  }

  /* End of Outputs for SubSystem: '<S1>/SpeedCalc' */

  /* RateTransition: '<S1>/Rate Transition1' */
  PMSMctrl_DWork.RateTransition1_Buffer0 = PMSMctrl_B.DiscreteStateSpace;

  /* RateTransition: '<S1>/Rate Transition2' */
  PMSMctrl_DWork.RateTransition2_Buffer0 = PMSMctrl_B.Gain3_p;
}

/* Model initialize function */
void PMSMctrl_initialize(void)
{
  /* Registration code */

  /* initialize real-time model */
  (void) memset((void *)PMSMctrl_M, 0,
                sizeof(RT_MODEL_PMSMctrl));

  /* block I/O */
  (void) memset(((void *) &PMSMctrl_B), 0,
                sizeof(BlockIO_PMSMctrl));

  /* exported global signals */
  pos_ref_ui = 0.0F;
  position_ref = 0.0F;
  pos_unaligned = 0.0F;
  pos_aligned = 0.0F;
  theta_enc_mul = 0.0F;
  speed_ff = 0.0F;
  Nref = 0.0F;
  speed_ref = 0.0F;
  speed_ref_lim = 0.0F;
  spd_fil_calc = 0.0F;
  spd_raw_n_by_m = 0.0F;
  spd_fil_n_by_m = 0.0F;
  spd_raw_n_by_1 = 0.0F;
  spd_fil_n_by_1 = 0.0F;
  speed_fil = 0.0F;
  iq_ref = 0.0F;
  theta_vf = 0.0F;
  theta_enc = 0.0F;
  id = 0.0F;
  iq = 0.0F;
  n_by_m_fil_debug = 0.0F;
  n_by_m_raw_debug = 0.0F;
  ia_sar = 0.0F;
  ib_sar = 0.0F;
  ic_sar = 0.0F;
  ic_sinc = 0.0F;
  ia_sinc = 0.0F;
  ib_sinc = 0.0F;
  Vdc = 0.0F;
  spd_raw_calc = 0.0F;
  speed_raw = 0.0F;
  theta_speed = 0.0F;
  w_step = 0.0F;
  iq_ref_step = 0.0F;
  speed_debug = 0.0F;
  pos_offset = 0.0F;
  speed_meas_raw_n_by_1 = 0.0F;
  speed_meas_raw_n_by_m = 0.0F;
  theta_qep_cnt = 0U;

  /* states (dwork) */
  (void) memset((void *)&PMSMctrl_DWork, 0,
                sizeof(D_Work_PMSMctrl));

  {
    int32_T i;
    static const uint16_T tmp[6] = { 0U, 43691U, 54613U, 21845U, 10923U, 32768U
    };

    static const uint16_T tmp_0[6] = { 27307U, 38229U, 49152U, 60075U, 5461U,
      16384U };

    /* InitializeConditions for DiscreteIntegrator: '<S73>/Integrator' */
    PMSMctrl_DWork.Integrator_PrevResetState = 2;

    /* InitializeConditions for DiscreteIntegrator: '<S68>/Filter' */
    PMSMctrl_DWork.Filter_PrevResetState = 2;

    /* SystemInitialize for MATLAB Function: '<S9>/MATLAB Function' */
    for (i = 0; i < 6; i++) {
      PMSMctrl_DWork.AngleStartTable_i[i] = tmp[i];
      PMSMctrl_DWork.AngleTable_m[i] = tmp_0[i];
    }

    PMSMctrl_DWork.OffsetState_b = 0U;
    PMSMctrl_DWork.AbsAngle_d = 0U;
    PMSMctrl_DWork.HallIn_m = 5U;

    /* End of SystemInitialize for MATLAB Function: '<S9>/MATLAB Function' */

    /* SystemInitialize for MATLAB Function: '<S9>/MATLAB Function3' */
    PMSMctrl_DWork.pos_rst_old = 0U;
    PMSMctrl_DWork.position_offset = 0.0F;

    /* SystemInitialize for MATLAB Function: '<S9>/MATLAB Function4' */
    PMSMctrl_DWork.AngleTable_not_empty = false;
    PMSMctrl_DWork.AngleStartTable_not_empty = false;
    PMSMctrl_DWork.OffsetState = 0U;
    PMSMctrl_DWork.AbsAngle = 0.0F;
    PMSMctrl_DWork.HallIn = 5U;

    /* SystemInitialize for MATLAB Function: '<S10>/MATLAB Function' */
    PMSMctrl_DWork.CurOff_p[0] = 0;
    PMSMctrl_DWork.CurOff_p[1] = 0;
    PMSMctrl_DWork.CurOff_p[2] = 0;
    PMSMctrl_DWork.SysCmd_old_m = 0U;
    PMSMctrl_DWork.ia_acc_m = 0.0F;
    PMSMctrl_DWork.ib_acc_j = 0.0F;
    PMSMctrl_DWork.ic_acc = 0.0F;
    PMSMctrl_DWork.sample_o = 0;

    /* SystemInitialize for MATLAB Function: '<S10>/MATLAB Function1' */
    PMSMctrl_DWork.CurOff[0] = 0.0F;
    PMSMctrl_DWork.CurOff[1] = 0.0F;
    PMSMctrl_DWork.SysCmd_old = 0U;
    PMSMctrl_DWork.ia_acc = 0.0F;
    PMSMctrl_DWork.ib_acc = 0.0F;
    PMSMctrl_DWork.sample = 0;

    /* SystemInitialize for MATLAB Function: '<S10>/MATLAB Function2' */
    PMSMctrl_DWork.cnt_old = MAX_uint32_T;
    PMSMctrl_DWork.turn_cnt = 0;

    /* SystemInitialize for MATLAB Function: '<S15>/MATLAB Function' */
    PMSMctrl_DWork.u_old_not_empty = false;

    /* SystemInitialize for MATLAB Function: '<S15>/MATLAB Function1' */
    PMSMctrl_DWork.old_sign = 1.0F;

    /* End of SystemInitialize for SubSystem: '<S1>/SpeedCalc' */

    /* SystemInitialize for MATLAB Function: '<S16>/MATLAB Function1' */
    PMSMctrl_DWork.sample_count_f = 0U;

    /* SystemInitialize for MATLAB Function: '<S16>/MATLAB Function2' */
    PMSMctrl_DWork.sample_count = 0U;
  }
}

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
