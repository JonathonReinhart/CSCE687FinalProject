#ifndef AUDIOFX_H
#define AUDIOFX_H

/***************************** Include Files ********************************/

#include "xbasic_types.h"
#include "xstatus.h"
#include "audiofx_l.h"

/************************** Constant Definitions ****************************/





/*******************************************************************************/

// Pre-gain
void set_pre_gain(unsigned int gain);

// Distortion
int MIN_DISTORTION(void);
int MAX_DISTORTION(void);
void set_distortion(int dist);

#endif /* AUDIOFX_H */
