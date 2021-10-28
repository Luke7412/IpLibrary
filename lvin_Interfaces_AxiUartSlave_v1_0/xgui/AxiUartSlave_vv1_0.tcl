# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  #Adding Group
  set Timing [ipgui::add_group $IPINST -name "Timing" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "g_AClkFrequency" -parent ${Timing}
  ipgui::add_param $IPINST -name "g_BaudRateSim" -parent ${Timing}
  ipgui::add_param $IPINST -name "g_BaudRate" -parent ${Timing}

  #Adding Group
  set config [ipgui::add_group $IPINST -name "config" -parent ${Page_0} -display_name {Framing}]
  ipgui::add_param $IPINST -name "g_EscapeByte" -parent ${config}
  ipgui::add_param $IPINST -name "g_StartByte" -parent ${config}
  ipgui::add_param $IPINST -name "g_StopByte" -parent ${config}



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

proc update_PARAM_VALUE.g_BaudRateSim { PARAM_VALUE.g_BaudRateSim } {
	# Procedure called to update g_BaudRateSim when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_BaudRateSim { PARAM_VALUE.g_BaudRateSim } {
	# Procedure called to validate g_BaudRateSim
	return true
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


proc update_MODELPARAM_VALUE.g_AClkFrequency { MODELPARAM_VALUE.g_AClkFrequency PARAM_VALUE.g_AClkFrequency } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_AClkFrequency}] ${MODELPARAM_VALUE.g_AClkFrequency}
}

proc update_MODELPARAM_VALUE.g_BaudRate { MODELPARAM_VALUE.g_BaudRate PARAM_VALUE.g_BaudRate } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_BaudRate}] ${MODELPARAM_VALUE.g_BaudRate}
}

proc update_MODELPARAM_VALUE.g_BaudRateSim { MODELPARAM_VALUE.g_BaudRateSim PARAM_VALUE.g_BaudRateSim } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_BaudRateSim}] ${MODELPARAM_VALUE.g_BaudRateSim}
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

