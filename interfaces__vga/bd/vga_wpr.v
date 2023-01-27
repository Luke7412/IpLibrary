
//------------------------------------------------------------------------------
module vga_wpr #(
  parameter RESOLUTION = 3
)( 
  input          aclk,
  input          aresetn,
  input               pix_tvalid,
  output              pix_tready,
  input   [2:0][3:0]  pix_tdata,
  input               pix_tlast,
  input               pix_tuser,
  output vsync,
  output hsync,
  output [3:0] r, 
  output [3:0] g, 
  output [3:0] b,
  output sof
);


  //----------------------------------------------------------------------------
  vga #(
    .RESOLUTION (RESOLUTION)
  ) I_vga (
    .aclk (aclk),
    .aresetn (aresetn),
    .pix_tvalid (pix_tvalid),
    .pix_tready (pix_tready),
    .pix_tdata (pix_tdata),
    .pix_tlast (pix_tlast),
    .pix_tuser (pix_tuser),
    .vsync (vsync),
    .hsync (hsync),
    .r (r), 
    .g (g), 
    .b (b),
    .sof (sof)
  );

endmodule