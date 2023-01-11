
//------------------------------------------------------------------------------
// Project Name: IpLibrary
//------------------------------------------------------------------------------
// Author      : Lukas Vinkx (lvin)
// Description : 
//------------------------------------------------------------------------------


module dmux_sync #(
  parameter int DEPTH = 2,
  parameter int WIDTH = 8,
  parameter bit RST_VAL = '0
)(
  // src domain
  input  logic             src_toggle,
  input  logic [WIDTH-1:0] src_data,
  // dst domain
  input  logic             dst_clk,
  input  logic             dst_rst_n,
  output logic             dst_pulse,
  output logic [WIDTH-1:0] dst_data
);


  //----------------------------------------------------------------------------


  //----------------------------------------------------------------------------
  pulse_sync #(
    .DEPTH      (DEPTH),
    .RST_VAL    (RST_VAL)
  ) i_pulse_sync (
    .src_toggle (src_toggle),
    .dst_clk    (dst_clk),
    .dst_rst_n  (dst_rst_n),
    .dst_pulse  (dst_pulse)
  );

  always_ff @(posedge dst_clk or negedge dst_rst_n) begin
    if (!dst_rst_n) begin
      dst_data <= '0;

    end else begin
      if (dst_pulse) begin
        dst_data <= src_data;
      end
    end
  end

endmodule