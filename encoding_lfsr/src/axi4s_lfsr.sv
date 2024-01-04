

module axi4s_lfsr 
  import lfsr_pkg::*;
#(
  parameter int                     POLY_DEGREE  = 16,                  
  parameter logic [POLY_DEGREE-1:0] POLYNOMIAL   = POLY_MAX_16,
  parameter logic [POLY_DEGREE-1:0] SEED         = 1,
  parameter int                     TDATA_WIDTH  = 8,
  parameter string                  IMPLEMENTATION = "galois"  // can be "galois" or "fibonacci"
)(
  input  logic aclk,
  input  logic aresetn,

  input  logic                    target_tvalid,
  output logic                    target_tready,
  input  logic [TDATA_WIDTH-1:0]  target_tdata,
  input  logic                    target_tlast,

  output logic                    initiator_tvalid,
  input  logic                    initiator_tready,
  output logic [TDATA_WIDTH-1:0]  initiator_tdata,
  output logic                    initiator_tlast
);


  //----------------------------------------------------------------------------
    function logic [POLY_DEGREE:1] prev_galois(
    input  logic [POLY_DEGREE:1] state,
    input  int reverse_n_bits
  );
    logic v_bit;

    repeat(reverse_n_bits) begin
      v_bit = state[POLY_DEGREE];

      if (v_bit) begin
        state ^= POLYNOMIAL;
      end

      state = {state, v_bit};
    end

    return state;
  endfunction


  //----------------------------------------------------------------------------
  localparam [POLY_DEGREE-1:0] INTERNAL_SEED = 
    IMPLEMENTATION == "galois" ? prev_galois(SEED, POLY_DEGREE) : SEED;

  logic [POLY_DEGREE-1:0] state;
  logic [POLY_DEGREE-1:0] next_state;
  logic [TDATA_WIDTH-1:0] lfsr_data;
 

  //----------------------------------------------------------------------------
  if (IMPLEMENTATION == "galois") begin
    lfsr_galois #(
      .POLY_DEGREE   (POLY_DEGREE ),
      .POLYNOMIAL    (POLYNOMIAL  ),
      .OUTPUT_WIDTH  (TDATA_WIDTH)           
    ) i_lfsr_core (
      .state      (state),
      .next_state (next_state),
      .data       (lfsr_data)
    );

  end else if (IMPLEMENTATION == "fibonacci") begin
    lfsr_fibonacci #(
      .POLY_DEGREE   (POLY_DEGREE ),
      .POLYNOMIAL    (POLYNOMIAL  ),
      .OUTPUT_WIDTH  (TDATA_WIDTH)           
    ) i_lfsr_core (
      .state      (state),
      .next_state (next_state),
      .data       (lfsr_data)
    );

  end else begin
    $fatal("Parameter IMPLEMENTATION must be 'galois' or 'fibonacci'.");
  end


  //----------------------------------------------------------------------------
  assign target_tready = initiator_tready;


  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      state <= INTERNAL_SEED;
      initiator_tvalid <= '0;
      initiator_tdata <= '0;

    end else begin
      if (initiator_tvalid && initiator_tready) begin
        initiator_tvalid <= '0;
      end

      if (target_tvalid && target_tready) begin
        initiator_tvalid <= '1;
        initiator_tdata <= lfsr_data;
        initiator_tlast <= target_tlast;

        state <= next_state;
        if (target_tlast) begin
          state <= INTERNAL_SEED;
        end
      end

    end
  end


endmodule









module axi4s_lfsr_chk #(
  parameter int                     POLY_DEGREE  = 16,                  
  parameter logic [POLY_DEGREE-1:0] POLYNOMIAL   = 16'b0110100000000001,
  parameter logic [POLY_DEGREE-1:0] SEED         = 1,
  parameter int                     TDATA_WIDTH  = 8
)(
  input  logic aclk,
  input  logic aresetn,

  input  logic                    target_tvalid,
  output logic                    target_tready,
  input  logic [TDATA_WIDTH-1:0]  target_tdata,
  input  logic                    target_tlast,

  output logic                    initiator_tvalid,
  input  logic                    initiator_tready,
  output logic [TDATA_WIDTH-1:0]  initiator_tdata,
  output logic                    initiator_tlast
);


  //----------------------------------------------------------------------------
  logic [POLY_DEGREE-1:0] state;
  logic [POLY_DEGREE-1:0] next_state;
  logic [TDATA_WIDTH-1:0] lfsr_data;
 

  //----------------------------------------------------------------------------
  lfsr_core #(
    .POLY_DEGREE   (POLY_DEGREE ),
    .POLYNOMIAL    (POLYNOMIAL  ),
    .OUTPUT_WIDTH  (TDATA_WIDTH)           
  ) i_lfsr_core (
    .state      (state),
    .next_state (next_state),
    .data       (lfsr_data)
  );


  assign target_tready = initiator_tready;


  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      state <= SEED;
      initiator_tvalid <= '0;
      initiator_tdata <= '0;

    end else begin
      if (initiator_tvalid && initiator_tready) begin
        initiator_tvalid <= '0;
      end

      if (target_tready && target_tready) begin
        initiator_tvalid <= '1;
        initiator_tdata <= lfsr_data;
        initiator_tlast <= target_tlast;

        state <= next_state;
        if (target_tlast) begin
          state <= SEED;
        end
      end

    end
  end


endmodule
