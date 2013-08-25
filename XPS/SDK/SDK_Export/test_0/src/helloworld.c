/*
 * Copyright (c) 2009 Xilinx, Inc.  All rights reserved.
 *
 * Xilinx, Inc.
 * XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS" AS A
 * COURTESY TO YOU.  BY PROVIDING THIS DESIGN, CODE, OR INFORMATION AS
 * ONE POSSIBLE   IMPLEMENTATION OF THIS FEATURE, APPLICATION OR
 * STANDARD, XILINX IS MAKING NO REPRESENTATION THAT THIS IMPLEMENTATION
 * IS FREE FROM ANY CLAIMS OF INFRINGEMENT, AND YOU ARE RESPONSIBLE
 * FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE FOR YOUR IMPLEMENTATION.
 * XILINX EXPRESSLY DISCLAIMS ANY WARRANTY WHATSOEVER WITH RESPECT TO
 * THE ADEQUACY OF THE IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO
 * ANY WARRANTIES OR REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE
 * FROM CLAIMS OF INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY
 * AND FITNESS FOR A PARTICULAR PURPOSE.
 *
 */

/*
 * helloworld.c: simple test application
 */

#include <stdio.h>
#include "xparameters.h"
#include "xac97.h"
#include "xac97_l.h"
#include "mb_interface.h"


#define ABS(x)	((x<0) ? -(x) : x)


int main()
{
	//int i = 0;
	Xint16 soundbyte;

	//Xint16 rollavg = 0;

    print("Calling init_sound\r\n");
    init_sound(48000);

    // Select only Line In for Record Select
    WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_RECORD_SELECT_REG, 0x0404);

    // Mute the mic in volume
    WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_MIC_VOLUME_REG, XAC97_VOL_MUTE);

    // Set the Line In gain to 0dB.
    WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_LINE_IN_VOLUME_REG, XAC97_VOL_0dB);



    print("Calling playback_enable\r\n");
    playback_enable();

    print("Calling record_enable\r\n");
    record_enable();

    while (1) {
    	microblaze_bread_datafsl(soundbyte, 0);
    	microblaze_bwrite_datafsl(soundbyte, 0);

    	//rollavg = (((rollavg<<5) - rollavg) + soundbyte) >> 5;	// 32

    	//if (++i & 0x2000)
    	//	xil_printf("rollavg = %d\r\n", rollavg);
    }

    return 0;
}
