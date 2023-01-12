
//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


module pulse_sync_wpr #(
  parameter DEPTH = 2,
  parameter RST_VAL = 1'b0,
  parameter TOGGLE_EARLY = 0
)(
  input  src_toggle,
  input  dst_clk,
  input  dst_rst_n,
  output dst_toggle,
  output dst_pulse
);


  //----------------------------------------------------------------------------
  pulse_sync #(
    .DEPTH (DEPTH),
    .RST_VAL (RST_VAL),
    .TOGGLE_EARLY (TOGGLE_EARLY)
  ) i_pulse_sync (
    .src_toggle (src_toggle),
    .dst_clk (dst_clk),
    .dst_rst_n (dst_rst_n),
    .dst_toggle (dst_toggle),
    .dst_pulse (dst_pulse)
  );

endmodule