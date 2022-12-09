//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


module identifier_wpr #(
  parameter NAME          = "TEST",
  parameter MAJOR_VERSION = 1,
  parameter MINOR_VERSION = 0
) (
  input         aclk,
  input         aresetn,
  input         ctrl_arvalid,
  output        ctrl_arready,
  input  [7:0]  ctrl_araddr,
  output        ctrl_rvalid,
  input         ctrl_rready,
  output [31:0] ctrl_rdata,
  output [1:0]  ctrl_rresp
);


  //----------------------------------------------------------------------------
  identifier  #(
    .NAME          (NAME),
    .MAJOR_VERSION (MAJOR_VERSION),
    .MINOR_VERSION (MINOR_VERSION)
  ) i_identifier (
    .aclk         (aclk),
    .aresetn      (aresetn),
    .ctrl_arvalid (ctrl_arvalid),
    .ctrl_arready (ctrl_arready),
    .ctrl_araddr  (ctrl_araddr),
    .ctrl_rvalid  (ctrl_rvalid),
    .ctrl_rready  (ctrl_rready),
    .ctrl_rdata   (ctrl_rdata),
    .ctrl_rresp   (ctrl_rresp)
  );
  

endmodule
