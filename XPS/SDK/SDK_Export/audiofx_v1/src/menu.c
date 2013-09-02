#include <xparameters.h>
#include <xio.h>
#include <audiofx.h>
#include "ac97.h"
#include "lcd.h"
#include "menu.h"
#include "config.h"

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

	if (get_ena_dsps() & (1<<0)) {	// DSP_0
		default_param_action(action, &s_pre_gain, MIN_PRE_GAIN, MAX_PRE_GAIN, set_pre_gain);
		show_param_val_range2(s_pre_gain, MIN_PRE_GAIN, MAX_PRE_GAIN);
	}
	else {
		lcd_print_string("   (Disabled)   ");
	}
}


void distortion_menu(MENU_ACTION action) {
	static int s_distortion = INIT_DISTORTION;

	menu_show_title("<  DISTORTION  >");

	if (get_ena_dsps() & (1<<1)) {	// DSP_1
		default_param_action(action, &s_distortion, MIN_DISTORTION, MAX_DISTORTION, set_distortion);
		show_param_val_range2(s_distortion, MIN_DISTORTION, MAX_DISTORTION);
	}
	else {
		lcd_print_string("   (Disabled)   ");
	}
}


void flanger_rate_menu(MENU_ACTION action) {
	static int s_flange_rate = INIT_FLANGER_PERIOD;

	menu_show_title("< FLANGER PER.  ");

	if (get_ena_dsps() & (1<<3)) {	// DSP_3
		default_param_action(action, &s_flange_rate, MIN_FLANGER_PERIOD, MAX_FLANGER_PERIOD, set_flanger_period);
		show_param_val_range2(s_flange_rate, MIN_FLANGER_PERIOD, MAX_FLANGER_PERIOD);
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
	{flanger_rate_menu},
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
