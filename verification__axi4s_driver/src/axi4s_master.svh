

class AXI4S_Master #(  
  parameter int TDATA_WIDTH = 8,
  parameter int TKEEP_WIDTH = (TDATA_WIDTH+7)/8,
  parameter int TSTRB_WIDTH = (TDATA_WIDTH+7)/8,
  parameter int TUSER_WIDTH = 1,
  parameter int TDEST_WIDTH = 1,
  parameter int TID_WIDTH   = 1
) extends AXI4S_Base;


  //----------------------------------------------------------------------------
  typedef virtual AXI4S_Intf #(
    TDATA_WIDTH, TKEEP_WIDTH, TSTRB_WIDTH, TUSER_WIDTH, TDEST_WIDTH, TID_WIDTH
  ) t_vif;

  typedef AXI4S_Transaction #(
    TDATA_WIDTH, TKEEP_WIDTH, TSTRB_WIDTH, TUSER_WIDTH, TDEST_WIDTH, TID_WIDTH
  ) Transaction;

  AXI4S_Monitor #(
    TDATA_WIDTH, TKEEP_WIDTH, TSTRB_WIDTH, TUSER_WIDTH, TDEST_WIDTH, TID_WIDTH
  ) monitor;

  t_vif vif;
  Transaction todo_queue [$];

  // Ctrl
  int cfg_trottle;


  //----------------------------------------------------------------------------
  function new(t_vif vif=null);
    monitor = new(vif);
    set_vif(vif);
    configure();
  endfunction

  function void set_vif(t_vif vif);
    monitor.set_vif(vif);
    this.vif = vif;
  endfunction

  function void configure(int trottle=100);
    cfg_trottle = trottle;
  endfunction


  //----------------------------------------------------------------------------
  task start();
    init();
    todo_queue.delete();
    monitor.start();
    super.start();
  endtask
  
  task main();
    Transaction t;
    forever begin
      wait (todo_queue.size > 0);
      t = todo_queue[0];
      execute_transaction(t);
      todo_queue.delete(0);
    end
  endtask

  task stop();
    super.stop();
    monitor.stop();
  endtask


  //----------------------------------------------------------------------------
  task init();
    vif.tvalid <= '0;
    vif.tdata  <= '0;
    vif.tkeep  <= '0;
    vif.tstrb  <= '0;
    vif.tuser  <= '0;
    vif.tid    <= '0;
    vif.tdest  <= '0;
    vif.tlast  <= '0;
  endtask

  task execute_transaction (input Transaction t);
    wait (vif.aresetn);

    vif.tvalid <= '1;
    vif.tdata  <= t.tdata;
    vif.tstrb  <= t.tstrb;
    vif.tkeep  <= t.tkeep;
    vif.tuser  <= t.tuser;
    vif.tid    <= t.tid  ;
    vif.tdest  <= t.tdest;
    vif.tlast  <= t.tlast;

    @(posedge vif.aclk iff vif.aresetn && vif.tready);
    vif.tvalid <= 0;

    while ($urandom_range(0, 99) > cfg_trottle) begin
      @(posedge vif.aclk);
    end
  endtask


  //----------------------------------------------------------------------------
  task wait_done();
    wait (todo_queue.size == 0);
  endtask

  task transact(input Transaction t, input bit blocking = 1);
    if (blocking) wait_done();
    todo_queue.push_back(t);
    if (blocking) wait_done();
  endtask

  task send_beat(      
    input logic [TDATA_WIDTH-1:0] tdata = '0,
    input logic [TKEEP_WIDTH-1:0] tkeep = '0,
    input logic [TSTRB_WIDTH-1:0] tstrb = '0,
    input logic [TUSER_WIDTH-1:0] tuser = '0,
    input logic [TID_WIDTH-1:0]   tid   = '0,
    input logic [TDEST_WIDTH-1:0] tdest = '0,
    input logic                   tlast = '0,
    input bit blocking = 1
  );
    Transaction t = new(tdata, tkeep, tstrb, tuser, tid, tdest, tlast);
    transact(t, blocking);
  endtask


endclass