module virtual_fifo #(
  parameter int TDATA_BYTES = 8,
  parameter int TUSER_WIDTH = 1,
  parameter int TKEEP_WIDTH = TDATA_BYTES,
  parameter int TSTRB_WIDTH = 1,
  parameter int TID_WIDTH   = 1,
  parameter int TDEST_WIDTH = 1,
  parameter int ADDR_WIDTH    = 12,
  parameter int MAX_BURST_LEN = 256
)( 
  input logic aclk,
  input logic aresetn,
  
  input  logic                      target_tvalid,    
  output logic                      target_tready,    
  input  logic [8*TDATA_BYTES-1:0]  target_tdata,     
  input  logic [TUSER_WIDTH-1:0]    target_tuser,     
  input  logic [TKEEP_WIDTH-1:0]    target_tkeep,     
  input  logic [TSTRB_WIDTH-1:0]    target_tstrb,     
  input  logic [TID_WIDTH-1:0]      target_tid,       
  input  logic [TDEST_WIDTH-1:0]    target_tdest,     
  input  logic                      target_tlast,     
  
  output logic                      initiator_tvalid,
  input  logic                      initiator_tready,
  output logic [8*TDATA_BYTES-1:0]  initiator_tdata,
  output logic [TUSER_WIDTH-1:0]    initiator_tuser,
  output logic [TKEEP_WIDTH-1:0]    initiator_tkeep,
  output logic [TSTRB_WIDTH-1:0]    initiator_tstrb,
  output logic [TID_WIDTH-1:0]      initiator_tid,
  output logic [TDEST_WIDTH-1:0]    initiator_tdest,
  output logic                      initiator_tlast,

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
  output logic [TDATA_BYTES-1:0]    mem_wstrb,
  output logic                      mem_wlast,
  input  logic                      mem_bvalid,
  output logic                      mem_bready,
  input  logic [3:0]                mem_bid,
  input  logic [1:0]                mem_bresp,
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
  input  logic                      mem_rlast
);


  //----------------------------------------------------------------------------
  logic                     headerinsert_tvalid;
  logic                     headerinsert_tready;
  logic [8*TDATA_BYTES-1:0] headerinsert_tdata;
  logic [7:0]               headerinsert_tuser;
  logic [TKEEP_WIDTH-1:0]   headerinsert_tkeep;
  logic                     headerinsert_tlast;

  logic                     streamdecomposer_tvalid, packetchopper_tvalid, datafifo_tvalid;
  logic                     streamdecomposer_tready, packetchopper_tready, datafifo_tready;
  logic [8*TDATA_BYTES-1:0] streamdecomposer_tdata , packetchopper_tdata , datafifo_tdata ;
  logic [TKEEP_WIDTH-1:0]   streamdecomposer_tkeep , packetchopper_tkeep , datafifo_tkeep ;
  logic                     streamdecomposer_tlast , packetchopper_tlast , datafifo_tlast ;

  logic                     meta_tvalid;
  logic                     meta_tready;
  logic [15:0]              meta_tdata;
  logic [TID_WIDTH-1:0]     meta_tid;
  logic [TDEST_WIDTH-1:0]   meta_tdest;

  logic                     axireader_tvalid;
  logic                     axireader_tready;
  logic [8*TDATA_BYTES-1:0] axireader_tdata;
  
  logic [ADDR_WIDTH-$clog2(TDATA_BYTES):0] wr_ptr;
  logic [ADDR_WIDTH-$clog2(TDATA_BYTES):0] rd_ptr;


  //----------------------------------------------------------------------------
  packet_chopper #(
    .TDATA_BYTES      (TDATA_BYTES),
    .TKEEP_WIDTH      (TKEEP_WIDTH),
    .TID_WIDTH        (TID_WIDTH),    
    .TDEST_WIDTH      (TDEST_WIDTH),
    .MAX_BURST_LEN    (MAX_BURST_LEN-1)
  ) i_packet_chopper (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (target_tvalid),
    .target_tready    (target_tready),
    .target_tdata     (target_tdata),
    .target_tkeep     (target_tkeep),
    .target_tid       (target_tid),
    .target_tdest     (target_tdest),
    .target_tlast     (target_tlast),
    .initiator_tvalid (packetchopper_tvalid),
    .initiator_tready (packetchopper_tready),
    .initiator_tdata  (packetchopper_tdata),
    .initiator_tkeep  (packetchopper_tkeep),
    .initiator_tlast  (packetchopper_tlast),
    .meta_tvalid      (meta_tvalid),
    .meta_tready      (meta_tready),
    .meta_tdata       (meta_tdata),
    .meta_tid         (meta_tid),
    .meta_tdest       (meta_tdest)
  );

  data_fifo #(
    .TDATA_BYTES (TDATA_BYTES),
    .TKEEP_WIDTH (TKEEP_WIDTH)
  ) i_data_fifo (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (packetchopper_tvalid),
    .target_tready    (packetchopper_tready),
    .target_tdata     (packetchopper_tdata),
    .target_tkeep     (packetchopper_tkeep),
    .target_tlast     (packetchopper_tlast),
    .initiator_tvalid (datafifo_tvalid),
    .initiator_tready (datafifo_tready),
    .initiator_tdata  (datafifo_tdata),
    .initiator_tkeep  (datafifo_tkeep),
    .initiator_tlast  (datafifo_tlast)
  );


  header_insert #(
    .TDATA_BYTES  (TDATA_BYTES),
    .TKEEP_WIDTH  (TKEEP_WIDTH),
    .TID_WIDTH    (TID_WIDTH),    
    .TDEST_WIDTH  (TDEST_WIDTH)
  ) i_header_insert (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (datafifo_tvalid),
    .target_tready    (datafifo_tready),
    .target_tdata     (datafifo_tdata),
    .target_tkeep     (datafifo_tkeep),
    .target_tlast     (datafifo_tlast),
    .initiator_tvalid (headerinsert_tvalid),
    .initiator_tready (headerinsert_tready),
    .initiator_tdata  (headerinsert_tdata),
    .initiator_tuser  (headerinsert_tuser),
    .initiator_tkeep  (headerinsert_tkeep),
    .initiator_tlast  (headerinsert_tlast),
    .meta_tvalid      (meta_tvalid),
    .meta_tready      (meta_tready),
    .meta_tdata       (meta_tdata),
    .meta_tid         (meta_tid),
    .meta_tdest       (meta_tdest)
  );


  axi_writer #(
    .TDATA_BYTES    (TDATA_BYTES),
    .ADDR_WIDTH     (ADDR_WIDTH),
    .MAX_BURST_LEN  (MAX_BURST_LEN)
  ) i_axi_writer ( 
    .aclk           (aclk),
    .aresetn        (aresetn),
    .target_tvalid  (headerinsert_tvalid),
    .target_tready  (headerinsert_tready),
    .target_tdata   (headerinsert_tdata),
    .target_tuser   (headerinsert_tuser),
    .target_tkeep   (headerinsert_tkeep),
    .target_tlast   (headerinsert_tlast),
    .mem_awvalid    (mem_awvalid),
    .mem_awready    (mem_awready),
    .mem_awaddr     (mem_awaddr),
    .mem_awlen      (mem_awlen),
    .mem_awsize     (mem_awsize),
    .mem_awburst    (mem_awburst),
    .mem_awid       (mem_awid),
    .mem_wvalid     (mem_wvalid),
    .mem_wready     (mem_wready),
    .mem_wdata      (mem_wdata),
    .mem_wstrb      (mem_wstrb),
    .mem_wlast      (mem_wlast),
    .mem_bvalid     (mem_bvalid),
    .mem_bready     (mem_bready),
    .mem_bid        (mem_bid),
    .mem_bresp      (mem_bresp),
    .wr_ptr         (wr_ptr),
    .rd_ptr         (rd_ptr)
  );


  axi_reader #(
    .TDATA_BYTES    (TDATA_BYTES),
    .ADDR_WIDTH     (ADDR_WIDTH),
    .MAX_BURST_LEN  (MAX_BURST_LEN)
  ) i_axi_reader (
    .aclk             (aclk),
    .aresetn          (aresetn),
    .mem_arvalid      (mem_arvalid),
    .mem_arready      (mem_arready),
    .mem_araddr       (mem_araddr),
    .mem_arlen        (mem_arlen),
    .mem_arsize       (mem_arsize),
    .mem_arburst      (mem_arburst),
    .mem_arid         (mem_arid),
    .mem_rvalid       (mem_rvalid),
    .mem_rready       (mem_rready),
    .mem_rdata        (mem_rdata),
    .mem_rid          (mem_rid),
    .mem_rresp        (mem_rresp),
    .mem_rlast        (mem_rlast),
    .initiator_tvalid (axireader_tvalid),
    .initiator_tready (axireader_tready),
    .initiator_tdata  (axireader_tdata),
    .wr_ptr           (wr_ptr),
    .rd_ptr           (rd_ptr)
  );


  stream_expander #(
    .TDATA_BYTES  (TDATA_BYTES),
    .TKEEP_WIDTH  (TKEEP_WIDTH),
    .TID_WIDTH    (TID_WIDTH),    
    .TDEST_WIDTH  (TDEST_WIDTH)
  ) i_stream_expander ( 
    .aclk             (aclk),
    .aresetn          (aresetn),
    .target_tvalid    (axireader_tvalid),
    .target_tready    (axireader_tready),
    .target_tdata     (axireader_tdata),
    .initiator_tvalid (initiator_tvalid),
    .initiator_tready (initiator_tready),
    .initiator_tdata  (initiator_tdata),
    .initiator_tkeep  (initiator_tkeep),
    .initiator_tid    (initiator_tid),
    .initiator_tdest  (initiator_tdest),
    .initiator_tlast  (initiator_tlast)
  );


endmodule
