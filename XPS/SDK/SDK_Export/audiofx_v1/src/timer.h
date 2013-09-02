#ifndef TIMER_H_
#define TIMER_H_

void init_timer(int period);
void watchdog_kick(void);
void watchdog_enable(void (*func)(void));

extern volatile int gv_one_sec_flag;

#endif /* TIMER_H_ */
