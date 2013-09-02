#ifndef TIMER_H_
#define TIMER_H_

void init_timer(void);
void watchdog_kick(void);
void watchdog_enable(void (*func)(void));

extern volatile char gv_tick_flag;
extern volatile char gv_one_sec_flag;

#endif /* TIMER_H_ */
