/*****************************************************************************/
/**
*
* @file xac97_intr.c
*
* Contains interrupt-related functions for the XAC97 component.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00  WN	 Apr, 04
* 
*
******************************************************************************/

/***************************** Include Files *********************************/

#include "xbasic_types.h"
#include "xac97_l.h"
#include "xac97.h"
#include "xparameters.h"

/*****************************************************************************
* Function: XAC97_SetHandler
* Notes:  function to be verified
*
******************************************************************************/

void XAC97_SetHandler(XAC97 *InstancePtr, XAC97_Handler FuncPtr, void *CallBackRef)
{
    XASSERT_VOID(InstancePtr != XNULL);
    XASSERT_VOID(FuncPtr != XNULL);
    XASSERT_VOID(InstancePtr->IsReady == XCOMPONENT_IS_READY);

    InstancePtr->Handler = FuncPtr;
    InstancePtr->CallBackRef = CallBackRef;
}

/*****************************************************************************
* Function: XAC97_Interrupt Handler
*			Triggers the interrupt when access_finish bit in register goes high
* Notes:	function to be verified
*
******************************************************************************/
void XAC97_InterruptHandler(void *InstancePtr)
{
    XAC97 *AC97Ptr = XNULL;
    Xuint8 Number;
    Xuint32 ControlStatusReg;

    
    XASSERT_VOID(InstancePtr != XNULL);

    AC97Ptr = (XAC97 *)InstancePtr;

    if(XAC97_mGetStatusReg(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR) & XAC97_REG_ACCESS_FINISHED)
    {
		AC97Ptr->Handler(AC97Ptr->CallBackRef);
	}
	
}

/******************************************************************************************
* Functions: playback_intr_enable & playback_intr_disable
* Use: enable/disable interrupt for playback
*******************************************************************************************/
void playback_intr_enable(void)
{

	Xuint32 temp;
	
	temp = XAC97_mRead(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_INTERRUPT_OFFSET);

	temp = temp | 0x0001;  

	XAC97_mWrite(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_INTERRUPT_OFFSET, temp);
		
}

void playback_intr_disable(void)
{
	Xuint32 temp;
	
	temp = XAC97_mRead(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_INTERRUPT_OFFSET);

	if ((temp & 0x0001) == 1)
	{
		temp = temp - 0x0001;
	}
	
	XAC97_mWrite(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_INTERRUPT_OFFSET, temp);

}

/******************************************************************************************
* Functions: record_intr_enable & record_intr_disable
* Use: enable/disable interrupt for record
*******************************************************************************************/
void record_intr_enable(void)
{

	Xuint32 temp;
	
	temp = XAC97_mRead(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_INTERRUPT_OFFSET);

	temp = temp | 0x0002;  

	XAC97_mWrite(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_INTERRUPT_OFFSET, temp);
		
}

void record_intr_disable(void)
{
	Xuint32 temp;
	
	temp = XAC97_mRead(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_INTERRUPT_OFFSET);

	if ((temp & 0x0002) == 1)
	{
		temp = temp - 0x0002;
	}
	
	XAC97_mWrite(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_INTERRUPT_OFFSET, temp);

}

/******************************************************************************************
* Functions: status_intr_enable & status_intr_disable
* Use: enable/disable interrupt for ac97 status register
*******************************************************************************************/
void status_intr_enable(void)
{

	Xuint32 temp;
	
	temp = XAC97_mRead(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_INTERRUPT_OFFSET);

	temp = temp | 0x0004;  

	XAC97_mWrite(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_INTERRUPT_OFFSET, temp);
		
}

void status_intr_disable(void)
{
	Xuint32 temp;
	
	temp = XAC97_mRead(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_INTERRUPT_OFFSET);

	if ((temp & 0x0004) == 1)
	{
		temp = temp - 0x0004;
	}
	
	XAC97_mWrite(XPAR_OPB_AC97_CONTROLLER_0_BASEADDR, XAC97_INTERRUPT_OFFSET, temp);

}
