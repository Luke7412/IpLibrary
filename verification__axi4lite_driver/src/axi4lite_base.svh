//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


virtual class Axi4lite_Base;

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