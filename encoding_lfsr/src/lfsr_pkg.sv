
package lfsr_pkg;

  // Note: Polynomials are Notated with X^0 omitted.
  // ie x5+x3+x0 is a 5 bit vector with bits 5 and 3 set

  // Maximal Length Polynomials 
  localparam bit [ 2:1] POLY_MAX_2   =  2'b11;                                // x2 + x1 + 1
  localparam bit [ 3:1] POLY_MAX_3   =  3'b110;                               // x3 + x2 + 1
  localparam bit [ 4:1] POLY_MAX_4   =  4'b1100;                              // x4 + x3 + 1
  localparam bit [ 5:1] POLY_MAX_5   =  5'b10100;                             // x5 + x3 + 1
  localparam bit [ 6:1] POLY_MAX_6   =  6'b110000;                            // x6 + x5 + 1
  localparam bit [ 7:1] POLY_MAX_7   =  7'b1100000;                           // x7 + x6 + 1
  localparam bit [ 8:1] POLY_MAX_8   =  8'b10110100;                          // x8 + x6 + x5 + x3 + 1
  localparam bit [ 9:1] POLY_MAX_9   =  9'b100010000;                         // x9 + x5 + 1
  localparam bit [10:1] POLY_MAX_10  = 10'b1001000000;                        // x10 + x7 + 1
  localparam bit [11:1] POLY_MAX_11  = 11'b10100000000;                       // x11 + x9 + 1
  localparam bit [12:1] POLY_MAX_12  = 12'b111000001000;                      // x12 + x11 + x10 + x4 + 1
  localparam bit [13:1] POLY_MAX_13  = 13'b1110010000000;                     // x13 + x12 + x11 + x8 + 1
  localparam bit [14:1] POLY_MAX_14  = 14'b11100000000010;                    // x14 + x13 + x12 + x2 + 1
  localparam bit [15:1] POLY_MAX_15  = 15'b110000000000000;                   // x15 + x14 + 1
  localparam bit [16:1] POLY_MAX_16  = 16'b1101000000001000;                  // x16 + x15 + x13 + x4 + 1
  localparam bit [17:1] POLY_MAX_17  = 17'b10010000000000000;                 // x17 + x14 + 1
  localparam bit [18:1] POLY_MAX_18  = 18'b100000010000000000;                // x18 + x11 + 1
  localparam bit [19:1] POLY_MAX_19  = 19'b1110010000000000000;               // x19 + x18 + x17 + x14 + 1
  localparam bit [20:1] POLY_MAX_20  = 20'b10010000000000000000;              // x20 + x17 + 1
  localparam bit [21:1] POLY_MAX_21  = 21'b101000000000000000000;             // x21 + x19 + 1
  localparam bit [22:1] POLY_MAX_22  = 22'b1100000000000000000000;            // x22 + x21 + 1
  localparam bit [23:1] POLY_MAX_23  = 23'b10000100000000000000000;           // x23 + x18 + 1
  localparam bit [24:1] POLY_MAX_24  = 24'b111000010000000000000000;          // x24 + x23 + x22 + x17 + 1
  localparam bit [25:1] POLY_MAX_25  = 25'b1001000000000000000000000;         // x25 + x22 + 1
  localparam bit [26:1] POLY_MAX_26  = 26'b10000000000000000000100011;        // x26 + x6 + x2 + x1 + 1
  localparam bit [27:1] POLY_MAX_27  = 27'b100000000000000000000010011;       // x27 + x5 + x2 + x1 + 1
  localparam bit [28:1] POLY_MAX_28  = 28'b1001000000000000000000000000;      // x28 + x25 + 1
  localparam bit [29:1] POLY_MAX_29  = 29'b10100000000000000000000000000;     // x29 + x27 + 1
  localparam bit [30:1] POLY_MAX_30  = 30'b100000000000000000000000101001;    // x30 + x6 + x4 + x1 + 1
  localparam bit [31:1] POLY_MAX_31  = 31'b1001000000000000000000000000000;   // x31 + x28 + 1

  // Common Polynomials
  localparam bit [ 7:1] PRBS7   =  7'b1100000;                                // PRBS7 : x7 + x6 + 1
  localparam bit [ 9:1] PRBS9   =  9'b100010000;                              // PRBS9 : x9 + x5 + 1
  localparam bit [11:1] PRBS11  = 11'b10010000000;                            // PRBS11: x11 + x9 + 1
  localparam bit [13:1] PRBS13  = 13'b1100000000011;                          // PRBS13: x13 + x12 + x2 + x1 + 1
  localparam bit [15:1] PRBS15  = 15'b110000000000000;                        // PRBS15: x15 + x14 + 1
  localparam bit [20:1] PRBS20  = 20'b10000000000000000100;                   // PRBS20: x20 + x3 + 1
  localparam bit [23:1] PRBS23  = 23'b10000100000000000000000;                // PRBS23: x23 + x18 + 1
  localparam bit [31:1] PRBS31  = 31'b1001000000000000000000000000000;        // PRBS31: x31 + x28 + 1
  

endpackage