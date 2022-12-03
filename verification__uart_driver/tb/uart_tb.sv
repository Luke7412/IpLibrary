

module uart_tb();
   import uart_pkg::*;

   UartIntf vif ();
   UartTransmitter #(9600) transmitter;
   UartReceiver #(9600) receiver;

   assign vif.rx = vif.tx;

   initial begin
      transmitter = new(vif);
      receiver = new(vif);

      transmitter.start();
      receiver.start();
      #50us;

      // transmitter.send_bytes('{8'h00, 8'h01, 8'h02, 8'h03}, .blocking(0));
      // #50us;

      // transmitter.send_bytes('{8'h04, 8'h05, 8'h06, 8'h07}, .blocking(1));
      // #50us;
      // transmitter.stop();
      // #50us;
      // transmitter.start();
      transmitter.send_bytes('{8'h08, 8'h09, 8'h0A, 8'h0B}, .blocking(0));
      // #50us;

      // transmitter.send_bytes('{8'h01}, .blocking(1));

      #1000us;
      $display(receiver.byte_queue.size());
      foreach (receiver.byte_queue[i])
         $display("%u", receiver.byte_queue[i]);
   end

   
endmodule