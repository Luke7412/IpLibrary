
//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


module dmux_sync_wpr #(
  parameter DEPTH = 2,
  parameter WIDTH = 8,
  parameter RST_VAL = 1'b0
)(
  input              src_toggle,
  input  [WIDTH-1:0] src_data,
  input              dst_clk,
  input              dst_rst_n,
  output             dst_pulse,
  output [WIDTH-1:0] dst_data
);


  //----------------------------------------------------------------------------
  dmux_sync #(
    .DEPTH (DEPTH),
    .WIDTH (WIDTH),
    .RST_VAL (RST_VAL)
  ) i_dmux_sync (
    .src_toggle (src_toggle),
    .src_data (src_data),
    .dst_clk (dst_clk),
    .dst_rst_n (dst_rst_n),
    .dst_pulse (dst_pulse),
    .dst_data (dst_data)
  );

endmodule