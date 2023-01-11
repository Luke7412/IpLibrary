
//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


module rst_sync #(
  parameter int DEPTH = 2,
  parameter bit RST_VAL = '0
)(
  // src domain
  input  logic src_rst_n,
  // dst domain
  input  logic dst_clk,
  output logic dst_rst_n
);


  //----------------------------------------------------------------------------


  //----------------------------------------------------------------------------
  dff_sync #(
    .DEPTH   (DEPTH),
    .RST_VAL (RST_VAL)
  ) i_dff_sync (
    .src_data  (!RST_VAL),
    .dst_clk   (dst_clk),
    .dst_rst_n (src_rst_n),
    .dst_data  (dst_rst_n)
  );


endmodule