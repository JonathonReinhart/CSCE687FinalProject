/***********************************************************************
* @file xac97.c
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00 WN   Apr, 04
* 
*****************************************************************************/

/******************************************************************************
This file contains the following functions:
XStatus			XAC97_Initialize(XAC97* InstancePtr, Xuint16 DeviceID)
XAC97_Config	*XAC97_LookupConfig(Xuint16 DeviceId)
XStatus			XAC97_SelfTest(XAC97* InstancePtr)
void			WriteAC97Reg(Xuint32 Base, Xuint32 Reg_Addr, Xuint32 Value)
Xuint32			ReadAC97Reg(Xuint32 Base, Xuint32 Reg_Addr)
void 			playback_enable(void);
void			playback_disable(void);
void  			playback_fifo_clear(void);
void			record_enable(void);
void			record_disable(void);
void			record_fifo_clear(void);
void 			opb_write_playbackfifo(Xuint16 soundbyte);
Xuint16			opb_read_recordfifo(void); 
/***************************** Include Files ********************************/

#include "mb_interface.h"
#include "xstatus.h"
#include "xac97_l.h"
#include "xac97.h"
#include "xparameters.h"
//#include "xac97_g.c"
//#include "xac97_intr.c"

/***************************************************************************************
*  Function:	XAC97_Initialize
*  Description:	Initializes the XAC97 instance by the caller based on the given DeviceID
*  Return:		XST_SUCCESS initialization is successful
				XST_DEVICE_NOT_FOUND Device configuration data was not found for a device
				with the supplied device ID
****************************************************************************************/
// JRR - I gutted the config stuff - it wasn't fully utilized.
/*
XStatus XAC97_Initialize(XAC97* InstancePtr, Xuint16 DeviceID)
{
	XAC97_Config *ConfigPtr;					// for structure of XAC97_Config
												//	refer to xac97.h
	XASSERT_NONVOID(InstancePtr != XNULL);	

	ConfigPtr = XAC97_LookupConfig(DeviceID);
	if (ConfigPtr == (XAC97_Config *)XNULL)
	{
		InstancePtr->IsReady = 0;				// for structure of XAC97
		return(XST_DEVICE_NOT_FOUND);			//	refer to xac97.h
	}
	
	InstancePtr->BaseAddress = ConfigPtr->BaseAddress;
	InstancePtr->IsReady = XCOMPONENT_IS_READY;		//XCOMPONENT_IS_READY defined in xstatus.h
	return(XST_SUCCESS);
}
*/

/***************************************************************************************
*  Function:	XAC97_LookupConfig
*  Description:	Looks up the device configuration based on the unique device ID.  
*  Return:		XAC97 configuration structure pointer if Device ID is found
****************************************************************************************/	
/*
XAC97_Config *XAC97_LookupConfig(Xuint16 DeviceId)
{
	XAC97_Config *CfgPtr = XNULL;

	int i;

	for (i=0; i<XPAR_XAC97_NUM_INSTANCES; i++)
	{
		if (XAC97_ConfigTable[i].DeviceId == DeviceId)
		{
			CfgPtr = &XAC97_ConfigTable[i];
			break;
		}
	}

	return CfgPtr;
}
*/

/***************************************************************************************
*  Function:	XAC97_SelfTest
*  Description:	Checks if the XAC97 instance is ready or not
*  Return:		XST_SUCCESS initialization is successful
****************************************************************************************/
XStatus XAC97_SelfTest(XAC97* InstancePtr)
{
	XASSERT_NONVOID(InstancePtr !=XNULL);
	XASSERT_NONVOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

	return (XST_SUCCESS);
}

/***************************************************************************************
*  Function:	WriteAC97Reg
*  Description:	Perform a write operation to the specified AC97 registers
*  Parameters:	Base -->  Base address of ac97_controller generated in xparameters.h
				Reg_Addr -->  Register to be written
				Value --> value to be written to the register
*  Return:		none
****************************************************************************************/
void WriteAC97Reg(Xuint32 Base, Xuint32 Reg_Addr, Xuint32 Value)
{
	XAC97_mSetWriteReg(Base, Value);		// see xac97_l.h for description of functions
	XAC97_mSetRegAddr(Base, Reg_Addr);
	while((XAC97_mGetStatusReg(Base) & XAC97_REG_ACCESS_FINISHED) == 0);
}

/***************************************************************************************
*  Function:	ReadAC97Reg
*  Description:	Perform a read operation from the specified AC97 registers
*  Parameters:	Base -->  Base address of ac97_controller generated in xparameters.h
				Reg_Addr -->  Register to be written
*  Return:		value stored in register
****************************************************************************************/
Xuint32 ReadAC97Reg(Xuint32 Base, Xuint32 Reg_Addr)
{
	XAC97_mConfReadAccess(Base, Reg_Addr);
	
	
	while((XAC97_mGetStatusReg(Base) & XAC97_REG_ACCESS_FINISHED)==0);
	
	return (XAC97_mGetReadData(Base));
}

/***************************************************************************************
*  Function:	init_sound
*  Description:	initialize AC97 registers to allow playback and record
*  Parameters:	sample_rate --> sampling rate in hz
*  Return:		none
****************************************************************************************/


