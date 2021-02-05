/*---------------------------------------------------------------*/
/* Performance Monitoring Unit (PMU) Example Code for Cortex-A/R */
/*                                                               */
/* Copyright (C) ARM Limited, 2010-2012. All rights reserved.    */
/*---------------------------------------------------------------*/

//#include <stdio.h>
#define HAVE_PMU
#ifdef HAVE_PMU
#include "v7_pmu.h"
#include <stdio.h>

typedef struct tsCounterCfg {
	unsigned int counter;
	const char * desc;
}tsCounterCfg;

// The Cortex-A9 processor PMU provides six counters to gather statistics on the operation of the processor and memory system.
#define NUM_COUNTERS 6
unsigned int get_num_counters(void) { return NUM_COUNTERS; }

static tsCounterCfg cfg[NUM_COUNTERS] = {
		[0].counter = 0x93,
		[0].desc    = "External interrupts",
		[1].counter = 0x3,
		[1].desc    = "Data Cache Miss",
		[2].counter = 0x66,
		[2].desc    = "Memory Access Read",
		[3].counter = 0x67,
		[3].desc    = "Memory Access Writes",
		[4].counter = 0x4,
		[4].desc    = "Level 1 data cache access",
		[5].counter = 0x62,
		[5].desc    = "Main TLB miss stall cycles",
};

void start_pmu_counters(void)
{
    enable_pmu_user_access();  // Allow access to PMU from User Mode

    enable_pmu();              // Enable the PMU

    for(int ii = 0; ii < NUM_COUNTERS; ++ii) {
    	pmn_config(ii,cfg[ii].counter);
    }

    for(int ii = 0; ii < NUM_COUNTERS; ++ii) {
    	enable_pmn(ii);
    }
    enable_ccnt();             // Enable CCNT

//    enable_caches();           // in startup.s

    reset_ccnt();              // Reset the CCNT (cycle counter)
    reset_pmn();               // Reset the configurable counters
}

void stop_pmu_counters(void)
{
	disable_ccnt();            // Stop CCNT
    for(int ii = 0; ii < NUM_COUNTERS; ++ii) {
    	disable_pmn(ii);
    }
}

void display_counters(void) {
    for(int ii = 0; ii < NUM_COUNTERS; ++ii) {
	  printf("PMU Counter %d = %u   -- %s\r\n", ii, read_pmn(ii),cfg[ii].desc);
    }
}
#else
void start_pmu_counters(void)
{}
void stop_pmu_counters(void)
{}
unsigned int getPMN(void) { return 0; }
void pmn_config(unsigned int counter, unsigned int event) { return ; }
void ccnt_divider(int divider) { return ; }
void enable_pmu(void) { return ; }
void disable_pmu(void) { return ; }
void enable_ccnt(void) { return ; }
void disable_ccnt(void) { return ; }
void enable_pmn(unsigned int counter) { return ; }
void disable_pmn(unsigned int counter) { return ; }
unsigned int read_ccnt(void) { return 0; }
unsigned int read_pmn(unsigned int counter) { return 0; }
unsigned int read_flags(void) { return 0; }
void write_flags(unsigned int flags) { return ; }
void enable_ccnt_irq(void) { return ; }
void disable_ccnt_irq(void) { return ; }
void enable_pmn_irq(unsigned int counter) { return ; }
void disable_pmn_irq(unsigned int counter) { return ; }
void reset_pmn(void) { return ; }
void reset_ccnt(void) { return ; }
void pmu_software_increment(unsigned int counter) { return ; }
void enable_pmu_user_access(void) { return ; }
void disable_pmu_user_access(void) { return ; }
#endif
