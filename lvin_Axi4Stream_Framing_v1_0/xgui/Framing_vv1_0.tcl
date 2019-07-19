# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "g_EscapeByte" -parent ${Page_0}
  ipgui::add_param $IPINST -name "g_StartByte" -parent ${Page_0}
  ipgui::add_param $IPINST -name "g_StopByte" -parent ${Page_0}


}

proc update_PARAM_VALUE.g_EscapeByte { PARAM_VALUE.g_EscapeByte } {
	# Procedure called to update g_EscapeByte when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_EscapeByte { PARAM_VALUE.g_EscapeByte } {
	# Procedure called to validate g_EscapeByte
	return true
}

proc update_PARAM_VALUE.g_StartByte { PARAM_VALUE.g_StartByte } {
	# Procedure called to update g_StartByte when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_StartByte { PARAM_VALUE.g_StartByte } {
	# Procedure called to validate g_StartByte
	return true
}

proc update_PARAM_VALUE.g_StopByte { PARAM_VALUE.g_StopByte } {
	# Procedure called to update g_StopByte when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_StopByte { PARAM_VALUE.g_StopByte } {
	# Procedure called to validate g_StopByte
	return true
}


proc update_MODELPARAM_VALUE.g_EscapeByte { MODELPARAM_VALUE.g_EscapeByte PARAM_VALUE.g_EscapeByte } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_EscapeByte}] ${MODELPARAM_VALUE.g_EscapeByte}
}

proc update_MODELPARAM_VALUE.g_StartByte { MODELPARAM_VALUE.g_StartByte PARAM_VALUE.g_StartByte } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_StartByte}] ${MODELPARAM_VALUE.g_StartByte}
}

proc update_MODELPARAM_VALUE.g_StopByte { MODELPARAM_VALUE.g_StopByte PARAM_VALUE.g_StopByte } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_StopByte}] ${MODELPARAM_VALUE.g_StopByte}
}

