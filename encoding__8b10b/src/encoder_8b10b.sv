
module encoder_8b10b (
  input  logic [7:0]  in_data, 
  input  logic        in_disp,
  input  logic        in_is_k, 
  output logic [7:0]  out_data, 
  output logic        out_disp
);


  //----------------------------------------------------------------------------
  logic hi, gi, fi, ei, di, ci, bi, ai;
  logic ki;

  logic aeqb, ceqd;
  logic l22, l40, l04, l13, l31;
  logic a_o, b_o, c_o, d_o, e_o, i_o, f_o, g_o, h_o, j_o;
  logic nd1s6, pd1s6;
  logic ndos6, pdos6;
  logic alt7;
  logic nd1s4, pd1s4;
  logic ndos4, pdos4;
  logic compls6;
  logic disp6;
  logic compls4;


  //----------------------------------------------------------------------------
  assign {hi, gi, fi, ei, di, ci, bi, ai} = in_data;
  assign ki = in_is_k;


  assign aeqb = (ai & bi) | (!ai & !bi);
  assign ceqd = (ci & di) | (!ci & !di);
  assign l22 = (ai & bi & !ci & !di) | (ci & di & !ai & !bi) | (!aeqb & !ceqd);
  assign l40 = ai & bi & ci & di ;
  assign l04 = !ai & !bi & !ci & !di;
  assign l13 = (!aeqb & !ci & !di) | (!ceqd & !ai & !bi);
  assign l31 = (!aeqb & ci & di) | (!ceqd & ai & bi);

  // 5b/6b encoding
  assign a_o = ai;
  assign b_o = (bi & !l40) | l04;
  assign c_o = l04 | ci | (ei & di & !ci & !bi & !ai);
  assign d_o = di & !(ai & bi & ci);
  assign e_o = (ei | l13) & !(ei & di & !ci & !bi & !ai);
  assign i_o = (l22 & !ei) | (ei & !di & !ci & !(ai & bi)) | (ei & l40) | (ki & ei & di & ci & !bi & !ai) | (ei & !di & ci & !bi & !ai);

  assign pd1s6 = (ei & di & !ci & !bi & !ai) | (!ei & !l22 & !l31);
  assign nd1s6 = ki | (ei & !l22 & !l13) | (!ei & !di & ci & bi & ai);

  assign ndos6 = pd1s6;
  assign pdos6 = ki | (ei & !l22 & !l13);

  assign alt7 = fi & gi & hi & (ki | (in_disp ? (!ei & di & l31) : (ei & !di & l13)));

  // 3b/4b encoding
  assign f_o = fi & !alt7;
  assign g_o = gi | (!fi & !gi & !hi);
  assign h_o = hi;
  assign j_o = (!hi & (gi ^ fi)) | alt7;

  assign nd1s4 = fi & gi;
  assign pd1s4 = (!fi & !gi) | (ki & ((fi & !gi) | (!fi & gi)));

  assign ndos4 = (!fi & !gi);
  assign pdos4 = fi & gi & hi;

  assign compls6 = (pd1s6 & !in_disp) | (nd1s6 & in_disp);

  assign disp6 = in_disp ^ (ndos6 | pdos6);

  assign compls4 = (pd1s4 & !disp6) | (nd1s4 & disp6);
  assign out_disp = disp6 ^ (ndos4 | pdos4);

  assign out_data = {
    (j_o ^ compls4), 
    (h_o ^ compls4),
    (g_o ^ compls4), 
    (f_o ^ compls4),
    (i_o ^ compls6), 
    (e_o ^ compls6),
    (d_o ^ compls6), 
    (c_o ^ compls6),
    (b_o ^ compls6), 
    (a_o ^ compls6)
  };


endmodule