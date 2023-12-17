
`include "svunit_defines.svh"
`timescale 1ns/1ns


module axi4s_framing_unit_test;
  import svunit_pkg::svunit_testcase;
  string name = "axi4s_framing_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  localparam real ACLK_PERIOD = 5ns;

  localparam bit [7:0] ESCAPE_BYTE = 8'h7F;
  localparam bit [7:0] START_BYTE  = 8'h7D;
  localparam bit [7:0] STOP_BYTE   = 8'h7E;

  logic       aclk;
  logic       aresetn;
  logic       rx_frame_tvalid, tx_frame_tvalid;
  logic       rx_frame_tready, tx_frame_tready;
  logic       rx_frame_tlast , tx_frame_tlast;
  logic [7:0] rx_frame_tdata , tx_frame_tdata;
  logic       rx_byte_tvalid, tx_byte_tvalid;
  logic       rx_byte_tready, tx_byte_tready;
  logic [7:0] rx_byte_tdata , tx_byte_tdata;


  //----------------------------------------------------------------------------
  `SVUNIT_CLK_GEN(aclk, (ACLK_PERIOD/2))


  //----------------------------------------------------------------------------
   framing #(
    .ESCAPE_BYTE (ESCAPE_BYTE),
    .START_BYTE  (START_BYTE),
    .STOP_BYTE   (STOP_BYTE)
  ) DUT ( 
    .aclk             (aclk),
    .aresetn          (aresetn),
    .rx_byte_tvalid   (rx_byte_tvalid),
    .rx_byte_tready   (rx_byte_tready),
    .rx_byte_tdata    (rx_byte_tdata),
    .rx_frame_tvalid  (rx_frame_tvalid),
    .rx_frame_tready  (rx_frame_tready),
    .rx_frame_tdata   (rx_frame_tdata),
    .rx_frame_tlast   (rx_frame_tlast),
    .tx_byte_tvalid   (tx_byte_tvalid),
    .tx_byte_tready   (tx_byte_tready),
    .tx_byte_tdata    (tx_byte_tdata),
    .tx_frame_tvalid  (tx_frame_tvalid),
    .tx_frame_tready  (tx_frame_tready),
    .tx_frame_tdata   (tx_frame_tdata),
    .tx_frame_tlast   (tx_frame_tlast)
  );


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


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN


  `SVTEST(test_)
    
  `SVTEST_END

 
  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
