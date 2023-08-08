
package lfsr_poly_pkg;

  // Note: Polynomials are Notated with X^DEG omitted and X^(DEG-1) on the left
  // ie x5+x3+x0 is a 5 bit vector with bits 3 and 0 set

  
  // Maximal Length Polynomials 
  localparam bit [1:0]  POLY_MAX_LEN_2  =  2'b11;                       // Maximal 2  bit Generator Poly -  x2+x+1
  localparam bit [2:0]  POLY_MAX_LEN_3  =  3'b101;                      // Maximal 3  bit Generator Poly -  x3+x2+1
  localparam bit [3:0]  POLY_MAX_LEN_4  =  4'b1001;                     // Maximal 4  bit Generator Poly -  x4+x3+1
  localparam bit [4:0]  POLY_MAX_LEN_5  =  5'b01001;                    // Maximal 5  bit Generator Poly -  x5+x3+1
  localparam bit [5:0]  POLY_MAX_LEN_6  =  6'b100001;                   // Maximal 6  bit Generator Poly -  x6+x5+1
  localparam bit [6:0]  POLY_MAX_LEN_7  =  7'b1000001;                  // Maximal 7  bit Generator Poly -  x7+x6+1
  localparam bit [7:0]  POLY_MAX_LEN_8  =  8'b01101001;                 // Maximal 8  bit Generator Poly -  x8+x6+x5+x3+1
  localparam bit [8:0]  POLY_MAX_LEN_9  =  9'b000100001;                // Maximal 9  bit Generator Poly -  x9+x5+1
  localparam bit [9:0]  POLY_MAX_LEN_10 = 10'b0010000001;               // Maximal 10 bit Generator Poly -  x10+x7+1
  localparam bit [10:0] POLY_MAX_LEN_11 = 11'b01000000001;              // Maximal 11 bit Generator Poly -  x11+x9+1
  localparam bit [11:0] POLY_MAX_LEN_12 = 12'b110000010001;             // Maximal 12 bit Generator Poly -  x12+x11+x10+x4+1
  localparam bit [12:0] POLY_MAX_LEN_13 = 13'b1100100000001;            // Maximal 13 bit Generator Poly -  x13+x12+x11+x8+1
  localparam bit [13:0] POLY_MAX_LEN_14 = 14'b11000000000101;           // Maximal 14 bit Generator Poly -  x14+x13+x12+x2+1
  localparam bit [14:0] POLY_MAX_LEN_15 = 15'b100000000000001;          // Maximal 15 bit Generator Poly -  x15+x14+1
  localparam bit [15:0] POLY_MAX_LEN_16 = 16'b1010000000010001;         // Maximal 16 bit Generator Poly -  x16+x15+x13+x4+1
  localparam bit [16:0] POLY_MAX_LEN_17 = 17'b00100000000000001;        // Maximal 17 bit Generator Poly -  x17+x14+1
  localparam bit [17:0] POLY_MAX_LEN_18 = 18'b000000100000000001;       // Maximal 18 bit Generator Poly -  x18+x11+1
  localparam bit [18:0] POLY_MAX_LEN_19 = 19'b1100100000000000001;      // Maximal 19 bit Generator Poly -  x19+x18+x17+x14+1
  localparam bit [19:0] POLY_MAX_LEN_20 = 20'b00100000000000000001;     // Maximal 20 bit Generator Poly -  x20+x17+1
  localparam bit [20:0] POLY_MAX_LEN_21 = 21'b010000000000000000001;    // Maximal 21 bit Generator Poly -  x21+x19+1
  localparam bit [21:0] POLY_MAX_LEN_22 = 22'b1000000000000000000001;   // Maximal 22 bit Generator Poly -  x22+x21+1
  localparam bit [22:0] POLY_MAX_LEN_23 = 23'b00001000000000000000001;  // Maximal 23 bit Generator Poly -  x23+x18+1
  localparam bit [23:0] POLY_MAX_LEN_24 = 24'b110000100000000000000001; // Maximal 24 bit Generator Poly -  x24+x23+x22+x17+1

  // Common Polynomials
  localparam bit [6:0]  PRBS7   =  7'b1000001;                           // PRBS7 : x7+x6+1
  localparam bit [8:0]  PRBS9   =  9'b000100001;                         // PRBS9 : x9+x5+1
  localparam bit [10:0] PRBS11  = 11'b00100000001;                       // PRBS11: x11+x9+1
  localparam bit [12:0] PRBS13  = 13'b1000000000111;                     // PRBS13: x13+x12+x2+x1+1
  localparam bit [14:0] PRBS15  = 15'b100000000000001;                   // PRBS15: x15+x14+1
  localparam bit [19:0] PRBS20  = 20'b00000000000000001001;              // PRBS20: x20+x3+1
  localparam bit [22:0] PRBS23  = 23'b00001000000000000000001;           // PRBS23: x23+x18+1
  localparam bit [30:0] PRBS31  = 31'b0010000000000000000000000000001;   // PRBS31: x31+x28+1

endpackage