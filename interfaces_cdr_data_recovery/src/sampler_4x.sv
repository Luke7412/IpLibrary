//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
module sampler_4x (
  input  logic       clk,
  input  logic       rst_n,
  input  logic       in_data,
  output logic       out_valid,
  output logic [3:0] out_data
);


  //----------------------------------------------------------------------------
  logic [1:0] shift_cnt;
  logic [3:0] shift_reg;

   
  //----------------------------------------------------------------------------
  always_ff @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      shift_cnt <= '1;
    else
      shift_cnt <= shift_cnt - 1;
      shift_reg <= {in_data, shift_reg} >> 1;
    end
  end

  assign out_valid = shift_cnt == 0; 
  assign out_data = shift_reg;


endmodule