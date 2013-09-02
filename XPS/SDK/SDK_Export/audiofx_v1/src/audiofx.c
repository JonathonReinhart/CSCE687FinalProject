// Configurable options

// Uncomment this to allow the LINE_IN signal to flow directly to LINE_OUT (no DSP).
//#define ANALOG_BYPASS

// End configurable options

#include <stdio.h>
#include <xparameters.h>
#include <mb_interface.h>
#include <xintc.h>
#include <xtmrctr.h>
#include <xac97.h>
#include <xac97_l.h>
#include <audiofx.h>
#include <xgpio.h>
#include "lcd.h"

/*** Macros, project-specific definitions ***/

#define INIT_OUTPUT_VOL		24
#define INIT_PRE_GAIN		1*8
#define INIT_DISTORTION		MIN_DISTORTION

#define ARRAY_LENGTH(ar)	(sizeof(ar)/sizeof(ar[0]))

#define FUNC_ENTER()	xil_printf(" %s()\r\n", __FUNCTION__)

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

static short mv_init_sound_watchdog = -1;

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

		if (mv_init_sound_watchdog > -1) {
			if (++mv_init_sound_watchdog == 1) {
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

#define MIN_OUTPUT_VOLUME	0
#define MAX_OUTPUT_VOLUME	32

// vol:
// 0 = mute
// 32 = max
void set_output_volume(int vol) {
	u16 regval;

	if (vol == 0) {
		regval = XAC97_VOL_MUTE;
	}
	else if (vol <= MAX_OUTPUT_VOLUME) {
		u8 val = 32 - vol;
		regval = ((32-vol) << 8) | val;
	}

	xil_printf("Setting master volume reg (%02Xh) to 0x%04X\r\n", XAC97_STEREO_VOLUME_REG, regval);
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_STEREO_VOLUME_REG, regval);
}



void do_ac97_init(void) {
	FUNC_ENTER();

	print("Calling init_sound\r\n");
	mv_init_sound_watchdog = 0;
	init_sound(48000);
	mv_init_sound_watchdog = -1;

	// Select Line In for Recording
	XAC97_RecordSelect(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_RECORD_LINE_IN);

	// Set the overall Record gain to 0dB.
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_RECORD_GAIN_REG, 0x0000);


	/////////////////////////////
	// Set analog mixer volumes

	// Mute the mic in volume
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_MIC_VOLUME_REG, XAC97_IN_MUTE);

#ifdef ANALOG_BYPASS
	// Listen to the LINE IN via the analog mixer.
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_LINE_IN_VOLUME_REG, XAC97_IN_GAIN_0dB);		// LINE IN = 0dB
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_PCM_OUT_VOLUME_REG, XAC97_IN_MUTE);			// PCM OUT = Mute
#else
	// Listen to the PCM OUT (digital audio playback).
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


/******************************************************************************/
// Menu 2

int get_ena_dsps(void) {
	return XIo_In32(XPAR_AUDIOFX_0_BASEADDR + AUDIOFX_DSPENA_REG_OFFSET);
}

void menu_show_title(const char *title)
{
    lcd_clear();
    lcd_set_line(1);
    lcd_print_string(title);
    lcd_set_line(2);
}

void show_param_val_range2(int val, int min, int max) {
	lcd_move_cursor_right();
	lcd_move_cursor_right();
	lcd_move_cursor_right();
	lcd_print_int(val);

	if (val < 100)
		lcd_move_cursor_right();
	if (val < 10)
		lcd_move_cursor_right();

	lcd_move_cursor_right();
	lcd_move_cursor_right();
	lcd_print_char('(');
	lcd_print_int(min);
	lcd_print_char('-');
	lcd_print_int(max);
	lcd_print_char(')');
}

typedef enum {
	SHOW,
	UP_PRESSED,
	DOWN_PRESSED,
	LEFT_PRESSED,
	RIGHT_PRESSED,
	CENTER_PRESSED,
} MENU_ACTION;

void default_param_action(MENU_ACTION action, int* value, int minval, int maxval, void (*update)(int)) {
	switch (action) {
	case UP_PRESSED:
		if (*value < maxval) {
			++(*value);
			update(*value);
		}
		break;
	case DOWN_PRESSED:
		if (*value > minval) {
			--(*value);
			update(*value);
		}
		break;
	default:
		break;
	}
}

void master_vol_menu(MENU_ACTION action) {
	static int s_master_vol = INIT_OUTPUT_VOL;

	menu_show_title("   MASTER VOL. >");

	default_param_action(action, &s_master_vol, MIN_OUTPUT_VOLUME, MAX_OUTPUT_VOLUME, set_output_volume);

	if (s_master_vol == 0) {
		lcd_print_string("     (Mute)     ");
	}
	else {
		show_param_val_range2(s_master_vol, MIN_OUTPUT_VOLUME, MAX_OUTPUT_VOLUME);
	}
}

void pre_gain_menu(MENU_ACTION action) {
	static int s_pre_gain = INIT_PRE_GAIN;

	menu_show_title("<   PRE-GAIN   >");

	if (get_ena_dsps() & (1<<0)) {
		default_param_action(action, &s_pre_gain, MIN_PRE_GAIN, MAX_PRE_GAIN, set_pre_gain);
		show_param_val_range2(s_pre_gain, MIN_PRE_GAIN, MAX_PRE_GAIN);
	}
	else {
		lcd_print_string("   (Disabled)   ");
	}
}


void distortion_menu(MENU_ACTION action) {
	static int s_distortion = INIT_DISTORTION;

	menu_show_title("<  DISTORTION   ");

	if (get_ena_dsps() & (1<<1)) {
		default_param_action(action, &s_distortion, MIN_DISTORTION, MAX_DISTORTION, set_distortion);
		show_param_val_range2(s_distortion, MIN_DISTORTION, MAX_DISTORTION);
	}
	else {
		lcd_print_string("   (Disabled)   ");
	}
}

void home_menu(MENU_ACTION action) {
	menu_show_title( "--  Audio FX  --");
	lcd_print_string("         Menu ->");
}


typedef void (*menu_func_t)(MENU_ACTION action);

typedef struct {
	menu_func_t		func;
} menu2_t;

static menu2_t m_menu[] =
{
	{home_menu},
	{master_vol_menu},
	{pre_gain_menu},
	{distortion_menu},
};
#define MIN_MENU2_IDX	0
#define MAX_MENU2_IDX	ARRAY_LENGTH(m_menu)-1

static int m_menu2_idx = MIN_MENU2_IDX;

void handle_menu(MENU_ACTION action) {
	switch (action) {
	case LEFT_PRESSED:
		if (m_menu2_idx > MIN_MENU2_IDX)
			--m_menu2_idx;
		break;
	case RIGHT_PRESSED:
		if (m_menu2_idx < MAX_MENU2_IDX)
			++m_menu2_idx;
		break;
	default:
		break;
	}

	m_menu[m_menu2_idx].func(action);
}

/******************************************************************************/



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

	do_ac97_init();
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
