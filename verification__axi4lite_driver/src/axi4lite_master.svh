//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


class Axi4lite_Master #(parameter int ADDR_WIDTH = 32) extends Axi4lite_Base;

  //----------------------------------------------------------------------------
  typedef virtual Axi4lite_Intf #(ADDR_WIDTH) t_vif;

  typedef Axi4lite_Transaction #(ADDR_WIDTH) Transaction;

  t_vif vif;
  Transaction todo_queue [$];


  //----------------------------------------------------------------------------
  function new(t_vif vif=null);
    // monitor = new(vif);
    set_vif(vif);
  endfunction

  function void set_vif(t_vif vif);
    // monitor.set_vif(vif);
    this.vif = vif;
  endfunction


  //----------------------------------------------------------------------------
  task start();
    init();
    todo_queue.delete();
    // monitor.start();
    super.start();
  endtask
  
  task main();
    Transaction t;
    forever begin
      wait (todo_queue.size > 0);
      t = todo_queue[0];
      if (t.write) execute_write(t); else execute_read(t);
      todo_queue.delete(0);
    end
  endtask

  task stop();
    super.stop();
    // monitor.stop();
  endtask


  //----------------------------------------------------------------------------
  task init();
    vif.arvalid <= '0;
    vif.araddr  <= '0;
    vif.arprot  <= '0;
    vif.rready  <= '0;
    vif.awvalid <= '0;
    vif.awaddr  <= '0;
    vif.awprot  <= '0;
    vif.wvalid  <= '0;
    vif.wdata   <= '0;
    vif.wstrb   <= '0;
    vif.bready  <= '0;
  endtask

  task execute_write (Transaction t);
    bit aw_done, w_done, b_done = 0;
    vif.awvalid <= '1;
    vif.awaddr  <= t.addr;
    vif.awprot  <= '0;
    vif.wvalid  <= '1;
    vif.wdata   <= t.data;
    vif.wstrb   <= t.strb;
    vif.bready  <= '1;

    do begin
      @(posedge vif.aclk);
      if (vif.awvalid && vif.awready) begin
        vif.awvalid <= '0;
        aw_done = 1;
      end 
      if (vif.wvalid && vif.wready) begin 
        vif.wvalid <= '0;
        w_done = 1;
      end 
      if (vif.bvalid && vif.bready) begin 
        vif.bvalid <= '0;
        t.resp = vif.bresp;
        b_done = 1;
      end 
    end while (!(aw_done && w_done && b_done));
  endtask

  task execute_read (Transaction t);
    bit ar_done, r_done = 0;
    vif.arvalid <= '1;
    vif.araddr  <= t.addr;
    vif.arprot  <= '0;
    vif.rready  <= '1;

    do begin
      @(posedge vif.aclk);
      if (vif.arvalid && vif.arready) begin
        vif.arvalid <= '0;
        ar_done = 1;
      end 
      if (vif.rvalid && vif.rready) begin 
        vif.rvalid <= '0;
        t.data = vif.rdata;
        t.resp = vif.rresp;
        r_done = 1;
      end 
    end while (!(ar_done && r_done));
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

  task read(
    input  bit [ADDR_WIDTH-1:0] addr, 
    output bit [31:0] data, 
    output bit [1:0] resp,
    input  bit blocking = '1
  );
    Transaction t = new(.write(0), .addr(addr));
    transact(t, blocking);
    data = t.data;
    resp = t.resp;
  endtask

  task write(
    input  bit [ADDR_WIDTH-1:0] addr, 
    input  bit [31:0] data,
    input  bit [3:0] strb = '1, 
    output bit [1:0] resp,
    input  bit blocking = '1
  );
    Transaction t = new(.write(0), .addr(addr), .data(data), .strb(strb));
    transact(t, blocking);
    resp = t.resp;
  endtask

endclass