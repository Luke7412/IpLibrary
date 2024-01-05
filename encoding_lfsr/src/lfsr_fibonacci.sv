

module lfsr_fibonacci 
  import lfsr_pkg::*;
#(
  parameter int                   POLY_DEGREE  = 7,
  parameter logic [POLY_DEGREE:1] POLYNOMIAL   = PRBS7,
  parameter int                   OUTPUT_WIDTH = 1,
  parameter bit                   CHK_NOT_GEN  = 0
)(
  input  logic [1:POLY_DEGREE]    state,
  output logic [1:POLY_DEGREE]    next_state,
  input  logic [OUTPUT_WIDTH-1:0] data_in,
  output logic [OUTPUT_WIDTH-1:0] data_out
);


  //----------------------------------------------------------------------------
  function logic [1:POLY_DEGREE] reverse (logic [POLY_DEGREE:1] x);
    logic [1:POLY_DEGREE] y;

    foreach(x[i]) 
      y[i] = x[i];
    return y;
  endfunction


  //----------------------------------------------------------------------------
  always_comb begin
    logic                    v_bit;
    logic [1:POLY_DEGREE]    v_state;
    logic [OUTPUT_WIDTH-1:0] v_err;
    logic [OUTPUT_WIDTH-1:0] v_data;

    v_state = state;

    for (int i=0; i<OUTPUT_WIDTH; i++) begin
      v_data = {v_state[POLY_DEGREE], v_data} >> 1;

      v_bit = ^(v_state & reverse(POLYNOMIAL));

      if (CHK_NOT_GEN) begin
        v_state = {data_in[i], v_state} >> 1;
        v_err[i] = v_bit != data_in[i];
      end else begin
        v_state = {v_bit, v_state} >> 1;
      end
    end

    next_state = v_state;
    data_out = CHK_NOT_GEN ? v_err : v_data;
  end

endmodule