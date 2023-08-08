//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
module sampler_2x (
  input  logic       clk,
  input  logic       rst_n,
  input  logic       in_data,
  output logic       out_valid,
  output logic [3:0] out_data
);


  //----------------------------------------------------------------------------
  logic [0:0] shift_cnt;
  logic [3:0] shift_reg_neg;
  logic [3:0] shift_reg_pos;


  //----------------------------------------------------------------------------
  always_ff @ (negedge clk) begin : p_sampling_neg
    shift_reg_neg <= {in_data, shift_reg_neg} >> 1;
  end


  always_ff @ (posedge clk or negedge rst_n) begin : p_sampling_pos
    if (!rst_n) begin 
      shift_cnt <= '1;
      out_valid <= '0;

    end else begin
      shift_cnt     <= shift_cnt - 1;
      shift_reg_pos <= {in_data, shift_reg_pos} >> 1;

      if (shift_cnt == 0) begin
        out_valid <= '1;
        out_data  <= {shift_reg_neg[1], shift_reg_pos[1], 
          shift_reg_neg[0], shift_reg_pos[0]};
      end else begin
        out_valid <= '0;
      end
    end
   end


endmodule