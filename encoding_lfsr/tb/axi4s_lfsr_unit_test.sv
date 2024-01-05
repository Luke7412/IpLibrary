
`include "svunit_defines.svh"
`timescale 1ns/1ns


module axi4s_lfsr_unit_test;
  import svunit_pkg::svunit_testcase;
  string name = "axi4s_lfsr_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import lfsr_pkg::*;

  localparam real ACLK_PERIOD = 5ns;
  logic [0:126] prbs7_series = 'b1000000100000110000101000111100100010110011101010011111010000111000100100110110101101111011000110100101110111001100101010111111;

  localparam int                   POLY_DEGREE = 7;
  localparam bit [POLY_DEGREE-1:0] POLYNOMIAL  = PRBS7;
  localparam bit [POLY_DEGREE-1:0] SEED        = 1;
  localparam int                   TDATA_WIDTH = 8;
  localparam bit                   CHK_NOT_GEN = 0;

  logic aclk;
  logic aresetn;
  logic                    target_tvalid;
  logic                    target_tready;
  logic [TDATA_WIDTH-1:0]  target_tdata;
  logic                    target_tlast;

  logic                    fib_gen_tvalid, fib_chk_tvalid, gal_gen_tvalid, gal_chk_tvalid;
  logic                    fib_gen_tready, fib_chk_tready, gal_gen_tready, gal_chk_tready;
  logic [TDATA_WIDTH-1:0]  fib_gen_tdata , fib_chk_tdata , gal_gen_tdata , gal_chk_tdata ;
  logic                    fib_gen_tlast , fib_chk_tlast , gal_gen_tlast , gal_chk_tlast ;


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))


  //----------------------------------------------------------------------------
  axi4s_lfsr #(
    .POLY_DEGREE    (POLY_DEGREE),
    .POLYNOMIAL     (POLYNOMIAL),
    .SEED           (SEED),
    .TDATA_WIDTH    (TDATA_WIDTH),
    .IMPLEMENTATION ("fibonacci"),
    .CHK_NOT_GEN    (0)
  ) lfsr_fib_gen (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (target_tvalid),
    .target_tready    (),
    .target_tdata     (target_tdata),
    .target_tlast     (target_tlast),
    .initiator_tvalid (fib_gen_tvalid),
    .initiator_tready (fib_gen_tready),
    .initiator_tdata  (fib_gen_tdata),
    .initiator_tlast  (fib_gen_tlast)
  );

  axi4s_lfsr #(
    .POLY_DEGREE    (POLY_DEGREE),
    .POLYNOMIAL     (POLYNOMIAL),
    .SEED           (SEED),
    .TDATA_WIDTH    (TDATA_WIDTH),
    .IMPLEMENTATION ("fibonacci"),
    .CHK_NOT_GEN    (1)
  ) lfsr_fib_chk (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (fib_gen_tvalid),
    .target_tready    (fib_gen_tready),
    .target_tdata     (fib_gen_tdata),
    .target_tlast     (fib_gen_tlast),
    .initiator_tvalid (fib_chk_tvalid),
    .initiator_tready (fib_chk_tready),
    .initiator_tdata  (fib_chk_tdata),
    .initiator_tlast  (fib_chk_tlast)
  );

  axi4s_lfsr #(
    .POLY_DEGREE    (POLY_DEGREE),
    .POLYNOMIAL     (POLYNOMIAL),
    .SEED           (SEED),
    .TDATA_WIDTH    (TDATA_WIDTH),
    .IMPLEMENTATION ("galois"),
    .CHK_NOT_GEN    (0)
  ) lfsr_gal_gen (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (target_tvalid),
    .target_tready    (),
    .target_tdata     (target_tdata),
    .target_tlast     (target_tlast),
    .initiator_tvalid (gal_gen_tvalid),
    .initiator_tready (gal_gen_tready),
    .initiator_tdata  (gal_gen_tdata),
    .initiator_tlast  (gal_gen_tlast)
  );

  axi4s_lfsr #(
    .POLY_DEGREE    (POLY_DEGREE),
    .POLYNOMIAL     (POLYNOMIAL),
    .SEED           (SEED),
    .TDATA_WIDTH    (TDATA_WIDTH),
    .IMPLEMENTATION ("galois"),
    .CHK_NOT_GEN    (1)
  ) lfsr_gal_chk (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (gal_gen_tvalid),
    .target_tready    (gal_gen_tready),
    .target_tdata     (gal_gen_tdata),
    .target_tlast     (gal_gen_tlast),
    .initiator_tvalid (gal_chk_tvalid),
    .initiator_tready (gal_chk_tready),
    .initiator_tdata  (gal_chk_tdata),
    .initiator_tlast  (gal_chk_tlast)
  );


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
  endfunction


  task setup();
    svunit_ut.setup();

    aresetn <= '0;
    target_tvalid <= '0;
    target_tdata <= '0;
    target_tlast <= '0;
    fib_chk_tready <= '0;
    gal_chk_tready <= '0;

    wait_tics(5);
    aresetn <= '1;
    wait_tics(5);
  endtask


  task teardown();
    svunit_ut.teardown();
    
    #(5*ACLK_PERIOD);
    aresetn <= '0;
  endtask


  //----------------------------------------------------------------------------
  task wait_tics(int tics=1);
    repeat(tics)
      @(posedge aclk);
  endtask


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN


  `SVTEST(test_continuous_stream)
    fib_chk_tready <= '1;
    gal_chk_tready <= '1;

    target_tvalid <= '1;
    target_tlast <= '0;
    wait_tics(100);

    target_tvalid <= '0;
  `SVTEST_END


  `SVTEST(test_continuous_stream_with_error)
    fib_chk_tready <= '1;
    gal_chk_tready <= '1;

    target_tvalid <= '1;
    target_tlast <= '0;
    wait_tics(10);
    target_tdata <= 1;
    wait_tics(1);
    target_tdata <= 0;
    wait_tics(20);

    target_tvalid <= '0;
  `SVTEST_END


  `SVTEST(test_restart)
    fib_chk_tready <= '1;
    gal_chk_tready <= '1;

    target_tvalid <= '1;
    target_tlast <= '0;
    wait_tics(10);
    target_tlast <= '1;
    wait_tics();
    target_tlast <= '0;
    wait_tics(10);
    target_tvalid <= '0;
    wait_tics(10);

    target_tvalid <= '0;
  `SVTEST_END

 

  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
