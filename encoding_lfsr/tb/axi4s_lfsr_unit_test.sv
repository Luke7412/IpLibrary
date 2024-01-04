
`include "svunit_defines.svh"
`timescale 1ns/1ns


module axi4s_lfsr_unit_test;
  import svunit_pkg::svunit_testcase;
  string name = "axi4s_lfsr_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import lfsr_pkg::*;

  localparam real ACLK_PERIOD = 5ns;

  localparam int                     POLY_DEGREE  = 7;
  localparam logic [POLY_DEGREE-1:0] POLYNOMIAL   = PRBS7;
  localparam logic [POLY_DEGREE-1:0] SEED         = 1;
  localparam int                     TDATA_WIDTH  = 8;

  logic aclk;
  logic aresetn;
  logic                    target_tvalid;
  logic                    target_tready;
  logic [TDATA_WIDTH-1:0]  target_tdata;
  logic                    target_tlast;

  logic                    fib_tvalid,  gal_tvalid;
  logic                    fib_tready,  gal_tready;
  logic [TDATA_WIDTH-1:0]  fib_tdata ,  gal_tdata;
  logic                    fib_tlast ,  gal_tlast;


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))


  //----------------------------------------------------------------------------
  // axi4s_lfsr DUT(.*);

  axi4s_lfsr #(
    .POLY_DEGREE    (POLY_DEGREE),
    .POLYNOMIAL     (POLYNOMIAL),
    .SEED           (SEED),
    .TDATA_WIDTH    (TDATA_WIDTH),
    .IMPLEMENTATION ("fibonacci")
  ) lfsr_fib (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (target_tvalid),
    .target_tready    (),
    .target_tdata     (target_tdata),
    .target_tlast     (target_tlast),
    .initiator_tvalid (fib_tvalid),
    .initiator_tready (fib_tready),
    .initiator_tdata  (fib_tdata),
    .initiator_tlast  (fib_tlast)
  );


  axi4s_lfsr #(
    .POLY_DEGREE    (POLY_DEGREE),
    .POLYNOMIAL     (POLYNOMIAL),
    .SEED           (SEED),
    .TDATA_WIDTH    (TDATA_WIDTH),
    .IMPLEMENTATION ("galois")
  ) lfsr_gal (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (target_tvalid),
    .target_tready    (),
    .target_tdata     (target_tdata),
    .target_tlast     (target_tlast),
    .initiator_tvalid (gal_tvalid),
    .initiator_tready (gal_tready),
    .initiator_tdata  (gal_tdata),
    .initiator_tlast  (gal_tlast)
  );


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
  endfunction


  task setup();
    svunit_ut.setup();

    aresetn <= '0;
    target_tvalid <= '0;
    fib_tready <= '0;
    gal_tready <= '0;

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
      @(posedge lfsr_fib.aclk);
  endtask


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN

  `SVTEST(test_1)
    fib_tready <= '1;
    gal_tready <= '1;

    target_tvalid <= '1;
    target_tlast <= '0;
    wait_tics(10);
    target_tlast <= '1;
    wait_tics();
    target_tlast <= '0;
    wait_tics(10);
    target_tvalid <= '0;
    wait_tics(10);

  `SVTEST_END

 

  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
