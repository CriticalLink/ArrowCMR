/*
 * Sponsored Third Party Support License -- for use only to support
 * products interfaced to MathWorks software under terms specified in your
 * company's restricted use license agreement.
 *
 * File: PMSMctrl.h
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

#ifndef RTW_HEADER_PMSMctrl_h_
#define RTW_HEADER_PMSMctrl_h_
#include <string.h>
#include <math.h>
#ifndef PMSMctrl_COMMON_INCLUDES_
# define PMSMctrl_COMMON_INCLUDES_
#include "rtwtypes.h"
#endif                                 /* PMSMctrl_COMMON_INCLUDES_ */

#include "PMSMctrl_types.h"

/* Macros for accessing real-time model data structure */
#ifndef rtmGetErrorStatus
# define rtmGetErrorStatus(rtm)        ((rtm)->errorStatus)
#endif

#ifndef rtmSetErrorStatus
# define rtmSetErrorStatus(rtm, val)   ((rtm)->errorStatus = (val))
#endif

/* Block signals (default storage) */
typedef struct {
  real32_T tmpForInput[9];
  uint32_T Gain2;                      /* '<S8>/Gain2' */
  uint32_T cnt_out;                    /* '<S8>/MATLAB Function3' */
  uint32_T Gain3;                      /* '<S8>/Gain3' */
  real32_T Product1;                   /* '<S10>/Product1' */
  real32_T y1;                         /* '<S34>/Unit  Delay' */
  real32_T Sum1;                       /* '<S34>/Sum1' */
  real32_T Deltau_limit;               /* '<S34>/Saturation' */
  real32_T y;                          /* '<S34>/Sum' */
  real32_T DataTypeConversion5;        /* '<S8>/Data Type Conversion5' */
  real32_T Gain6;                      /* '<S8>/Gain6' */
  real32_T Switch1;                    /* '<S10>/Switch1' */
  real32_T Sum;                        /* '<S10>/Sum' */
  real32_T PosLoopGain;                /* '<S10>/Pos Loop Gain' */
  real32_T Switch4;                    /* '<S10>/Switch4' */
  real32_T Sum1_n;                     /* '<S10>/Sum1' */
  real32_T y1_d;                       /* '<S33>/Unit  Delay' */
  real32_T Sum1_m;                     /* '<S33>/Sum1' */
  real32_T Deltau_limit_g;             /* '<S33>/Saturation' */
  real32_T y_i;                        /* '<S33>/Sum' */
  real32_T Switch;                     /* '<S17>/Switch' */
  real32_T MAX_RPM;                    /* '<S140>/MAX_RPM' */
  real32_T Switch_n;                   /* '<S14>/Switch' */
  real32_T MAX_RPM_j;                  /* '<S14>/MAX_RPM' */
  real32_T Product1_b;                 /* '<S14>/Product1' */
  real32_T DataTypeConversion;         /* '<S14>/Data Type Conversion' */
  real32_T y1_h;                       /* '<S39>/Unit  Delay' */
  real32_T Sum1_j;                     /* '<S39>/Sum1' */
  real32_T Deltau_limit_h;             /* '<S39>/Saturation' */
  real32_T Abs;                        /* '<S15>/Abs' */
  real32_T DataTypeConversion5_j;      /* '<S7>/Data Type Conversion5' */
  real32_T Switch3;                    /* '<S15>/Switch3' */
  real32_T Sum2;                       /* '<S14>/Sum2' */
  real32_T ProportionalGain;           /* '<S113>/Proportional Gain' */
  real32_T Integrator;                 /* '<S96>/Integrator' */
  real32_T DerivativeGain;             /* '<S73>/Derivative Gain' */
  real32_T Filter;                     /* '<S78>/Filter' */
  real32_T SumD;                       /* '<S78>/SumD' */
  real32_T FilterCoefficient;          /* '<S106>/Filter Coefficient' */
  real32_T Sum_i;                      /* '<S126>/Sum' */
  real32_T TmpSignalConversionAtSFunctionI[2];
  real32_T DataTypeConversion7[2];     /* '<S8>/Data Type Conversion7' */
  real32_T Sum4[2];                    /* '<S8>/Sum4' */
  real32_T Gain4[2];                   /* '<S8>/Gain4' */
  real32_T Gain5[2];                   /* '<S8>/Gain5' */
  real32_T Gain7[2];                   /* '<S8>/Gain7' */
  real32_T Sum3;                       /* '<S8>/Sum3' */
  real32_T DataTypeConversion_p[3];    /* '<S8>/Data Type Conversion' */
  real32_T Sum1_o[3];                  /* '<S8>/Sum1' */
  real32_T Gain[3];                    /* '<S8>/Gain' */
  real32_T Switch1_l[3];               /* '<S8>/Switch1' */
  real32_T DataTypeConversion1;        /* '<S7>/Data Type Conversion1' */
  real32_T Switch2;                    /* '<S2>/Switch2' */
  real32_T DataTypeConversion1_h;      /* '<S3>/Data Type Conversion1' */
  real32_T sine_cosine2_o1;            /* '<S3>/sine_cosine2' */
  real32_T sine_cosine2_o2;            /* '<S3>/sine_cosine2' */
  real32_T Product;                    /* '<S141>/Product' */
  real32_T Product1_i;                 /* '<S141>/Product1' */
  real32_T sinwt2pi3;                  /* '<S141>/Sum' */
  real32_T Product3;                   /* '<S141>/Product3' */
  real32_T Product2;                   /* '<S141>/Product2' */
  real32_T coswt2pi3;                  /* '<S141>/Sum1' */
  real32_T sinwt2pi3_m;                /* '<S141>/Sum2' */
  real32_T coswt2pi3_g;                /* '<S141>/Sum3' */
  real32_T VectorConcatenate[2];       /* '<S18>/Vector Concatenate' */
  real32_T Memory[3];                  /* '<S18>/Memory' */
  real32_T Gain2_m[3];                 /* '<S18>/Gain2' */
  real32_T v_dq[2];                    /* '<S18>/Vector Concatenate1' */
  real32_T SFunction[2];               /* '<S18>/S-Function' */
  real32_T Switch2_m[3];               /* '<S16>/Switch2' */
  real32_T Product_m;                  /* '<S19>/Product' */
  real32_T Product1_n;                 /* '<S19>/Product1' */
  real32_T sinwt2pi3_a;                /* '<S19>/Sum' */
  real32_T Product3_h;                 /* '<S19>/Product3' */
  real32_T Product2_b;                 /* '<S19>/Product2' */
  real32_T coswt2pi3_n;                /* '<S19>/Sum1' */
  real32_T sinwt2pi3_h;                /* '<S19>/Sum2' */
  real32_T coswt2pi3_c;                /* '<S19>/Sum3' */
  real32_T Va;                         /* '<S19>/Fcn2' */
  real32_T Vb;                         /* '<S19>/Fcn4' */
  real32_T Vc;                         /* '<S19>/Fcn5' */
  real32_T SVmod_o1;                   /* '<S12>/SVmod' */
  real32_T SVmod_o2;                   /* '<S12>/SVmod' */
  real32_T SVmod_o3;                   /* '<S12>/SVmod' */
  real32_T Sum_c[3];                   /* '<S9>/Sum' */
  real32_T Gain_c[3];                  /* '<S9>/Gain' */
  real32_T Saturation[3];              /* '<S9>/Saturation' */
  real32_T DataTypeConversion1_j;      /* '<S8>/Data Type Conversion1' */
  real32_T Sum2_h;                     /* '<S8>/Sum2' */
  real32_T ZeroGain;                   /* '<S69>/ZeroGain' */
  real32_T DeadZone;                   /* '<S69>/DeadZone' */
  real32_T SignPreSat;                 /* '<S69>/SignPreSat' */
  real32_T IntegralGain;               /* '<S86>/Integral Gain' */
  real32_T SignPreIntegrator;          /* '<S69>/SignPreIntegrator' */
  real32_T Switch_b;                   /* '<S69>/Switch' */
  real32_T Sum4_d;                     /* '<S141>/Sum4' */
  real32_T Gain1;                      /* '<S141>/Gain1' */
  real32_T SYS_CMD1;                   /* '<S1>/SYS_CMD1' */
  real32_T vector_lim[3];              /* '<S16>/MATLAB Function1' */
  real32_T Switch1_o[3];               /* '<S16>/Switch1' */
  real32_T DataTypeConversion_m;       /* '<S17>/Data Type Conversion' */
  real32_T gain2;                      /* '<S17>/gain2' */
  real32_T Gain_b[2];                  /* '<S18>/Gain' */
  real32_T Switch4_b;                  /* '<S15>/Switch4' */
  real32_T y_e;                        /* '<S14>/MATLAB Function' */
  real32_T Saturation_b;               /* '<S117>/Saturation' */
  real32_T Gain3_p;                    /* '<S13>/Gain3' */
  real32_T DiscreteStateSpace;         /* '<S35>/Discrete State-Space' */
  real32_T y_ej;                       /* '<S13>/MATLAB Function1' */
  real32_T ManualSwitch;               /* '<S1>/Manual Switch' */
  real32_T pos_multi;                  /* '<S8>/MATLAB Function2' */
  real32_T y_k[2];                     /* '<S8>/MATLAB Function1' */
  real32_T y_d;                        /* '<S7>/MATLAB Function4' */
  real32_T Sum4_dt;                    /* '<S7>/Sum4' */
  real32_T Sum3_n;                     /* '<S7>/Sum3' */
  int32_T Product_i;                   /* '<S17>/Product' */
  int32_T DataTypeConversion6;         /* '<S8>/Data Type Conversion6' */
  int32_T Gain1_j;                     /* '<S140>/Gain1' */
  int32_T UnitDelay1;                  /* '<S140>/Unit Delay1' */
  int32_T Sum2_p;                      /* '<S140>/Sum2' */
  int32_T VF_MAX_RATE;                 /* '<S140>/VF_MAX_RATE' */
  int32_T Sum4_o;                      /* '<S140>/Sum4' */
  int32_T Product1_g;                  /* '<S17>/Product1' */
  int32_T DataTypeConversion_f;        /* '<S18>/Data Type Conversion' */
  int32_T Memory1[2];                  /* '<S18>/Memory1' */
  int32_T dq_is_lim[2];                /* '<S16>/MATLAB Function1' */
  uint16_T VF_BOOST;                   /* '<S1>/VF_BOOST' */
  uint16_T DataTypeConversion3;        /* '<S8>/Data Type Conversion3' */
  uint16_T Switch1_e;                  /* '<S7>/Switch1' */
  uint16_T DataTypeConversion_n[3];    /* '<S9>/Data Type Conversion' */
  uint16_T Switch1_ou;                 /* '<S17>/Switch1' */
  uint16_T y_g;                        /* '<S7>/MATLAB Function' */
  uint16_T DataTypeConversion4;        /* '<S8>/Data Type Conversion4' */
  uint16_T Sum1_p;                     /* '<S7>/Sum1' */
  uint16_T Sum2_l;                     /* '<S7>/Sum2' */
  uint16_T Sum5;                       /* '<S7>/Sum5' */
  int16_T Gain_h;                      /* '<S139>/Gain' */
  int16_T Sum5_p[3];                   /* '<S8>/Sum5' */
  int16_T Sum_a;                       /* '<S17>/Sum' */
  int16_T VF_GAIN;                     /* '<S1>/VF_GAIN' */
  int16_T ROT_DIR;                     /* '<S1>/ROT_DIR' */
  int16_T Switch2_f;                   /* '<S10>/Switch2' */
  int16_T VF_CTRL;                     /* '<S1>/VF_CTRL' */
  int16_T Gain2_d;                     /* '<S140>/Gain2' */
  int16_T Switch3_h;                   /* '<S14>/Switch3' */
  int16_T Switch2_g;                   /* '<S17>/Switch2' */
  int16_T Gain1_f;                     /* '<S139>/Gain1' */
  int16_T UnitDelay;                   /* '<S139>/Unit Delay' */
  int16_T Sum1_m1;                     /* '<S139>/Sum1' */
  int16_T Switch2_fn;                  /* '<S14>/Switch2' */
  int16_T Switch2_b;                   /* '<S11>/Switch2' */
  int16_T y_gd[3];                     /* '<S8>/MATLAB Function' */
  uint8_T Compare;                     /* '<S6>/Compare' */
  uint8_T Compare_l;                   /* '<S5>/Compare' */
  uint8_T Compare_p;                   /* '<S4>/Compare' */
  uint8_T SYS_CMD2;                    /* '<S1>/SYS_CMD2' */
  int8_T DataTypeConv1;                /* '<S69>/DataTypeConv1' */
  int8_T DataTypeConv2;                /* '<S69>/DataTypeConv2' */
  boolean_T NotEqual;                  /* '<S69>/NotEqual' */
  boolean_T Equal1;                    /* '<S69>/Equal1' */
  boolean_T AND3;                      /* '<S69>/AND3' */
} BlockIO_PMSMctrl;

