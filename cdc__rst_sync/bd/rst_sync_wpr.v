
//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


module rst_sync_wpr #(
  parameter DEPTH = 2
)(
  input  src_rst_n,
  input  dst_clk,
  output dst_rst_n
);


  //----------------------------------------------------------------------------
  rst_sync #(
    .DEPTH   (DEPTH)
  ) i_rst_sync (
    .src_data  (src_rst_n),
    .dst_clk   (dst_clk),
    .dst_rst_n (dst_rst_n)
  );

endmodule