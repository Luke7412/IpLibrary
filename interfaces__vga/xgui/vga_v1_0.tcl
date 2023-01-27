
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/vga_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "Resolution" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "InputClock" -parent ${Page_0}


}

proc update_PARAM_VALUE.InputClock { PARAM_VALUE.InputClock PARAM_VALUE.Resolution } {
	# Procedure called to update InputClock when any of the dependent parameters in the arguments change
	
	set InputClock ${PARAM_VALUE.InputClock}
	set Resolution ${PARAM_VALUE.Resolution}
	set values(Resolution) [get_property value $Resolution]
	set_property value [gen_USERPARAMETER_InputClock_VALUE $values(Resolution)] $InputClock
}

proc validate_PARAM_VALUE.InputClock { PARAM_VALUE.InputClock } {
	# Procedure called to validate InputClock
	return true
}

proc update_PARAM_VALUE.Resolution { PARAM_VALUE.Resolution } {
	# Procedure called to update Resolution when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Resolution { PARAM_VALUE.Resolution } {
	# Procedure called to validate Resolution
	return true
}


proc update_MODELPARAM_VALUE.RESOLUTION { MODELPARAM_VALUE.RESOLUTION PARAM_VALUE.Resolution } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Resolution}] ${MODELPARAM_VALUE.RESOLUTION}
}

