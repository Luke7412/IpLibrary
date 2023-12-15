//------------------------------------------------------------------------------
// Project Name   : IpLibrary
//------------------------------------------------------------------------------
// Author         : Lukas Vinkx (lvin)
// Description: 
//------------------------------------------------------------------------------


module vga #(
  parameter int DEFAULT_CONFIG = 3
)( 
  input  logic            aclk,
  input  logic            aresetn,
  // AXI4-Lite Interface
  input  logic            ctrl_arvalid,
  output logic            ctrl_arready,
  input  logic [11:0]     ctrl_araddr,
  output logic            ctrl_rvalid,
  input  logic            ctrl_rready,
  output logic [31:0]     ctrl_rdata,
  output logic [1:0]      ctrl_rresp,
  input  logic            ctrl_awvalid,
  output logic            ctrl_awready,
  input  logic [11:0]     ctrl_awaddr,
  input  logic            ctrl_wvalid,
  output logic            ctrl_wready,
  input  logic [31:0]     ctrl_wdata,
  input  logic [3:0]      ctrl_wstrb,
  output logic            ctrl_bvalid,
  input  logic            ctrl_bready,
  output logic [1:0]      ctrl_bresp,
  // AXI4-Stream Video
  input  logic            pix_tvalid,
  output logic            pix_tready,
  input  logic [2:0][7:0] pix_tdata,
  input  logic            pix_tlast,
  input  logic            pix_tuser,
  // VGA Interface
  output logic            vga_vsync,
  output logic            vga_hsync,
  output logic [3:0]      vga_red, 
  output logic [3:0]      vga_green, 
  output logic [3:0]      vga_blue
);


  //----------------------------------------------------------------------------
  logic [15:0] h_res;
  logic [15:0] h_front_porch;
  logic [15:0] h_sync_pulse;
  logic [15:0] h_back_porch;
  logic [15:0] v_res;
  logic [15:0] v_front_porch;
  logic [15:0] v_sync_pulse;
  logic [15:0] v_back_porch;


  logic [15:0] h_cnt;
  logic [15:0] v_cnt;

  enum {H_BLANK, H_FP, H_PIX, H_BP} h_state;
  enum {V_BLANK, V_FP, V_PIX, V_BP} v_state;

  logic vga_vsync_q;
  logic synced;
  logic flush;
  logic load_pix;


  //----------------------------------------------------------------------------
  vga_reg_intf #(
    .DEFAULT_CONFIG (DEFAULT_CONFIG)
  ) i_vga_reg_intf (
    .aclk           (aclk),
    .aresetn        (aresetn),
    // AXI4-Lite Interface
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
    // Regs
    .h_res          (h_res),
    .h_front_porch  (h_front_porch),
    .h_sync_pulse   (h_sync_pulse),
    .h_back_porch   (h_back_porch),
    .v_res          (v_res),
    .v_front_porch  (v_front_porch),
    .v_sync_pulse   (v_sync_pulse),
    .v_back_porch   (v_back_porch)
  );


  vga_core i_vga_core ( 
    .aclk           (aclk),
    .aresetn        (aresetn),
    // Timing Control
    .h_res          (h_res),
    .h_front_porch  (h_front_porch),
    .h_sync_pulse   (h_sync_pulse),
    .h_back_porch   (h_back_porch),
    .v_res          (v_res),
    .v_front_porch  (v_front_porch),
    .v_sync_pulse   (v_sync_pulse),
    .v_back_porch   (v_back_porch),
    // AXI4-Stream Video
    .pix_tvalid     (pix_tvalid),
    .pix_tready     (pix_tready),
    .pix_tdata      (pix_tdata),
    .pix_tlast      (pix_tlast),
    .pix_tuser      (pix_tuser),
    // VGA Interface
    .vga_vsync      (vga_vsync),
    .vga_hsync      (vga_hsync),
    .vga_red        (vga_red), 
    .vga_green      (vga_green), 
    .vga_blue       (vga_blue)
  );


endmodule