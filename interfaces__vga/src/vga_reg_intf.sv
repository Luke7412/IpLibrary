//------------------------------------------------------------------------------
// Project Name   : IpLibrary
//------------------------------------------------------------------------------
// Author         : Lukas Vinkx (lvin)
// Description: 
//------------------------------------------------------------------------------


module vga_reg_intf
  import vga_pkg::*;
#(
  parameter int DEFAULT_CONFIG = 3
)( 
  input  logic        aclk,
  input  logic        aresetn,
  // AXI4-Lite Interface
  input  logic        ctrl_arvalid,
  output logic        ctrl_arready,
  input  logic [11:0] ctrl_araddr,
  output logic        ctrl_rvalid,
  input  logic        ctrl_rready,
  output logic [31:0] ctrl_rdata,
  output logic [1:0]  ctrl_rresp,
  input  logic        ctrl_awvalid,
  output logic        ctrl_awready,
  input  logic [11:0] ctrl_awaddr,
  input  logic        ctrl_wvalid,
  output logic        ctrl_wready,
  input  logic [31:0] ctrl_wdata,
  input  logic [3:0]  ctrl_wstrb,
  output logic        ctrl_bvalid,
  input  logic        ctrl_bready,
  output logic [1:0]  ctrl_bresp,
  // Regs
  output logic [15:0] h_res,
  output logic [15:0] h_front_porch,
  output logic [15:0] h_sync_pulse,
  output logic [15:0] h_back_porch,
  output logic [15:0] v_res,
  output logic [15:0] v_front_porch,
  output logic [15:0] v_sync_pulse,
  output logic [15:0] v_back_porch
);


  //----------------------------------------------------------------------------
  always_ff @(posedge aclk or negedge aresetn) begin 
    if (!aresetn) begin
      ctrl_rvalid <= '0;
      ctrl_bvalid <= '0;
      ctrl_rdata  <= '0;
      
      h_res         <= vga_configs[DEFAULT_CONFIG].H_RES;
      h_front_porch <= vga_configs[DEFAULT_CONFIG].H_FRONT_PORCH;
      h_sync_pulse  <= vga_configs[DEFAULT_CONFIG].H_SYNC_PULSE;
      h_back_porch  <= vga_configs[DEFAULT_CONFIG].H_BACK_PORCH;
      v_res         <= vga_configs[DEFAULT_CONFIG].V_RES;
      v_front_porch <= vga_configs[DEFAULT_CONFIG].V_FRONT_PORCH;
      v_sync_pulse  <= vga_configs[DEFAULT_CONFIG].V_SYNC_PULSE;
      v_back_porch  <= vga_configs[DEFAULT_CONFIG].V_BACK_PORCH;

    end else begin
      
      // Read Handshake/Data
      if (ctrl_arvalid && ctrl_arready) begin
        ctrl_rvalid <= '1;
      
        unique case ({ctrl_araddr[11:2], 2'b00})
          'h000   : ctrl_rdata <= 'hDEADBEEF;
          'h010   : ctrl_rdata <= h_res;
          'h014   : ctrl_rdata <= h_front_porch;
          'h018   : ctrl_rdata <= h_sync_pulse;
          'h01C   : ctrl_rdata <= h_back_porch;
          'h020   : ctrl_rdata <= v_res;
          'h024   : ctrl_rdata <= v_front_porch;
          'h028   : ctrl_rdata <= v_sync_pulse;
          'h02C   : ctrl_rdata <= v_back_porch;
          default : ctrl_rdata <= '0;
        endcase

      end else if (ctrl_rvalid && ctrl_rready) begin
        ctrl_rvalid <= '0;
      end


      // Write Handshake/Data
      if (ctrl_awvalid && ctrl_awready && ctrl_wvalid && ctrl_wready) begin
        ctrl_bvalid <= '1;
 
         unique case ({ctrl_araddr[11:2], 2'b00})
          'h000   : ;   // Readonly
          'h010   : h_res         <= ctrl_wdata;
          'h014   : h_front_porch <= ctrl_wdata;
          'h018   : h_sync_pulse  <= ctrl_wdata;
          'h01C   : h_back_porch  <= ctrl_wdata;
          'h020   : v_res         <= ctrl_wdata;
          'h024   : v_front_porch <= ctrl_wdata;
          'h028   : v_sync_pulse  <= ctrl_wdata;
          'h02C   : v_back_porch  <= ctrl_wdata;
          default : ;
        endcase

      end else if (ctrl_bvalid && ctrl_bready) begin
        ctrl_bvalid <= '0;
      end

    end
  end


  assign ctrl_arready = !ctrl_rvalid;
  assign ctrl_awready = ctrl_wvalid  && !ctrl_bvalid;
  assign ctrl_wready  = ctrl_awvalid && !ctrl_bvalid;
  
  assign ctrl_rresp = '0;
  assign ctrl_bresp = '0;


endmodule