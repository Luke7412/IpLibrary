
//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


module pulse_sync #(
  parameter int DEPTH = 2,
  parameter bit RST_VAL = '0,
  parameter bit TOGGLE_EARLY = 0
)(
  // src domain
  input  logic src_toggle,
  // dst domain
  input  logic dst_clk,
  input  logic dst_rst_n,
  output logic dst_toggle,
  output logic dst_pulse
);


  //----------------------------------------------------------------------------
  logic dst_toggle_i, dst_toggle_q;


  //----------------------------------------------------------------------------
  dff_sync #(
    .DEPTH   (DEPTH),
    .RST_VAL (RST_VAL)
  ) i_dff_sync (
    // src domain
    .src_data  (src_toggle),
    // dst domain
    .dst_clk   (dst_clk),
    .dst_rst_n (dst_rst_n),
    .dst_data  (dst_toggle_i)
  );

  always_ff @(posedge dst_clk or negedge dst_rst_n) begin
    if (!dst_rst_n) begin
      dst_toggle_q <= RST_VAL;
    end else begin
      dst_toggle_q <= dst_toggle_i;
    end
  end

  assign dst_toggle = TOGGLE_EARLY ? dst_toggle_i : dst_toggle_q;
  assign dst_pulse  = dst_toggle_q ^ dst_toggle_i;


endmodule