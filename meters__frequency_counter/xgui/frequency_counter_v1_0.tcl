# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ACLK_FREQUENCY" -parent ${Page_0}


}

proc update_PARAM_VALUE.ACLK_FREQUENCY { PARAM_VALUE.ACLK_FREQUENCY } {
	# Procedure called to update ACLK_FREQUENCY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ACLK_FREQUENCY { PARAM_VALUE.ACLK_FREQUENCY } {
	# Procedure called to validate ACLK_FREQUENCY
	return true
}


proc update_MODELPARAM_VALUE.ACLK_FREQUENCY { MODELPARAM_VALUE.ACLK_FREQUENCY PARAM_VALUE.ACLK_FREQUENCY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ACLK_FREQUENCY}] ${MODELPARAM_VALUE.ACLK_FREQUENCY}
}

