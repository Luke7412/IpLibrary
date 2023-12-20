
package lfsr_pkg;

  // Note: Polynomials are Notated with X^DEG omitted and X^(DEG-1) on the left
  // ie x5+x3+x0 is a 5 bit vector with bits 3 and 0 set

  // Maximal Length Polynomials 
  localparam bit [ 1:0] POLY_MAX_2   = 2'b11;                                 // x2 + x1 + 1
  localparam bit [ 2:0] POLY_MAX_3   = 3'b101;                                // x3 + x2 + 1
  localparam bit [ 3:0] POLY_MAX_4   = 4'b1001;                               // x4 + x3 + 1
  localparam bit [ 4:0] POLY_MAX_5   = 5'b01001;                              // x5 + x3 + 1
  localparam bit [ 5:0] POLY_MAX_6   = 6'b100001;                             // x6 + x5 + 1
  localparam bit [ 6:0] POLY_MAX_7   = 7'b1000001;                            // x7 + x6 + 1
  localparam bit [ 7:0] POLY_MAX_8   = 8'b01101001;                           // x8 + x6 + x5 + x3 + 1
  localparam bit [ 8:0] POLY_MAX_9   = 9'b000100001;                          // x9 + x5 + 1
  localparam bit [ 9:0] POLY_MAX_10  = 10'b0010000001;                        // x10 + x7 + 1
  localparam bit [10:0] POLY_MAX_11  = 11'b01000000001;                       // x11 + x9 + 1
  localparam bit [11:0] POLY_MAX_12  = 12'b110000010001;                      // x12 + x11 + x10 + x4 + 1
  localparam bit [12:0] POLY_MAX_13  = 13'b1100100000001;                     // x13 + x12 + x11 + x8 + 1
  localparam bit [13:0] POLY_MAX_14  = 14'b11000000000101;                    // x14 + x13 + x12 + x2 + 1
  localparam bit [14:0] POLY_MAX_15  = 15'b100000000000001;                   // x15 + x14 + 1
  localparam bit [15:0] POLY_MAX_16  = 16'b1010000000010001;                  // x16 + x15 + x13 + x4 + 1
  localparam bit [16:0] POLY_MAX_17  = 17'b00100000000000001;                 // x17 + x14 + 1
  localparam bit [17:0] POLY_MAX_18  = 18'b000000100000000001;                // x18 + x11 + 1
  localparam bit [18:0] POLY_MAX_19  = 19'b1100100000000000001;               // x19 + x18 + x17 + x14 + 1
  localparam bit [19:0] POLY_MAX_20  = 20'b00100000000000000001;              // x20 + x17 + 1
  localparam bit [20:0] POLY_MAX_21  = 21'b010000000000000000001;             // x21 + x19 + 1
  localparam bit [21:0] POLY_MAX_22  = 22'b1000000000000000000001;            // x22 + x21 + 1
  localparam bit [22:0] POLY_MAX_23  = 23'b00001000000000000000001;           // x23 + x18 + 1
  localparam bit [23:0] POLY_MAX_24  = 24'b110000100000000000000001;          // x24 + x23 + x22 + x17 + 1
  localparam bit [24:0] POLY_MAX_25  = 25'b0010000000000000000000001;         // x25 + x22 + 1
  localparam bit [25:0] POLY_MAX_26  = 26'b00000000000000000001000111;        // x26 + x6 + x2 + x1 + 1
  localparam bit [26:0] POLY_MAX_27  = 27'b000000000000000000000100111;       // x27 + x5 + x2 + x1 + 1
  localparam bit [27:0] POLY_MAX_28  = 28'b0010000000000000000000000001;      // x28 + x25 + 1
  localparam bit [28:0] POLY_MAX_29  = 29'b01000000000000000000000000001;     // x29 + x27 + 1
  localparam bit [29:0] POLY_MAX_30  = 30'b000000000000000000000001010011;    // x30 + x6 + x4 + x1 + 1
  localparam bit [30:0] POLY_MAX_31  = 31'b0010000000000000000000000000001;   // x31 + x28 + 1

  // Common Polynomials
  localparam bit [6:0]  PRBS7   = 7'b1000001;                                 // PRBS7 : x7 + x6 + 1
  localparam bit [8:0]  PRBS9   = 9'b000100001;                               // PRBS9 : x9 + x5 + 1
  localparam bit [10:0] PRBS11  = 11'b00100000001;                            // PRBS11: x11 + x9 + 1
  localparam bit [12:0] PRBS13  = 13'b1000000000111;                          // PRBS13: x13 + x12 + x2 + x1 + 1
  localparam bit [14:0] PRBS15  = 15'b100000000000001;                        // PRBS15: x15 + x14 + 1
  localparam bit [19:0] PRBS20  = 20'b00000000000000001001;                   // PRBS20: x20 + x3 + 1
  localparam bit [22:0] PRBS23  = 23'b00001000000000000000001;                // PRBS23: x23 + x18 + 1
  localparam bit [30:0] PRBS31  = 31'b0010000000000000000000000000001;        // PRBS31: x31 + x28 + 1
  
endpackage