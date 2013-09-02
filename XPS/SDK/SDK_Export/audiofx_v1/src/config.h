#ifndef CONFIG_H_
#define CONFIG_H_

// Configurable options

// Uncomment this to allow the LINE_IN signal to flow directly to LINE_OUT (no DSP).
//#define ANALOG_BYPASS

// Show AC'97 registers at startup
//#define SHOW_AC97_REGS

// Periodically probe AudioFX core stats
//#define PROBE_AUDIOFX_STATS


#define INIT_OUTPUT_VOL			24
#define INIT_PRE_GAIN			1*8
#define INIT_DISTORTION			MIN_DISTORTION
#define INIT_FLANGER_PERIOD		20				// 2.0 sec

#define TIMER_TICK_HZ		2


// Move this stuff to another header file

#define FUNC_ENTER()		xil_printf(" %s()\r\n", __FUNCTION__)
#define ARRAY_LENGTH(ar)	(sizeof(ar)/sizeof(ar[0]))

#endif /* CONFIG_H_ */
