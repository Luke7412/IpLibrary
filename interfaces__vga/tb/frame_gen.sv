
//------------------------------------------------------------------------------
module frame_gen ( 
  input  logic aclk,
  input  logic aresetn,

  input  logic [15:0] H_RES,
  input  logic [15:0] V_RES,
  input  logic        sof,

  output logic             pix_tvalid,
  input  logic             pix_tready,
  output logic [2:0][7:0]  pix_tdata,
  output logic             pix_tlast,
  output logic             pix_tuser
);


  //----------------------------------------------------------------------------
  logic [$size(H_RES)-1:0] h_cnt;
  logic [$size(V_RES)-1:0] v_cnt;
  logic running;


  //----------------------------------------------------------------------------
  always_ff @(posedge aclk or negedge aresetn) begin
    logic v_is_h_border;
    logic v_is_v_border;

    if (!aresetn) begin
      pix_tvalid  <= '0;
      pix_tdata   <= '0;
      v_cnt       <= '0;
      h_cnt       <= '0;
      running     <= '0;

    end else begin
      if (sof && !running) begin
        pix_tvalid  <= '0;
        pix_tdata   <= '0;
        pix_tlast   <= '0;
        pix_tuser   <= '0;
        v_cnt       <= '0;
        h_cnt       <= '0;
        running     <= '1;

      end else begin
        if (pix_tvalid && pix_tready) begin
          pix_tvalid <= '0;
          pix_tdata  <= '0;
          pix_tlast  <= '0;
          pix_tuser  <= '0;
        end
        
        if (running && (!pix_tvalid || pix_tready)) begin
          v_is_h_border = h_cnt == H_RES-1 || h_cnt == 0;
          v_is_v_border = v_cnt == V_RES-1 || v_cnt == 0;

          pix_tvalid  <= '1;
          pix_tdata   <= {8'(0), 8'(v_cnt), 8'(h_cnt)};
          // pix_tdata <= {
          //   8'h00,
          //   v_is_h_border ? 8'hFF : 8'h00, 
          //   v_is_v_border ? 8'hFF : 8'h00
          // };
          pix_tlast   <= h_cnt == H_RES-1;
          pix_tuser   <= v_cnt == 0 && h_cnt == 0;

          if (h_cnt != H_RES-1) begin
            h_cnt <= h_cnt + 1;
          end else begin
            h_cnt <= '0;
            if (v_cnt != V_RES-1) begin
              v_cnt <= v_cnt + 1;
            end else begin
              running <= '0;
              v_cnt <= '0;
            end
          end
        end

      end
    end
  end


endmodule