onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand /axi4litevip_tb/Ctrl0
add wave -noupdate /axi4litevip_tb/Master/gen_Simulation/state
add wave -noupdate -expand /axi4litevip_tb/Ctrl1
add wave -noupdate /axi4litevip_tb/Passthrough/gen_Simulation/state
add wave -noupdate /axi4litevip_tb/i_Regbank/reg_array
add wave -noupdate /axi4litevip_tb/i_Regbank/Ctrl_ARValid
add wave -noupdate /axi4litevip_tb/i_Regbank/Ctrl_ARReady
add wave -noupdate /axi4litevip_tb/i_Regbank/Ctrl_ARAddr
add wave -noupdate /axi4litevip_tb/i_Regbank/Ctrl_RValid
add wave -noupdate /axi4litevip_tb/i_Regbank/Ctrl_RReady
add wave -noupdate /axi4litevip_tb/i_Regbank/Ctrl_RData
add wave -noupdate /axi4litevip_tb/i_Regbank/Ctrl_RResp
add wave -noupdate /axi4litevip_tb/i_Regbank/Ctrl_AWValid
add wave -noupdate /axi4litevip_tb/i_Regbank/Ctrl_AWReady
add wave -noupdate /axi4litevip_tb/i_Regbank/Ctrl_AWAddr
add wave -noupdate /axi4litevip_tb/i_Regbank/Ctrl_WValid
add wave -noupdate /axi4litevip_tb/i_Regbank/Ctrl_WReady
add wave -noupdate /axi4litevip_tb/i_Regbank/Ctrl_WData
add wave -noupdate /axi4litevip_tb/i_Regbank/Ctrl_WStrb
add wave -noupdate /axi4litevip_tb/i_Regbank/Ctrl_BValid
add wave -noupdate /axi4litevip_tb/i_Regbank/Ctrl_BReady
add wave -noupdate /axi4litevip_tb/i_Regbank/Ctrl_BResp
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {453813130 fs} 0}
quietly wave cursor active 1
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
configure wave -timelineunits fs
update
WaveRestoreZoom {225412951 fs} {793399319 fs}
