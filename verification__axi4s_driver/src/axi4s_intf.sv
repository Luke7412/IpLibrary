//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


interface Axi4s_Intf #(
  parameter int TDATA_WIDTH = 8,
  parameter int TKEEP_WIDTH = TDATA_WIDTH/8,
  parameter int TSTRB_WIDTH = TDATA_WIDTH/8,
  parameter int TUSER_WIDTH = 1,
  parameter int TDEST_WIDTH = 1,
  parameter int TID_WIDTH   = 1
)(
  input logic aclk,
  input logic aresetn
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


endinterface