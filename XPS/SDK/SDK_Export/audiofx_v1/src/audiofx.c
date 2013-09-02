#include <stdio.h>
#include <xparameters.h>
#include <mb_interface.h>
#include <xintc.h>
#include <xac97.h>
#include <xac97_l.h>
#include <audiofx.h>
#include <xgpio.h>

#include "ac97.h"
#include "lcd.h"
#include "inputs.h"
#include "timer.h"
#include "menu.h"
#include "config.h"


void init_interrupts(void) {
	FUNC_ENTER();

	// Start the interrupt controller
	XIntc_MasterEnable(XPAR_XPS_INTC_0_BASEADDR);

	microblaze_enable_interrupts();
}


void probe_audiofx_stats(void) {
	static u32 s_prev_fsl_sample_count = 0;
	u32 temp;

	temp = XIo_In32(XPAR_AUDIOFX_0_BASEADDR + AUDIOFX_REG_0Ch_OFFSET);
	xil_printf("\r\nSampling rate = %d samp/sec\r\n", temp - s_prev_fsl_sample_count);
	s_prev_fsl_sample_count = temp;

	temp = XIo_In32(XPAR_AUDIOFX_0_BASEADDR + AUDIOFX_REG_10h_OFFSET);
	xil_printf("Left avg  = %d\r\n");

	temp = XIo_In32(XPAR_AUDIOFX_0_BASEADDR + AUDIOFX_REG_14h_OFFSET);
	xil_printf("Right avg = %d\r\n");
}

/******************************************************************************/
void watchdog_handler() {
	xil_printf("\r\n\r\n!!!!!  WATCHDOG  !!!!!\r\n\r\n\r\n\r\n");
	lcd_clear();
	lcd_print_2strings("    WATCHDOG!", LCD_BLANKLINE);

	// TODO: Perform a hardware-reset of the system.
}

int main(void)
{
	print("\r\n\r\nMicroblaze started. Built on " __DATE__ " at " __TIME__ "\r\n");

	///////////////////
	// Initialization
	init_interrupts();
	init_timer(1000);

	watchdog_enable(watchdog_handler);

	lcd_init();
	lcd_on();
	lcd_clear();
	lcd_print_string("Init");

	do_gpio_init();
	do_ac97_init();

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
    	watchdog_kick();

    	// When the timer ISR sets this flag, perform every-second tasks in the main thread.
    	if (gv_one_sec_flag) {
    		gv_one_sec_flag = 0;

    		//probe_audiofx_stats();
    	}

    	handle_dip_switches();
    	handle_pushbuttons();
    }

    while (1) { }
    return 0;
}
