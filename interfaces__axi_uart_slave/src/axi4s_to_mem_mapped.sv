

module axi4s_to_mem_mapped (
  // Clock and Reset
  input  logic       aclk,
  input  logic       aresetn,
  // Axi4-Stream RxPacket interface
  input  logic       rx_packet_tvalid,
  output logic       rx_packet_tready,
  input  logic       rx_packet_tlast,
  input  logic [7:0] rx_packet_tdata,
  input  logic [2:0] rx_packet_tid,
  // Axi4-Stream TxPacket interface
  output logic       tx_packet_tvalid,
  input  logic       tx_packet_tready,
  output logic       tx_packet_tlast,
  output logic [7:0] tx_packet_tdata,
  output logic [2:0] tx_packet_tid,
  // Axi4 Interface
  output logic        m_axi_awvalid,
  input  logic        m_axi_awready,
  output logic [31:0] m_axi_awaddr,
  output logic [7:0]  m_axi_awlen,
  output logic [2:0]  m_axi_awsize,
  output logic [1:0]  m_axi_awburst,
  output logic [0:0]  m_axi_awlock,
  output logic [3:0]  m_axi_awcache,
  output logic [2:0]  m_axi_awprot,
  output logic [3:0]  m_axi_awqos,
  output logic        m_axi_wvalid,
  input  logic        m_axi_wready,
  output logic [31:0] m_axi_wdata,
  output logic [3:0]  m_axi_wstrb,
  output logic        m_axi_wlast,
  input  logic        m_axi_bvalid,
  output logic        m_axi_bready,
  input  logic [1:0]  m_axi_bresp,
  output logic        m_axi_arvalid,
  input  logic        m_axi_arready,
  output logic [31:0] m_axi_araddr,
  output logic [7:0]  m_axi_arlen,
  output logic [2:0]  m_axi_arsize,
  output logic [1:0]  m_axi_arburst,
  output logic [0:0]  m_axi_arlock,
  output logic [3:0]  m_axi_arcache,
  output logic [2:0]  m_axi_arprot,
  output logic [3:0]  m_axi_arqos,
  input  logic        m_axi_rvalid,
  output logic        m_axi_rready,
  input  logic [31:0] m_axi_rdata,
  input  logic [1:0]  m_axi_rresp,
  input  logic        m_axi_rlast
);


  //----------------------------------------------------------------------------
  localparam logic [2:0] ID_B  = 'b000;
  localparam logic [2:0] ID_AW = 'b001;
  localparam logic [2:0] ID_AR = 'b010;
  localparam logic [2:0] ID_R  = 'b011;
  localparam logic [2:0] ID_W  = 'b100;

  logic [63:0] shift_aw;
  logic [63:0] shift_ar;
  logic [39:0] shift_w;
  logic [36:0] shift_r;
  logic [1:0]  shift_b;
      
  logic [2:0] cnt_shift_r;
  logic [0:0] cnt_shift_b;


  //----------------------------------------------------------------------------
  assign m_axi_awaddr  = shift_aw[31:0];
  assign m_axi_awprot  = shift_aw[34:32];
  assign m_axi_awsize  = shift_aw[37:35];
  assign m_axi_awburst = shift_aw[39:38];
  assign m_axi_awcache = shift_aw[43:40];
  assign m_axi_awlen   = shift_aw[51:44];
  assign m_axi_awlock  = shift_aw[52:52];
  assign m_axi_awqos   = shift_aw[57:54];

  assign m_axi_araddr  = shift_ar[31:0];
  assign m_axi_arprot  = shift_ar[34:32];
  assign m_axi_arsize  = shift_ar[37:35];
  assign m_axi_arburst = shift_ar[39:38];
  assign m_axi_arcache = shift_ar[43:40];
  assign m_axi_arlen   = shift_ar[51:44];
  assign m_axi_arlock  = shift_ar[52:52];
  assign m_axi_arqos   = shift_ar[57:54];

  assign m_axi_wdata   = shift_w[31:0];
  assign m_axi_wstrb   = shift_w[35:32];
  assign m_axi_wlast   = shift_w[36];


  always_ff @ (posedge aclk or negedge aresetn) begin : stream_to_aw_ar_w
    if (!aresetn) begin
      m_axi_awvalid <= '0;
      m_axi_arvalid <= '0;
      m_axi_wvalid  <= '0;

    end else begin
      if (m_axi_awvalid && m_axi_awready) 
        m_axi_awvalid <= '0;

      if (m_axi_arvalid && m_axi_arready)
        m_axi_arvalid <= '0;

      if (m_axi_wvalid && m_axi_wready)
        m_axi_wvalid <= '0;


      if (rx_packet_tvalid && rx_packet_tready) begin
        case (rx_packet_tid)
          ID_AW : begin
            shift_aw <= {rx_packet_tdata, shift_aw} >> 8;
            if (rx_packet_tlast) begin
              m_axi_awvalid <= '1;
            end
          end
        
          ID_AR : begin
            shift_ar <= {rx_packet_tdata, shift_ar} >> 8;
            if (rx_packet_tlast) begin
              m_axi_arvalid <= '1;
            end
          end
        
          ID_W : begin
            shift_w <= {rx_packet_tdata, shift_w} >> 8;
            if (rx_packet_tlast) begin
              m_axi_wvalid <= '1;
            end
          end

          default : begin end

        endcase
      end

    end
  end


  always_comb begin
   rx_packet_tready <= !(
    (rx_packet_tid == ID_AW && m_axi_awvalid) ||
    (rx_packet_tid == ID_AR && m_axi_arvalid) ||
    (rx_packet_tid == ID_W  && m_axi_wvalid)
   );
  end


  //----------------------------------------------------------------------------
  always_ff @ (posedge aclk or negedge aresetn) begin : r_b_to_stream
    if (!aresetn) begin
      cnt_shift_r      <= '0;
      cnt_shift_b      <= '0;
      tx_packet_tvalid <= '0;

    end else begin
      if (m_axi_rvalid && m_axi_rready) begin
        cnt_shift_r <= 5;
        shift_r     <= {m_axi_rlast, m_axi_rresp, m_axi_rdata};
      end

      if (m_axi_bvalid && m_axi_bready) begin
        cnt_shift_b <= 1;
        shift_b     <= m_axi_bresp;
      end


      if (tx_packet_tvalid && tx_packet_tready) begin
        tx_packet_tvalid <= '0;
      end

      if (!tx_packet_tvalid || tx_packet_tready) begin
        if (cnt_shift_r != 0) begin
          cnt_shift_r       <= cnt_shift_r - 1;
          tx_packet_tvalid  <= '1;
          shift_r           <= shift_r >> 8;
          tx_packet_tdata   <= shift_r[7:0];
          tx_packet_tid     <= ID_R;
          tx_packet_tlast   <= '0;
          if (cnt_shift_r == 1) begin
            tx_packet_tlast <= '1;
          end

        end else if (cnt_shift_b != 0) begin
          cnt_shift_b       <= cnt_shift_b - 1;
          tx_packet_tvalid  <= '1;
          tx_packet_tdata   <= shift_b;
          tx_packet_tid     <= ID_B;
          tx_packet_tlast <= '1;
        end
      end

    end
  end


  assign m_axi_rready = cnt_shift_r == 0 && cnt_shift_b == 0;
  assign m_axi_bready = cnt_shift_r == 0 && cnt_shift_b == 0;
   
endmodule
