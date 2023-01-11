
//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


module dff_sync #(
  parameter int DEPTH = 2,
  parameter bit RST_VAL = '0
)(
  // src domain
  input  logic src_data,
  // dst domain
  input  logic dst_clk,
  input  logic dst_rst_n,
  output logic dst_data
);


  //----------------------------------------------------------------------------
  logic [0:DEPTH-1] shift_data ;


  //----------------------------------------------------------------------------
  always_ff @(posedge dst_clk or negedge dst_rst_n) begin
    if (!dst_rst_n) begin
      shift_data <= {DEPTH{RST_VAL}};
    end else begin
      shift_data <= {src_data, shift_data} >> 1;
    end
  end

  assign dst_data = shift_data[DEPTH-1];


endmodule