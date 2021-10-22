
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/PRBS_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "Mode" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "POLY_LENGTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "POLY_TAP" -parent ${Page_0}
  ipgui::add_param $IPINST -name "TDATA_WIDTH" -parent ${Page_0}
}

proc update_PARAM_VALUE.CHK_MODE { PARAM_VALUE.CHK_MODE PARAM_VALUE.Mode } {
	# Procedure called to update CHK_MODE when any of the dependent parameters in the arguments change
	
	set CHK_MODE ${PARAM_VALUE.CHK_MODE}
	set Mode ${PARAM_VALUE.Mode}
	set values(Mode) [get_property value $Mode]
	set_property value [gen_USERPARAMETER_CHK_MODE_VALUE $values(Mode)] $CHK_MODE
}

proc validate_PARAM_VALUE.CHK_MODE { PARAM_VALUE.CHK_MODE } {
	# Procedure called to validate CHK_MODE
	return true
}

proc update_PARAM_VALUE.Mode { PARAM_VALUE.Mode } {
	# Procedure called to update Mode when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Mode { PARAM_VALUE.Mode } {
	# Procedure called to validate Mode
	return true
}

proc update_PARAM_VALUE.POLY_LENGTH { PARAM_VALUE.POLY_LENGTH } {
	# Procedure called to update POLY_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.POLY_LENGTH { PARAM_VALUE.POLY_LENGTH } {
	# Procedure called to validate POLY_LENGTH
	return true
}

proc update_PARAM_VALUE.POLY_TAP { PARAM_VALUE.POLY_TAP } {
	# Procedure called to update POLY_TAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.POLY_TAP { PARAM_VALUE.POLY_TAP } {
	# Procedure called to validate POLY_TAP
	return true
}

proc update_PARAM_VALUE.TDATA_WIDTH { PARAM_VALUE.TDATA_WIDTH } {
	# Procedure called to update TDATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TDATA_WIDTH { PARAM_VALUE.TDATA_WIDTH } {
	# Procedure called to validate TDATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.CHK_MODE { MODELPARAM_VALUE.CHK_MODE PARAM_VALUE.CHK_MODE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CHK_MODE}] ${MODELPARAM_VALUE.CHK_MODE}
}

proc update_MODELPARAM_VALUE.POLY_TAP { MODELPARAM_VALUE.POLY_TAP PARAM_VALUE.POLY_TAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.POLY_TAP}] ${MODELPARAM_VALUE.POLY_TAP}
}

proc update_MODELPARAM_VALUE.TDATA_WIDTH { MODELPARAM_VALUE.TDATA_WIDTH PARAM_VALUE.TDATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TDATA_WIDTH}] ${MODELPARAM_VALUE.TDATA_WIDTH}
}

proc update_MODELPARAM_VALUE.POLY_LENGTH { MODELPARAM_VALUE.POLY_LENGTH PARAM_VALUE.POLY_LENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.POLY_LENGTH}] ${MODELPARAM_VALUE.POLY_LENGTH}
}