/* Block states (default storage) for system '<Root>' */
typedef struct {
  struct {
    void *LoggedData[2];
  } Scope2_PWORK;                      /* '<S15>/Scope2' */

  real32_T UnitDelay_DSTATE;           /* '<S34>/Unit  Delay' */
  real32_T UnitDelay_DSTATE_i;         /* '<S33>/Unit  Delay' */
  real32_T UnitDelay_DSTATE_e;         /* '<S39>/Unit  Delay' */
  real32_T DiscreteStateSpace_DSTATE;  /* '<S20>/Discrete State-Space' */
  real32_T Integrator_DSTATE;          /* '<S96>/Integrator' */
  real32_T Filter_DSTATE;              /* '<S78>/Filter' */
  real32_T DiscreteStateSpace_DSTATE_f;/* '<S35>/Discrete State-Space' */
  int32_T UnitDelay1_DSTATE;           /* '<S140>/Unit Delay1' */
  real32_T RateTransition1_Buffer0;    /* '<S1>/Rate Transition1' */
  real32_T Memory_PreviousInput[3];    /* '<S18>/Memory' */
  real32_T RateTransition2_Buffer0;    /* '<S1>/Rate Transition2' */
  real32_T old_sign;                   /* '<S13>/MATLAB Function1' */
  real32_T u_old;                      /* '<S13>/MATLAB Function' */
  real32_T CurOff[2];                  /* '<S8>/MATLAB Function1' */
  real32_T ia_acc;                     /* '<S8>/MATLAB Function1' */
  real32_T ib_acc;                     /* '<S8>/MATLAB Function1' */
  real32_T ia_acc_i;                   /* '<S8>/MATLAB Function' */
  real32_T ib_acc_m;                   /* '<S8>/MATLAB Function' */
  real32_T ic_acc;                     /* '<S8>/MATLAB Function' */
  real32_T AngleTable[6];              /* '<S7>/MATLAB Function4' */
  real32_T AngleStartTable[6];         /* '<S7>/MATLAB Function4' */
  real32_T AbsAngle;                   /* '<S7>/MATLAB Function4' */
  real32_T position_offset;            /* '<S7>/MATLAB Function3' */
  int32_T Sum5_DWORK1[3];              /* '<S8>/Sum5' */
  int32_T Memory1_PreviousInput[2];    /* '<S18>/Memory1' */
  int32_T Sum_DWORK1;                  /* '<S17>/Sum' */
  int32_T turn_cnt;                    /* '<S8>/MATLAB Function2' */
  uint32_T cnt_old;                    /* '<S8>/MATLAB Function2' */
  int16_T UnitDelay_DSTATE_h;          /* '<S139>/Unit Delay' */
  int16_T Sum4_DWORK1[2];              /* '<S8>/Sum4' */
  int16_T sample;                      /* '<S8>/MATLAB Function1' */
  int16_T CurOff_m[3];                 /* '<S8>/MATLAB Function' */
  int16_T sample_b;                    /* '<S8>/MATLAB Function' */
  uint16_T sample_count;               /* '<S14>/MATLAB Function1' */
  uint16_T OffsetState;                /* '<S7>/MATLAB Function4' */
  uint16_T HallIn;                     /* '<S7>/MATLAB Function4' */
  uint16_T AngleTable_h[6];            /* '<S7>/MATLAB Function' */
  uint16_T AngleStartTable_n[6];       /* '<S7>/MATLAB Function' */
  uint16_T OffsetState_g;              /* '<S7>/MATLAB Function' */
  uint16_T AbsAngle_d;                 /* '<S7>/MATLAB Function' */
  uint16_T HallIn_j;                   /* '<S7>/MATLAB Function' */
  int8_T Integrator_PrevResetState;    /* '<S96>/Integrator' */
  int8_T Filter_PrevResetState;        /* '<S78>/Filter' */
  uint8_T SysCmd_old;                  /* '<S8>/MATLAB Function1' */
  uint8_T SysCmd_old_o;                /* '<S8>/MATLAB Function' */
  uint8_T pos_rst_old;                 /* '<S7>/MATLAB Function3' */
  boolean_T u_old_not_empty;           /* '<S13>/MATLAB Function' */
  boolean_T AngleTable_not_empty;      /* '<S7>/MATLAB Function4' */
  boolean_T AngleStartTable_not_empty; /* '<S7>/MATLAB Function4' */
} D_Work_PMSMctrl;

