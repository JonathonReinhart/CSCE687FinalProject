#include <xparameters.h>
#include <xio.h>
#include <audiofx.h>
#include "ac97.h"
#include "lcd.h"
#include "menu.h"
#include "config.h"

/*********************************************************************************************************/
// DSP Enable functions

// Get a bitmask of the currently-enabled DSPs.
static int get_ena_dsps(void) {
	return XIo_In32(XPAR_AUDIOFX_0_BASEADDR + AUDIOFX_DSPENA_REG_OFFSET);
}

// Enable all of the DSPs set in dsp_mask
static void enable_dsps(int dsp_mask) {
	dsp_mask |= get_ena_dsps();
	XIo_Out32(XPAR_AUDIOFX_0_BASEADDR + AUDIOFX_DSPENA_REG_OFFSET, dsp_mask);
}

// Disable all of the DSPs set in dsp_mask
static void disable_dsps(int dsp_mask) {
	dsp_mask = get_ena_dsps() & (~dsp_mask);
	XIo_Out32(XPAR_AUDIOFX_0_BASEADDR + AUDIOFX_DSPENA_REG_OFFSET, dsp_mask);
}

/*********************************************************************************************************/
// Utility functions used by menus

static void menu_show_title(const char *title)
{
    lcd_clear();
    lcd_set_line(1);
    lcd_print_string(title);
    lcd_set_line(2);
}

static void show_param_val_range2(int val, int min, int max) {
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


static void default_param_action(MENU_ACTION action, int* value, int minval, int maxval, void (*update)(int)) {
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

/*********************************************************************************************************/
// Menus

static void home_menu(MENU_ACTION action) {
	menu_show_title( "--  Audio FX  --");
	lcd_print_string("         Menu ->");
}

static void master_vol_menu(MENU_ACTION action) {
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

static void handle_enadis_action(MENU_ACTION action, int dsp_mask) {
	if (action == CENTER_PRESSED) {
		if (get_ena_dsps() & dsp_mask)
			disable_dsps(dsp_mask);
		else
			enable_dsps(dsp_mask);
	}
}

static void pre_gain_menu(MENU_ACTION action) {
	static int s_pre_gain = INIT_PRE_GAIN;

	menu_show_title("<   PRE-GAIN   >");

	handle_enadis_action(action, DSP0_PREGAIN);

	if (get_ena_dsps() & DSP0_PREGAIN) {
		default_param_action(action, &s_pre_gain, MIN_PRE_GAIN, MAX_PRE_GAIN, set_pre_gain);
		show_param_val_range2(s_pre_gain, MIN_PRE_GAIN, MAX_PRE_GAIN);
	}
	else {
		lcd_print_string("   (Disabled)   ");
	}
}


static void distortion_menu(MENU_ACTION action) {
	static int s_distortion = INIT_DISTORTION;

	menu_show_title("<  DISTORTION  >");

	handle_enadis_action(action, DSP1_DISTORTION);

	if (get_ena_dsps() & DSP1_DISTORTION) {
		default_param_action(action, &s_distortion, MIN_DISTORTION, MAX_DISTORTION, set_distortion);
		show_param_val_range2(s_distortion, MIN_DISTORTION, MAX_DISTORTION);
	}
	else {
		lcd_print_string("   (Disabled)   ");
	}
}


static void flanger_rate_menu(MENU_ACTION action) {
	static int s_flange_rate = INIT_FLANGER_PERIOD;

	menu_show_title("< FLANGER PER.  ");

	handle_enadis_action(action, DSP3_FLANGER);

	if (get_ena_dsps() & DSP3_FLANGER) {
		default_param_action(action, &s_flange_rate, MIN_FLANGER_PERIOD, MAX_FLANGER_PERIOD, set_flanger_period);
		show_param_val_range2(s_flange_rate, MIN_FLANGER_PERIOD, MAX_FLANGER_PERIOD);
	}
	else {
		lcd_print_string("   (Disabled)   ");
	}
}

/*********************************************************************************************************/

// Defines a "menu function" that each menu will have
typedef void (*menu_func_t)(MENU_ACTION action);

// Information about each menu
typedef struct {
	menu_func_t		func;
} menu_t;

// The list of menus, in order
static menu_t m_menu[] =
{
	{home_menu},
	{master_vol_menu},
	{pre_gain_menu},
	{distortion_menu},
	{flanger_rate_menu},
};
#define MIN_MENU2_IDX	0
#define MAX_MENU2_IDX	ARRAY_LENGTH(m_menu)-1

// The currently selected menu index.
static int m_cur_menu_idx = MIN_MENU2_IDX;

// Public function, indicate to the menu system that some action has happened.
void handle_menu(MENU_ACTION action) {

	// Left/right button presses are handled here, and change
	// the currently selected menu.
	switch (action) {
	case LEFT_PRESSED:
		if (m_cur_menu_idx > MIN_MENU2_IDX) {
			--m_cur_menu_idx;
			action = SHOW;
		}
		else {
			action = NONE;
		}
		break;
	case RIGHT_PRESSED:
		if (m_cur_menu_idx < MAX_MENU2_IDX) {
			++m_cur_menu_idx;
			action = SHOW;
		}
		else {
			action = NONE;
		}
		break;
	default:
		break;
	}

	if (action != NONE)
		m_menu[m_cur_menu_idx].func(action);
}
