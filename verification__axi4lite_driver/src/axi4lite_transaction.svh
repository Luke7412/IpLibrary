//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


class Axi4lite_Transaction #(parameter int ADDR_WIDTH = 8);

  bit                   write;
  bit [ADDR_WIDTH-1:0]  addr;
  bit [31:0]            data;
  bit [1:0]             resp;
  bit [3:0]             strb;

  function new (
    bit                   write = '0,
    bit [ADDR_WIDTH-1:0]  addr  = '0,
    bit [31:0]            data  = '0,
    bit [3:0]             strb  = '0,
    bit [1:0]             resp  = '0
  );
    this.write = write;
    this.addr  = addr;
    this.data  = data;
    this.strb  = strb;
    this.resp  = resp;
  endfunction

endclass