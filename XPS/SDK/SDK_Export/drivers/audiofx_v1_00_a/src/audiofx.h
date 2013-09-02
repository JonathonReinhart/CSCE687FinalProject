#ifndef AUDIOFX_H
#define AUDIOFX_H

/***************************** Include Files ********************************/

#include "xbasic_types.h"
#include "xstatus.h"
#include "audiofx_l.h"

/************************** Constant Definitions ****************************/





/*******************************************************************************/

// Pre-gain
#define MIN_PRE_GAIN    0
#define MAX_PRE_GAIN    80      // 80/8 = 10
void set_pre_gain(int gain);

// Distortion
#define MIN_DISTORTION  0
#define MAX_DISTORTION  14
void set_distortion(int dist);

#endif /* AUDIOFX_H */
