
module enc_8b10b (
  input  logic [7:0]  code_8b, 
  input  logic        is_k, 
  input  logic        disp,
  output logic [9:0]  code_10b, 
  output logic        disp_next
);


  //----------------------------------------------------------------------------
  logic a, b, c, d, e, f, g, h;
  logic aeqb; 
  logic ceqd; 
  logic l22; 
  logic l40; 
  logic l04; 
  logic l13; 
  logic l31; 
  logic pd1s6;
  logic nd1s6;
  logic ndos6;
  logic pdos6;
  logic nd1s4;
  logic pd1s4;
  logic ndos4;
  logic pdos4;
  logic compls6;
  logic disp6;
  logic compls4;
  logic dispval;
  logic alt7; 
  logic A, B, C, D, E, I, F, G, H, J;


  //----------------------------------------------------------------------------
  assign {h, g, f, e, d, c, b, a} = code_8b;


  //----------------------------------------------------------------------------
  assign aeqb = !(a ^ b);
  assign ceqd = !(c ^ d);
  assign l22  = (a & b) & (!c & !d) | (c & d & !a & !b) | (!aeqb  & !ceqd);
  assign l40 = a & b & c & d;
  assign l04 = !a  & !b & !c & !d;
  assign l13 = (!aeqb & !c & !d) | (!ceqd & !a & !b);
  assign l31 = (!aeqb & c & d) | (!ceqd & a & b);

  assign A = a;
  assign B = (b & !l40) | l04;
  assign C = l04 | c | (e & d & !c & !b & !a);
  assign D = d & (!(a & b & c));
  assign E = (e | l13) & !(e & d & !c & !b & !a);
  assign I = (l22 & !e) | (e & !d & !c & !(a & b)) | (e & l40) | (is_k & e &  d & c & !b & !a) | (e & !d & c  & !b & !a);

  assign pd1s6 = (e & d & !c & !b & !a) | (!e & !l22 & !l31);
  assign nd1s6 = is_k | (e & !l22 & !l13) | (!e & !d & c & b & a);

  assign ndos6 = pd1s6;
  assign pdos6 = is_k | (e & !l22 & !l13);

  assign compls6 = (pd1s6 & (!disp)) | (nd1s6 & disp);
  assign disp6 = disp ^ (ndos6 | pdos6);


  //----------------------------------------------------------------------------
  assign dispval = disp ? (!e & d & l31) : (e & !d & l13);
  assign alt7 = f & g & h & (is_k | dispval);

  assign F = f & !alt7;
  assign G = g | (!f & !g & !h);
  assign H = h;
  assign J = (!h & (g ^ f)) | alt7;

  assign nd1s4 = f & g;
  assign pd1s4 = (!f & !g) | (is_k & ((f & !g) | (!f & g)));
  assign ndos4 = (!f & !g);
  assign pdos4 = f & g & h;
  assign compls4 = (pd1s4 & !disp6) | (nd1s4 & disp6);


  //----------------------------------------------------------------------------
  assign code_10b = { 
    (J ^ compls4), (H ^ compls4),
    (G ^ compls4), (F ^ compls4),
    (I ^ compls6), (E ^ compls6),
    (D ^ compls6), (C ^ compls6),
    (B ^ compls6), (A ^ compls6) 
  };

  assign disp_next = disp6 ^ (ndos4 | pdos4);


endmodule