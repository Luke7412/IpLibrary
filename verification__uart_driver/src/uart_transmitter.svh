//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


class Uart_Transmitter #(real BAUD_RATE=9600) extends Uart_Base;

  localparam real BIT_PERIOD = 1000000000/BAUD_RATE;
  typedef bit [7:0] u8;

  virtual Uart_Intf vif;
  u8 tx_queue [$];

  //----------------------------------------------------------------------------
  function new (virtual Uart_Intf vif);
    this.vif = vif;
  endfunction

  //----------------------------------------------------------------------------
  task start();
    init();
    super.start();
  endtask

  task init();
    vif.txd <= '1;
  endtask

  task main();
    forever begin
      wait (tx_queue.size() > 0);
      send_byte(tx_queue[0]);
      void'(tx_queue.pop_front());
    end
  endtask

  //----------------------------------------------------------------------------
  task send_byte(u8 data);
    logic [9:0] bits = {1'b1, data, 1'b0};

    for (int i=0; i<$size(bits); i++) begin
      vif.txd <= bits[i];
      #(BIT_PERIOD); 
    end
  endtask

  task send_bytes(u8 bytes [], bit blocking=1);
    foreach(bytes[i])
      tx_queue.push_back(bytes[i]);

    if (blocking)
      wait (tx_queue.size() == 0);
  endtask

endclass