//------------------------------------------------------------------------------
// Project Name   : IpLibrary
//------------------------------------------------------------------------------
// Author         : Lukas Vinkx (lvin)
// Description: 
//------------------------------------------------------------------------------


module vga_core #(
  parameter int DEFAULT_CONFIG = 3
)( 
  input  logic            aclk,
  input  logic            aresetn,
  // Timing Control
  input  logic [15:0]     h_res,
  input  logic [15:0]     h_front_porch,
  input  logic [15:0]     h_sync_pulse,
  input  logic [15:0]     h_back_porch,
  input  logic [15:0]     v_res,
  input  logic [15:0]     v_front_porch,
  input  logic [15:0]     v_sync_pulse,
  input  logic [15:0]     v_back_porch,
  // AXI4-Stream Video
  input  logic            pix_tvalid,
  output logic            pix_tready,
  input  logic [2:0][7:0] pix_tdata,
  input  logic            pix_tlast,
  input  logic            pix_tuser,
  // VGA Interface
  output logic            vga_vsync,
  output logic            vga_hsync,
  output logic [3:0]      vga_red, 
  output logic [3:0]      vga_green, 
  output logic [3:0]      vga_blue
);


  //----------------------------------------------------------------------------
  logic [15:0] h_cnt;
  logic [15:0] v_cnt;

  enum {H_BLANK, H_FP, H_PIX, H_BP} h_state;
  enum {V_BLANK, V_FP, V_PIX, V_BP} v_state;

  logic vga_vsync_q;
  logic synced;
  logic flush;
  logic load_pix;


  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      h_cnt   <= '0;
      h_state <= H_BLANK;

    end else begin
      case (h_state)

        H_BLANK : begin
          h_cnt <= h_cnt - 1;
          if (h_cnt == 0) begin
            h_cnt   <= h_back_porch-1;
            h_state <= H_BP;
          end
        end

        H_BP : begin
          h_cnt <= h_cnt - 1;
          if (h_cnt == 0) begin
            h_cnt   <= h_res-1;
            h_state <= H_PIX;
          end
        end

        H_PIX : begin
          h_cnt <= h_cnt - 1;
          if (h_cnt == 0) begin
            h_cnt   <= h_front_porch-1;
            h_state <= H_FP;
          end
        end

        H_FP : begin
          h_cnt <= h_cnt - 1;
          if (h_cnt == 0) begin
            h_cnt   <= h_sync_pulse-1;
            h_state <= H_BLANK;
          end
        end

      endcase
    end

  end


  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      v_cnt   <= '0;
      v_state <= V_BLANK;

    end else begin
      if (h_state == H_FP && h_cnt == 0) begin
        case (v_state)
          V_BLANK : begin
            v_cnt <= v_cnt - 1;
            if (v_cnt == 0) begin
              v_cnt   <= v_back_porch-1;
              v_state <= V_BP;
            end
          end

          V_BP : begin
            v_cnt <= v_cnt - 1;
            if (v_cnt == 0) begin
              v_cnt   <= v_res-1;
              v_state <= V_PIX;
            end
          end

          V_PIX : begin
            v_cnt <= v_cnt - 1;
            if (v_cnt == 0) begin
              v_cnt   <= v_front_porch-1;
              v_state <= V_FP;
            end
          end

          V_FP : begin
            v_cnt <= v_cnt - 1;
            if (v_cnt == 0) begin
              v_cnt   <= v_sync_pulse-1;
              v_state <= V_BLANK;
            end
          end

        endcase
      end

    end
  end


  assign vga_vsync = v_state != V_BLANK;
  assign vga_hsync = h_state != H_BLANK;
  assign vga_green = load_pix ? pix_tdata[0][7:4] : '0; 
  assign vga_blue  = load_pix ? pix_tdata[1][7:4] : '0;
  assign vga_red   = load_pix ? pix_tdata[2][7:4] : '0; 


  always @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      vga_vsync_q <= '0;
      synced <= '0;

    end else begin
      vga_vsync_q <= vga_vsync;

      if (vga_vsync && !vga_vsync_q) begin
        // True if: First pixel is ready on pix intf at start of vga frame
        synced <= pix_tvalid && pix_tuser;
      end

    end
  end

  assign flush = !synced && !(pix_tvalid && pix_tuser);
  assign load_pix = synced && h_state == H_PIX && v_state == V_PIX;
  assign pix_tready = flush || load_pix;


endmodule