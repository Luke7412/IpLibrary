
proc init { cell_name undefined_params } {
  set_property BRIDGES {Master} [get_bd_intf_pins $cell_name/Slave]
}


proc post_config_ip { cell_name args } {

}


proc propagate { cell_name prop_info  } { 

}

ifx_debug_trace_setup
