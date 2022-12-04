

class Axi4sMonitor #(type T Axi4sTransaction) extends axi4s_base;

  typedef Axi4sIntf #(
    Axi4sTransaction.TDATA_WIDTH, Axi4sTransaction.TKEEP_WIDTH, 
    Axi4sTransaction.TSTRB_WIDTH, Axi4sTransaction.TUSER_WIDTH, 
    Axi4sTransaction.TDEST_WIDTH, Axi4sTransaction.TID_WIDTH
  ) t_vif;

  t_vif vif;
  Axi4sTransaction queue [$];


  //----------------------------------------------------------------------------
  function new(t_vif vif);
    this.vif = vif;
  endfunction


  //----------------------------------------------------------------------------
  task start();
    queue.delete();
    super.start();
  endtask


  task main();
    Axi4sTransaction transaction;

    forever begin
      @(posedge vif.aclk) iff (vif.tvalid && vif.tready);
      transaction = new (
        .tdata (vif.tdata), .tkeep (vif.tkeep), .tstrb (vif.tstrb),
        .tuser (vif.tuser), .tdest (vif.tdest), .tid (vif.tid),
        .tlast (vif.tlast)
      )
      queue.push_back(transaction);
    end
  endtask

  
  //----------------------------------------------------------------------------

endclass