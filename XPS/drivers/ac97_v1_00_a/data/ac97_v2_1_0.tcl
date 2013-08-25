
#uses "xillib.tcl"

proc generate {drv_handle} {
  set level [xget_value $drv_handle "PARAMETER" "level"]
  if {$level == 0} {
    xdefine_include_file $drv_handle "xparameters.h" "XAC97" "NUM_INSTANCES" "C_BASEADDR" "C_HIGHADDR" "DEVICE_ID"  
  }
  if {$level == 1} {
    xdefine_include_file $drv_handle "xparameters.h" "XAC97" "NUM_INSTANCES" "C_BASEADDR" "C_HIGHADDR" "DEVICE_ID"
    xdefine_config_file $drv_handle "xac97_g.c" "XAC97"  "DEVICE_ID" "C_BASEADDR"
  }
}
