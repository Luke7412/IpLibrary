# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "ACLK_FREQUENCY" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BAUD_RATE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "BAUD_RATE_SIM" -parent ${Page_0}
  ipgui::add_param $IPINST -name "ESCAPE_BYTE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "START_BYTE" -parent ${Page_0}
  ipgui::add_param $IPINST -name "STOP_BYTE" -parent ${Page_0}


}

proc update_PARAM_VALUE.ACLK_FREQUENCY { PARAM_VALUE.ACLK_FREQUENCY } {
	# Procedure called to update ACLK_FREQUENCY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ACLK_FREQUENCY { PARAM_VALUE.ACLK_FREQUENCY } {
	# Procedure called to validate ACLK_FREQUENCY
	return true
}

proc update_PARAM_VALUE.BAUD_RATE { PARAM_VALUE.BAUD_RATE } {
	# Procedure called to update BAUD_RATE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BAUD_RATE { PARAM_VALUE.BAUD_RATE } {
	# Procedure called to validate BAUD_RATE
	return true
}

proc update_PARAM_VALUE.BAUD_RATE_SIM { PARAM_VALUE.BAUD_RATE_SIM } {
	# Procedure called to update BAUD_RATE_SIM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BAUD_RATE_SIM { PARAM_VALUE.BAUD_RATE_SIM } {
	# Procedure called to validate BAUD_RATE_SIM
	return true
}

proc update_PARAM_VALUE.ESCAPE_BYTE { PARAM_VALUE.ESCAPE_BYTE } {
	# Procedure called to update ESCAPE_BYTE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ESCAPE_BYTE { PARAM_VALUE.ESCAPE_BYTE } {
	# Procedure called to validate ESCAPE_BYTE
	return true
}

proc update_PARAM_VALUE.START_BYTE { PARAM_VALUE.START_BYTE } {
	# Procedure called to update START_BYTE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.START_BYTE { PARAM_VALUE.START_BYTE } {
	# Procedure called to validate START_BYTE
	return true
}

proc update_PARAM_VALUE.STOP_BYTE { PARAM_VALUE.STOP_BYTE } {
	# Procedure called to update STOP_BYTE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STOP_BYTE { PARAM_VALUE.STOP_BYTE } {
	# Procedure called to validate STOP_BYTE
	return true
}


proc update_MODELPARAM_VALUE.ACLK_FREQUENCY { MODELPARAM_VALUE.ACLK_FREQUENCY PARAM_VALUE.ACLK_FREQUENCY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ACLK_FREQUENCY}] ${MODELPARAM_VALUE.ACLK_FREQUENCY}
}

proc update_MODELPARAM_VALUE.BAUD_RATE { MODELPARAM_VALUE.BAUD_RATE PARAM_VALUE.BAUD_RATE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BAUD_RATE}] ${MODELPARAM_VALUE.BAUD_RATE}
}

proc update_MODELPARAM_VALUE.BAUD_RATE_SIM { MODELPARAM_VALUE.BAUD_RATE_SIM PARAM_VALUE.BAUD_RATE_SIM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BAUD_RATE_SIM}] ${MODELPARAM_VALUE.BAUD_RATE_SIM}
}

proc update_MODELPARAM_VALUE.ESCAPE_BYTE { MODELPARAM_VALUE.ESCAPE_BYTE PARAM_VALUE.ESCAPE_BYTE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ESCAPE_BYTE}] ${MODELPARAM_VALUE.ESCAPE_BYTE}
}

proc update_MODELPARAM_VALUE.START_BYTE { MODELPARAM_VALUE.START_BYTE PARAM_VALUE.START_BYTE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.START_BYTE}] ${MODELPARAM_VALUE.START_BYTE}
}

proc update_MODELPARAM_VALUE.STOP_BYTE { MODELPARAM_VALUE.STOP_BYTE PARAM_VALUE.STOP_BYTE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STOP_BYTE}] ${MODELPARAM_VALUE.STOP_BYTE}
}

