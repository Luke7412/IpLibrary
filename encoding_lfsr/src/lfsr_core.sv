
module lfsr_core #(
  parameter int                     POLY_DEGREE  = 16,                  
  parameter logic [POLY_DEGREE-1:0] POLYNOMIAL   = 16'b0110100000000001,
  parameter int                     OUTPUT_WIDTH = 8                  
)(
  input  logic [POLY_DEGREE-1:0]  state,
  output logic [POLY_DEGREE-1:0]  next_state,
  output logic [OUTPUT_WIDTH-1:0] data
);


  //----------------------------------------------------------------------------
  always_comb begin
    logic                    v_out_bit;
    logic [POLY_DEGREE-1:0]  v_state;
    logic [OUTPUT_WIDTH-1:0] v_data;

    v_state = state;

    for (int i=0; i<OUTPUT_WIDTH; i++) begin
      v_out_bit = v_state[$high(v_state)];
      v_data[i] = v_out_bit;

      v_state = v_state << 1;

      if (v_out_bit) begin
        v_state = v_state ^ POLYNOMIAL;
      end
    end

    next_state = v_state;
    data = v_data;
  end


endmodule
