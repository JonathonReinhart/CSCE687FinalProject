#ifndef MENU_H_
#define MENU_H_


typedef enum {
	NONE,
	SHOW,
	UP_PRESSED,
	DOWN_PRESSED,
	LEFT_PRESSED,
	RIGHT_PRESSED,
	CENTER_PRESSED,
} MENU_ACTION;

void handle_menu(MENU_ACTION action);

#endif /* MENU_H_ */
