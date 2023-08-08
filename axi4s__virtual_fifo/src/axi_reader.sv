
module axi_reader #(
  parameter int TDATA_BYTES   = 8,
  parameter int ADDR_WIDTH    = 16,
  parameter int MAX_BURST_LEN = 256
)(
  // Clock and Reset
  input  logic aclk,
  input  logic aresetn,
  // AXI4 Read interface
  output logic                      mem_arvalid,
  input  logic                      mem_arready,
  output logic [ADDR_WIDTH-1:0]     mem_araddr,
  output logic [7:0]                mem_arlen,
  output logic [2:0]                mem_arsize,
  output logic [1:0]                mem_arburst,
  output logic [3:0]                mem_arid,
  input  logic                      mem_rvalid,
  output logic                      mem_rready,
  input  logic [8*TDATA_BYTES-1:0]  mem_rdata,
  input  logic [3:0]                mem_rid,
  input  logic [1:0]                mem_rresp,
  input  logic                      mem_rlast,
  // AXI4-Stream output interface
  output logic                      initiator_tvalid,
  input  logic                      initiator_tready,
  output logic [8*TDATA_BYTES-1:0]  initiator_tdata,
  // Others
  input  logic [ADDR_WIDTH-$clog2(TDATA_BYTES):0] wr_ptr,
  output logic [ADDR_WIDTH-$clog2(TDATA_BYTES):0] rd_ptr
);


  //----------------------------------------------------------------------------
  localparam int BEATADDRSHIFT  = $clog2(TDATA_BYTES);

  enum logic [1:0] {IDLE, BUSY, FINISH} state;

  logic [$size(rd_ptr)-1:0] rd_ptr_int;
  logic [$size(rd_ptr)-1:0] delta_ptr;


  //----------------------------------------------------------------------------
  always_ff @(posedge aclk or negedge aresetn) begin  
    if (!aresetn) begin
      state       <= IDLE;   
      mem_arvalid <= '0;
      mem_araddr  <= '0;
      rd_ptr      <= '0;
      rd_ptr_int  <= '0;
      delta_ptr   <= '0;

    end else begin
      delta_ptr <= wr_ptr - rd_ptr_int;

      if (mem_arvalid && mem_arready) begin
        mem_arvalid <= '0;
      end

      case (state)
        IDLE : begin
          if (delta_ptr != 0) begin
            state       <= BUSY;
            mem_arvalid <= '1;
            mem_araddr  <= rd_ptr_int[$high(rd_ptr_int)-1:0] << $clog2(TDATA_BYTES);
            mem_arlen   <= (delta_ptr < MAX_BURST_LEN) ? delta_ptr-1 : MAX_BURST_LEN-1;
          end
        end

        BUSY : begin 
          if (mem_rvalid && mem_rready) begin
            rd_ptr_int <= rd_ptr_int + 1;
            if (mem_rlast) begin
              rd_ptr <= rd_ptr_int;
              state <= FINISH;
            end
          end
        end

        FINISH : begin 
          state <= IDLE;
        end

      endcase
    end
  end


  assign initiator_tvalid = mem_rvalid;
  assign initiator_tdata  = mem_rdata;
  assign mem_rready       = initiator_tready;

  assign mem_arsize       = $clog2(TDATA_BYTES);
  assign mem_arburst      = 2'b01; // increment
  assign mem_arid         = '0;
   

endmodule
