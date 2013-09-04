/***********************************************************************
* @file xac97.h
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00 WN	 Apr, 04
* 
*****************************************************************************/

#ifndef XAC97_H /*prevent circular inclusions*/
#define XAC97_H /*by using protection macros*/

/***************************** Include Files ********************************/

#include "xbasic_types.h"
#include "xstatus.h"
#include "xac97_l.h"

/************************** Constant Definitions ****************************/

/**************************** Type Definitions ******************************/
typedef void (*XAC97_Handler)(void *CallBackRef);

/*
 * This typedef contains configuration information for the device.
 */
typedef struct
{
    Xuint16 DeviceId;      /* Unique ID  of device */
    Xuint32 BaseAddress;   /* Device base address */
} XAC97_Config;

/**
 * The XAC97 driver instance data. The user is required to allocate a
 * variable of this type for every AC97 controller device in the system. A pointer
 * to a variable of this type is then passed to the driver API functions.
 */
typedef struct
{
    Xuint32 BaseAddress;   /* Device base address */
    Xuint32 IsReady;       /* Device is initialized and ready */

	XAC97_Handler Handler;    /* Callback function */
    void *CallBackRef;          /* Callback reference for handler */

} XAC97;


/***************** Macros (Inline Functions) Definitions ********************/


/************************** Function Prototypes *****************************/
// defined in xac97.c
XStatus XAC97_Initialize(XAC97 *InstancePtr, Xuint16 DeviceId);
XAC97_Config *XAC97_LookupConfig(Xuint16 DeviceId);
XStatus XAC97_SelfTest(XAC97 *InstancePtr);

void    WriteAC97Reg( Xuint32 Base, Xuint32 Reg_Addr, Xuint32 Value);
Xuint32 ReadAC97Reg( Xuint32 Base, Xuint32 Reg_Addr);
void    init_sound(int sample_rate);
void 	playback_enable(void);
void	playback_disable(void);
void  	playback_fifo_clear(void);
void	record_enable(void);
void	record_disable(void);
void	record_fifo_clear(void);
void 	opb_write_playbackfifo(Xuint16 soundbyte);
Xuint16 opb_read_recordfifo(void); 

// defined in xac97_intr.c 
void 	playback_intr_enable(void);
void 	playback_intr_disable(void);
void 	record_intr_enable(void);
void 	record_intr_disable(void);
void 	status_intr_enable(void);
void 	status_intr_disable(void);

// defined in xac97_intr.c... function has not been verified
void 	XAC97_SetHandler(XAC97 *InstancePtr, XAC97_Handler FuncPtr, void *CallBackRef);
void 	XAC97_InterruptHandler(void *InstancePtr);

/*******************************************************************************/
#endif