/* Constant parameters (default storage) */
typedef struct {
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
  uint8_T pooled20;
} ConstParam_PMSMctrl;

/* External inputs (root inport signals with default storage) */
typedef struct {
  uint16_T ibc_sinc[2];                /* '<Root>/iab_sinc' */
  uint16_T iabc_adc[3];                /* '<Root>/iabc_adc' */
  uint32_T QEP_cnt;                    /* '<Root>/QEP_cnt' */
  uint16_T Vdc_adc;                    /* '<Root>/Vdc_adc' */
  uint16_T hall_state;                 /* '<Root>/hall_state' */
  uint32_T N_by_M;                     /* '<Root>/N_by_M' */
  uint32_T N_by_1;                     /* '<Root>/N_by_1' */
  uint32_T SPORT_cnt;                  /* '<Root>/SPORT_cnt' */
  int8_T ROT_DIR_meas;                 /* '<Root>/ROT_DIR_meas' */
} ExternalInputs_PMSMctrl;

/* External outputs (root outports fed by signals with default storage) */
typedef struct {
  uint16_T cnt_a;                      /* '<Root>/cnt_a' */
  uint16_T cnt_b;                      /* '<Root>/cnt_b' */
  uint16_T cnt_c;                      /* '<Root>/cnt_c' */
} ExternalOutputs_PMSMctrl;

