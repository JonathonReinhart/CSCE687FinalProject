#include <stdio.h>
#include <xparameters.h>
#include <xac97.h>
#include "ac97.h"
#include "config.h"

// vol:
// 0 = mute
// 32 = max
void set_output_volume(int vol) {
	u16 regval;

	if (vol == 0) {
		regval = XAC97_VOL_MUTE;
	}
	else if (vol <= MAX_OUTPUT_VOLUME) {
		u8 val = 32 - vol;
		regval = ((32-vol) << 8) | val;
	}

	xil_printf("Setting master volume reg (%02Xh) to 0x%04X\r\n", XAC97_STEREO_VOLUME_REG, regval);
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_STEREO_VOLUME_REG, regval);
}




void do_ac97_init(void) {
	FUNC_ENTER();

	print("Calling init_sound\r\n");
	init_sound(48000);

	// Select Line In for Recording
	XAC97_RecordSelect(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_RECORD_LINE_IN);

	// Set the overall Record gain to 0dB.
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_RECORD_GAIN_REG, 0x0000);


	/////////////////////////////
	// Set analog mixer volumes

	// Mute the mic in volume
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_MIC_VOLUME_REG, XAC97_IN_MUTE);

#ifdef ANALOG_BYPASS
	// Listen to the LINE IN via the analog mixer.
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_LINE_IN_VOLUME_REG, XAC97_IN_GAIN_0dB);		// LINE IN = 0dB
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_PCM_OUT_VOLUME_REG, XAC97_IN_MUTE);			// PCM OUT = Mute
#else
	// Listen to the PCM OUT (digital audio playback).
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_LINE_IN_VOLUME_REG, XAC97_IN_MUTE);			// LINE IN = Mute
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_PCM_OUT_VOLUME_REG, XAC97_IN_GAIN_0dB);		// PCM OUT = 0dB
#endif

	// Set the Master volume to 0dB.
	set_output_volume(24);

	print("Calling playback_enable\r\n");
	playback_enable();

	print("Calling record_enable\r\n");
	record_enable();
}
