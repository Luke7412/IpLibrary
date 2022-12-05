

package axi4s_pkg;

  typedef enum {s_OFF, s_ON, s_PERIODIC, s_TROTTLE} t_mode;

  `include "axi4s_transaction.svh"
  `include "axi4s_base.svh"
  `include "axi4s_monitor.svh"
  `include "axi4s_master.svh"
  `include "axi4s_slave.svh"

endpackage