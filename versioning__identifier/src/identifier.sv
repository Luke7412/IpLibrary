//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


module identifier #(
  parameter  bit [15:0][7:0] NAME          = "TEST",
  parameter  bit [15:0]      MAJOR_VERSION = 1,
  parameter  bit [15:0]      MINOR_VERSION = 0
) (
  input  logic        aclk,
  input  logic        aresetn,
  input  logic        ctrl_arvalid,
  output logic        ctrl_arready,
  input  logic [11:0] ctrl_araddr,
  output logic        ctrl_rvalid,
  input  logic        ctrl_rready,
  output logic [31:0] ctrl_rdata,
  output logic [1:0]  ctrl_rresp
);


  //----------------------------------------------------------------------------  
  localparam bit [0:3][31:0] NAME_ARR = NAME;


  //----------------------------------------------------------------------------
  always_ff @ (posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      ctrl_rvalid <= '0;

    end else begin
      // Read Handshake
      if (ctrl_arvalid && ctrl_arready) begin
        ctrl_rvalid <= '1;

        case ({ctrl_araddr[11:2], 2'b00})
          'h004   : ctrl_rdata <= NAME_ARR[0];
          'h008   : ctrl_rdata <= NAME_ARR[1];
          'h00C   : ctrl_rdata <= NAME_ARR[2];
          'h010   : ctrl_rdata <= NAME_ARR[3];
          'h014   : ctrl_rdata <= {MAJOR_VERSION, MINOR_VERSION};
          default : ctrl_rdata <= '0;
        endcase

      end else if (ctrl_rvalid && ctrl_rready) begin
        ctrl_rvalid <= '0;
      end

    end
  end


  assign ctrl_rresp = '0;

  assign ctrl_arready = !ctrl_rvalid;
  

endmodule
