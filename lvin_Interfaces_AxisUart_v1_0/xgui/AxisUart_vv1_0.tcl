# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "g_AClkFrequency" -parent ${Page_0}
  ipgui::add_param $IPINST -name "g_BaudRate" -parent ${Page_0} -show_range false


}

proc update_PARAM_VALUE.g_AClkFrequency { PARAM_VALUE.g_AClkFrequency } {
	# Procedure called to update g_AClkFrequency when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_AClkFrequency { PARAM_VALUE.g_AClkFrequency } {
	# Procedure called to validate g_AClkFrequency
	return true
}

proc update_PARAM_VALUE.g_BaudRate { PARAM_VALUE.g_BaudRate } {
	# Procedure called to update g_BaudRate when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_BaudRate { PARAM_VALUE.g_BaudRate } {
	# Procedure called to validate g_BaudRate
	return true
}


proc update_MODELPARAM_VALUE.g_AClkFrequency { MODELPARAM_VALUE.g_AClkFrequency PARAM_VALUE.g_AClkFrequency } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_AClkFrequency}] ${MODELPARAM_VALUE.g_AClkFrequency}
}

proc update_MODELPARAM_VALUE.g_BaudRate { MODELPARAM_VALUE.g_BaudRate PARAM_VALUE.g_BaudRate } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_BaudRate}] ${MODELPARAM_VALUE.g_BaudRate}
}

