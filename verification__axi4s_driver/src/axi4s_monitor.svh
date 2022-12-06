//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


class Axi4s_Monitor #(
  parameter int TDATA_WIDTH = 8,
  parameter int TKEEP_WIDTH = (TDATA_WIDTH+7)/8,
  parameter int TSTRB_WIDTH = (TDATA_WIDTH+7)/8,
  parameter int TUSER_WIDTH = 1,
  parameter int TDEST_WIDTH = 1,
  parameter int TID_WIDTH   = 1
) extends Axi4s_Base;


  //----------------------------------------------------------------------------
  typedef virtual Axi4s_Intf #(
    TDATA_WIDTH, TKEEP_WIDTH, TSTRB_WIDTH, TUSER_WIDTH, TDEST_WIDTH, TID_WIDTH
  ) t_vif;

  typedef Axi4s_Transaction #(
    TDATA_WIDTH, TKEEP_WIDTH, TSTRB_WIDTH, TUSER_WIDTH, TDEST_WIDTH, TID_WIDTH
  ) Transaction;

  t_vif vif;
  Transaction queue [$];


  //----------------------------------------------------------------------------
  function new(t_vif vif=null);
    set_vif(vif);
  endfunction

  function void set_vif(t_vif vif);
    this.vif = vif;
  endfunction


  //----------------------------------------------------------------------------
  task start();
    queue.delete();
    super.start();
  endtask

  task main();
    Transaction t;

    forever begin
      @(posedge vif.aclk iff vif.aresetn && vif.tvalid && vif.tready);
      t = new (vif.tdata, vif.tkeep, vif.tstrb, vif.tuser, vif.tdest, vif.tid, vif.tlast);
      queue.push_back(t);
    end
  endtask

  
  //----------------------------------------------------------------------------

endclass