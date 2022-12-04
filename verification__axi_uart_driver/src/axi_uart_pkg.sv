

package axi_uart_pkg;
  import uart_pkg::*;

  typedef enum bit [2:0] {
    READ_ADDR=2, READ_RESP=3, WRITE_ADDR=1, WRITE_DATA=4, WRITE_RESP=0
  } t_pkt_id;


  `include "axi_uart_driver.svh"

endpackage