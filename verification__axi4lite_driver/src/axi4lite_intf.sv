

interface Axi4lite_Intf #(
  parameter int ADDR_WIDTH = 32
)(
  input logic aclk,
  input logic aresetn
);
  
  logic                   arvalid;
  logic                   arready;
  logic [ADDR_WIDTH-1:0]  araddr;
  logic [2:0]             arprot;
  logic                   rvalid;
  logic                   rready;
  logic [31:0]            rdata;
  logic [1:0]             rresp;
  logic                   awvalid;
  logic                   awready;
  logic [ADDR_WIDTH-1:0]  awaddr;
  logic [2:0]             awprot;
  logic                   wvalid;
  logic                   wready;
  logic [31:0]            wdata;
  logic [3:0]             wstrb;
  logic                   bvalid;
  logic                   bready;
  logic [1:0]             bresp;

endinterface