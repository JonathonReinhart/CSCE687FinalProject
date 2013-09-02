#include "mb_interface.h"
#include "xstatus.h"
#include "audiofx.h"
#include "xparameters.h"

/**************************************************************************************************/
// DSP_0    Pre-gain

// gain 	A number in 1/8ths. For example:
// gain		multiplier
//	0		0.0  	(-inf dB)
//  4		0.5  	(-6 dB)
//  8       1.0  	(0 dB)
//  12		1.5  	(3.5 dB)
//  16		2.0		(6 dB)
void set_pre_gain(unsigned int gain) {
	u32 regval;
	// The 32-bit gain register is fixed-point, with 16 integer, 16 fractional bits.
	//XIo_Out32(XPAR_AUDIOFX_0_BASEADDR + 0x20, 0x00010000);	// 1.0

	regval = gain << (16-3);

	xil_printf("Gain = %d   -> PREGAIN (20h) = 0x%08X\r\n", gain, regval);

	XIo_Out32(XPAR_AUDIOFX_0_BASEADDR + 0x20, regval);
}

/**************************************************************************************************/
// DSP_1    Distortion

typedef struct {
	int	thresh;
	int gain;
} distval_t;

// NOTE: If any values are added/removed from this table,
//       you must update MAX_DISTORTION in audiofx.h !
static distval_t m_dist_table[] = {
	{ 0x7FFF,	0x00010000 },
	{ 8000,	0x00018000 },
	{ 6000, 0x00020000 },
	{ 4000, 0x00028000 },
	{ 2600, 0x00038000 },
	{ 1800, 0x00048000 },
	{ 1000, 0x00050000 },
	{ 800, 	0x00070000 },
	{ 600, 	0x00090000 },
	{ 300,  0x000E0000 },
	{ 160,  0x00180000 },
	{ 100, 	0x00200000 },
	{ 60, 	0x00380000 },
	{ 40, 	0x00480000 },
	{ 24, 	0x00600000 },
};

#define MIN_DIST_VAL	0
#define MAX_DIST_VAL	((sizeof(m_dist_table)/sizeof(m_dist_table[0]))-1)

void set_distortion(int dist) {
	int thresh;
	int gain;

	if (dist < MIN_DIST_VAL)	dist = MIN_DIST_VAL;
	if (dist > MAX_DIST_VAL)	dist = MAX_DIST_VAL;

	thresh 	= m_dist_table[dist].thresh;
	gain 	= m_dist_table[dist].gain;

	xil_printf("Dist = %d   -> DTHRESH (24h) = %d,  DGAIN (28h) = 0x%08X\r\n", dist, thresh, gain);

	XIo_Out32(XPAR_AUDIOFX_0_BASEADDR + 0x24, thresh);	// Distortion threshold
	XIo_Out32(XPAR_AUDIOFX_0_BASEADDR + 0x28, gain);	// Distortion gain (fixed 32-16)
}



/**************************************************************************************************/
