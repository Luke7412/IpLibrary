onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /testrunner/tb_ts/frequency_meter_ut/DUT/aclk
add wave -noupdate /testrunner/tb_ts/frequency_meter_ut/DUT/aresetn
add wave -noupdate /testrunner/tb_ts/frequency_meter_ut/DUT/us_pulse
add wave -noupdate /testrunner/tb_ts/frequency_meter_ut/DUT/div_toggle
add wave -noupdate /testrunner/tb_ts/frequency_meter_ut/DUT/req
add wave -noupdate /testrunner/tb_ts/frequency_meter_ut/DUT/req_sync
add wave -noupdate /testrunner/tb_ts/frequency_meter_ut/DUT/req_pulse
add wave -noupdate /testrunner/tb_ts/frequency_meter_ut/DUT/ack
add wave -noupdate /testrunner/tb_ts/frequency_meter_ut/DUT/ack_sync
add wave -noupdate /testrunner/tb_ts/frequency_meter_ut/DUT/ack_pulse
add wave -noupdate /testrunner/tb_ts/frequency_meter_ut/DUT/reg_freq_cnt
add wave -noupdate /testrunner/tb_ts/frequency_meter_ut/DUT/reg_freq_overflow
add wave -noupdate /testrunner/tb_ts/frequency_meter_ut/DUT/sen_clk
add wave -noupdate /testrunner/tb_ts/frequency_meter_ut/DUT/sen_rst_n
add wave -noupdate /testrunner/tb_ts/frequency_meter_ut/DUT/i_rst_sync/i_dff_sync/shift_data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1065 ns} 0} {{Cursor 2} {150 ns} 0}
quietly wave cursor active 2
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {4789 ns}
