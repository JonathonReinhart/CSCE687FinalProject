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

void init_interrupts(void);
void probe_audiofx_stats(void);
void watchdog_handler();

int main(void)
{
	print("\r\n\r\nMicroblaze started. Built on " __DATE__ " at " __TIME__ "\r\n");

	///////////////////
	// Initialization
	init_interrupts();
	init_timer();

	watchdog_enable(watchdog_handler);

	lcd_init();
	lcd_print_string("LCD Initialized");


	do_gpio_init();
	do_ac97_init();

	//////////////////////
	// Set parameter DSP values
	set_output_volume(INIT_OUTPUT_VOL);
	set_pre_gain(INIT_PRE_GAIN);
	set_distortion(INIT_DISTORTION);
	set_flanger_period(INIT_FLANGER_PERIOD);


	handle_menu(SHOW);


	////////////////////////
	// Main loop
	print("Entering main loop...\r\n");
    while (1) {
    	watchdog_kick();

    	// When the timer ISR sets this flag, perform every-second tasks in the main thread.
    	if (gv_one_sec_flag) {
    		gv_one_sec_flag = 0;

    		//xil_printf("One second.\r\n");
    	}

    	if (gv_tick_flag) {
    		gv_tick_flag = 0;

#ifdef PROBE_AUDIOFX_STATS
    		probe_audiofx_stats();
#endif
    	}



    	handle_dip_switches();
    	handle_pushbuttons();
    }

    while (1) { }
    return 0;
}


void init_interrupts(void) {
	FUNC_ENTER();

	// Start the interrupt controller
	XIntc_MasterEnable(XPAR_XPS_INTC_0_BASEADDR);

	microblaze_enable_interrupts();
}

#ifdef PROBE_AUDIOFX_STATS
void probe_audiofx_stats(void) {
	static u32 s_prev_fsl_sample_count = 0;
	u32 temp;

	temp = XIo_In32(XPAR_AUDIOFX_0_BASEADDR + AUDIOFX_REG_0Ch_OFFSET);
	if (s_prev_fsl_sample_count != 0) {
		u32 diff = (temp - s_prev_fsl_sample_count);
		xil_printf("\r\nSampling rate = %d samp/sec\r\n", (diff * TIMER_TICK_HZ));
	}
	s_prev_fsl_sample_count = temp;

	temp = XIo_In32(XPAR_AUDIOFX_0_BASEADDR + AUDIOFX_REG_10h_OFFSET);
	xil_printf("Left avg  = %d\r\n");

	temp = XIo_In32(XPAR_AUDIOFX_0_BASEADDR + AUDIOFX_REG_14h_OFFSET);
	xil_printf("Right avg = %d\r\n");
}
#endif

void watchdog_handler() {
	xil_printf("\r\n\r\n!!!!!  WATCHDOG  !!!!!\r\n\r\n\r\n\r\n");

	if (lcd_is_initialized()) {
		lcd_clear();
		lcd_print_2strings("    WATCHDOG!", LCD_BLANKLINE);
	}

	// TODO: Perform a hardware-reset of the system.
}



