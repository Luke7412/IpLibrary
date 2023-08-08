module axi_writer #(
  parameter int TDATA_BYTES   = 8,
  parameter int TKEEP_WIDTH   = TDATA_BYTES,
  parameter int TSTRB_WIDTH   = TDATA_BYTES,
  parameter int ADDR_WIDTH    = 16,
  parameter int MAX_BURST_LEN = 256
)( 
  // Clock and Reset
  input  logic aclk,
  input  logic aresetn,
  // AXI4-Stream target interface
  input  logic                      target_tvalid,
  output logic                      target_tready,
  input  logic [8*TDATA_BYTES-1:0]  target_tdata,
  input  logic [7:0]                target_tuser,
  input  logic [TKEEP_WIDTH-1:0]    target_tkeep,
  input  logic                      target_tlast,
  // AXI4 Write interface
  output logic                      mem_awvalid,
  input  logic                      mem_awready,
  output logic [ADDR_WIDTH-1:0]     mem_awaddr,
  output logic [7:0]                mem_awlen,
  output logic [2:0]                mem_awsize,
  output logic [1:0]                mem_awburst,
  output logic [3:0]                mem_awid,
  output logic                      mem_wvalid,
  input  logic                      mem_wready,
  output logic [8*TDATA_BYTES-1:0]  mem_wdata,
  output logic [TSTRB_WIDTH-1:0]    mem_wstrb,
  output logic                      mem_wlast,
  input  logic                      mem_bvalid,
  output logic                      mem_bready,
  input  logic [3:0]                mem_bid,
  input  logic [1:0]                mem_bresp,
  // Others
  output logic [ADDR_WIDTH-$clog2(TDATA_BYTES):0] wr_ptr,
  input  logic [ADDR_WIDTH-$clog2(TDATA_BYTES):0] rd_ptr
);


  //----------------------------------------------------------------------------
  enum logic [0:0] {HEADER, DATA} state;

  logic [$size(wr_ptr)-1:0] wr_ptr_int;
  logic [$size(wr_ptr)-1:0] delta_ptr;
  logic ready_int;

  logic full;

  //----------------------------------------------------------------------------
  assign full = delta_ptr[$high(delta_ptr)];



  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      wr_ptr_int  <= '0;
      mem_awvalid <= '0;
      mem_bready  <= '0;
      ready_int   <= '0;
      state       <= HEADER;

    end else begin
      delta_ptr <= wr_ptr_int + MAX_BURST_LEN - rd_ptr;

      if (ready_int) begin
        wr_ptr <= wr_ptr_int;
      end

      if (mem_awvalid && mem_awready) begin
        mem_awvalid <= '0;
      end

      if (mem_wvalid && mem_wready) begin
        wr_ptr_int <= wr_ptr_int + 1;
      end

      if (mem_bvalid && mem_bready) begin
        mem_bready <= '0;
      end

      case (state)
        HEADER : begin
          if (!full) begin
            if (target_tvalid) begin
              ready_int   <= '1;
              mem_bready  <= '1;
              mem_awvalid <= '1;
              mem_awaddr  <= wr_ptr_int[$high(wr_ptr_int)-1:0] << $clog2(TDATA_BYTES);
              mem_awlen   <= target_tuser;
              state       <= DATA;
            end
          end
        end

        DATA : begin
          if (mem_wvalid && mem_wready) begin
            if (mem_wlast) begin
              ready_int <= '0;
              state     <= HEADER;
            end      
          end
        end

      endcase
    end
  end
  

  assign target_tready = mem_wready && ready_int;

  assign mem_awsize    =  $clog2(TDATA_BYTES);
  assign mem_awburst   = 2'b01; // increment
  assign mem_awid      = '0;
  
  assign mem_wvalid    = target_tvalid && ready_int;
  assign mem_wdata     = target_tdata;
  assign mem_wstrb     = target_tkeep;
  assign mem_wlast     = target_tlast; 
  
endmodule