/* Parameters (default storage) */
struct Parameters_PMSMctrl_ {
  real32_T Kiw;                        /* Variable: Kiw
                                        * Referenced by: '<S86>/Integral Gain'
                                        */
  real32_T Kpw;                        /* Variable: Kpw
                                        * Referenced by: '<S113>/Proportional Gain'
                                        */
  real32_T MBC_ID;                     /* Variable: MBC_ID
                                        * Referenced by: '<S1>/SYS_CMD1'
                                        */
  real32_T POS_REF;                    /* Variable: POS_REF
                                        * Referenced by: '<S1>/SPEED_REF1'
                                        */
  real32_T SPD_FF;                     /* Variable: SPD_FF
                                        * Referenced by: '<S1>/SPEED_REF2'
                                        */
  real32_T SpdSlewRateNeg;             /* Variable: SpdSlewRateNeg
                                        * Referenced by: '<S39>/Saturation'
                                        */
  real32_T SpdSlewRatePos;             /* Variable: SpdSlewRatePos
                                        * Referenced by: '<S39>/Saturation'
                                        */
  real32_T iabcOffset[3];              /* Variable: iabcOffset
                                        * Referenced by: '<S8>/Constant'
                                        */
  real32_T iabcScale;                  /* Variable: iabcScale
                                        * Referenced by: '<S8>/Gain'
                                        */
  real32_T iqMax;                      /* Variable: iqMax
                                        * Referenced by:
                                        *   '<S69>/DeadZone'
                                        *   '<S117>/Saturation'
                                        */
  real32_T iqMin;                      /* Variable: iqMin
                                        * Referenced by:
                                        *   '<S69>/DeadZone'
                                        *   '<S117>/Saturation'
                                        */
  real32_T vdcOffset;                  /* Variable: vdcOffset
                                        * Referenced by: '<S8>/Constant1'
                                        */
  real32_T vdcScale;                   /* Variable: vdcScale
                                        * Referenced by: '<S8>/Gain1'
                                        */
  int16_T MAX_RPM;                     /* Variable: MAX_RPM
                                        * Referenced by:
                                        *   '<S10>/MAX_RPM'
                                        *   '<S14>/MAX_RPM'
                                        *   '<S140>/MAX_RPM'
                                        */
  int16_T SPEED_REF;                   /* Variable: SPEED_REF
                                        * Referenced by: '<S1>/SPEED_REF'
                                        */
  int8_T VF_MAX_RATE;                  /* Variable: VF_MAX_RATE
                                        * Referenced by: '<S140>/VF_MAX_RATE'
                                        */
  uint8_T MOTOR_CFG;                   /* Variable: MOTOR_CFG
                                        * Referenced by: '<S1>/SYS_CMD2'
                                        */
  uint8_T POS_RST;                     /* Variable: POS_RST
                                        * Referenced by: '<S1>/POS_RST'
                                        */
  uint8_T ROT_DIR;                     /* Variable: ROT_DIR
                                        * Referenced by: '<S1>/ROT_DIR'
                                        */
  uint8_T SYSTEM_CMD;                  /* Variable: SYSTEM_CMD
                                        * Referenced by: '<S1>/SYS_CMD'
                                        */
  uint8_T VF_BOOST;                    /* Variable: VF_BOOST
                                        * Referenced by: '<S1>/VF_BOOST'
                                        */
  uint8_T VF_CTRL;                     /* Variable: VF_CTRL
                                        * Referenced by: '<S1>/VF_CTRL'
                                        */
  uint8_T VF_GAIN;                     /* Variable: VF_GAIN
                                        * Referenced by: '<S1>/VF_GAIN'
                                        */
};

