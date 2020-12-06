
set_property ASYNC_REG true [get_cells {req_sync2_pgen/i_sync/sync_reg[*]}]
set_property ASYNC_REG true [get_cells {ack_sync2_pgen/i_sync/sync_reg[*]}]

set_false_path -to [get_pins {*/i_sync/sync_reg[0]/D}]

set_max_delay -datapath_only -from [get_pins {TData_reg[*]/C}] -to [get_pins {Dest_TData_reg[*]/D}] 5.0