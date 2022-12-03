

class Axi4sMonitor #(
  parameter int TDATA_WIDTH = 8,
  parameter int TKEEP_WIDTH = TDATA_WIDTH/8,
  parameter int TSTRB_WIDTH = TDATA_WIDTH/8,
  parameter int TUSER_WIDTH = 1,
  parameter int TDEST_WIDTH = 1,
  parameter int TID_WIDTH   = 1
) extends axi4s_base;

  typedef Axi4sIntf #(
    TDATA_WIDTH, TKEEP_WIDTH, TSTRB_WIDTH, TUSER_WIDTH, TDEST_WIDTH, TID_WIDTH
  ) t_vif;

  t_vif vif;

  T queue [$];


  //----------------------------------------------------------------------------
  function new(t_vif vif);
    this.vif = vif;
  endfunction


  //----------------------------------------------------------------------------
  function void start();
    queue.delete();
    super.start();
  endfunction

  task main();
    forever begin
      @(posedge vif.aclk) iff (vif.tvalid && vif.tready);
      queue.push_back();
    end
  endtask

  
  //----------------------------------------------------------------------------

endclass