
module dec_8b10b ( 
  input  logic [9:0] code_10b,
  input	 logic 	     disp,
  output logic [7:0] code_8b,
  output logic       is_k,
  output logic       disp_next,
  output logic 	     decode_err,
  output logic 	     disp_err
);


  //----------------------------------------------------------------------------
  logic A, B, C, D, E, I, F, G, H, J;
  logic a, b, c, d, e, f, g, h;

  logic aeqb;
  logic ceqd;
  logic p22;
  logic p13;
  logic p31;
  logic p40;
  logic p04;
  logic disp6a;
  logic disp6a2;
  logic disp6a0;
  logic disp6b;

  logic p22bceeqi;
  logic p22bncneeqi;
  logic p13in;
  logic p31i;
  logic p13dei;
  logic p22aceeqi;
  logic p22ancneeqi;
  logic p13en;
  logic anbnenin;
  logic abei;
  logic cndnenin;

  logic compa;
  logic compb;
  logic compc;
  logic compd;
  logic compe;

  logic feqg;
  logic heqj;
  logic fghj22;
  logic fghjp13;
  logic fghjp31;

  logic k28p;
  logic disp6p;
  logic disp6n;
  logic disp4p;
  logic disp4n;


  //----------------------------------------------------------------------------
  assign A = code_10b[0];
  assign B = code_10b[1];
  assign C = code_10b[2];
  assign D = code_10b[3];
  assign E = code_10b[4];
  assign I = code_10b[5];
  assign F = code_10b[6];
  assign G = code_10b[7];
  assign H = code_10b[8];
  assign J = code_10b[9];


  //----------------------------------------------------------------------------
  always_comb begin

    aeqb = !(A ^ B);
    ceqd = !(C ^ D);
    p22  = (A & B & !C & !D) | (C & D & !A & !B) | (!aeqb & !ceqd);
    p40  = A & B & C & D;
    p04  = !A & !B & !C & !D;
    p13  = (!aeqb & !C & !D) | (!ceqd & !A & !B);
    p31  = (!aeqb & C & D) | (!ceqd & A & B);

    disp6a = p31 | (p22 & disp);  // pos disp if p22 and was pos, or p31.
    disp6a2 = p31 & disp;         // disp is ++ after 4 bits
    disp6a0 = p13 & !disp;        // -- disp after 4 bits
    
    disp6b = (((E & I & !disp6a0) | (disp6a & (E | I)) | disp6a2 |
      (E & I & D)) & (E | I | D));


    // The 5B/6B decoding special cases where ABCDE != abcde
    p22bceeqi   = p22 & B & C & (E == I);
    p22bncneeqi = p22 & !B & !C & (E == I);
    p13in       = p13 & !I;
    p31i        = p31 & I;
    p13dei      = p13 & D & E & I;
    p22aceeqi   = p22 & A & C & (E == I);
    p22ancneeqi = p22 & !A & !C & (E == I);
    p13en       = p13 & !E;
    anbnenin    = !A & !B & !E & !I;
    abei        = A & B & E & I;
    cndnenin    = !C & !D & !E & !I;

    compa = p22bncneeqi | p31i | p13dei | p22ancneeqi | 
      p13en | abei | cndnenin;
    compb = p22bceeqi | p31i | p13dei | p22aceeqi | 
      p13en | abei | cndnenin;
    compc = p22bceeqi | p31i | p13dei | p22ancneeqi | 
      p13en | anbnenin | cndnenin;
    compd = p22bncneeqi | p31i | p13dei | p22aceeqi |
      p13en | abei | cndnenin;
    compe = p22bncneeqi | p13in | p13dei | p22ancneeqi | 
      p13en | anbnenin | cndnenin;

    a = A ^ compa;
    b = B ^ compb;
    c = C ^ compc;
    d = D ^ compd;
    e = E ^ compe;

    feqg    = !(F ^ G);
    heqj    = !(H ^ J);
    fghj22  = (F & G & !H & !J) | (!F & !G & H & J) | (!feqg & !heqj);
    fghjp13 = (!feqg & !H & !J) | (!heqj & !F & !G);
    fghjp31 = ((!feqg) & H & J) | (!heqj & F & G);

    disp_next = (fghjp31 | (disp6b & fghj22) | (H & J)) & (H | J);

    is_k = (C & D & E & I) | (!C & !D & !E & !I) |
      (p13 & !E & I & G & H & J) |
      (p31 & E & !I & !G & !H & !J);

    // k28 with positive disp into fghi - .1, .2, .5, and .6 special cases
    k28p = (!C &!D & !E & !I);

    f = (J & !F & (H | !G | k28p)) | (F & !J & (!H | G | !k28p)) |
      (k28p & G & H) | (!k28p & !G & !H);
    g = (J & !F & (H | !G | !k28p)) | (F & !J & (!H | G |k28p)) |
      (!k28p & G & H) | (k28p & !G & !H);
    h = ((J ^ H) & !((!F & G & !H & J & !k28p) | (!F & G & H & !J & k28p) | 
      (F & !G & !H & J & !k28p) | (F & !G & H & !J & k28p))) |
      (!F & G & H & J) | (F & !G & !H & !J);

    disp6p = (p31 & (E | I)) | (p22 & E & I);
    disp6n = (p13 & !(E & I)) | (p22 & !E & !I);
    disp4p = fghjp31;
    disp4n = fghjp13;

    decode_err = p40 | p04 | (F & G & H & J) | (!F & !G & !H & !J) |
      (p13 & !E & !I) | (p31 & E & I) | 
      (E & I & F & G & H) | (!E & !I & !F & !G & !H) | 
      (E & !I & G & H & J) | (!E & I & !G & !H & !J) |
      (!p31 & E & !I & !G & !H & !J) |
      (!p13 & !E & I & G & H & J) |
      (((E & I & !G & !H & !J) |  (!E & !I & G & H & J)) &
       !((C & D & E) | (!C & !D & !E))) |
      (disp6p & disp4p) | (disp6n & disp4n) |
      (A & B & C & !E & !I & ((!F & !G) | fghjp13)) |
      (!A & !B & !C & E & I & ((F & G) | fghjp31)) |
      (F & G & !H & !J & disp6p) |
      (!F & !G & H & J & disp6n) |
      (C & D & E & I & !F & !G & !H) |
      (!C & !D & !E & !I & F & G & H);

    code_8b = {h, g, f, e, d, c, b, a};

    // disp err fires for any legal codes that violate disparity, may fire for illegal codes
    disp_err = ((disp & disp6p) | (disp6n & !disp) |
      (disp & !disp6n & F & G) |
      (disp & A & B & C) |
      (disp & !disp6n & disp4p) |
      (!disp & !disp6p & !F & !G) |
      (!disp & !A & !B & !C) |
      (!disp & !disp6p & disp4n) |
      (disp6p & disp4p) | (disp6n & disp4n));
  end

endmodule