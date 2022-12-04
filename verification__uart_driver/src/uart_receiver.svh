//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


class UartReceiver #(real BAUD_RATE=9600) extends UartBase;

  localparam real BIT_PERIOD = 1000000000/BAUD_RATE;
  typedef bit [7:0] u8;
  
  virtual UartIntf vif;
  u8 rx_queue [$];

  //----------------------------------------------------------------------------
  function new (virtual UartIntf vif);
    this.vif = vif;
  endfunction


  //----------------------------------------------------------------------------
  task start();
    rx_queue.delete();
    super.start();
  endtask

  task main();
    logic [9:0] bits;
    
    forever begin
      @ (negedge vif.rxd);
      #(BIT_PERIOD/2);
      bits[0] = vif.rxd;
      for (int i=1; i<$size(bits); i++) begin
        #(BIT_PERIOD);
        bits[i] = vif.rxd;
      end
      if (!bits[0] && bits[9])
        rx_queue.push_back(bits[8:1]);
    end
  endtask


  //----------------------------------------------------------------------------
  task fetch_byte(output u8 data, input bit blocking=1);
    if (blocking)
      wait (rx_queue.size() > 1);
    data = rx_queue.pop_front();
  endtask

  task send_bytes(output u8 bytes [], input bit blocking=1);
    foreach(bytes[i])
      fetch_byte(bytes[i], blocking);
  endtask

endclass