
#uses "xillib.tcl"

proc generate {drv_handle} {
    xdefine_include_file $drv_handle "xparameters.h" "AUDIOFX" "NUM_INSTANCES" "C_BASEADDR" "C_HIGHADDR" "DEVICE_ID"  
}
