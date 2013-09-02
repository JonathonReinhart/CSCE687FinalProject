#include <stdio.h>
#include <xparameters.h>
#include <mb_interface.h>
#include <xintc.h>
#include <xtmrctr.h>
#include <xac97.h>
#include <xac97_l.h>
#include <audiofx.h>
#include <xgpio.h>

#include "ac97.h"
#include "lcd.h"
#include "menu.h"
#include "config.h"

/*** Macros, project-specific definitions ***/






#define PB5_N	0x01	// North
#define PB5_E	0x02	// East
#define PB5_S	0x04	// South
#define PB5_W	0x08	// West
#define PB5_C	0x10	// Center


/*** Data ***/

static XGpio m_gpioDIP8;
static XGpio m_gpioLEDs8;
static XGpio m_gpioPBs5;

static volatile int mv_one_sec_flag = 0;

static volatile short mv_ac97_init_watchdog = -1;

/*** Function definitions ***/


void timer_int_handler(void* _unused) {
	u32 tcsr0;

	/* Read timer 0 CSR to see if it raised the interrupt */
	tcsr0 = XTmrCtr_GetControlStatusReg(XPAR_XPS_TIMER_0_BASEADDR, 0);

	/* If the interrupt occurred, then increment a counter and set one_second_flag */
	if (tcsr0 & XTC_CSR_INT_OCCURED_MASK) {
		/* Clear the timer interrupt */
		XTmrCtr_SetControlStatusReg(XPAR_XPS_TIMER_0_BASEADDR, 0, tcsr0);

		mv_one_sec_flag = 1;

		if (mv_ac97_init_watchdog > -1) {
			if (++mv_ac97_init_watchdog == 1) {
				lcd_clear();
				lcd_print_2strings("AC97 WATCHDOG", LCD_BLANKLINE);
			}
		}
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




/*
void list_ac97_regs(void) {
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




inline u8 read_PB5(void) {
	return XGpio_DiscreteRead(&m_gpioPBs5, 1) & 0xFF;
}

inline u8 read_DIP8(void) {
	return XGpio_DiscreteRead(&m_gpioDIP8, 1) & 0xFF;
}

void handle_pushbuttons(void) {
	static u8 s_last_pb = 0;
	u8 new_pb;

	// Check if push buttons have been pressed or released
	new_pb = read_PB5();
	if (new_pb == s_last_pb) return;

	s_last_pb = new_pb;
	//xil_printf("New Pushbuttons value: 0x%X\r\n", new_pb);

	// Up/down = volume
	if (new_pb & PB5_N) {		// Up pressed?
		handle_menu(UP_PRESSED);
	}
	else if (new_pb & PB5_S) {	// Down pressed?
		handle_menu(DOWN_PRESSED);
	}

	// Left/right = distortion
	if (new_pb & PB5_E) {		// Right pressed?
		handle_menu(RIGHT_PRESSED);
	}
	else if (new_pb & PB5_W) {	// Left pressed?
		handle_menu(LEFT_PRESSED);
	}
}

void handle_dip_switches(void) {
	static u8 s_last_dip = 0;
	u8 new_dip;
	u32 temp;

	// Check if DSP select switches changed
	new_dip = read_DIP8();
	if (new_dip == s_last_dip) return;

	s_last_dip = new_dip;

	//xil_printf("New DIP switch value: 0x%X\r\n", new_dip);
	XIo_Out32(XPAR_AUDIOFX_0_BASEADDR + AUDIOFX_DSPENA_REG_OFFSET, new_dip);

	temp = XIo_In32(XPAR_AUDIOFX_0_BASEADDR + AUDIOFX_DSPENA_REG_OFFSET);
	xil_printf("Enabled DSPs: 0x%X\r\n", temp);

	handle_menu(SHOW);
}

void probe_audiofx_stats(void) {
	static u32 s_prev_fsl_sample_count = 0;
	u32 temp;

	temp = XIo_In32(XPAR_AUDIOFX_0_BASEADDR + AUDIOFX_REG_0Ch_OFFSET);
	xil_printf("\r\ndiff = %d\r\n", temp - s_prev_fsl_sample_count);
	s_prev_fsl_sample_count = temp;

	temp = XIo_In32(XPAR_AUDIOFX_0_BASEADDR + AUDIOFX_REG_10h_OFFSET);
	xil_printf("Left avg  = %d\r\n");

	temp = XIo_In32(XPAR_AUDIOFX_0_BASEADDR + AUDIOFX_REG_14h_OFFSET);
	xil_printf("Right avg = %d\r\n");
}




/******************************************************************************/

int main(void)
{
	print("\r\n\r\nMicroblaze started. Built on " __DATE__ " at " __TIME__ "\r\n");

	lcd_init();
	lcd_on();

	lcd_clear();
	lcd_print_string("Init");


	///////////////////
	// Initialization
	init_interrupts();

	do_gpio_init();

	mv_ac97_init_watchdog = 0;
	do_ac97_init();
	mv_ac97_init_watchdog = -1;

	//list_ac97_regs();
	//while (1) {}


	//////////////////////
	// Set parameter DSP values
	set_output_volume(INIT_OUTPUT_VOL);
	set_pre_gain(INIT_PRE_GAIN);
	set_distortion(INIT_DISTORTION);

	handle_menu(SHOW);


	////////////////////////
	// Main loop
	print("Entering main loop...\r\n");
    while (1) {
    	// When the timer ISR sets this flag, perform every-second tasks in the main thread.
    	if (mv_one_sec_flag) {
    		mv_one_sec_flag = 0;

    		//probe_audiofx_stats();
    	}

    	handle_dip_switches();
    	handle_pushbuttons();
    }

    while (1) { }
    return 0;
}
