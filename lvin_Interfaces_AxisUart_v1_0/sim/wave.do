onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /axisuart_tb/ClockEnable
add wave -noupdate /axisuart_tb/AClk
add wave -noupdate /axisuart_tb/AResetn
add wave -noupdate /axisuart_tb/In_TValid
add wave -noupdate /axisuart_tb/In_TReady
add wave -noupdate /axisuart_tb/In_TData
add wave -noupdate /axisuart_tb/In_TKeep
add wave -noupdate /axisuart_tb/Out_TValid
add wave -noupdate /axisuart_tb/Out_TReady
add wave -noupdate /axisuart_tb/Out_TData
add wave -noupdate /axisuart_tb/Uart_Txd
add wave -noupdate /axisuart_tb/Uart_Rxd
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1287797157924 fs} 0} {{Cursor 2} {1354395000000 fs} 0}
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
WaveRestoreZoom {0 fs} {9087380360849 fs}
