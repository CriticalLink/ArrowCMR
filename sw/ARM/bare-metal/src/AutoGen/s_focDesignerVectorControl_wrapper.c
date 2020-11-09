
/*
 * Include Files
 *
 */
#if defined(MATLAB_MEX_FILE)
#include "tmwtypes.h"
#include "simstruc_types.h"
#else
#include "rtwtypes.h"
#endif



/* %%%-SFUNWIZ_wrapper_includes_Changes_BEGIN --- EDIT HERE TO _END */
#include "focDesigner.h"
/* %%%-SFUNWIZ_wrapper_includes_Changes_END --- EDIT HERE TO _BEGIN */
#define u_width 2
#define y_width 1

/*
 * Create external references here.  
 *
 */
/* %%%-SFUNWIZ_wrapper_externs_Changes_BEGIN --- EDIT HERE TO _END */
 
/* %%%-SFUNWIZ_wrapper_externs_Changes_END --- EDIT HERE TO _BEGIN */

/*
 * Output function
 *
 */
void s_focDesignerVectorControl_Outputs_wrapper(const real32_T *i_ref_dq,
			const real32_T *i_dq,
			const int32_T *en,
			const real32_T *v_ref_lim_dq,
			const int32_T *dq_is_lim,
			real32_T *v_ref_dq)
{
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_BEGIN --- EDIT HERE TO _END */
dqFrame_t currentRef;
dqFrame_t current;
dqFrame_t voltageRef;
dqFrame_t voltageRefLim;

currentRef.d = i_ref_dq[0];
currentRef.q = i_ref_dq[1];
current.d = i_dq[0];
current.q = i_dq[1];
voltageRefLim.d = v_ref_lim_dq[0];
voltageRefLim.q = v_ref_lim_dq[1];

voltageRef = focDesignerVectorControl(currentRef, current, en[0]);
focDesignerVectorControlPostLimiting(voltageRefLim, dq_is_lim[0], dq_is_lim[1]);

v_ref_dq[0] = voltageRef.d;
v_ref_dq[1] = voltageRef.q;
/* %%%-SFUNWIZ_wrapper_Outputs_Changes_END --- EDIT HERE TO _BEGIN */
}


