//------------------------------------------------------------------------------
// Project Name   : IpLibrary
// Design Name    : Regbank
// File Name      : Regbank.vhd
//------------------------------------------------------------------------------
// Author         : Lukas Vinkx
// Description: 
//------------------------------------------------------------------------------


module frequency_meter #(
  parameter int ACLK_FREQ = 200 // in MHz
)(
  input  logic aclk,
  input  logic aresetn,
  input  logic sen_clk,
  // Control interface (AXI4Lite)
  input  logic        ctrl_arvalid,
  output logic        ctrl_arready,
  input  logic [11:0] ctrl_araddr,
  output logic        ctrl_rvalid,
  input  logic        ctrl_rready,
  output logic [31:0] ctrl_rdata,
  output logic [1:0]  ctrl_rresp,
  input  logic        ctrl_awvalid,
  output logic        ctrl_awready,
  input  logic [11:0] ctrl_awaddr,
  input  logic        ctrl_wvalid,
  output logic        ctrl_wready,
  input  logic [31:0] ctrl_wdata,
  input  logic [3:0]  ctrl_wstrb,
  output logic        ctrl_bvalid,
  input  logic        ctrl_bready,
  output logic [1:0]  ctrl_bresp
);


  //----------------------------------------------------------------------------
  localparam int FREQ_CNT_WIDTH = 16;
  localparam bit [FREQ_CNT_WIDTH-1:0] FREQ_CNT_MAX = '1;

  logic sen_rst_n;

  logic req, req_sync, req_pulse, ack, ack_pulse;

  logic [FREQ_CNT_WIDTH-1:0] freq_cnt, freq_cnt_sample, reg_freq_cnt;
  logic freq_overflow, freq_overflow_sample, reg_freq_overflow;
 
  logic [$clog2(ACLK_FREQ)-1:0] us_cnt;
  logic [12:0] div_toggle;
  logic us_pulse;

  logic reg_updated;
  logic [1:0] reg_sel;


  //----------------------------------------------------------------------------
  always_ff @(posedge aclk or negedge aresetn) begin 
    if (!aresetn) begin
      us_cnt     <= ACLK_FREQ-1;
      us_pulse   <= '0;
      div_toggle <= '0;

    end else begin
      if (us_cnt == 0) begin
        us_pulse <= '1;
        us_cnt   <= ACLK_FREQ-1;
      end else begin
        us_pulse <= '0;
        us_cnt   <= us_cnt - 1;
      end

      if (us_cnt == 0) begin
        div_toggle <= div_toggle + 1;
      end
    end
  end

  assign req = div_toggle[4*reg_sel];


  //----------------------------------------------------------------------------
  // Sen domain
  rst_sync #(
    .DEPTH   (2),
    .RST_VAL (0)
  ) i_rst_sync (
    .src_rst_n (aresetn),
    .dst_clk   (sen_clk),
    .dst_rst_n (sen_rst_n)
);

  pulse_sync #(
    .DEPTH      (2),
    .RST_VAL    (0)
  ) i_pulse_sync (
    .src_toggle (req),
    .dst_clk    (sen_clk),
    .dst_rst_n  (sen_rst_n),
    .dst_toggle (req_sync),
    .dst_pulse  (req_pulse)
  );


  always_ff @(posedge sen_clk or negedge sen_rst_n) begin
    if (!sen_rst_n) begin
        freq_cnt             <= '0;
        freq_overflow        <= '0;
        freq_cnt_sample      <= '0;
        freq_overflow_sample <= '0;

    end else begin
      if (req_pulse) begin
        freq_cnt             <= 1;
        freq_overflow        <= '0;
        freq_cnt_sample      <= freq_cnt;
        freq_overflow_sample <= freq_overflow;

      end else if (freq_cnt != FREQ_CNT_MAX) begin
        freq_cnt <= freq_cnt + 1;
      end else begin
        freq_overflow <= '1;
      end
    end 
  end


  //----------------------------------------------------------------------------
  // aclk domain
  assign ack = req_sync;

  dmux_sync #(
    .DEPTH   (2),
    .WIDTH   (FREQ_CNT_MAX+1),
    .RST_VAL ('0)
  ) i_dmux_sync (
    .src_toggle (ack),
    .src_data   ({freq_overflow_sample, freq_cnt_sample}),
    .dst_clk    (aclk),
    .dst_rst_n  (aresetn),
    .dst_pulse  (ack_pulse),
    .dst_data   ({reg_freq_overflow, reg_freq_cnt})
  );


  //----------------------------------------------------------------------------
  // CTRL INTF
  always_ff @(posedge aclk or negedge aresetn) begin
    logic [11:0] v_addr;
  
    if (!aresetn) begin
      ctrl_rvalid <= '0;
      ctrl_bvalid <= '0;
      ctrl_rdata  <= '0;

      reg_updated <= '0;
      reg_sel     <= '0;

    end else begin
      if (ack_pulse)
        reg_updated <= '1;

      
      // Read Handshake/Data
      if (ctrl_arvalid && ctrl_arready) begin
        ctrl_rvalid <= '1;

        v_addr = {ctrl_araddr[11:2], 2'b00};
        case (v_addr)
          'h00    : ctrl_rdata <= 'hDEADBEEF;
          'h04    : ctrl_rdata <= reg_sel;
          'h08    : begin
            reg_updated <= '0;
            ctrl_rdata  <= {reg_updated, reg_freq_overflow, reg_freq_cnt};
          end
          default : ctrl_rdata <= '0;
        endcase

      end else if (ctrl_rvalid && ctrl_rready) begin
        ctrl_rvalid <= '0;
      end


      // Write Handshake/Data
      if (ctrl_awvalid && ctrl_awready && ctrl_wvalid && ctrl_wready) begin
        ctrl_bvalid <= '1;

        v_addr = {ctrl_awaddr[11:2], 2'b00};
        case (v_addr)
          'h00     : ; // Read only
          'h04     : reg_sel <= ctrl_wdata;
          'h08     : ; // Read only
           default : ; // Read only
        endcase

      end else if (ctrl_bvalid && ctrl_bready) begin
        ctrl_bvalid <= '0;
      end

    end
  end


  assign ctrl_arready = !ctrl_rvalid;
  assign ctrl_awready = ctrl_wvalid  && !ctrl_bvalid;
  assign ctrl_wready  = ctrl_awvalid && !ctrl_bvalid;


endmodule
