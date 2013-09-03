#include <stdio.h>
#include <xparameters.h>
#include <xgpio.h>
#include <audiofx.h>
#include "inputs.h"
#include "menu.h"
#include "config.h"


#define PB5_N	0x01	// North
#define PB5_E	0x02	// East
#define PB5_S	0x04	// South
#define PB5_W	0x08	// West
#define PB5_C	0x10	// Center

static XGpio m_gpioDIP8;
static XGpio m_gpioLEDs8;
static XGpio m_gpioPBs5;

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

	// Up/down
	if (new_pb & PB5_N) {		// Up pressed?
		handle_menu(UP_PRESSED);
	}
	else if (new_pb & PB5_S) {	// Down pressed?
		handle_menu(DOWN_PRESSED);
	}

	// Left/right
	if (new_pb & PB5_E) {		// Right pressed?
		handle_menu(RIGHT_PRESSED);
	}
	else if (new_pb & PB5_W) {	// Left pressed?
		handle_menu(LEFT_PRESSED);
	}

	// Center
	if (new_pb & PB5_C) {		// Center pressed?
		handle_menu(CENTER_PRESSED);
	}

}

void handle_dip_switches(void) {
	static u8 s_last_dip = 0;
	u8 new_dip;

	// Check if DSP select switches changed
	new_dip = read_DIP8();
	if (new_dip == s_last_dip) return;

	s_last_dip = new_dip;

	// Do nothing....
}

