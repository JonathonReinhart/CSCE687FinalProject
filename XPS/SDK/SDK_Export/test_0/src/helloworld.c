/*
 * Copyright (c) 2009 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

/*
 * helloworld.c: simple test application
 */

#include <stdio.h>
#include <xparameters.h>
#include <mb_interface.h>

#include <xintc.h>
#include <xtmrctr.h>

#include <xac97.h>
#include <xac97_l.h>

unsigned int count = 1;
int one_second_flag = 0;


void timer_int_handler(void* _unused) {
	u32 csr;

	/* Read timer 0 CSR to see if it raised the interrupt */
	csr = XTmrCtr_GetControlStatusReg(XPAR_XPS_TIMER_0_BASEADDR, 0);

	/* If the interrupt occurred, then increment a counter and set one_second_flag */
	if (csr & XTC_CSR_INT_OCCURED_MASK) {
		count++;
		one_second_flag = 1;
	}

	/* Clear the timer interrupt */
	XTmrCtr_SetControlStatusReg(XPAR_XPS_TIMER_0_BASEADDR, 0, csr);

	xil_printf("tick %d\r\n", count);
}


void init_interrupts(void) {
	print("Calling init_interrupts()\r\n");


	////////////////////////////////////
	// Initialize interrupt controller

	// Register the Timer interrupt handler in the vector table
	XIntc_RegisterHandler(
			XPAR_XPS_INTC_0_BASEADDR,                       // BaseAddress
			XPAR_XPS_INTC_0_XPS_TIMER_0_INTERRUPT_INTR,     // InterruptId
			timer_int_handler,                              // Handler
			0);                                             // CallBackRef - parameter passed to Handler

	// Start the interrupt controller
	XIntc_MasterEnable(XPAR_XPS_INTC_0_BASEADDR);

	// Enable timer interrupts in the interrupt controller
	XIntc_EnableIntr(XPAR_XPS_INTC_0_BASEADDR, XPAR_XPS_TIMER_0_INTERRUPT_MASK);


	////////////////////////////////////
	// Initialize timer

	// Set the number of cycles the timer counts before interrupting
	XTmrCtr_SetLoadReg(XPAR_XPS_TIMER_0_BASEADDR, 0, 1 * XPAR_XPS_TIMER_0_CLOCK_FREQ_HZ);

	// Reset the timer, and clear the interrupt occurred flag
	XTmrCtr_SetControlStatusReg(XPAR_XPS_TIMER_0_BASEADDR, 0,
			XTC_CSR_INT_OCCURED_MASK |        // Clear T0INT
			XTC_CSR_LOAD_MASK                 // LOAD0 1 = Loads timer with value in TLR0
			);

	// Start the timers
	XTmrCtr_SetControlStatusReg(XPAR_XPS_TIMER_0_BASEADDR, 0,
			XTC_CSR_ENABLE_TMR_MASK |         // ENT0 Enable Timer0
			XTC_CSR_ENABLE_INT_MASK |         // ENIT Enable Interrupt for Timer0
			XTC_CSR_AUTO_RELOAD_MASK |        // ARHT0 1 = Auto reload Timer0 and continue running
			XTC_CSR_DOWN_COUNT_MASK           // UDT0  1 = Timer counts down
			);


	////////////////////////////////////

	// Ready to go - enable interrupts!
	microblaze_enable_interrupts();
}


int main(void)
{
	print("Microblaze started. Built on " __DATE__ " at " __TIME__ "\r\n");

	init_interrupts();
	while (1) { }

    print("Calling init_sound\r\n");
    init_sound(48000);

    // Select only Line In for Record Select
    WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_RECORD_SELECT_REG, 0x0404);

    // Mute the mic in volume
    WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_MIC_VOLUME_REG, XAC97_VOL_MUTE);

    // Set the Line In gain to 0dB.
    WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_LINE_IN_VOLUME_REG, XAC97_VOL_0dB);

    // Set the Master volume to 0dB.
    WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_STEREO_VOLUME_REG, XAC97_VOL_0dB);



    print("Calling playback_enable\r\n");
    playback_enable();

    print("Calling record_enable\r\n");
    record_enable();

    print("CPU effectively stopped.");
    while (1) {

    }



    return 0;
}
