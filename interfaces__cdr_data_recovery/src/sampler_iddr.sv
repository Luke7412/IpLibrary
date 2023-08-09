//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
module sampler_iddr(
  input  logic       clk,
  input  logic       rst_n,
  input  logic       in_data,
  output logic [3:0] out_data
);


  //----------------------------------------------------------------------------
  logic q2, q1;
  logic [0:0] shift_cnt;
  logic [3:0] shift_reg;


  //----------------------------------------------------------------------------
  IDDR #(
    .DDR_CLK_EDGE ("SAME_EDGE_PIPELINED"),
    .INIT_Q1      ('0),
    .INIT_Q2      ('0),
    .SRTYPE       ("SYNC")
    ) i_IDDR (
    .Q1 (q1),
    .Q2 (q2),
    .C  (clk),
    .CE ('1),
    .D  (in_data),
    .R  ('0),
    .S  ('0)
  );


  always_ff @ (posedge clk or negedge rst_n) begin : p_sampling
    if (!rst_n) begin
      shift_cnt <= '0;

    end else begin
      shift_cnt <= shift_cnt + 1;
      shift_reg <= {q2, q1, shift_reg} >> 2;

      if (shift_cnt == 0) begin
        out_data <= shift_reg;
      end 
    end
  end



endmodule