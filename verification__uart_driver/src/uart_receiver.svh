//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


class UartReceiver #(real BAUD_RATE=9600) extends UartBase;

  localparam real BIT_PERIOD = 1000000000/BAUD_RATE;
  virtual UartIntf vif;

  byte rx_queue [$];

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


endclass