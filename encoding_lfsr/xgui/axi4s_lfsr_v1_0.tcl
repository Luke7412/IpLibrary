# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  #Adding Group
  set Mode [ipgui::add_group $IPINST -name "Mode" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "CHK_NOT_GEN" -parent ${Mode} -widget comboBox

  #Adding Group
  set lfsr [ipgui::add_group $IPINST -name "lfsr" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "IMPLEMENTATION" -parent ${lfsr} -widget comboBox
  ipgui::add_param $IPINST -name "POLY_DEGREE" -parent ${lfsr}
  ipgui::add_param $IPINST -name "POLYNOMIAL" -parent ${lfsr}
  ipgui::add_param $IPINST -name "SEED" -parent ${lfsr}

  #Adding Group
  set Interface [ipgui::add_group $IPINST -name "Interface" -parent ${Page_0}]
  ipgui::add_param $IPINST -name "TDATA_WIDTH" -parent ${Interface}



}

proc update_PARAM_VALUE.CHK_NOT_GEN { PARAM_VALUE.CHK_NOT_GEN } {
	# Procedure called to update CHK_NOT_GEN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CHK_NOT_GEN { PARAM_VALUE.CHK_NOT_GEN } {
	# Procedure called to validate CHK_NOT_GEN
	return true
}

proc update_PARAM_VALUE.IMPLEMENTATION { PARAM_VALUE.IMPLEMENTATION } {
	# Procedure called to update IMPLEMENTATION when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IMPLEMENTATION { PARAM_VALUE.IMPLEMENTATION } {
	# Procedure called to validate IMPLEMENTATION
	return true
}

proc update_PARAM_VALUE.POLYNOMIAL { PARAM_VALUE.POLYNOMIAL } {
	# Procedure called to update POLYNOMIAL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.POLYNOMIAL { PARAM_VALUE.POLYNOMIAL } {
	# Procedure called to validate POLYNOMIAL
	return true
}

proc update_PARAM_VALUE.POLY_DEGREE { PARAM_VALUE.POLY_DEGREE } {
	# Procedure called to update POLY_DEGREE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.POLY_DEGREE { PARAM_VALUE.POLY_DEGREE } {
	# Procedure called to validate POLY_DEGREE
	return true
}

proc update_PARAM_VALUE.SEED { PARAM_VALUE.SEED } {
	# Procedure called to update SEED when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SEED { PARAM_VALUE.SEED } {
	# Procedure called to validate SEED
	return true
}

proc update_PARAM_VALUE.TDATA_WIDTH { PARAM_VALUE.TDATA_WIDTH } {
	# Procedure called to update TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TDATA_WIDTH { PARAM_VALUE.TDATA_WIDTH } {
	# Procedure called to validate TDATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.POLY_DEGREE { MODELPARAM_VALUE.POLY_DEGREE PARAM_VALUE.POLY_DEGREE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.POLY_DEGREE}] ${MODELPARAM_VALUE.POLY_DEGREE}
}

proc update_MODELPARAM_VALUE.POLYNOMIAL { MODELPARAM_VALUE.POLYNOMIAL PARAM_VALUE.POLYNOMIAL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.POLYNOMIAL}] ${MODELPARAM_VALUE.POLYNOMIAL}
}

proc update_MODELPARAM_VALUE.SEED { MODELPARAM_VALUE.SEED PARAM_VALUE.SEED } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SEED}] ${MODELPARAM_VALUE.SEED}
}

proc update_MODELPARAM_VALUE.TDATA_WIDTH { MODELPARAM_VALUE.TDATA_WIDTH PARAM_VALUE.TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TDATA_WIDTH}] ${MODELPARAM_VALUE.TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.IMPLEMENTATION { MODELPARAM_VALUE.IMPLEMENTATION PARAM_VALUE.IMPLEMENTATION } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IMPLEMENTATION}] ${MODELPARAM_VALUE.IMPLEMENTATION}
}

proc update_MODELPARAM_VALUE.CHK_NOT_GEN { MODELPARAM_VALUE.CHK_NOT_GEN PARAM_VALUE.CHK_NOT_GEN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CHK_NOT_GEN}] ${MODELPARAM_VALUE.CHK_NOT_GEN}
}

