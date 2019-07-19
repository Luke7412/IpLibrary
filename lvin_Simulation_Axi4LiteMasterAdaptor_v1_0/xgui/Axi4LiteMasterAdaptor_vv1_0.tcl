# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "AddrWidth" -parent ${Page_0}
  ipgui::add_param $IPINST -name "IntfIndex" -parent ${Page_0}


}

proc update_PARAM_VALUE.AddrWidth { PARAM_VALUE.AddrWidth } {
	# Procedure called to update AddrWidth when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AddrWidth { PARAM_VALUE.AddrWidth } {
	# Procedure called to validate AddrWidth
	return true
}

proc update_PARAM_VALUE.IntfIndex { PARAM_VALUE.IntfIndex } {
	# Procedure called to update IntfIndex when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IntfIndex { PARAM_VALUE.IntfIndex } {
	# Procedure called to validate IntfIndex
	return true
}


proc update_MODELPARAM_VALUE.IntfIndex { MODELPARAM_VALUE.IntfIndex PARAM_VALUE.IntfIndex } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IntfIndex}] ${MODELPARAM_VALUE.IntfIndex}
}

proc update_MODELPARAM_VALUE.AddrWidth { MODELPARAM_VALUE.AddrWidth PARAM_VALUE.AddrWidth } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AddrWidth}] ${MODELPARAM_VALUE.AddrWidth}
}

