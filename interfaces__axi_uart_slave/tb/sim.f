-sv -sv09compat

../../src/axis_uart_rx.sv
../../src/axis_uart_tx.sv
../../src/axis_uart.sv

../../../axi4s__framing/src/deescaper.sv
../../../axi4s__framing/src/escaper.sv
../../../axi4s__framing/src/framer.sv
../../../axi4s__framing/src/deframer.sv
../../../axi4s__framing/src/framing.sv

../../../axi4s__dest_packetizer/src/dest_extract.sv
../../../axi4s__dest_packetizer/src/dest_insert.sv
../../../axi4s__dest_packetizer/src/dest_packetizer.sv

../../src/axi4s_to_mem_mapped.sv
../../src/axi_uart_slave.sv


+incdir+../../../verification__uart_driver/src/
../../../verification__uart_driver/src/uart_intf.sv
../../../verification__uart_driver/src/uart_pkg.sv

+incdir+../../../verification__axi_uart_driver/src/
../../../verification__axi_uart_driver/src/axi_uart_pkg.sv