/* *****************************************************************************
Generated by FocDesigner v1.0.0.0, Analog Devices Inc.

Generation date: 2021-02-18
*******************************************************************************/

#include "focDesigner.h"

static piParameter_t dAxisPi = {
    0.927701110726851,
    0.0862307541522398,
    0.0,
    0.0
};

static piParameter_t qAxisPi = {
    0.927701110726851,
    0.0862307541522398,
    0.0,
    0.0
};

static float updatePi(piParameter_t* piParam, float u)
{
    float acc = piParam->intGain*(u + piParam->u_n1) + piParam->acc_n1;
    float y = piParam->propGain*u + acc;
    
    piParam->u_n1 = u;
    piParam->acc_n1 = acc;
    
    return y;
}

// This function represents the vector controller that is called for each sample
// set of the d/q current components
// @param currentRef    The stator current vector reference
// @param current       The measured stator current vector
// @param en            Control enable flag
// @return              The voltage vector reference for e.g. SVM
dqFrame_t focDesignerVectorControl(dqFrame_t currentRef, dqFrame_t current, int en)
{
    dqFrame_t currentErr;
    dqFrame_t voltageRef = {0, 0};

    if (!en)
    {
        dAxisPi.u_n1 = 0;
        dAxisPi.acc_n1 = 0;
        qAxisPi.u_n1 = 0;
        qAxisPi.acc_n1 = 0;
        
        return voltageRef;
    }
    
    currentErr.d = currentRef.d - current.d;
    currentErr.q = currentRef.q - current.q;
    
    voltageRef.d = updatePi(&dAxisPi, currentErr.d);
    voltageRef.q = updatePi(&qAxisPi, currentErr.q);
    
    return voltageRef;
}

// This function needs to be called after any limiting has been performed on the
// voltage vector reference returned by focDesignerVectorControl to avoid
// winding up the integrators in the d/q PI controllers
// @param voltageRef    The limited voltage vector reference
// @param dIsLimited    Has the d-component been limited?
// @param qIsLimited    Has the q-component been limited?
void focDesignerVectorControlPostLimiting(dqFrame_t voltageRef, int dIsLimited, int qIsLimited)
{
    float refAbs;
    float accAbs;
    
    if (dIsLimited)
    {
        if (voltageRef.d < 0)
            refAbs = -voltageRef.d;
        else
            refAbs = voltageRef.d;
        
        if (dAxisPi.acc_n1 < 0)
            accAbs = -dAxisPi.acc_n1;
        else
            accAbs = dAxisPi.acc_n1;
        
        if (accAbs > refAbs)
            dAxisPi.acc_n1 = voltageRef.d;
    }
    
    if (qIsLimited)
    {
        if (voltageRef.q < 0)
            refAbs = -voltageRef.q;
        else
            refAbs = voltageRef.q;
        
        if (qAxisPi.acc_n1 < 0)
            accAbs = -qAxisPi.acc_n1;
        else
            accAbs = qAxisPi.acc_n1;
        
        if (accAbs > refAbs)
            qAxisPi.acc_n1 = voltageRef.q;
    }
}
