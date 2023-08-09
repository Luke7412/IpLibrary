//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------
`include "svunit_defines.svh"
`timescale 1ns/1ps


module cdr_data_recovery_unit_test;
  import svunit_pkg::svunit_testcase;

  string name = "cdr_data_recovery_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  localparam real ACLK_FREQUENCY = 100000000;
  localparam real ACLK_PERIOD = 1s/ACLK_FREQUENCY;


  localparam string MODE = "phased";  // mode: "phased", "2x", "4x", "iddr"
  localparam int TDATA_WIDTH = 16;  

  int CLK_RATIO [string] = '{
    "phased" : 1,
    "2x" : 2,
    "4x" : 4,
    "iddr" : 2
  };

  logic                   clk;
  logic                   clk90;
  logic                   in_data;
  logic                   aclk;
  logic                   aresetn;
  logic                   m_tvalid;
  logic [TDATA_WIDTH-1:0] m_tdata;


  localparam logic [15:0] PAR_DATA = 16'b1010_1100_1110_0100;
  logic [15:0] shift_data;


  //----------------------------------------------------------------------------
  real SAMPLE_PERIOD = ACLK_PERIOD / CLK_RATIO[MODE];

  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))
  `SVUNIT_CLK_GEN(clk, (SAMPLE_PERIOD/2))
  assign #(SAMPLE_PERIOD/4) clk90 = clk;


  //----------------------------------------------------------------------------
  cdr_data_recovery #(
    .MODE         (MODE),  // mode: "phased", "2x", "4x", "iddr" or "iddr2x"
    .TDATA_WIDTH  (TDATA_WIDTH)
  ) DUT (
    .clk      (clk),
    .clk90    (clk90),
    .aclk     (aclk),
    .aresetn  (aresetn),
    .in_data  (in_data),
    .m_tvalid (m_tvalid),
    .m_tdata  (m_tdata)
  );


  assign in_data = shift_data[0];


  initial begin
    shift_data = PAR_DATA;
    forever begin
      wait_tics(1);
      shift_data = {shift_data[0], shift_data} >> 1;
    end
  end


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
  endfunction


  task setup();
    svunit_ut.setup();

    aresetn <= '0;
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

  function automatic bit is_valid(logic[15:0] data);
    for (int i=0; i<16; i++) begin
      if (PAR_DATA == 16'({data, data} >> i)) begin
        return 1;
      end 
    end 
    return 0;
  endfunction


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN

  `SVTEST(test_)
    wait_tics(200);

    @(posedge aclk iff m_tvalid);
    `FAIL_UNLESS(is_valid(m_tdata));
  `SVTEST_END



  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule