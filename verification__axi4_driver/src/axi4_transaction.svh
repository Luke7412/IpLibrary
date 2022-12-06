

class Axi4_Transaction #(
  parameter int TDATA_WIDTH = 8,
  parameter int TKEEP_WIDTH = TDATA_WIDTH/8,
  parameter int TSTRB_WIDTH = TDATA_WIDTH/8,
  parameter int TUSER_WIDTH = 1,
  parameter int TDEST_WIDTH = 1,
  parameter int TID_WIDTH   = 1
);

  logic                   tvalid;
  logic                   tready;
  logic [TDATA_WIDTH-1:0] tdata;
  logic [TKEEP_WIDTH-1:0] tkeep;
  logic [TSTRB_WIDTH-1:0] tstrb;
  logic [TUSER_WIDTH-1:0] tuser;
  logic [TDEST_WIDTH-1:0] tdest;
  logic [TID_WIDTH-1:0]   tid;
  logic                   tlast;

  function new (
    logic [TDATA_WIDTH-1:0] tdata = '0,
    logic [TKEEP_WIDTH-1:0] tkeep = '0,
    logic [TSTRB_WIDTH-1:0] tstrb = '0,
    logic [TUSER_WIDTH-1:0] tuser = '0,
    logic [TDEST_WIDTH-1:0] tdest = '0,
    logic [TID_WIDTH-1:0]   tid   = '0,
    logic                   tlast = '0
  );
    this tdata = tdata;
    this tkeep = tkeep;
    this tstrb = tstrb;
    this tuser = tuser;
    this tdest = tdest;
    this tid = tid;
    this tlast = tlast;
  endfunction

endclass