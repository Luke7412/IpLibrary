//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
module sampler_phased (
  input  logic       clk,
  input  logic       clk90,
  input  logic       rst_n,
  input  logic       in_data,
  output logic [3:0] out_data
);


  //----------------------------------------------------------------------------
  logic [3:0] az, bz, cz, dz;

   
  //----------------------------------------------------------------------------
  always_ff @ (posedge clk) begin : p_sampling_clk_000
    az[0] <= in_data;
    az[1] <= az[0];
    az[2] <= az[1];
    az[3] <= az[2];

    bz[1] <= bz[0];
    bz[2] <= bz[1];
    bz[3] <= bz[2];

    cz[2] <= cz[1];
    cz[3] <= cz[2];

    dz[3] <= dz[2];
  end


  always_ff @ (posedge clk90) begin : p_sampling_clk_090
    bz[0] <= in_data;
    cz[1] <= cz[0];
    dz[2] <= dz[1];
  end


  always_ff @ (negedge clk) begin : p_sampling_clk_180
    cz[0] <= in_data;
    dz[1] <= dz[0];
  end


  always_ff @ (negedge clk90) begin : p_sampling_clk_270
    dz[0] <= in_data;
  end


  assign out_data = {dz[3], cz[3], bz[3], az[3]};


endmodule