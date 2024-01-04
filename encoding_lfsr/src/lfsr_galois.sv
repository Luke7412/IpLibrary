

module lfsr_galois #(
  parameter int                   POLY_DEGREE  = 7,
  parameter logic [POLY_DEGREE:1] POLYNOMIAL   = 7'b110_0000,
  parameter int                   OUTPUT_WIDTH = 1
)(
  input  logic [POLY_DEGREE:1]    state,
  output logic [POLY_DEGREE:1]    next_state,
  output logic [OUTPUT_WIDTH-1:0] data
);


  //----------------------------------------------------------------------------
  always_comb begin
    logic                 v_bit;
    logic [POLY_DEGREE:1] v_state;

    v_state = state;

    for (int i=0; i<OUTPUT_WIDTH; i++) begin
      v_bit = v_state[1];
      data = {v_bit, data} >> 1;

      v_state = v_state >> 1;
      if (v_bit) begin
        v_state ^= POLYNOMIAL;
      end

    end

    next_state = v_state;
  end

endmodule