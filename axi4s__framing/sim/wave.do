onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /framing_tb/AClk
add wave -noupdate /framing_tb/AResetn
add wave -noupdate -expand -group TxFrame /framing_tb/Dut/TxFrame_TValid
add wave -noupdate -expand -group TxFrame /framing_tb/Dut/TxFrame_TReady
add wave -noupdate -expand -group TxFrame /framing_tb/Dut/TxFrame_TData
add wave -noupdate -expand -group TxFrame /framing_tb/Dut/TxFrame_TLast
add wave -noupdate -expand -group Escaped /framing_tb/Dut/Escaped_TValid
add wave -noupdate -expand -group Escaped /framing_tb/Dut/Escaped_TReady
add wave -noupdate -expand -group Escaped /framing_tb/Dut/Escaped_TData
add wave -noupdate -expand -group Escaped /framing_tb/Dut/Escaped_TLast
add wave -noupdate -expand -group TxByte /framing_tb/Dut/TxByte_TValid
add wave -noupdate -expand -group TxByte /framing_tb/Dut/TxByte_TReady
add wave -noupdate -expand -group TxByte /framing_tb/Dut/TxByte_TData
add wave -noupdate /framing_tb/Dut/i_InsertEscape/IsFromPacket
add wave -noupdate /framing_tb/Dut/i_InsertEscape/IsToPacket
add wave -noupdate /framing_tb/Dut/i_InsertEscape/Match
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {343790718 fs} 0}
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
WaveRestoreZoom {635741909 fs} {861276742 fs}
