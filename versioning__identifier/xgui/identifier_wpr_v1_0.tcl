# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "MAJOR_VERSION" -parent ${Page_0}
  ipgui::add_param $IPINST -name "MINOR_VERSION" -parent ${Page_0}
  ipgui::add_param $IPINST -name "NAME" -parent ${Page_0}


}

proc update_PARAM_VALUE.MAJOR_VERSION { PARAM_VALUE.MAJOR_VERSION } {
	# Procedure called to update MAJOR_VERSION when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MAJOR_VERSION { PARAM_VALUE.MAJOR_VERSION } {
	# Procedure called to validate MAJOR_VERSION
	return true
}

proc update_PARAM_VALUE.MINOR_VERSION { PARAM_VALUE.MINOR_VERSION } {
	# Procedure called to update MINOR_VERSION when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MINOR_VERSION { PARAM_VALUE.MINOR_VERSION } {
	# Procedure called to validate MINOR_VERSION
	return true
}

proc update_PARAM_VALUE.NAME { PARAM_VALUE.NAME } {
	# Procedure called to update NAME when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.NAME { PARAM_VALUE.NAME } {
	# Procedure called to validate NAME
	return true
}


proc update_MODELPARAM_VALUE.NAME { MODELPARAM_VALUE.NAME PARAM_VALUE.NAME } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.NAME}] ${MODELPARAM_VALUE.NAME}
}

proc update_MODELPARAM_VALUE.MAJOR_VERSION { MODELPARAM_VALUE.MAJOR_VERSION PARAM_VALUE.MAJOR_VERSION } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MAJOR_VERSION}] ${MODELPARAM_VALUE.MAJOR_VERSION}
}

proc update_MODELPARAM_VALUE.MINOR_VERSION { MODELPARAM_VALUE.MINOR_VERSION PARAM_VALUE.MINOR_VERSION } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MINOR_VERSION}] ${MODELPARAM_VALUE.MINOR_VERSION}
}

