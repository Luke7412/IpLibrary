# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "g_Name" -parent ${Page_0}
  ipgui::add_param $IPINST -name "g_MajorVersion" -parent ${Page_0}
  ipgui::add_param $IPINST -name "g_MinorVersion" -parent ${Page_0}


}

proc update_PARAM_VALUE.g_MajorVersion { PARAM_VALUE.g_MajorVersion } {
	# Procedure called to update g_MajorVersion when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_MajorVersion { PARAM_VALUE.g_MajorVersion } {
	# Procedure called to validate g_MajorVersion
	return true
}

proc update_PARAM_VALUE.g_MinorVersion { PARAM_VALUE.g_MinorVersion } {
	# Procedure called to update g_MinorVersion when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_MinorVersion { PARAM_VALUE.g_MinorVersion } {
	# Procedure called to validate g_MinorVersion
	return true
}

proc update_PARAM_VALUE.g_Name { PARAM_VALUE.g_Name } {
	# Procedure called to update g_Name when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.g_Name { PARAM_VALUE.g_Name } {
	# Procedure called to validate g_Name
	return true
}


proc update_MODELPARAM_VALUE.g_Name { MODELPARAM_VALUE.g_Name PARAM_VALUE.g_Name } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_Name}] ${MODELPARAM_VALUE.g_Name}
}

proc update_MODELPARAM_VALUE.g_MajorVersion { MODELPARAM_VALUE.g_MajorVersion PARAM_VALUE.g_MajorVersion } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_MajorVersion}] ${MODELPARAM_VALUE.g_MajorVersion}
}

proc update_MODELPARAM_VALUE.g_MinorVersion { MODELPARAM_VALUE.g_MinorVersion PARAM_VALUE.g_MinorVersion } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.g_MinorVersion}] ${MODELPARAM_VALUE.g_MinorVersion}
}

