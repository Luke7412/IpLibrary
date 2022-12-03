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
    logic [9:0] rx;
    
    forever begin
      @ (negedge vif.rx);
      #(BIT_PERIOD/2);
      rx[0] = vif.rx;
      for (int i=1; i<$size(rx); i++) begin
        #(BIT_PERIOD);
        rx[i] = vif.rx;
      end
      if (!rx[0] && rx[9])
        rx_queue.push_back(rx[8:1]);
    end
  endtask


endclass