
//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


module dff_sync_wpr #(
  parameter DEPTH = 2,
  parameter RST_VAL = 1'b0
)(
  input  src_data,
  input  dst_clk,
  input  dst_rst_n,
  output dst_data
);


  //----------------------------------------------------------------------------
  dff_sync #(
    .DEPTH (DEPTH),
    .RST_VAL (RST_VAL)
  ) i_dff_sync (
    .src_data (src_data),
    .dst_clk (dst_clk),
    .dst_rst_n (dst_rst_n),
    .dst_data (dst_data)
  );

endmodule