


module lfsr_fibonacci #(
  parameter int                   POLY_DEGREE  = 7,
  parameter logic [POLY_DEGREE:1] POLYNOMIAL   = 7'b110_0000,
  parameter int                   OUTPUT_WIDTH = 1
)(
  input  logic [1:POLY_DEGREE]    state,
  output logic [1:POLY_DEGREE]    next_state,
  output logic [OUTPUT_WIDTH-1:0] data
);


  //----------------------------------------------------------------------------
  // If true: the lfsr stream will start with the seed value
  localparam bit SEED_FIRST = 1;


  //----------------------------------------------------------------------------
  always_comb begin
    logic                 v_bit;
    logic [1:POLY_DEGREE] v_state;
    logic [OUTPUT_WIDTH-1:0] v_data_late, v_data_early;

    v_state = state;

    for (int i=0; i<OUTPUT_WIDTH; i++) begin
      v_data_late = {v_state[POLY_DEGREE], v_data_late} >> 1;

      v_bit = ^(v_state & {<<{POLYNOMIAL}});
      v_state = {v_bit, v_state} >> 1;

      v_data_early = {v_bit, v_data_early} >> 1;
    end

    next_state = v_state;
    data = SEED_FIRST ? v_data_late : v_data_early;
  end

endmodule