/* Real-time Model Data Structure */
struct tag_RTM_PMSMctrl {
  const char_T * volatile errorStatus;

  /*
   * Timing:
   * The following substructure contains information regarding
   * the timing information for the model.
   */
  struct {
    struct {
      uint8_T TID0_1;
    } RateInteraction;
  } Timing;
};

/* Block parameters (default storage) */
extern Parameters_PMSMctrl PMSMctrl_P;

/* Block signals (default storage) */
extern BlockIO_PMSMctrl PMSMctrl_B;

/* Block states (default storage) */
extern D_Work_PMSMctrl PMSMctrl_DWork;

/* External inputs (root inport signals with default storage) */
extern ExternalInputs_PMSMctrl PMSMctrl_U;

/* External outputs (root outports fed by signals with default storage) */
extern ExternalOutputs_PMSMctrl PMSMctrl_Y;

/* Constant parameters (default storage) */
extern const ConstParam_PMSMctrl PMSMctrl_ConstP;

/*
 * Exported Global Signals
 *
 * Note: Exported global signals are block signals with an exported global
 * storage class designation.  Code generation will declare the memory for
 * these signals and export their symbols.
 *
 */
extern real32_T pos_ref_ui;            /* '<S11>/Switch4' */
extern real32_T position_ref;          /* '<S10>/Switch3' */
extern real32_T pos_unaligned;         /* '<S7>/Switch2' */
extern real32_T pos_aligned;           /* '<S7>/Sum6' */
extern real32_T theta_enc_mul;         /* '<S7>/Gain3' */
extern real32_T speed_ff;              /* '<S1>/SPEED_REF2' */
extern real32_T Nref;                  /* '<S10>/MAX_RPM' */
extern real32_T speed_ref;             /* '<S11>/Switch3' */
extern real32_T speed_ref_lim;         /* '<S39>/Sum' */
extern real32_T spd_fil_calc;          /* '<S1>/Rate Transition1' */
extern real32_T spd_raw_n_by_m;        /* '<S7>/Product1' */
extern real32_T spd_fil_n_by_m;        /* '<S20>/Discrete State-Space' */
extern real32_T spd_raw_n_by_1;        /* '<S7>/Product3' */
extern real32_T spd_fil_n_by_1;        /* '<S7>/Gain4' */
extern real32_T speed_fil;             /* '<S15>/Switch2' */
extern real32_T iq_ref;                /* '<S14>/Manual Switch' */
extern real32_T theta_vf;              /* '<S139>/Data Type Conversion' */
extern real32_T theta_enc;             /* '<S7>/Gain1' */
extern real32_T id;                    /* '<S141>/Fcn2' */
extern real32_T iq;                    /* '<S141>/Fcn1' */
extern real32_T theta_speed;           /* '<S2>/Rate Transition1' */
extern real32_T n_by_m_fil_debug;      /* '<S7>/Gain10' */
extern real32_T n_by_m_raw_debug;      /* '<S7>/Gain2' */
extern real32_T ia_sar;                /* '<S31>/Gain3' */
extern real32_T ib_sar;                /* '<S31>/Gain6' */
extern real32_T ic_sar;                /* '<S31>/Gain7' */
extern real32_T ic_sinc;               /* '<S32>/Gain10' */
extern real32_T ia_sinc;               /* '<S32>/Gain8' */
extern real32_T ib_sinc;               /* '<S32>/Gain9' */
extern real32_T Vdc;                   /* '<S8>/Gain1' */
extern real32_T spd_raw_calc;          /* '<S1>/Rate Transition2' */
extern real32_T speed_raw;             /* '<S15>/Switch1' */
extern real32_T iq_ref_step;           /* '<S14>/MATLAB Function1' */
extern real32_T speed_debug;           /* '<S13>/MATLAB Function' */
extern real32_T pos_offset;            /* '<S7>/MATLAB Function3' */
extern real32_T speed_meas_raw_n_by_1; /* '<S7>/MATLAB Function2' */
extern real32_T speed_meas_raw_n_by_m; /* '<S7>/MATLAB Function1' */

