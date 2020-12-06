
create_clock -period 7.000 -name Dest_AClk   -waveform {0.000 3.500} [get_ports Dest_AClk]
create_clock -period 5.000 -name Source_AClk -waveform {0.000 2.500} [get_ports Source_AClk]
