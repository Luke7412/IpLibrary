
//------------------------------------------------------------------------------
module vga_wpr #(
  DEFAULT_CONFIG = 3
)( 
  input  aclk,
  input  aresetn,
  // AXI4-Lite Interface
  input         ctrl_arvalid,
  output        ctrl_arready,
  input  [11:0] ctrl_araddr,
  output        ctrl_rvalid,
  input         ctrl_rready,
  output [31:0] ctrl_rdata,
  output [1:0]  ctrl_rresp,
  input         ctrl_awvalid,
  output        ctrl_awready,
  input  [11:0] ctrl_awaddr,
  input         ctrl_wvalid,
  output        ctrl_wready,
  input  [31:0] ctrl_wdata,
  input  [3:0]  ctrl_wstrb,
  output        ctrl_bvalid,
  input         ctrl_bready,
  output [1:0]  ctrl_bresp,
  // AXI4-Stream Video
  input              pix_tvalid,
  output             pix_tready,
  input  [2:0][7:0]  pix_tdata,
  input              pix_tlast,
  input              pix_tuser,
  // VGA Interface
  output       vga_vsync,
  output       vga_hsync,
  output [3:0] vga_red,
  output [3:0] vga_green,
  output [3:0] vga_blue
);


  //----------------------------------------------------------------------------
  vga #(
    .DEFAULT_CONFIG(DEFAULT_CONFIG)
  ) i_vga ( 
    .aclk           (aclk),
    .aresetn        (aresetn),
    .ctrl_arvalid   (ctrl_arvalid),
    .ctrl_arready   (ctrl_arready),
    .ctrl_araddr    (ctrl_araddr),
    .ctrl_rvalid    (ctrl_rvalid),
    .ctrl_rready    (ctrl_rready),
    .ctrl_rdata     (ctrl_rdata),
    .ctrl_rresp     (ctrl_rresp),
    .ctrl_awvalid   (ctrl_awvalid),
    .ctrl_awready   (ctrl_awready),
    .ctrl_awaddr    (ctrl_awaddr),
    .ctrl_wvalid    (ctrl_wvalid),
    .ctrl_wready    (ctrl_wready),
    .ctrl_wdata     (ctrl_wdata),
    .ctrl_wstrb     (ctrl_wstrb),
    .ctrl_bvalid    (ctrl_bvalid),
    .ctrl_bready    (ctrl_bready),
    .ctrl_bresp     (ctrl_bresp),
    .pix_tvalid     (pix_tvalid),
    .pix_tready     (pix_tready),
    .pix_tdata      (pix_tdata),
    .pix_tlast      (pix_tlast),
    .pix_tuser      (pix_tuser),
    .vga_vsync      (vga_vsync),
    .vga_hsync      (vga_hsync),
    .vga_red        (vga_red), 
    .vga_green      (vga_green), 
    .vga_blue       (vga_blue)
  );

endmodule