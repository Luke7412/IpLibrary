//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


module identifier #(
  parameter string   NAME           = "TEST",
  parameter bit[15:0] MAJOR_VERSION = 1,
  parameter bit[15:0] MINOR_VERSION = 0
) (
  input  logic        aclk,
  input  logic        aresetn,
  input  logic        ctrl_arvalid,
  output logic        ctrl_arready,
  input  logic [7:0]  ctrl_araddr,
  output logic        ctrl_rvalid,
  input  logic        ctrl_rready,
  output logic [31:0] ctrl_rdata,
  output logic [1:0]  ctrl_rresp
);


  //----------------------------------------------------------------------------
  localparam logic [31:0] HASH = 'h`include "identifier.hash";

  
  localparam string PADDED_NAME = {NAME, {16{" "}}};
  localparam logic [15:0][7:0] CASTED = 128'(PADDED_NAME.substr(0, 15));
  logic [3:0][31:0] NAME_ARR;


  always_comb begin
    NAME_ARR = {<<8{CASTED}};
  end


  //----------------------------------------------------------------------------
  always_ff @ (posedge aclk or negedge aresetn) begin
    logic [7:0] v_addr;

    if (!aresetn) begin
      ctrl_rvalid <= '0;

    end else begin
      // Read Handshake
      if (ctrl_arvalid && ctrl_arready) begin
        v_addr = {ctrl_araddr[7:2], 2'b00};
        ctrl_rvalid <= '1;
        ctrl_rresp  <= 2'b00;

        case (ctrl_araddr)
          'h00    : ctrl_rdata <= HASH;
          'h04    : ctrl_rdata <= NAME_ARR[0];
          'h08    : ctrl_rdata <= NAME_ARR[1];
          'h0C    : ctrl_rdata <= NAME_ARR[2];
          'h10    : ctrl_rdata <= NAME_ARR[3];
          'h14    : ctrl_rdata <= {MAJOR_VERSION, MINOR_VERSION};
          default : begin
            ctrl_rdata <= '0;
            ctrl_rresp <= 2'b10; 
          end
        endcase

      end else if (ctrl_rvalid && ctrl_rready) begin
        ctrl_rvalid <= '0;
      end

    end
  end


  assign ctrl_arready = !ctrl_rvalid;
  

endmodule
