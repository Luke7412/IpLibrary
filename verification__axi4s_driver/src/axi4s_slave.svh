//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


class Axi4s_Slave #(
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

  Axi4s_Monitor #(
    TDATA_WIDTH, TKEEP_WIDTH, TSTRB_WIDTH, TUSER_WIDTH, TDEST_WIDTH, TID_WIDTH
  ) monitor;

  t_vif vif;

  // Ctrl
  t_mode   cfg_mode;
  int      cfg_period;
  int      cfg_trottle;
  bit      cfg_monitor_en;


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

  function void configure(t_mode mode=s_ON, int period=1, trottle=100);
    cfg_mode    = mode;
    cfg_period  = period;
    cfg_trottle = trottle;
  endfunction


  //----------------------------------------------------------------------------
  task start();
    init();
    monitor.start();
    super.start();
  endtask

  task main();
    int div_cnt = 0;

    forever begin
      @(posedge vif.aclk);

      // tready generation
      div_cnt = div_cnt == 0 ?  cfg_period-1 : div_cnt-1;

      case (cfg_mode)
        s_OFF      : vif.tready <= '0;
        s_ON       : vif.tready <= '1;
        s_PERIODIC : vif.tready <= div_cnt == 0;
        s_TROTTLE  : vif.tready <= $urandom_range(0, 99) < cfg_trottle;
        default    : vif.tready <= 0;
      endcase

    end
  endtask 

  task stop();
    super.stop();
    monitor.stop();
  endtask


  //----------------------------------------------------------------------------
  task init();
    vif.tready <= '0;
  endtask


endclass