#ifndef LCD_H_
#define LCD_H_

#define LCD_BLANKLINE	"                "

void lcd_init(void);
void lcd_on(void);
void lcd_off(void);
void lcd_clear(void);

void lcd_move_cursor_home(void);
void lcd_move_cursor_left(void);
void lcd_move_cursor_right(void);
void lcd_set_line(int line); //line1 = 1, line2 = 2

void lcd_print_char(char c);
void lcd_print_string(const char * line);
void lcd_print_2strings(const char* line1, const char* line2);

void lcd_print_num(unsigned int x, unsigned int base);
void lcd_print_int(unsigned int x);

#endif /* LCD_H_ */
