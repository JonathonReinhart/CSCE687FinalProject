/****************************************************************************/
/*
* @file xac97_l.h
*
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00 WN	 Apr, 04
* 
*****************************************************************************/

#ifndef XAC97_L_H /*prevent circular inclusions */
#define XAC97_L_H /*by using protection macros */


/***************************** Include Files ********************************/

#include "xbasic_types.h"
#include "xio.h"


/************************** Constant Definitions ****************************/

#define  XAC97_INFIFO_OFFSET		0x00000000	//Write 16 bit data sample to playback FIFO
#define  XAC97_OUTFIFO_OFFSET		0x00000004	//Read 16 bit data sample from record FIFO
#define  XAC97_FIFO_STATUS_OFFSET	0x00000008	//Status Register
#define  XAC97_INTERRUPT_OFFSET	    0x0000000C  //contains playback/record interrupt enable bit
												// ac97 status register enable it
#define  XAC97_REGADDR_OFFSET		0x00000010  //AC97 Control Address Register
#define  XAC97_REGREAD_OFFSET		0x00000014  //AC97 Status Data Read Register
#define  XAC97_REGWRITE_OFFSET	    0x00000018  //AC97 Control Data Write Register
#define  XAC97_SOUNDENABLE_OFFSET	0x0000001c  //Enable OPB playback or record 

#define XAC97_INFIFO_FULL	        0x00000001	//Playback FIFO full
#define XAC97_INFIFO_EMPTY        	0x00000002	//Record FIFO full
#define XAC97_REG_ACCESS_FINISHED	0x00000010	//Register Access Finished
#define XAC97_CODEC_RDY             0x00000020	//Codec Ready
#define XAC97_REG_ACCESS          	0x00000040	//Register Access

#define XAC97_CONTROL_REGADDR_READ	0x00000080

#define XAC97_STEREO_VOLUME_REG		0x02	//Master volume
#define XAC97_AUX_VOLUME_REG		0x04	//True Line Level Out Volume
#define XAC97_MONO_VOLUME_REG		0x06	//Master Volume Mono
#define XAC97_BEEP_VOLUME_REG		0x0A	//PC_BEEP volume
#define XAC97_MIC_VOLUME_REG		0x0E	//Mic volume
#define XAC97_PCM_OUT_VOLUME_REG	0x18	//PCM Out volume
#define XAC97_RECORD_SELECT_REG	    0x1A	//Record select
#define XAC97_RECORD_GAIN_REG		0x1C	//Record gain
#define XAC97_GENERAL_PURPOSE_REG	0x20	//General Purpose
#define XAC97_STATUS_CONTROL_REG	0x2A	//Extended Audio Status/Control
#define XAC97_PCM_DAC_SAMPLE_RATE_REG	0x2C	//PCM front DAC Rate
#define XAC97_PCM_ADC_SAMPLE_RATE_REG	0x32	//PCM ADC Rate


/***************** Macros (Inline Functions) Definitions *********************/

/*****************************************************************************
*
* Low-level driver macros and functions. The list below provides signatures
* to help the user use the macros.
*
* XAC97_mGetStatusReg(Xuint32 Base)
* XAC97_mSetWriteReg(Xuint32 Base, Xuint32 Value)
* XAC97_mSetRegAddr(Xuint32 Base, Xuint32 Reg_Addr)
* XAC97_mGetReadData(Xuint32 Base)
* XAC97_mConfReadAccess(Xuint32 Base, Xuint32 Reg_Addr)
* XAC97_mWrite(Xuint32 Base, Xuint32 Offset, Xuint32 Value)
* XAC97_mRead(Xuint32 Base, Xuint32 Offset)
* 
*
*****************************************************************************/

// Reads only from the Status Register
#define XAC97_mGetStatusReg(Base) \
		XIo_In32((XIo_Address)((Base)+XAC97_FIFO_STATUS_OFFSET)) 

// Places value to AC97 Control Data Write Register
#define XAC97_mSetWriteReg(Base, Value) \
		XIo_Out32(((XIo_Address)((Base)+XAC97_REGWRITE_OFFSET)),(Value))

// Places address to AC97 Control Address Register
#define XAC97_mSetRegAddr(Base, Reg_Addr) \
		XIo_Out32(((XIo_Address)((Base)+XAC97_REGADDR_OFFSET)), (Reg_Addr))

// Reads from AC97 Status Data Read Register
#define XAC97_mGetReadData(Base) \
		XIo_In32((XIo_Address)((Base)+XAC97_REGREAD_OFFSET))

// Enable read access
#define XAC97_mConfReadAccess(Base, Reg_Addr) \
		XAC97_mSetRegAddr((XIo_Address)((Base)+XAC97_REGADDR_OFFSET), ((Reg_Addr)|XAC97_CONTROL_REGADDR_READ))

// Performs a general write operation to specified address
#define XAC97_mWrite(Base, Offset, Value) \
		XIo_Out32(((XIo_Address)((Base)+(Offset))),(Value))

// Performs a general read operation from specified address
#define XAC97_mRead(Base, Offset) \
		XIo_In32((XIo_Address)((Base)+Offset))


/****************************************************************************************************/

#endif /* end of protection macro */
