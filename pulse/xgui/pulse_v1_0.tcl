# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ACLK_FREQ" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TDATA_NUM_BYTES" -parent ${Page_0}


}

proc update_PARAM_VALUE.ACLK_FREQ { PARAM_VALUE.ACLK_FREQ } {
	# Procedure called to update ACLK_FREQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ACLK_FREQ { PARAM_VALUE.ACLK_FREQ } {
	# Procedure called to validate ACLK_FREQ
	return true
}

proc update_PARAM_VALUE.TDATA_NUM_BYTES { PARAM_VALUE.TDATA_NUM_BYTES } {
	# Procedure called to update TDATA_NUM_BYTES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TDATA_NUM_BYTES { PARAM_VALUE.TDATA_NUM_BYTES } {
	# Procedure called to validate TDATA_NUM_BYTES
	return true
}


proc update_MODELPARAM_VALUE.TDATA_NUM_BYTES { MODELPARAM_VALUE.TDATA_NUM_BYTES PARAM_VALUE.TDATA_NUM_BYTES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TDATA_NUM_BYTES}] ${MODELPARAM_VALUE.TDATA_NUM_BYTES}
}

proc update_MODELPARAM_VALUE.ACLK_FREQ { MODELPARAM_VALUE.ACLK_FREQ PARAM_VALUE.ACLK_FREQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ACLK_FREQ}] ${MODELPARAM_VALUE.ACLK_FREQ}
}

