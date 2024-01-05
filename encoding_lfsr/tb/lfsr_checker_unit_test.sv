
`include "svunit_defines.svh"
`timescale 1ns/1ns


module lfsr_checker_unit_test;
  import svunit_pkg::svunit_testcase;
  string name = "lfsr_checker_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import lfsr_pkg::*;

  localparam int                   POLY_DEGREE  = 7;
  localparam bit [POLY_DEGREE-1:0] POLYNOMIAL   = PRBS7;
  localparam int                   OUTPUT_WIDTH = 1;
  localparam bit                   CHK_NOT_GEN  = 1;

  logic [POLY_DEGREE-1:0]  fib_state;
  logic [POLY_DEGREE-1:0]  fib_next_state;
  logic [OUTPUT_WIDTH-1:0] fib_data;
  logic [OUTPUT_WIDTH-1:0] fib_err;

  logic [POLY_DEGREE-1:0]  gal_state;
  logic [POLY_DEGREE-1:0]  gal_next_state;
  logic [OUTPUT_WIDTH-1:0] gal_data;
  logic [OUTPUT_WIDTH-1:0] gal_err;

  localparam logic [0:126] PRBS7_SERIES = 'b1000000100000110000101000111100100010110011101010011111010000111000100100110110101101111011000110100101110111001100101010111111;
  logic [0:126] prbs7_shift;
  logic [OUTPUT_WIDTH-1:0] err;


  //----------------------------------------------------------------------------
  function logic [POLY_DEGREE:1] prev_galois(
    logic [POLY_DEGREE:1] state,
    int reverse_n_bits
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
  lfsr_fibonacci #(
    .POLY_DEGREE  (POLY_DEGREE),
    .POLYNOMIAL   (POLYNOMIAL),
    .OUTPUT_WIDTH (OUTPUT_WIDTH),
    .CHK_NOT_GEN  (CHK_NOT_GEN)
  ) lfsr_fib (
    .state      (fib_state),
    .next_state (fib_next_state),
    .data_in    (fib_data),
    .data_out   (fib_err)
  );


  lfsr_galois #(
    .POLY_DEGREE  (POLY_DEGREE),
    .POLYNOMIAL   (POLYNOMIAL),
    .OUTPUT_WIDTH (OUTPUT_WIDTH),
    .CHK_NOT_GEN  (CHK_NOT_GEN)
  ) lfsr_gal (
    .state      (gal_state),
    .next_state (gal_next_state),
    .data_in    (gal_data),
    .data_out   (gal_err)
  );


  assign fib_data = {<<{prbs7_shift[0+:OUTPUT_WIDTH]}} ^ err;
  assign gal_data = {<<{prbs7_shift[0+:OUTPUT_WIDTH]}} ^ err;


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
  endfunction


  task setup();
    svunit_ut.setup();

    fib_state <= '0;
    gal_state <= '0;
    prbs7_shift <= PRBS7_SERIES;
    err <= '0;
  endtask


  task teardown();
    svunit_ut.teardown();
  endtask


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN

  `SVTEST(test_1)
    fib_state <= 7'b01;
    gal_state <= prev_galois(7'b01, POLY_DEGREE);

    for(int i=0; i<5*$size(prbs7_shift); i++) begin
      #5;
      if (i>POLY_DEGREE) begin
        `FAIL_IF(fib_err != '0);
        `FAIL_IF(fib_err != '0);
      end

      fib_state <= fib_next_state;
      gal_state <= gal_next_state;
      prbs7_shift <= {prbs7_shift, prbs7_shift[0+:OUTPUT_WIDTH]};
    end

  `SVTEST_END


  `SVTEST(test_with_errors)
    fib_state <= 7'b01;
    gal_state <= prev_galois(7'b01, POLY_DEGREE);

    for(int i=0; i<5*$size(prbs7_shift); i++) begin
      #5;

      if (i%100 > POLY_DEGREE) begin
        `FAIL_IF(fib_err != '0);
        `FAIL_IF(fib_err != '0);
      end

      fib_state <= fib_next_state;
      gal_state <= gal_next_state;
      err[0] <= (i%100 == 99);
      prbs7_shift <= {prbs7_shift, prbs7_shift[0+:OUTPUT_WIDTH]};
    end

  `SVTEST_END
 
  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
