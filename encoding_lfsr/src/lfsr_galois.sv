

module lfsr_galois
  import lfsr_pkg::*;
#(
  parameter int                 POLY_DEGREE  = 7,
  parameter bit [POLY_DEGREE:1] POLYNOMIAL   = PRBS7,
  parameter int                 OUTPUT_WIDTH = 1,
  parameter bit                 CHK_NOT_GEN  = 0
)(
  input  logic [POLY_DEGREE:1]    state,
  output logic [POLY_DEGREE:1]    next_state,
  input  logic [OUTPUT_WIDTH-1:0] data_in,
  output logic [OUTPUT_WIDTH-1:0] data_out
);


  //----------------------------------------------------------------------------
  always_comb begin
    logic                 v_bit;
    logic [POLY_DEGREE:1] v_state;
    logic [OUTPUT_WIDTH-1:0] v_data;

    v_state = state;

    for (int i=0; i<OUTPUT_WIDTH; i++) begin
      v_bit = v_state[1];
      v_data = {v_bit, v_data} >> 1;

      v_state = v_state >> 1;
      if (CHK_NOT_GEN ? data_in[i] : v_bit) begin
        v_state ^= POLYNOMIAL;
      end

    end

    next_state = v_state;
    data_out = v_data ^ data_in;
  end


endmodule