
proc init { cell_name args } {
  bd::mark_propagate_only [get_bd_cells $cell_name] "ACLK_FREQUENCY"
}


proc post_config_ip { cell_name args } {
}


proc propagate { cell_name {prop_info {}} } { 
  puts $prop_info

  set ip   [get_bd_cells $cell_name]

  set aclk [get_bd_pins $cell_name/aclk]
  set freq [get_property CONFIG.FREQ_HZ $aclk]

  set_property CONFIG.ACLK_FREQUENCY $freq $ip
}
