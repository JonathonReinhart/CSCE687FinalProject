/*****************************************************************************/
/**
*
* @file xac97_g.c
*
* This file contains a configuration table that specifies the configuration
* of OPB AC97 controller devices in the system. In addition, there is a lookup function used
* by the driver to access its configuration information.
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -----------------------------------------------
* 1.00 WN   Apr, 04
* 
* 
******************************************************************************/

/***************************** Include Files *********************************/
#include "xac97.h"
#include "xparameters.h"

/************************** Variable Prototypes ******************************/

XAC97_Config XAC97_ConfigTable[] =
{
    {
      XPAR_OPB_AC97_CONTROLLER_0_DEVICE_ID,
      XPAR_OPB_AC97_CONTROLLER_0_BASEADDR,
    }
};



