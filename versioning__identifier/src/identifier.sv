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
  typedef logic [0:15][7:0] t_name_arr;
  localparam t_name_arr NAME_ARR = t_name_arr'(NAME);
  
  localparam logic [31:0] HASH = 'h`include "identifier.hash";


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
          'h04    : ctrl_rdata <= NAME_ARR[0:3];
          'h08    : ctrl_rdata <= NAME_ARR[4:7];
          'h0C    : ctrl_rdata <= NAME_ARR[8:11];
          'h10    : ctrl_rdata <= NAME_ARR[12:15];
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
