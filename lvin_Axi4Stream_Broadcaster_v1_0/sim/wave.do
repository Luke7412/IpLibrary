onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /broadcaster_tb/DUT/AClk
add wave -noupdate /broadcaster_tb/DUT/AResetn
add wave -noupdate -expand -group Target /broadcaster_tb/DUT/Target_TValid
add wave -noupdate -expand -group Target /broadcaster_tb/DUT/Target_TReady
add wave -noupdate -expand -group Target /broadcaster_tb/DUT/Target_TData
add wave -noupdate -expand -group Target /broadcaster_tb/DUT/Target_TStrb
add wave -noupdate -expand -group Target /broadcaster_tb/DUT/Target_TKeep
add wave -noupdate -expand -group Target /broadcaster_tb/DUT/Target_TUser
add wave -noupdate -expand -group Target /broadcaster_tb/DUT/Target_TId
add wave -noupdate -expand -group Target /broadcaster_tb/DUT/Target_TDest
add wave -noupdate -expand -group Target /broadcaster_tb/DUT/Target_TLast
add wave -noupdate -expand -group Initiator /broadcaster_tb/DUT/Initiator_TValid
add wave -noupdate -expand -group Initiator /broadcaster_tb/DUT/Initiator_TReady
add wave -noupdate -expand -group Initiator /broadcaster_tb/DUT/Initiator_TData
add wave -noupdate -expand -group Initiator /broadcaster_tb/DUT/Initiator_TStrb
add wave -noupdate -expand -group Initiator /broadcaster_tb/DUT/Initiator_TKeep
add wave -noupdate -expand -group Initiator /broadcaster_tb/DUT/Initiator_TUser
add wave -noupdate -expand -group Initiator /broadcaster_tb/DUT/Initiator_TId
add wave -noupdate -expand -group Initiator /broadcaster_tb/DUT/Initiator_TDest
add wave -noupdate -expand -group Initiator /broadcaster_tb/DUT/Initiator_TLast
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 fs} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 fs} {1 ps}
