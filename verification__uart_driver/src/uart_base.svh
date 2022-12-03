

virtual class UartBase;

  process p;

  //----------------------------------------------------------------------------
  task start();
    if (p == null) begin
      fork
        begin
          p = process::self(); 
          main();
        end
      join_none
    end
  endtask

  function void stop();
    if (p != null)
        p.kill();
    p = null;
  endfunction

  pure virtual task main(); 

endclass