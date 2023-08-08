
module lfsr #(
  parameter int                     POLY_DEGREE     = 16,                  
  parameter logic [POLY_DEGREE-1:0] POLYNOMIAL      = 16'b0110100000000001,
  parameter int                     OUTPUT_WIDTH    = 8,                  
  parameter logic                   REGISTER_OUTPUT = 1'b1                 
)(
  input logic                       clk,  
  input logic                       rst_n,

  input  logic                      init,   
  input  logic [POLY_DEGREE-1:0]    seed,   
  input  logic                      update, 

  output logic [OUTPUT_WIDTH-1:0]   lfsr_out
);

  //##############################################################################
  //<> Declarations
  //##############################################################################
  logic                    nxt_init_l     , init_l;
  logic [POLY_DEGREE-1:0]  nxt_init_seed_l, init_seed_l;

  logic [POLY_DEGREE-1:0]  lfsr_state_fb_d0;
  logic [POLY_DEGREE-1:0]  lfsr_state_d0;

  logic [POLY_DEGREE-1:0]  nxt_lfsr_state_d1, lfsr_state_d1;
  logic [OUTPUT_WIDTH-1:0] nxt_lfsr_output_d1, lfsr_output_d1;


  logic                    init_latch;
  logic [POLY_DEGREE-1:0]  seed_latch;


  //##############################################################################
  //<> Implementation
  //##############################################################################
  assign lfsr_state_fb_d0           = lfsr_state_d1;
  assign lfsr_state_d0              = i_init ?  i_seed : lfsr_state_fb_d0; //either load new state, or use previous


  //TODO clean up the Init latch logic so its more clear whats actually going on.

  always_comb begin: lfsr_comb_blk
    logic                    v_out_bit;
    logic [POLY_DEGREE-1:0]  v_lfsr_state;
    logic [OUTPUT_WIDTH-1:0] v_lfsr_output;

    // latch i_init and i_seed until i_update is high
    nxt_init_l      = init_l;
    nxt_init_seed_l = init_seed_l;
    if(i_init) begin
      nxt_init_l      = ~i_update;
      nxt_init_seed_l = i_seed;
    end else if(i_update) begin
      nxt_init_l      = '0;
    end

    v_lfsr_output = '0;
    v_lfsr_state  = init_l ? init_seed_l : lfsr_state_d0;
    for( int i =0; i<OUTPUT_WIDTH; i++) begin
      v_out_bit = v_lfsr_state[0];
      if(v_out_bit) begin
        v_lfsr_state = (v_lfsr_state ^ POLYNOMIAL);
      end
      v_lfsr_state  = {v_out_bit, v_lfsr_state[POLY_DEGREE-1:1]};

      v_lfsr_output = v_lfsr_output>>1;
      v_lfsr_output[OUTPUT_WIDTH-1] = v_out_bit;
    end

    nxt_lfsr_state_d1       = v_lfsr_state;
    nxt_lfsr_output_d1      = v_lfsr_output;
  end


  always_ff @(negedge i_rst_n, posedge i_clk) begin : lfsr_seq_blk
    if (! i_rst_n) begin
      init_l         <= '0;
      init_seed_l    <= '1;
      lfsr_state_d1  <= '1;
      lfsr_output_d1 <= '0;

    end else begin

      

    logic                    v_out_bit;
    logic [POLY_DEGREE-1:0]  v_lfsr_state;
    logic [OUTPUT_WIDTH-1:0] v_lfsr_output;

    // latch i_init and i_seed until i_update is high
    nxt_init_l      = init_l;
    nxt_init_seed_l = init_seed_l;
    
    if(init) begin
      init_latch <= '1;
      seed_latch <= seed;
    end else if(i_update) begin
      init_latch <= '0;
    end

    v_lfsr_output = '0;
    v_lfsr_state  = init_l ? init_seed_l : lfsr_state_d0;
    for( int i =0; i<OUTPUT_WIDTH; i++) begin
      v_out_bit = v_lfsr_state[0];
      if(v_out_bit) begin
        v_lfsr_state = (v_lfsr_state ^ POLYNOMIAL);
      end
      v_lfsr_state  = {v_out_bit, v_lfsr_state[POLY_DEGREE-1:1]};

      v_lfsr_output = v_lfsr_output>>1;
      v_lfsr_output[OUTPUT_WIDTH-1] = v_out_bit;
    end

    nxt_lfsr_state_d1       = v_lfsr_state;
    nxt_lfsr_output_d1      = v_lfsr_output;






      init_l         <= nxt_init_l;
      init_seed_l    <= nxt_init_seed_l;
      if(i_update) begin
        lfsr_state_d1  <= nxt_lfsr_state_d1;
        lfsr_output_d1 <= nxt_lfsr_output_d1;
      end
    end
  end


  if(REGISTER_OUTPUT) begin
    assign o_output = lfsr_output_d1;
  end else begin
    assign o_output = nxt_lfsr_output_d1;
  end
endmodule
