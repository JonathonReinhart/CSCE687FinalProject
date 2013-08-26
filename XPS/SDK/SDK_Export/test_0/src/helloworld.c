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

#define AC97_FSL_ID		0

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

    // Set the Master volume to 0dB.
    WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_STEREO_VOLUME_REG, XAC97_VOL_0dB);



    print("Calling playback_enable\r\n");
    playback_enable();

    print("Calling record_enable\r\n");
    record_enable();

    print("CPU effectively stopped.");
    while (1) { }


    while (1) {
#define BUFSIZE	32

    	int i;
    	Xint16 buf[BUFSIZE];

    	for (i=0; i<BUFSIZE; ++i) {
    		Xint16 x;
    		getfsl(x, AC97_FSL_ID);
    		buf[i] = x;
    	}

    	for (i=0; i<BUFSIZE; ++i) {
    		Xint16 x = buf[i];
    		putfsl(x, AC97_FSL_ID);
    	}

    	/*
    	Xint16	s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15;

    	getfsl(s0, AC97_FSL_ID);
    	getfsl(s1, AC97_FSL_ID);
    	getfsl(s2, AC97_FSL_ID);
    	getfsl(s3, AC97_FSL_ID);
    	getfsl(s4, AC97_FSL_ID);
    	getfsl(s5, AC97_FSL_ID);
    	getfsl(s6, AC97_FSL_ID);
    	getfsl(s7, AC97_FSL_ID);
    	getfsl(s8, AC97_FSL_ID);
    	getfsl(s9, AC97_FSL_ID);
    	getfsl(s10, AC97_FSL_ID);
    	getfsl(s11, AC97_FSL_ID);
    	getfsl(s12, AC97_FSL_ID);
    	getfsl(s13, AC97_FSL_ID);
    	getfsl(s14, AC97_FSL_ID);
    	getfsl(s15, AC97_FSL_ID);

    	putfsl(s0, AC97_FSL_ID);
    	putfsl(s1, AC97_FSL_ID);
    	putfsl(s2, AC97_FSL_ID);
    	putfsl(s3, AC97_FSL_ID);
    	putfsl(s4, AC97_FSL_ID);
    	putfsl(s5, AC97_FSL_ID);
    	putfsl(s6, AC97_FSL_ID);
    	putfsl(s7, AC97_FSL_ID);
    	putfsl(s8, AC97_FSL_ID);
    	putfsl(s9, AC97_FSL_ID);
    	putfsl(s10, AC97_FSL_ID);
    	putfsl(s11, AC97_FSL_ID);
    	putfsl(s12, AC97_FSL_ID);
    	putfsl(s13, AC97_FSL_ID);
    	putfsl(s14, AC97_FSL_ID);
    	putfsl(s15, AC97_FSL_ID);
		*/



    	//microblaze_bread_datafsl(soundbyte, 0);
    	//microblaze_bwrite_datafsl(soundbyte, 0);

    	//rollavg = (((rollavg<<5) - rollavg) + soundbyte) >> 5;	// 32

    	//if (++i & 0x2000)
    	//	xil_printf("rollavg = %d\r\n", rollavg);
    }

    return 0;
}
