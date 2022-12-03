
proc init { cell_name args } {

   bd::mark_propagate_only [get_bd_cells $cell_name] "g_AClkFrequency"

}


proc post_config_ip { cell_name args } {

}


proc propagate { cell_name {prop_info {}} } { 
   puts $prop_info

   set ip   [get_bd_cells $cell_name]

   set AClk [get_bd_pins $cell_name/AClk]
   set freq [get_property CONFIG.FREQ_HZ $AClk]

   set_property CONFIG.g_AClkFrequency $freq $ip

}

ifx_debug_trace_setup
