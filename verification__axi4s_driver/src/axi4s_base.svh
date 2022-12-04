

virtual class AxisBase;

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

  task stop();
    if (p != null)
      p.kill();
    p = null;
  endtask

  pure virtual task main(); 

endclass