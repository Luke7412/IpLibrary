//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
module axis_uart_tx #(
  parameter int ACLK_FREQUENCY = 200000000,
  parameter int BAUD_RATE      = 9600,
  parameter int BAUD_RATE_SIM  = 50000000
)( 
  input  logic        aclk,
  input  logic        aresetn,
  output logic        uart_txd,
  input  logic        txbyte_tvalid,
  output logic        txbyte_tready,
  input  logic [7:0]  txbyte_tdata,
  input  logic [0:0]  txbyte_tkeep
);


  //----------------------------------------------------------------------------
  localparam int USED_BAUD_RATE = BAUD_RATE
    // synthesis translate_off
    - BAUD_RATE + BAUD_RATE_SIM
    // synthesis translate_on
    ;

  localparam int TICS_PER_BEAT = ACLK_FREQUENCY / USED_BAUD_RATE;                     

  logic [8:0]                       txd_shift;
  logic [$clog2(9)-1:0]             beat_cnt;
  logic [$clog2(TICS_PER_BEAT)-1:0] tic_cnt;

  enum logic [0:0] {IDLE, RUNNING} state;
  

  //----------------------------------------------------------------------------
  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      txbyte_tready <= '0;
      txd_shift     <= '1;
      state         <= IDLE;

    end else begin
      case (state)
        IDLE : begin
          txbyte_tready <= '1;
          if (txbyte_tvalid && txbyte_tready && txbyte_tkeep) begin
            txbyte_tready <= '0;
            txd_shift     <= {txbyte_tdata, 1'b0};
            tic_cnt       <= TICS_PER_BEAT-1;
            beat_cnt      <= 9;
            state         <= RUNNING;
          end
        end

        RUNNING : begin
          tic_cnt <= tic_cnt-1;

          if (tic_cnt == 0) begin
            tic_cnt   <= TICS_PER_BEAT-1;
            beat_cnt  <= beat_cnt-1;
            txd_shift <= {1'b1, txd_shift} >> 1;
            
            if (beat_cnt == 0) begin
              txbyte_tready <= '1;
              state         <= IDLE;
            end           
          end
        end

      endcase         
    end
  end 


  assign uart_txd = txd_shift[0];


endmodule