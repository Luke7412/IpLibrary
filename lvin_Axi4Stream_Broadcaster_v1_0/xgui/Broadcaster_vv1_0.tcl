# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "g_NofInitiators" -parent ${Page_0}
  ipgui::add_param $IPINST -name "g_NumByteLanes" -parent ${Page_0}
  ipgui::add_param $IPINST -name "g_TDestWidth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "g_TIdWidth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "g_TUserWidth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "g_UseTKeep" -parent ${Page_0}
  ipgui::add_param $IPINST -name "g_UseTStrb" -parent ${Page_0}


}

proc update_PARAM_VALUE.g_NofInitiators { PARAM_VALUE.g_NofInitiators } {
	# Procedure called to update g_NofInitiators when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_NofInitiators { PARAM_VALUE.g_NofInitiators } {
	# Procedure called to validate g_NofInitiators
	return true
}

proc update_PARAM_VALUE.g_NumByteLanes { PARAM_VALUE.g_NumByteLanes } {
	# Procedure called to update g_NumByteLanes when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_NumByteLanes { PARAM_VALUE.g_NumByteLanes } {
	# Procedure called to validate g_NumByteLanes
	return true
}

proc update_PARAM_VALUE.g_TDestWidth { PARAM_VALUE.g_TDestWidth } {
	# Procedure called to update g_TDestWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_TDestWidth { PARAM_VALUE.g_TDestWidth } {
	# Procedure called to validate g_TDestWidth
	return true
}

proc update_PARAM_VALUE.g_TIdWidth { PARAM_VALUE.g_TIdWidth } {
	# Procedure called to update g_TIdWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_TIdWidth { PARAM_VALUE.g_TIdWidth } {
	# Procedure called to validate g_TIdWidth
	return true
}

proc update_PARAM_VALUE.g_TUserWidth { PARAM_VALUE.g_TUserWidth } {
	# Procedure called to update g_TUserWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_TUserWidth { PARAM_VALUE.g_TUserWidth } {
	# Procedure called to validate g_TUserWidth
	return true
}

proc update_PARAM_VALUE.g_UseTKeep { PARAM_VALUE.g_UseTKeep } {
	# Procedure called to update g_UseTKeep when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_UseTKeep { PARAM_VALUE.g_UseTKeep } {
	# Procedure called to validate g_UseTKeep
	return true
}

proc update_PARAM_VALUE.g_UseTStrb { PARAM_VALUE.g_UseTStrb } {
	# Procedure called to update g_UseTStrb when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_UseTStrb { PARAM_VALUE.g_UseTStrb } {
	# Procedure called to validate g_UseTStrb
	return true
}


proc update_MODELPARAM_VALUE.g_NumByteLanes { MODELPARAM_VALUE.g_NumByteLanes PARAM_VALUE.g_NumByteLanes } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_NumByteLanes}] ${MODELPARAM_VALUE.g_NumByteLanes}
}

proc update_MODELPARAM_VALUE.g_UseTKeep { MODELPARAM_VALUE.g_UseTKeep PARAM_VALUE.g_UseTKeep } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_UseTKeep}] ${MODELPARAM_VALUE.g_UseTKeep}
}

proc update_MODELPARAM_VALUE.g_UseTStrb { MODELPARAM_VALUE.g_UseTStrb PARAM_VALUE.g_UseTStrb } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_UseTStrb}] ${MODELPARAM_VALUE.g_UseTStrb}
}

proc update_MODELPARAM_VALUE.g_TUserWidth { MODELPARAM_VALUE.g_TUserWidth PARAM_VALUE.g_TUserWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_TUserWidth}] ${MODELPARAM_VALUE.g_TUserWidth}
}

proc update_MODELPARAM_VALUE.g_TIdWidth { MODELPARAM_VALUE.g_TIdWidth PARAM_VALUE.g_TIdWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_TIdWidth}] ${MODELPARAM_VALUE.g_TIdWidth}
}

proc update_MODELPARAM_VALUE.g_TDestWidth { MODELPARAM_VALUE.g_TDestWidth PARAM_VALUE.g_TDestWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_TDestWidth}] ${MODELPARAM_VALUE.g_TDestWidth}
}

proc update_MODELPARAM_VALUE.g_NofInitiators { MODELPARAM_VALUE.g_NofInitiators PARAM_VALUE.g_NofInitiators } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_NofInitiators}] ${MODELPARAM_VALUE.g_NofInitiators}
}

