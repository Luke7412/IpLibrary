//------------------------------------------------------------------------------
// Project Name   : IpLibrary
// Design Name    : Regbank
// File Name      : Regbank.vhd
//------------------------------------------------------------------------------
// Author         : Lukas Vinkx
// Description: 
//------------------------------------------------------------------------------


module axi4lite_regbank #(
  parameter int NOF_REGOUT = 4,
  parameter int NOF_REGIN  = 4
)( 
  input  logic        aclk,
  input  logic        aresetn,
  
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
    
  output logic [31:0] reg_out [NOF_REGOUT],
  input  logic [31:0] reg_in  [NOF_REGIN ]
);


  //----------------------------------------------------------------------------
  always_ff @(posedge aclk or negedge aresetn) begin
    logic [9:0] v_address;
  
    if (!aresetn) begin
      ctrl_rvalid <= '0;
      ctrl_bvalid <= '0;
      reg_out     <= '{default:'0};

    end else begin
      
      // Read Handshake/Data
      if (ctrl_arvalid && ctrl_arready) begin
        v_address = ctrl_araddr[11:2];
        ctrl_rvalid <= '1;
      
        if (v_address[0]) begin               
          ctrl_rdata <= reg_out[v_address[9:1]];
        end else begin
          ctrl_rdata <= reg_in[v_address[9:1]];
        end

      end else if (ctrl_rvalid && ctrl_rready) begin
        ctrl_rvalid <= '0;
      end


      // Write Handshake/Data
      if (ctrl_awvalid && ctrl_awready && ctrl_wvalid && ctrl_wready) begin
        v_address = ctrl_awaddr[11:2];
        ctrl_bvalid <= '1;
        
        if (v_address[0]) begin               
          reg_out[v_address[9:1]] <= ctrl_wdata;
        end

      end else if (ctrl_bvalid && ctrl_bready) begin
        ctrl_bvalid <= '0;
      end

    end
  end


  assign ctrl_arready = !ctrl_rvalid;
  assign ctrl_awready = ctrl_wvalid  && !ctrl_bvalid;
  assign ctrl_wready  = ctrl_awvalid && !ctrl_bvalid;
  
endmodule