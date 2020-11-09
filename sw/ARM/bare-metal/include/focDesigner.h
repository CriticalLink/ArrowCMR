/* *****************************************************************************
Generated by FocDesigner v1.0.0.0, Analog Devices Inc.

Generation date: 2019-05-01
*******************************************************************************/

#ifndef FOC_DESIGNER_H_
#define FOC_DESIGNER_H_

#define FOC_DESIGNER_DOUBLE_UPDATE_MODE_EN  0

typedef struct
{
    float propGain;
    float intGain;
    float u_n1;
    float acc_n1;
} piParameter_t;

typedef struct
{
    float d;
    float q;
} dqFrame_t;

void focDesignerSincConfig(void);
void focDesignerTimerConfig(void);
void focDesignerTruConfig(void);

dqFrame_t focDesignerVectorControl(dqFrame_t currentRef, dqFrame_t current, int controlEn);
void focDesignerVectorControlPostLimiting(dqFrame_t voltageRef, int dIsLimited, int qIsLimited);

#endif
