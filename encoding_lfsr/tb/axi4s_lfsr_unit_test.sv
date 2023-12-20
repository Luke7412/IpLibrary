
`include "svunit_defines.svh"
`timescale 1ns/1ns


module axi4s_lfsr_unit_test;
  import svunit_pkg::svunit_testcase;
  string name = "axi4s_lfsr_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import lfsr_pkg::*;

  localparam real ACLK_PERIOD = 5ns;

  localparam int                     POLY_DEGREE  = 16;
  localparam logic [POLY_DEGREE-1:0] POLYNOMIAL   = 16'b0110100000000001;
  localparam logic [POLY_DEGREE-1:0] SEED         = '1;
  localparam int                     TDATA_WIDTH  = 8;

  logic aclk;
  logic aresetn;
  logic                    target_tvalid;
  logic                    target_tready;
  logic [TDATA_WIDTH-1:0]  target_tdata;
  logic                    target_tlast;
  logic                    initiator_tvalid;
  logic                    initiator_tready;
  logic [TDATA_WIDTH-1:0]  initiator_tdata;
  logic                    initiator_tlast;


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))


  //----------------------------------------------------------------------------
  // axi4s_lfsr DUT(.*);

  axi4s_lfsr #(
    .POLY_DEGREE  (POLY_DEGREE),
    .POLYNOMIAL   (POLYNOMIAL),
    .SEED         (SEED),
    .TDATA_WIDTH  (TDATA_WIDTH)
  ) DUT (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (target_tvalid),
    .target_tready    (target_tready),
    .target_tdata     (target_tdata),
    .target_tlast     (target_tlast),
    .initiator_tvalid (initiator_tvalid),
    .initiator_tready (initiator_tready),
    .initiator_tdata  (initiator_tdata),
    .initiator_tlast  (initiator_tlast)
  );


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
  endfunction


  task setup();
    svunit_ut.setup();

    aresetn <= '0;
    target_tvalid <= '0;
    initiator_tready <= '0;

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

  `SVTEST(test_1)
    initiator_tready <= '1;

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