/* Model entry point functions */
extern void PMSMctrl_initialize(void);
extern void PMSMctrl_step0(void);
extern void PMSMctrl_step1(void);

/* Real-time Model object */
extern RT_MODEL_PMSMctrl *const PMSMctrl_M;

/*-
 * The generated code includes comments that allow you to trace directly
 * back to the appropriate location in the model.  The basic format
 * is <system>/block_name, where system is the system number (uniquely
 * assigned by Simulink) and block_name is the name of the block.
 *
 * Note that this particular code originates from a subsystem build,
 * and has its own system numbers different from the parent model.
 * Refer to the system hierarchy for this subsystem below, and use the
 * MATLAB hilite_system command to trace the generated code back
 * to the parent model.  For example,
 *
 * hilite_system('CM40xPMSM/PMSMctrl')    - opens subsystem CM40xPMSM/PMSMctrl
 * hilite_system('CM40xPMSM/PMSMctrl/Kp') - opens and selects block Kp
 *
 * Here is the system hierarchy for this model
 *
 * '<Root>' : 'CM40xPMSM'
 * '<S1>'   : 'CM40xPMSM/PMSMctrl'
 * '<S2>'   : 'CM40xPMSM/PMSMctrl/AngleSelect'
 * '<S3>'   : 'CM40xPMSM/PMSMctrl/CORDIC'
 * '<S4>'   : 'CM40xPMSM/PMSMctrl/Compare To Constant'
 * '<S5>'   : 'CM40xPMSM/PMSMctrl/Compare To Constant1'
 * '<S6>'   : 'CM40xPMSM/PMSMctrl/Compare To Constant2'
 * '<S7>'   : 'CM40xPMSM/PMSMctrl/EncInterface'
 * '<S8>'   : 'CM40xPMSM/PMSMctrl/InputScaling'
 * '<S9>'   : 'CM40xPMSM/PMSMctrl/OutputScaling'
 * '<S10>'  : 'CM40xPMSM/PMSMctrl/Position Controller'
 * '<S11>'  : 'CM40xPMSM/PMSMctrl/Reference Select'
 * '<S12>'  : 'CM40xPMSM/PMSMctrl/SVPWM'
 * '<S13>'  : 'CM40xPMSM/PMSMctrl/SpeedCalc'
 * '<S14>'  : 'CM40xPMSM/PMSMctrl/SpeedControl'
 * '<S15>'  : 'CM40xPMSM/PMSMctrl/SpeedSwitch'
 * '<S16>'  : 'CM40xPMSM/PMSMctrl/Switch'
 * '<S17>'  : 'CM40xPMSM/PMSMctrl/VFCtrl'
 * '<S18>'  : 'CM40xPMSM/PMSMctrl/VectorControl'
 * '<S19>'  : 'CM40xPMSM/PMSMctrl/dq_to_abc'
 * '<S20>'  : 'CM40xPMSM/PMSMctrl/EncInterface/Discrete 1st-Order Filter2'
 * '<S21>'  : 'CM40xPMSM/PMSMctrl/EncInterface/MATLAB Function'
 * '<S22>'  : 'CM40xPMSM/PMSMctrl/EncInterface/MATLAB Function1'
 * '<S23>'  : 'CM40xPMSM/PMSMctrl/EncInterface/MATLAB Function2'
 * '<S24>'  : 'CM40xPMSM/PMSMctrl/EncInterface/MATLAB Function3'
 * '<S25>'  : 'CM40xPMSM/PMSMctrl/EncInterface/MATLAB Function4'
 * '<S26>'  : 'CM40xPMSM/PMSMctrl/InputScaling/MATLAB Function'
 * '<S27>'  : 'CM40xPMSM/PMSMctrl/InputScaling/MATLAB Function1'
 * '<S28>'  : 'CM40xPMSM/PMSMctrl/InputScaling/MATLAB Function2'
 * '<S29>'  : 'CM40xPMSM/PMSMctrl/InputScaling/MATLAB Function3'
 * '<S30>'  : 'CM40xPMSM/PMSMctrl/InputScaling/MATLAB Function4'
 * '<S31>'  : 'CM40xPMSM/PMSMctrl/InputScaling/Subsystem'
 * '<S32>'  : 'CM40xPMSM/PMSMctrl/InputScaling/Subsystem1'
 * '<S33>'  : 'CM40xPMSM/PMSMctrl/Position Controller/Discrete Rate Limiter1'
 * '<S34>'  : 'CM40xPMSM/PMSMctrl/Position Controller/Discrete Rate Limiter2'
 * '<S35>'  : 'CM40xPMSM/PMSMctrl/SpeedCalc/Discrete 1st-Order Filter'
 * '<S36>'  : 'CM40xPMSM/PMSMctrl/SpeedCalc/MATLAB Function'
 * '<S37>'  : 'CM40xPMSM/PMSMctrl/SpeedCalc/MATLAB Function1'
 * '<S38>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2'
 * '<S39>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete Rate Limiter2'
 * '<S40>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/MATLAB Function'
 * '<S41>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/MATLAB Function1'
 * '<S42>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Anti-windup'
 * '<S43>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/D Gain'
 * '<S44>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Filter'
 * '<S45>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Filter ICs'
 * '<S46>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/I Gain'
 * '<S47>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Ideal P Gain'
 * '<S48>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Ideal P Gain Fdbk'
 * '<S49>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Integrator'
 * '<S50>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Integrator ICs'
 * '<S51>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/N Copy'
 * '<S52>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/N Gain'
 * '<S53>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/P Copy'
 * '<S54>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Parallel P Gain'
 * '<S55>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Reset Signal'
 * '<S56>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Saturation'
 * '<S57>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Saturation Fdbk'
 * '<S58>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Sum'
 * '<S59>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Sum Fdbk'
 * '<S60>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Tracking Mode'
 * '<S61>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Tracking Mode Sum'
 * '<S62>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/postSat Signal'
 * '<S63>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/preSat Signal'
 * '<S64>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Anti-windup/Back Calculation'
 * '<S65>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Anti-windup/Cont. Clamping Ideal'
 * '<S66>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Anti-windup/Cont. Clamping Parallel'
 * '<S67>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Anti-windup/Disabled'
 * '<S68>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Anti-windup/Disc. Clamping Ideal'
 * '<S69>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Anti-windup/Disc. Clamping Parallel'
 * '<S70>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Anti-windup/Passthrough'
 * '<S71>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/D Gain/Disabled'
 * '<S72>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/D Gain/External Parameters'
 * '<S73>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/D Gain/Internal Parameters'
 * '<S74>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Filter/Cont. Filter'
 * '<S75>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Filter/Differentiator'
 * '<S76>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Filter/Disabled'
 * '<S77>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Filter/Disc. Backward Euler Filter'
 * '<S78>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Filter/Disc. Forward Euler Filter'
 * '<S79>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Filter/Disc. Trapezoidal Filter'
 * '<S80>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Filter ICs/Disabled'
 * '<S81>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Filter ICs/External IC'
 * '<S82>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Filter ICs/Internal IC - Differentiator'
 * '<S83>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Filter ICs/Internal IC - Filter'
 * '<S84>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/I Gain/Disabled'
 * '<S85>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/I Gain/External Parameters'
 * '<S86>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/I Gain/Internal Parameters'
 * '<S87>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Ideal P Gain/External Parameters'
 * '<S88>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Ideal P Gain/Internal Parameters'
 * '<S89>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Ideal P Gain/Passthrough'
 * '<S90>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Ideal P Gain Fdbk/Disabled'
 * '<S91>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Ideal P Gain Fdbk/External Parameters'
 * '<S92>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Ideal P Gain Fdbk/Internal Parameters'
 * '<S93>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Ideal P Gain Fdbk/Passthrough'
 * '<S94>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Integrator/Continuous'
 * '<S95>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Integrator/Disabled'
 * '<S96>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Integrator/Discrete'
 * '<S97>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Integrator ICs/Disabled'
 * '<S98>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Integrator ICs/External IC'
 * '<S99>'  : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Integrator ICs/Internal IC'
 * '<S100>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/N Copy/Disabled'
 * '<S101>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/N Copy/Disabled wSignal Specification'
 * '<S102>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/N Copy/External Parameters'
 * '<S103>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/N Copy/Internal Parameters'
 * '<S104>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/N Gain/Disabled'
 * '<S105>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/N Gain/External Parameters'
 * '<S106>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/N Gain/Internal Parameters'
 * '<S107>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/N Gain/Passthrough'
 * '<S108>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/P Copy/Disabled'
 * '<S109>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/P Copy/External Parameters Ideal'
 * '<S110>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/P Copy/Internal Parameters Ideal'
 * '<S111>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Parallel P Gain/Disabled'
 * '<S112>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Parallel P Gain/External Parameters'
 * '<S113>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Parallel P Gain/Internal Parameters'
 * '<S114>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Parallel P Gain/Passthrough'
 * '<S115>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Reset Signal/Disabled'
 * '<S116>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Reset Signal/External Reset'
 * '<S117>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Saturation/Enabled'
 * '<S118>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Saturation/Passthrough'
 * '<S119>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Saturation Fdbk/Disabled'
 * '<S120>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Saturation Fdbk/Enabled'
 * '<S121>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Saturation Fdbk/Passthrough'
 * '<S122>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Sum/Passthrough_I'
 * '<S123>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Sum/Passthrough_P'
 * '<S124>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Sum/Sum_PD'
 * '<S125>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Sum/Sum_PI'
 * '<S126>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Sum/Sum_PID'
 * '<S127>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Sum Fdbk/Disabled'
 * '<S128>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Sum Fdbk/Enabled'
 * '<S129>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Sum Fdbk/Passthrough'
 * '<S130>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Tracking Mode/Disabled'
 * '<S131>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Tracking Mode/Enabled'
 * '<S132>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Tracking Mode Sum/Passthrough'
 * '<S133>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/Tracking Mode Sum/Tracking Mode'
 * '<S134>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/postSat Signal/Feedback_Path'
 * '<S135>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/postSat Signal/Forward_Path'
 * '<S136>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/preSat Signal/Feedback_Path'
 * '<S137>' : 'CM40xPMSM/PMSMctrl/SpeedControl/Discrete PID Controller2/preSat Signal/Forward_Path'
 * '<S138>' : 'CM40xPMSM/PMSMctrl/Switch/MATLAB Function1'
 * '<S139>' : 'CM40xPMSM/PMSMctrl/VFCtrl/AngCalc'
 * '<S140>' : 'CM40xPMSM/PMSMctrl/VFCtrl/RefCtrl'
 * '<S141>' : 'CM40xPMSM/PMSMctrl/VectorControl/abc_to_dq2'
 */
#endif                                 /* RTW_HEADER_PMSMctrl_h_ */

/*
 * File trailer for generated code.
 *
 * [EOF]
 */
