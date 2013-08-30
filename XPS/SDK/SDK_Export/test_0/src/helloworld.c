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
#include <audiofx.h>
#include <xgpio.h>

#define FUNC_ENTER()	xil_printf(" %s()\r\n", __FUNCTION__)

static XGpio m_gpioDIP8;
static XGpio m_gpioLEDs8;
static XGpio m_gpioPBs5;

static volatile int one_second_flag = 0;


void timer_int_handler(void* _unused) {
	u32 tcsr0;

	/* Read timer 0 CSR to see if it raised the interrupt */
	tcsr0 = XTmrCtr_GetControlStatusReg(XPAR_XPS_TIMER_0_BASEADDR, 0);

	/* If the interrupt occurred, then increment a counter and set one_second_flag */
	if (tcsr0 & XTC_CSR_INT_OCCURED_MASK) {
		one_second_flag = 1;

		/* Clear the timer interrupt */
		XTmrCtr_SetControlStatusReg(XPAR_XPS_TIMER_0_BASEADDR, 0, tcsr0);
	}

}


void init_interrupts(void) {
	FUNC_ENTER();


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

// vol:
// 0 = mute
// 32 = max
void set_output_volume(int vol) {
	if (vol == 0) {
		WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_STEREO_VOLUME_REG, XAC97_VOL_MUTE);
	}
	else if (vol <= 32) {
		u8 val = 32 - vol;
		u16 regval = (val << 8) | val;
		xil_printf("Setting master volume reg (02h) to 0x%04X\r\n", regval);
		WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_STEREO_VOLUME_REG, regval);
	}
}


//#define ANALOG_BYPASS

void do_ac97_init(void) {
	FUNC_ENTER();

	print("Calling init_sound\r\n");
	init_sound(48000);

	// Select Line In for Recording
	XAC97_RecordSelect(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_RECORD_LINE_IN);

	// Set the overall Record gain to 0dB.
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_RECORD_GAIN_REG, 0x0000);


	/////////////////////////////
	// Set analog mixer volumes

	// Mute the mic in volume
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_MIC_VOLUME_REG, XAC97_IN_MUTE);

#ifdef ANALOG_BYPASS
	// Set the Line In gain to 0dB.
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_LINE_IN_VOLUME_REG, XAC97_IN_GAIN_0dB);		// LINE IN = 0dB
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_PCM_OUT_VOLUME_REG, XAC97_IN_MUTE);			// PCM OUT = Mute
#else
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_LINE_IN_VOLUME_REG, XAC97_IN_MUTE);			// LINE IN = Mute
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_PCM_OUT_VOLUME_REG, XAC97_IN_GAIN_0dB);		// PCM OUT = 0dB
#endif






	// Set the Master volume to 0dB.
	set_output_volume(24);



	print("Calling playback_enable\r\n");
	playback_enable();

	print("Calling record_enable\r\n");
	record_enable();
}

void do_gpio_init(void) {
	FUNC_ENTER();
	// direction: Bits set to 0 are output and bits set to 1 are input.

    XGpio_Initialize(&m_gpioDIP8, XPAR_DIP_SWITCHES_8BIT_DEVICE_ID);
    XGpio_SetDataDirection(&m_gpioDIP8, 1, 0xFFFFFFFF);	// dip switches are inputs

    XGpio_Initialize(&m_gpioPBs5, XPAR_PUSH_BUTTONS_5BIT_DEVICE_ID);
	XGpio_SetDataDirection(&m_gpioPBs5, 1, 0xFFFFFFFF);	// push buttons are inputs

    XGpio_Initialize(&m_gpioLEDs8, XPAR_LEDS_8BIT_DEVICE_ID);
    XGpio_SetDataDirection(&m_gpioLEDs8, 1, 0x00000000);	// LEDs are outputs


}

inline u8 read_DIP8(void) {
	return XGpio_DiscreteRead(&m_gpioDIP8, 1) & 0xFF;
}

inline u8 read_PB5(void) {
	return XGpio_DiscreteRead(&m_gpioPBs5, 1) & 0xFF;
}

/*
void list_regs(void) {
	int i;
	u16 val;

	xil_printf("0x%X\r\n", ReadAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_RECORD_SELECT_REG));

	print("AC'97 registers:\r\n");
	for (i=0; i<=0x3A; i+=2) {
		val = ReadAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, i);

		xil_printf("  [%02Xh] = 0x%04X\r\n", i, val);
	}
}
*/

// gain 	A number in 1/8ths. For example:
// gain		multiplier
//	0		0.0  	(-inf dB)
//  4		0.5  	(-6 dB)
//  8       1.0  	(0 dB)
//  12		1.5  	(3.5 dB)
//  16		2.0		(6 dB)
void set_gain(uint gain) {
	u32 regval;
	// The 32-bit gain register is fixed-point, with 16 integer, 16 fractional bits.
	//XIo_Out32(XPAR_AUDIOFX_0_BASEADDR + 0x20, 0x00010000);	// 1.0

	regval = gain << (16-3);

	xil_printf("Programming gain reg (20h) to 0x%08X\r\n", regval);

	XIo_Out32(XPAR_AUDIOFX_0_BASEADDR + 0x20, regval);
}



int main(void)
{
	u8 cur_dip=0, new_dip=0;
	u8 cur_pb=0, new_pb=0;
	u32 temp;

	print("Microblaze started. Built on " __DATE__ " at " __TIME__ "\r\n");
	init_interrupts();
	do_ac97_init();
	do_gpio_init();

	//list_regs();
	//while (1) {}

	set_gain(8);


	print("Entering main loop...\r\n");
    while (1) {

    	/*
    	if (one_second_flag) {
    		u32 fsl_count=0, prev_fsl_count=0;

    		one_second_flag = 0;

    		fsl_count = XIo_In32(XPAR_AUDIOFX_0_BASEADDR + AUDIOFX_REG_0Ch_OFFSET);
    		xil_printf("\r\ndiff = %d\r\n", fsl_count - prev_fsl_count);
    		prev_fsl_count = fsl_count;

    		temp = XIo_In32(XPAR_AUDIOFX_0_BASEADDR + 0x10);
    		xil_printf("Left avg  = %d\r\n");

    		temp = XIo_In32(XPAR_AUDIOFX_0_BASEADDR + 0x14);
			xil_printf("Right avg = %d\r\n");
    	}
    	*/

    	// Check if DSP select switches changed
    	new_dip = read_DIP8();
    	if (new_dip != cur_dip) {
    		cur_dip = new_dip;

    		xil_printf("New DIP switch value: 0x%X\r\n", new_dip);
    		XIo_Out32(XPAR_AUDIOFX_0_BASEADDR + AUDIOFX_DSPENA_REG_OFFSET, new_dip);

    		temp = XIo_In32(XPAR_AUDIOFX_0_BASEADDR + AUDIOFX_DSPENA_REG_OFFSET);

    		xil_printf("Enabled DSPs: 0x%X\r\n", temp);
    	}

    	// Check if push buttons have been pressed or released
    	new_pb = read_PB5();
    	if (new_pb != cur_pb) {
    		cur_pb = new_pb;

    		xil_printf("New Pushbuttons value: 0x%X\r\n", new_pb);
    	}
    }



    while (1) { }
    return 0;
}
