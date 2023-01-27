
//------------------------------------------------------------------------------
module vga #(
  parameter int H_RES           = 640,
  parameter int V_RES           = 480,
  parameter int H_FRONT_PORCH   = 48,
  parameter int H_BACK_PORCH    = 16,
  parameter int V_FRONT_PORCH   = 29,
  parameter int V_BACK_PORCH    = 10,
  parameter int H_BLANKING      = 160,
  parameter int V_BLANKING      = 41
)( 
  input  logic        aclk,
  input  logic        aresetn,

  input  logic             pix_tvalid,
  output logic             pix_tready,
  input  logic [2:0][3:0]  pix_tdata,
  input  logic             pix_tlast,
  input  logic             pix_tuser,
  // VGA Interface
  output logic vsync,
  output logic hsync,
  output logic [3:0] r, 
  output logic [3:0] g, 
  output logic [3:0] b,

  output logic sof
);


  //----------------------------------------------------------------------------
  localparam int H_ACT_BLANKING = H_BLANKING - H_FRONT_PORCH - H_BACK_PORCH;
  localparam int V_ACT_BLANKING = V_BLANKING - V_FRONT_PORCH - V_BACK_PORCH;

  logic [$clog2(H_RES)-1:0] h_cnt;
  logic [$clog2(V_RES)-1:0] v_cnt;

  enum {H_BLANK, H_FP, H_PIX, H_BP} h_state;
  enum {V_BLANK, V_FP, V_PIX, V_BP} v_state;

  logic vsync_q;


  //----------------------------------------------------------------------------
  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      h_cnt   <= H_ACT_BLANKING-1;
      h_state <= H_BLANK;

    end else begin
      case (h_state)
        H_BLANK : begin
          h_cnt <= h_cnt - 1;
          if (h_cnt == 0) begin
            h_cnt   <= H_FRONT_PORCH-1;
            h_state <= H_FP;
          end
        end

        H_FP : begin
          h_cnt <= h_cnt - 1;
          if (h_cnt == 0) begin
            h_cnt   <= H_RES-1;
            h_state <= H_PIX;
          end
        end

        H_PIX : begin
          h_cnt <= h_cnt - 1;
          if (h_cnt == 0) begin
            h_cnt   <= H_BACK_PORCH-1;
            h_state <= H_BP;
          end
        end

        H_BP : begin
          h_cnt <= h_cnt - 1;
          if (h_cnt == 0) begin
            h_cnt   <= H_ACT_BLANKING-1;
            h_state <= H_BLANK;
          end
        end

      endcase
    end
  end


  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      v_cnt   <= V_ACT_BLANKING-1;
      v_state <= V_BLANK;

    end else if (h_state == H_BP && h_cnt == 0) begin
      case (v_state)
        V_BLANK : begin
          v_cnt <= v_cnt - 1;
          if (v_cnt == 0) begin
            v_cnt   <= V_FRONT_PORCH-1;
            v_state <= V_FP;
          end
        end

        V_FP : begin
          v_cnt <= v_cnt - 1;
          if (v_cnt == 0) begin
            v_cnt   <= V_RES-1;
            v_state <= V_PIX;
          end
        end

        V_PIX : begin
          v_cnt <= v_cnt - 1;
          if (v_cnt == 0) begin
            v_cnt   <= V_BACK_PORCH-1;
            v_state <= V_BP;
          end
        end

        V_BP : begin
          v_cnt <= v_cnt - 1;
          if (v_cnt == 0) begin
            v_cnt   <= V_ACT_BLANKING-1;
            v_state <= V_BLANK;
          end
        end

      endcase
    end
  end


  assign pix_tready = h_state == H_PIX && v_state == V_PIX;


  assign {b, g, r} = pix_tdata; 
  assign vsync = v_state != V_BLANK;
  assign hsync = h_state != H_BLANK;


  always @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      vsync_q <= '0;
    end else begin
      vsync_q <= vsync;
    end
  end

  assign sof = vsync && !vsync_q;

endmodule