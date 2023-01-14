
//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


module rst_sync #(
  parameter int DEPTH = 2
)(
  // src domain
  input  logic src_rst_n,
  // dst domain
  input  logic dst_clk,
  output logic dst_rst_n
);


  //----------------------------------------------------------------------------
  logic [0:DEPTH-1] shift_data;


  //----------------------------------------------------------------------------
  always_ff @(posedge dst_clk or negedge src_rst_n) begin
    if (!src_rst_n) begin
      shift_data <= '0;
    end else begin
      shift_data <= {1'b1, shift_data} >> 1;
    end
  end

  assign dst_rst_n = shift_data[DEPTH-1];


endmodule