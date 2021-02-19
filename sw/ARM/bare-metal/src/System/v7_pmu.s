/*---------------------------------------------------------------
;; Performance Monitoring Unit (PMU) Example Code for Cortex-A/R
;;
;; Copyright (C) ARM Limited, 2010-2012. All rights reserved.
;;---------------------------------------------------------------
*/

  /* ARMAS - PRESERVE8 */
/* .align 8 */

  /* ARMAS - AREA  v7PMU,CODE,READONLY */
.text
  /* ARMAS - ARM */
.arm

/*  ------------------------------------------------------------ */
/*  Performance Monitor Block */
/*  ------------------------------------------------------------ */

  /* Returns the number of progammable counters */
  /* uint32_t getPMN(void) */
.global getPMN
getPMN:
  .fnstart
  MRC     p15, 0, r0, c9, c12, 0 /*  Read PMCR Register */
  MOV     r0, r0, LSR #11        /*  Shift N field down to bit 0 */
  AND     r0, r0, #0x1F          /*  Mask to leave just the 5 N bits */
  BX      lr
  .fnend



  /*  Sets the event for a programmable counter to record */
  /*  void pmn_config(unsigned counter, uint32_t event) */
  /*  counter (in r0) = Which counter to program (e.g. 0 for PMN0, 1 for PMN1) */
  /*  event   (in r1) = The event code (from appropriate TRM or ARM Architecture Reference Manual) */
.global pmn_config
pmn_config:
  .fnstart
  AND     r0, r0, #0x1F          /*  Mask to leave only bits 4:0 */
  MCR     p15, 0, r0, c9, c12, 5 /*  Write PMSELR Register */
  ISB                            /*  Synchronize context */
  MCR     p15, 0, r1, c9, c13, 1 /*  Write PMXEVTYPER Register */
  BX      lr
  .fnend



  /*  Enables/disables the divider (1/64) on CCNT */
  /*  void ccnt_divider(int divider) */
  /*  divider (in r0) = If 0 disable divider, else enable divider */
.global ccnt_divider
ccnt_divider:
  .fnstart
  MRC     p15, 0, r1, c9, c12, 0  /*  Read PMCR */

  CMP     r0, #0x0                /*  IF (r0 == 0) */
  BICEQ   r1, r1, #0x08           /*  THEN: Clear the D bit (disables the divisor) */
  ORRNE   r1, r1, #0x08           /*  ELSE: Set the D bit (enables the divisor) */

  MCR     p15, 0, r1, c9, c12, 0  /*  Write PMCR */
  BX      lr
  .fnend

  /*  --------------------------------------------------------------- */
  /*  Enable/Disable */
  /*  --------------------------------------------------------------- */


  /*  Global PMU enable */
  /*  void enable_pmu(void) */
.global enable_pmu 
enable_pmu :
  .fnstart
  MRC     p15, 0, r0, c9, c12, 0  /*  Read PMCR */
  ORR     r0, r0, #0x01           /*  Set E bit */
  MCR     p15, 0, r0, c9, c12, 0  /*  Write PMCR */
  BX      lr
  .fnend



  /*  Global PMU disable */
  /*  void disable_pmu(void) */
.global disable_pmu 
disable_pmu :
  .fnstart
  MRC     p15, 0, r0, c9, c12, 0  /*  Read PMCR */
  BIC     r0, r0, #0x01           /*  Clear E bit */
  MCR     p15, 0, r0, c9, c12, 0  /*  Write PMCR */
  BX      lr
  .fnend



  /*  Enable the CCNT */
  /*  void enable_ccnt(void) */
.global enable_ccnt
enable_ccnt:
  .fnstart
  MOV     r0, #0x80000000         /*  Set C bit */
  MCR     p15, 0, r0, c9, c12, 1  /*  Write PMCNTENSET Register */
  BX      lr
  .fnend



  /*  Disable the CCNT */
  /*  void disable_ccnt(void) */
.global disable_ccnt
disable_ccnt:
  .fnstart
  MOV     r0, #0x80000000         /*  Set C bit */
  MCR     p15, 0, r0, c9, c12, 2  /*  Write PMCNTENCLR Register */
  BX      lr
  .fnend



  /*  Enable PMN{n} */
  /*  void enable_pmn(uint32_t counter) */
  /*  counter (in r0) = The counter to enable (e.g. 0 for PMN0, 1 for PMN1) */
.global enable_pmn
enable_pmn:
  .fnstart
  MOV     r1, #0x1
  MOV     r1, r1, LSL r0
  MCR     p15, 0, r1, c9, c12, 1  /*  Write PMCNTENSET Register */
  BX      lr
  .fnend



  /*  Disable PMN{n} */
  /*  void disable_pmn(uint32_t counter) */
  /*  counter (in r0) = The counter to disable (e.g. 0 for PMN0, 1 for PMN1) */
.global disable_pmn
disable_pmn:
  .fnstart
  MOV     r1, #0x1
  MOV     r1, r1, LSL r0
  MCR     p15, 0, r1, c9, c12, 2  /*  Write PMCNTENCLR Register */
  BX      lr
  .fnend



  /*  Enables User mode access to the PMU (must be called in a privileged mode) */
  /*  void enable_pmu_user_access(void) */
.global enable_pmu_user_access
enable_pmu_user_access:
  .fnstart
  MRC     p15, 0, r0, c9, c14, 0  /*  Read PMUSERENR Register */
  ORR     r0, r0, #0x01           /*  Set EN bit (bit 0) */
  MCR     p15, 0, r0, c9, c14, 0  /*  Write PMUSERENR Register */
  ISB                             /*  Synchronize context */
  BX      lr
  .fnend



  /*  Disables User mode access to the PMU (must be called in a privileged mode) */
  /*  void disable_pmu_user_access(void) */
