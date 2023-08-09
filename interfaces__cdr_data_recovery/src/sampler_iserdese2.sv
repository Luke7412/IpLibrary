//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
module sampler_iserdese2 (
  input  logic       clk,
  input  logic       clk90,
  input  logic       rst_n,
  input  logic       in_data,
  output logic [3:0] out_data
);
  

  //----------------------------------------------------------------------------
  ISERDESE2 #(
    .DATA_RATE         ("DDR"),         // DDR, SDR
    .DATA_WIDTH        (4),             // Parallel data width (2-8,10,14)
    .DYN_CLKDIV_INV_EN ("FALSE"),       // Enable DYNCLKDIVINVSEL inversion (FALSE, TRUE)
    .DYN_CLK_INV_EN    ("FALSE"),       // Enable DYNCLKINVSEL inversion (FALSE, TRUE)
    .INIT_Q1           ('0),            // INIT_Q1 - INIT_Q4: Initial value on the Q outputs (0/1)
    .INIT_Q2           ('0),
    .INIT_Q3           ('0),
    .INIT_Q4           ('0),
    .INTERFACE_TYPE    ("OVERSAMPLE"),  // MEMORY, MEMORY_DDR3, MEMORY_QDR, NETWORKING, OVERSAMPLE
    .IOBDELAY          ("NONE"),        // NONE, BOTH, IBUF, IFD
    .NUM_CE            (1),             // Number of clock enables (1,2)
    .OFB_USED          ("FALSE"),       // Select OFB path (FALSE, TRUE)
    .SERDES_MODE       ("MASTER"),      // MASTER, SLAVE
    .SRVAL_Q1          ('0),            // SRVAL_Q1 - SRVAL_Q4: Q output values when SR is used (0/1)
    .SRVAL_Q2          ('0),
    .SRVAL_Q3          ('0),
    .SRVAL_Q4          ('0)
  ) i_iserdese2 (
    .O            (),                   // 1-bit output: Combinatorial output
    .Q1           (out_data[0]),        // Q1 - Q8: 1-bit (each) output: Registered data outputs
    .Q2           (out_data[1]),
    .Q3           (out_data[2]),
    .Q4           (out_data[3]),
    .Q5           (),
    .Q6           (),
    .Q7           (),
    .Q8           (),
    .SHIFTOUT1    (),                   // SHIFTOUT1, SHIFTOUT2: 1-bit (each) output: Data width expansion output ports
    .SHIFTOUT2    (),
    .BITSLIP      ('0),           
    .CE1          ('1),                 // CE1, CE2: 1-bit (each) input: Data register clock enable inputs
    .CE2          ('1),
    .CLKDIVP      ('0),                 // 1-bit input: TBD
    .CLK          (clk),                // 1-bit input: High-speed clock
    .CLKB         (!clk),               // 1-bit input: High-speed secondary clock
    .CLKDIV       ('0),                 // 1-bit input: Divided clock
    .OCLK         (clk90),              // 1-bit input: High speed output clock used when INTERFACE_TYPE="MEMORY" 
    .OCLKB        (!clk90),             // 1-bit input: High speed negative edge output clock
    .DYNCLKDIVSEL ('0),                 // 1-bit input: Dynamic CLKDIV inversion
    .DYNCLKSEL    ('0),                 // 1-bit input: Dynamic CLK/CLKB inversion
    .D            (in_data),            // 1-bit input: Data input
    .DDLY         ('0),                 // 1-bit input: Serial data from IDELAYE2
    .OFB          ('0),                 // 1-bit input: Data feedback from OSERDESE2
    .RST          ('0),                 // 1-bit input: Active high asynchronous reset
    .SHIFTIN1     ('0),                 // SHIFTIN1, SHIFTIN2: 1-bit (each) input: Data width expansion input ports
    .SHIFTIN2     ('0)
  );


endmodule