void init_sound(int sample_rate)
{
	// wait until codec is ready to be written
	while(!(XAC97_mGetStatusReg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR) & XAC97_CODEC_RDY));

	// see xac97_l.h for description of constants XAC97_ .... 
	// refer to LM4549 Register Map for proper mapping to allow for playback and record
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_PCM_DAC_SAMPLE_RATE_REG, sample_rate);
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_PCM_ADC_SAMPLE_RATE_REG, sample_rate);	

	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_STATUS_CONTROL_REG, 1); //enable VRA mode

	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_STEREO_VOLUME_REG, 0x0000);
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_AUX_VOLUME_REG, 0x0000);
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_MONO_VOLUME_REG, 0x0000);
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_BEEP_VOLUME_REG, 0x8000);
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_PCM_OUT_VOLUME_REG, 0x0000);

	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_RECORD_SELECT_REG, 0x0000);
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_RECORD_GAIN_REG, 0x000f);	
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_MIC_VOLUME_REG, 0x8040);
	WriteAC97Reg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_GENERAL_PURPOSE_REG, 0x8000);

}
	
/***************************************************************************************
*  Function:	playback_enable
*  Description:	enable playback function (for both playback through OPB and FSL)
*  Parameters:	none
*  Return:		none
****************************************************************************************/
void playback_enable(void)	
{
	Xuint16 temp;
	
	temp = XAC97_mRead(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_SOUNDENABLE_OFFSET);

	temp = temp | 0x0001;  //  write 1 to bit 0 of register

	XAC97_mWrite(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_SOUNDENABLE_OFFSET, temp);
		
}

/***************************************************************************************
*  Function:	playback_disable
*  Description:	disable playback function (For both playback through OPB and FSL)
*  Parameters:	none
*  Return:		none
****************************************************************************************/
void playback_disable(void)
{	
	Xuint16 temp;
	
	temp = XAC97_mRead(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_SOUNDENABLE_OFFSET);

	if ((temp & 0x0001) == 1)
	{
		temp = temp - 0x0001;
	}
	
	XAC97_mWrite(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_SOUNDENABLE_OFFSET, temp);
}

/***************************************************************************************
*  Function:	playback_fifo_clear
*  Description:	clears playback fifo (for playback through OPB only)
*  Parameters:	none
*  Return:		none
****************************************************************************************/
void playback_fifo_clear(void)
{	
	Xuint16 temp;
	
	temp = XAC97_mRead(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_SOUNDENABLE_OFFSET);

	temp = temp | 0x0004;

	XAC97_mWrite(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_SOUNDENABLE_OFFSET, temp);
}

/***************************************************************************************
*  Function:	record_enable
*  Description:	enable record function (for record through both FSL and OPB)
*  Parameters:	none
*  Return:		none
****************************************************************************************/
void record_enable(void)
{
	Xuint16 temp;
	
	temp = XAC97_mRead(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_SOUNDENABLE_OFFSET);

	temp = temp | 0x0002;

	XAC97_mWrite(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_SOUNDENABLE_OFFSET, temp);
}

/***************************************************************************************
*  Function:	record_disable
*  Description:	disable record function (for record through both FSL and OPB)
*  Parameters:	none
*  Return:		none
****************************************************************************************/
void record_disable(void)
{
	Xuint16 temp;
	
	temp = XAC97_mRead(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_SOUNDENABLE_OFFSET);

	if ((temp & 0x0002) == 1)
	{
		temp = temp - 0x0002;
	}
	
	XAC97_mWrite(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_SOUNDENABLE_OFFSET, temp);

}
/***************************************************************************************
*  Function:	record_fifo_clear
*  Description:	clears record fifo (for record through OPB only)
*  Parameters:	none
*  Return:		none
****************************************************************************************/
void record_fifo_clear(void)
{
	Xuint16 temp;
	
	temp = XAC97_mRead(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_SOUNDENABLE_OFFSET);

	temp = temp | 0x0008;

	XAC97_mWrite(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_SOUNDENABLE_OFFSET, temp);
}

/***************************************************************************************
*  Function:	opb_write_playbackfifo
*  Description:	playback function using opb (plays out 'soundbyte')
*  Parameters:	soundbyte --> sound sample to be played
*  Return:		none
****************************************************************************************/
void opb_write_playbackfifo(Xuint16 soundbyte)
{
	while((XAC97_mGetStatusReg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR) & 0x0001) == 0);

    XAC97_mWrite(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR,XAC97_INFIFO_OFFSET, (Xuint32)soundbyte);
}

/***************************************************************************************
*  Function:	opb_read_playbackfifo
*  Description:	read function using opb (saves 'soundbyte')
*  Parameters:	none
*  Return:		soundbyte --> sound sample to be stored
****************************************************************************************/
Xuint16 opb_read_recordfifo(void)
{

	Xuint16 soundbyte;
	
	while((XAC97_mGetStatusReg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR) & 0x0008) == 0);

	soundbyte = XAC97_mRead(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR,XAC97_OUTFIFO_OFFSET);

	return soundbyte;
}