.global disable_pmu_user_access
disable_pmu_user_access:
  .fnstart
  MRC     p15, 0, r0, c9, c14, 0  /*  Read PMUSERENR Register */
  BIC     r0, r0, #0x01           /*  Clear EN bit (bit 0) */
  MCR     p15, 0, r0, c9, c14, 0  /*  Write PMUSERENR Register */
  ISB                             /*  Synchronize context */
  BX      lr
  .fnend


  /*  --------------------------------------------------------------- */
  /*  Counter read registers */
  /*  --------------------------------------------------------------- */


  /*  Returns the value of CCNT */
  /*  uint32_t read_ccnt(void) */
.global read_ccnt
read_ccnt:
  .fnstart
  MRC     p15, 0, r0, c9, c13, 0 /*  Read CCNT Register */
  BX      lr
  .fnend



  /*  Returns the value of PMN{n} */
  /*  uint32_t read_pmn(uint32_t counter) */
  /*  counter (in r0) = The counter to read (e.g. 0 for PMN0, 1 for PMN1) */
.global read_pmn
read_pmn:
  .fnstart
  AND     r0, r0, #0x1F          /*  Mask to leave only bits 4:0 */
  MCR     p15, 0, r0, c9, c12, 5 /*  Write PMSELR Register */
  ISB                            /*  Synchronize context */
  MRC     p15, 0, r0, c9, c13, 2 /*  Read current PMNx Register */
  BX      lr
  .fnend


  /*  --------------------------------------------------------------- */
  /*  Software Increment */
  /*  --------------------------------------------------------------- */


  /*  Writes to software increment register */
  /*  void pmu_software_increment(uint32_t counter) */
  /*  counter (in r0) = The counter to increment (e.g. 0 for PMN0, 1 for PMN1) */
.global pmu_software_increment
pmu_software_increment:
  .fnstart
  MOV     r1, #0x01
  MOV     r1, r1, LSL r0
  MCR     p15, 0, r1, c9, c12, 4 /*  Write PMSWINCR Register */
  BX      lr
  .fnend


  /*  --------------------------------------------------------------- */
  /*  Overflow & Interrupt Generation */
  /*  --------------------------------------------------------------- */


  /*  Returns the value of the overflow flags */
  /*  uint32_t read_flags(void) */
.global read_flags
read_flags:
  .fnstart
  MRC     p15, 0, r0, c9, c12, 3 /*  Read PMOVSR Register */
  BX      lr
  .fnend



  /*  Writes the overflow flags */
  /*  void write_flags(uint32_t flags) */
.global write_flags
write_flags:
  .fnstart
  MCR     p15, 0, r0, c9, c12, 3 /*  Write PMOVSR Register */
  ISB                            /*  Synchronize context */
  BX      lr
  .fnend



  /*  Enables interrupt generation on overflow of the CCNT */
  /*  void enable_ccnt_irq(void) */
.global enable_ccnt_irq
enable_ccnt_irq:
  .fnstart
  MOV     r0, #0x80000000
  MCR     p15, 0, r0, c9, c14, 1  /*  Write PMINTENSET Register */
  BX      lr
  .fnend



  /*  Disables interrupt generation on overflow of the CCNT */
  /*  void disable_ccnt_irq(void) */
.global disable_ccnt_irq
disable_ccnt_irq:
  .fnstart
  MOV     r0, #0x80000000
  MCR     p15, 0, r0, c9, c14, 2   /*  Write PMINTENCLR Register */
  BX      lr
  .fnend



  /*  Enables interrupt generation on overflow of PMN{x} */
  /*  void enable_pmn_irq(uint32_t counter) */
  /*  counter (in r0) = The counter to enable the interrupt for (e.g. 0 for PMN0, 1 for PMN1) */
.global enable_pmn_irq
enable_pmn_irq:
  .fnstart
  MOV     r1, #0x1
  MOV     r0, r1, LSL r0
  MCR     p15, 0, r0, c9, c14, 1   /*  Write PMINTENSET Register */
  BX      lr
  .fnend



  /*  Disables interrupt generation on overflow of PMN{x} */
  /*  void disable_pmn_irq(uint32_t counter) */
  /*  counter (in r0) = The counter to disable the interrupt for (e.g. 0 for PMN0, 1 for PMN1) */
.global disable_pmn_irq
disable_pmn_irq:
  .fnstart
  MOV     r1, #0x1
  MOV     r0, r1, LSL r0
  MCR     p15, 0, r0, c9, c14, 2  /*  Write PMINTENCLR Register */
  BX      lr
  .fnend


  /*  --------------------------------------------------------------- */
  /*  Reset Functions */
  /*  --------------------------------------------------------------- */


  /*  Resets all programmable counters to zero */
  /*  void reset_pmn(void) */
.global reset_pmn
reset_pmn:
  .fnstart
  MRC     p15, 0, r0, c9, c12, 0  /*  Read PMCR */
  ORR     r0, r0, #0x2            /*  Set P bit (Event counter reset) */
  MCR     p15, 0, r0, c9, c12, 0  /*  Write PMCR */
  BX      lr
  .fnend



  /*  Resets the CCNT */
  /*  void reset_ccnt(void) */
.global reset_ccnt
reset_ccnt:
  .fnstart
  MRC     p15, 0, r0, c9, c12, 0  /*  Read PMCR */
  ORR     r0, r0, #0x4            /*  Set C bit (Clock counter reset) */
  MCR     p15, 0, r0, c9, c12, 0  /*  Write PMCR */
  BX      lr
  .fnend
