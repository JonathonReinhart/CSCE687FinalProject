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
void set_pre_gain(int gain) {
	u32 regval;
	
    if (gain < 0) return;
	if (gain > MAX_PRE_GAIN) return;

    // The input value is in 1/8s.
    // The 32-bit gain register is fixed-point, with 16 integer, 16 fractional bits.
	regval = gain << (16-3);

	xil_printf("Gain = %d   -> PREGAIN (20h) = 0x%08X\r\n", gain, regval);

	XIo_Out32(XPAR_AUDIOFX_0_BASEADDR + AUDIOFX_REG_20h_OFFSET, regval);
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
// DSP_3    Flanger

/*
    A sawtooth generator selects for far back in the past to grab a sample.
    The sawtooth delays for saw_delay clocks before advancing to the next value.
    
            _           _
          _- -_       _- -_           |
        _-     -_   _-     -_         | depth
      _-         -_-         -_       |
    >| |<         |<--------->|
    saw_delay     flanger_period

    * saw_delay is the number of samples the sawtooth waits before incrementing
      to the next value (shown here as the width of each dash)
    
    * depth is the maximum value of the sawtooth generator, which determines
      how-far-back a sample from the delay buffer is added to the outuput.
      It is currently hard-coded to 480 (10ms).
    
    * flanger_period then, is calculated as:
       2 * saw_delay * depth  (samples)

    Or

          2 * saw_delay * depth
        ------------------------  = Tflange (seconds)
             48000


    Solving for saw_delay:

          Tflange * 48000
        ------------------------  = saw_delay (samp)
           2 * depth
           
           
    Our minimum saw_delay is 1, which yields a Tflange-min of
       (2 * 1 * 480) / 48000 = 0.02
    which is unreasonably fast, so we set the Tflange-min to 1 (0.1 sec)
    
    Our maximum saw_delay is shy of 1024 samples:
       (2 * 1024 * 480) / 48000 = 20.48
    So we will go with an unlikely high value of of 200 (20.0 sec)
       
*/

#define SAMP_RATE       48000
#define FLANGER_DEPTH	480		// samples

void set_saw_delay(int saw_delay) {
	XIo_Out32(XPAR_AUDIOFX_0_BASEADDR + AUDIOFX_FLSAWDLY_REG_OFFSET, saw_delay);
}

void set_flanger_period(int period_tenths) {

	int saw_delay = (period_tenths * SAMP_RATE / 10) / (2 * FLANGER_DEPTH);

	xil_printf("set_flanger_period() period_tenths=%d  saw_delay=%d\r\n", period_tenths, saw_delay);

	set_saw_delay(saw_delay);
}

