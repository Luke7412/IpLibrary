//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
module uart_rx #(
  parameter int ACLK_FREQUENCY = 200000000,
  parameter int BAUD_RATE      = 9600,
  parameter int BAUD_RATESIM   = 50000000,
  localparam real BAUDRATE_SAMPLE = $real(ACLK_FREQUENCY) / $real(ACLK_FREQUENCY/BAUD_RATE);
)( 
  input  logic        aclk,
  input  logic        aresetn,
  input  logic        uart_rxd,
  output logic        rxbyte_tvalid,
  input  logic        rxbyte_tready,
  input  logic [7:0]  rxbyte_tdata
  );
begin


  //----------------------------------------------------------------------------
  // synthesis translate_off
  assert 10.0*(1.0-$real(BAUD_RATE)/BAUDRATE_SAMPLE) < 0.45
    report "Unsafe baudrate ratio."
    severity error;
  // synthesis translate_on

 
  localparam int USED_BAUD_RATE = BAUD_RATE
                            // synthesis translate_off
                            - BAUD_RATE + BAUDRATE_SAMPLE
                            // synthesis translate_on
                            ;

  localparam int TICS_PER_BEAT = ACLK_FREQUENCY / USED_BAUD_RATE;                     

  enum logic [1:0] (WAIT_FOR_START, SAMPLING, OUTPUTTING) state;
  
  logic [$clog2(9)-1:0]             beat_cnt;
  logic [$clog2(TICS_PER_BEAT)-1:0] tic_cnt;


  logic [3:0] deglitch_shift;
  logic       rxd_deglitch;
  logic [9:0] rxd_shift;

  
  //----------------------------------------------------------------------------
  always_ff @(posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      deglitch_shift <= '1;
      rxd_deglitch   <= '1;

      RxByte_TValid <= '0;
      state         <= WAIT_FOR_START;

    end else begin
      deglitch_shift <= {uart_rxd, deglitch_shift} >> 1;

      if (deglitch_shift == 0) begin
        rxd_deglitch <= '0;
      end else if ((~deglitch_shift) == 0) begin
        rxd_deglitch <= '1;
      end

      if (rxbyte_tvalid && rxbyte_tready) begin
        rxbyte_tvalid <= '0;
      end

      case (state)
        WAIT_FOR_START : begin
          if (!rxd_deglitch) begin
            tic_cnt  <= TICS_PER_BEAT/2-2;
            beat_cnt <= 9;
            state    <= SAMPLING;
          end
        end

       SAMPLING : begin
          if (tic_cnt != 0) begin
            tic_cnt <= tic_cnt-1;

          end else begin
            tic_cnt     <= TICS_PER_BEAT-1;
            rxd_shift <= {rxd_deglitch, rxd_shift} >> 1;

            if (beat_cnt != 0) begin
              beat_cnt <= beat_cnt-1;
            end else begin
              state <= s_outputting;
            end
          end
       end

        OUTPUTTING : begin
          state <= WAIT_FOR_START;
          if (!rxbyte_tvalid && !rxd_shift[0] && rxd_shift[9]) begin
            rxbyte_tvalid <= '1;
            rxbyte_tdata  <= rxd_shift[8:1];
          end
        end

      endcase        
    end
  end


endmodule