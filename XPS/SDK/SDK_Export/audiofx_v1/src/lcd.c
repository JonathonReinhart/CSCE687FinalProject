#include <stdio.h>
#include "xgpio_l.h"
#include "xparameters.h"



#define LCD_BASEADDR XPAR_LCD_IP_0_BASEADDR
#define INIT_DELAY 1000 //usec delay timer during initialization, important to change if clock speed changes
#define INST_DELAY 500 //usec delay timer between instructions
#define DATA_DELAY 250 //usec delay timer between data

#define LCD_NUM_COLS	16

static char m_lcd_initialized = 0;

//==============================================================================
//
//								INTERNAL FUNCTIONS
//
//==============================================================================


static void lcd_udelay(unsigned int delay) {
	unsigned int j, i;

	for(i=0; i<delay; i++)
	   for(j=0; j<26; j++);
}

static void XromInitInst(void)
{
		XGpio_WriteReg(LCD_BASEADDR, 1, 0x00000003);
		lcd_udelay(1);
		XGpio_WriteReg(LCD_BASEADDR, 1, 0x00000043); //set enable and data
		lcd_udelay(1);
		XGpio_WriteReg(LCD_BASEADDR, 1, 0x00000003);
		lcd_udelay(INIT_DELAY);
}

static void XromWriteInst(unsigned long inst1, unsigned long inst2)
{

	unsigned long printinst;

	printinst = 0x00000040 | inst1;

	XGpio_WriteReg(LCD_BASEADDR, 1, inst1); //write data
	lcd_udelay(1);
	XGpio_WriteReg(LCD_BASEADDR, 1, printinst); //set enable
	lcd_udelay(1);
	XGpio_WriteReg(LCD_BASEADDR, 1, inst1); //turn off enable
	lcd_udelay(1);

	printinst = 0x00000040 | inst2;

	XGpio_WriteReg(LCD_BASEADDR, 1, printinst); //set enable and data
	lcd_udelay(1);
	XGpio_WriteReg(LCD_BASEADDR, 1, inst2); //turn off enable

	lcd_udelay(INST_DELAY);

}

static void XromWriteData(unsigned long data1, unsigned long data2)
{

	unsigned long rs_data, enable_rs_data;
	//bool busy=true;

	rs_data = (0x00000020 | data1); //sets rs, data1
	enable_rs_data = (0x00000060 | data1);

	XGpio_WriteReg(LCD_BASEADDR, 1, rs_data); //write data, rs
	lcd_udelay(1);
	XGpio_WriteReg(LCD_BASEADDR, 1, enable_rs_data); //set enable, keep data, rs
	lcd_udelay(1);
	XGpio_WriteReg(LCD_BASEADDR, 1, rs_data); //turn off enable
	lcd_udelay(1);

	rs_data = (0x00000020 | data2); //sets rs, data2
	enable_rs_data = (0x00000060 | data2); //sets rs, data2

	XGpio_WriteReg(LCD_BASEADDR, 1, enable_rs_data); //set enable, rs, data
	lcd_udelay(1);
	XGpio_WriteReg(LCD_BASEADDR, 1, rs_data); //turn off enable

	lcd_udelay(DATA_DELAY);
}





//==================================================================================
//
//								EXTERNAL FUNCTIONS
//
//==================================================================================

void lcd_move_cursor_home(){
	XromWriteInst(0x00000000, 0x00000002);
}

void lcd_move_cursor_left(){
	XromWriteInst(0x00000001, 0x00000000);
}

void lcd_move_cursor_right(){
	XromWriteInst(0x00000001, 0x00000004);
}

void lcd_on(void) {
	//XromWriteInst(0x00000000, 0x0000000E);
	XromWriteInst(0x00000000, 0x0000000C);
}

void lcd_off(void) {
	XromWriteInst(0x00000000, 0x00000008);
}

void lcd_clear(void) {
	XromWriteInst(0x00000000, 0x00000001);
	XromWriteInst(0x00000000, 0x00000010);
	lcd_move_cursor_home();
}

void lcd_init(void) {
	//XGpio_SetDataDirection(LCD_BASEADDR, 1, 0x00000000); //Sets CHAR LCD Reg to Write Mode
	XGpio_WriteReg(LCD_BASEADDR, 1, 0x00000000); //Zeroes CHAR LCD Reg

	//LCD INIT
	lcd_udelay(15000);	//After VCC>4.5V Wait 15ms to Init Char LCD
	XromInitInst();

	// Why keep calling this? Maybe it's just my delay in FPGA programming, but this seems
	// unnecessary. Someone didn't know what they were doing.
	lcd_udelay(4100); //Wait 4.1ms
	XromInitInst();

	lcd_udelay(100); //Wait 100us
	XromInitInst();
	XromInitInst();

	//Function Set
	XromWriteInst(0x00000002, 0x00000008);

	//Entry Mode Set
	XromWriteInst(0x00000000, 0x00000006);

	//Display Off
	XromWriteInst(0x00000000, 0x00000008);

	//Display On
	//XromWriteInst(0x00000000, 0x0000000F);
	XromWriteInst(0x00000000, 0x0000000C);

	//Display Clear
	//XromWriteInst(0x00000000, 0x00000001);
	lcd_clear();

	m_lcd_initialized = 1;
}

char lcd_is_initialized(void) {
	return m_lcd_initialized;
}

void lcd_set_line(int line){ //line1 = 1, line2 = 2

	int i;

	if((line - 1)) {
		lcd_move_cursor_home();
		for(i=0; i<40; i++)
			lcd_move_cursor_right();
	}
	else
		lcd_move_cursor_home();

}

void lcd_print_char(char c){
	XromWriteData(((c >> 4) & 0x0000000F), (c & 0x0000000F));
}


void lcd_print_string(const char* str) {
	int i = 0;

	for (i=0; i<LCD_NUM_COLS && str[i]; ++i) {
		lcd_print_char(str[i]);
	}
}

void lcd_print_2strings(const char* line1, const char* line2) {
	lcd_set_line(1);
	lcd_print_string(line1);

	lcd_set_line(2);
	lcd_print_string(line2);
}


void lcd_print_num(unsigned int x, unsigned int base)
{
  static char hex[]="0123456789ABCDEF";
  char digit[10];
  int i;

  i = 0;
  do
  {
    digit[i] = hex[x % base];
    x = x / base;
    i++;
  } while (x != 0);

  while (i > 0)
  {
  	i--;
    lcd_print_char(digit[i]);
  }
}


void lcd_print_int(unsigned int x)
{
  unsigned int val;

  if (x < 0)
  {
    lcd_print_char('-');
    val = ((unsigned int) ~x ) + 1;
  }
  else
    val = (unsigned int) x;

  lcd_print_num(val, 10);
}



