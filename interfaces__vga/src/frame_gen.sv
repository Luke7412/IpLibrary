
//------------------------------------------------------------------------------
module frame_gen #(
  parameter int H_RES           = 640,
  parameter int V_RES           = 480
)( 
  input  logic        aclk,
  input  logic        aresetn,

  input  logic        sof,

  output logic             pix_tvalid,
  input  logic             pix_tready,
  output logic [2:0][3:0]  pix_tdata,
  output logic             pix_tlast,
  output logic             pix_tuser
);



  //----------------------------------------------------------------------------
  logic [$clog2(H_RES)-1:0] h_cnt;
  logic [$clog2(V_RES)-1:0] v_cnt;
  logic [3:0]               f_cnt;


  //----------------------------------------------------------------------------
  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      pix_tvalid <= '0;
      pix_tdata  <= '0;
      f_cnt      <= '0;
      v_cnt      <= '0;
      h_cnt      <= '0;

    end else begin
      if (sof || (pix_tvalid && pix_tready)) begin
        pix_tvalid <= '1;
        pix_tdata  <= {4'(f_cnt), 4'(v_cnt), 4'(h_cnt)};
        pix_tlast  <= '0;
        pix_tuser  <= v_cnt == 0 && h_cnt == 0;

        h_cnt <= h_cnt + 1;
        if (h_cnt == H_RES-1) begin
          pix_tlast  <= '1;
          h_cnt <= '0;
          v_cnt <= v_cnt + 1;
          if (v_cnt == V_RES-1) begin
            pix_tvalid <= '0;
            v_cnt <= '0;
            f_cnt <= f_cnt + 1;
          end
        end
      end

    end
  end


endmodule