
module decoder_8b10b (
  input  logic [9:0] in_data, 
  input  logic       in_disp, 
  output logic [7:0] out_data,
  output logic       out_disp,
  output logic       out_is_k, 
  output logic       err_code, 
  output logic       err_disp
);


  //----------------------------------------------------------------------------
  logic ji, hi, gi, fi, ii, ei, di, ci, bi, ai;
  logic aeqb, ceqd;
  logic p22, p13, p31, p40, p04;
  logic disp6a, disp6a2, disp6a0, disp6b;
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
  logic cdei;
  logic cndnenin;
  logic p22enin;
  logic p22ei;
  logic p31dnenin;
  logic p31e;
  logic compa, compb, compc, compd, compe;
  logic a_o, b_o, c_o, d_o, e_o, f_o, g_o, h_o;
  logic k_o;
  logic feqg, heqj;
  logic fghj22, fghjp13, fghjp31;
  logic alt7;
  logic k28, k28p;
  logic disp6n, disp4p, disp4n;
 

  //----------------------------------------------------------------------------
  assign {ji, hi, gi, fi, ii, ei, di, ci, bi, ai} = in_data;
  

  assign aeqb = (ai & bi) | (!ai & !bi);
  assign ceqd = (ci & di) | (!ci & !di);
  assign p22 = (ai & bi & !ci & !di) | (ci & di & !ai & !bi) | ( !aeqb & !ceqd);
  assign p13 = (!aeqb & !ci & !di) | (!ceqd & !ai & !bi);
  assign p31 = (!aeqb & ci & di) | (!ceqd & ai & bi);

  assign p40 = ai & bi & ci & di;
  assign p04 = !ai & !bi & !ci & !di;

  assign disp6a = p31 | (p22 & in_disp);
  assign disp6a2 = p31 & in_disp;
  assign disp6a0 = p13 & ! in_disp;
  assign disp6b = (((ei & ii & ! disp6a0) | (disp6a & (ei | ii)) | disp6a2 | (ei & ii & di)) & (ei | ii | di));

  // The 5B/6B decoding special cases where ABCDE != abcde
  assign p22bceeqi = p22 & bi & ci & (ei == ii);
  assign p22bncneeqi = p22 & !bi & !ci & (ei == ii);
  assign p13in = p13 & !ii;
  assign p31i = p31 & ii;
  assign p13dei = p13 & di & ei & ii;
  assign p22aceeqi = p22 & ai & ci & (ei == ii);
  assign p22ancneeqi = p22 & !ai & !ci & (ei == ii);
  assign p13en = p13 & !ei;
  assign anbnenin = !ai & !bi & !ei & !ii;
  assign abei = ai & bi & ei & ii;
  assign cdei = ci & di & ei & ii;
  assign cndnenin = !ci & !di & !ei & !ii;

  // non-zero disparity cases:
  assign p22enin = p22 & !ei & !ii;
  assign p22ei = p22 & ei & ii;
  assign p31dnenin = p31 & !di & !ei & !ii;
  assign p31e = p31 & ei;

  assign compa = p22bncneeqi | p31i | p13dei | p22ancneeqi | p13en | abei | cndnenin;
  assign compb = p22bceeqi | p31i | p13dei | p22aceeqi | p13en | abei | cndnenin;
  assign compc = p22bceeqi | p31i | p13dei | p22ancneeqi | p13en | anbnenin | cndnenin;
  assign compd = p22bncneeqi | p31i | p13dei | p22aceeqi |p13en | abei | cndnenin;
  assign compe = p22bncneeqi | p13in | p13dei | p22ancneeqi | p13en | anbnenin | cndnenin;

  assign a_o = ai ^ compa;
  assign b_o = bi ^ compb;
  assign c_o = ci ^ compc;
  assign d_o = di ^ compd;
  assign e_o = ei ^ compe;


  assign feqg = (fi & gi) | (!fi & !gi);
  assign heqj = (hi & ji) | (!hi & !ji);
  assign fghj22 = (fi & gi & !hi & !ji) | (!fi & !gi & hi & ji) | ( !feqg & !heqj);
  assign fghjp13 = (!feqg & !hi & !ji) | (!heqj & !fi & !gi);
  assign fghjp31 = ((!feqg) & hi & ji) | (!heqj & fi & gi);

  assign out_disp = (fghjp31 | (disp6b & fghj22) | (hi & ji)) & (hi | ji);

  assign k_o = ((ci & di & ei & ii) | (!ci & !di & !ei & !ii) | 
    (p13 & !ei & ii & gi & hi & ji) | (p31 & ei & !ii & !gi & !hi & !ji)
  );

  assign alt7 = 
    (fi & !gi & !hi & ((in_disp & ci & di & !ei & !ii) | k_o | (in_disp & !ci & di & !ei & !ii))) | 
    (!fi & gi & hi & ((!in_disp & !ci & !di & ei & ii) | k_o | (!in_disp & ci & !di & ei & ii))
  );

  assign k28 = (ci & di & ei & ii) | !(ci | di | ei | ii);
  assign k28p = !(ci | di | ei | ii);
  assign f_o = (ji & !fi & (hi | !gi | k28p)) | (fi & !ji & (!hi | gi | !k28p)) | 
    (k28p & gi & hi) | (!k28p & !gi & !hi);
  assign g_o = (ji & !fi & (hi | !gi | !k28p)) | (fi & !ji & (!hi | gi |k28p)) | 
    (!k28p & gi & hi) | (k28p & !gi & !hi);
  assign h_o = ((ji ^ hi) & ! ((!fi & gi & !hi & ji & !k28p) | (!fi & gi & hi & !ji & k28p) | 
		(fi & !gi & !hi & ji & !k28p) | (fi & !gi & hi & !ji & k28p))) |
	  (!fi & gi & hi & ji) | (fi & !gi & !hi & !ji) ;

  assign disp6p = (p31 & (ei | ii)) | (p22 & ei & ii);
  assign disp6n = (p13 & ! (ei & ii)) | (p22 & !ei & !ii);
  assign disp4p = fghjp31;
  assign disp4n = fghjp13;

  assign err_code = p40 | p04 | (fi & gi & hi & ji) | (!fi & !gi & !hi & !ji) |
    (p13 & !ei & !ii) | (p31 & ei & ii) | (ei & ii & fi & gi & hi) | 
    (!ei & !ii & !fi & !gi & !hi) | (ei & !ii & gi & hi & ji) | 
    (!ei & ii & !gi & !hi & !ji) | (!p31 & ei & !ii & !gi & !hi & !ji) |
    (!p13 & !ei & ii & gi & hi & ji) |
    (
      ((ei & ii & !gi & !hi & !ji) | (!ei & !ii & gi & hi & ji)) &
      !((ci & di & ei) | (!ci & !di & !ei))
    ) |
    (disp6p & disp4p) | (disp6n & disp4n) |
    (ai & bi & ci & !ei & !ii & ((!fi & !gi) | fghjp13)) |
    (!ai & !bi & !ci & ei & ii & ((fi & gi) | fghjp31)) |
    (fi & gi & !hi & !ji & disp6p) | (!fi & !gi & hi & ji & disp6n) |
    (ci & di & ei & ii & !fi & !gi & !hi) | (!ci & !di & !ei & !ii & fi & gi & hi);

  assign out_data = {h_o, g_o, f_o, e_o, d_o, c_o, b_o, a_o};
  assign out_is_k = k_o;

  assign err_disp = (
    (in_disp & disp6p) | (disp6n & !in_disp) | (in_disp & !disp6n & fi & gi) |
    (in_disp & ai & bi & ci) | (in_disp & !disp6n & disp4p) |
    (!in_disp & !disp6p & !fi & !gi) | (!in_disp & !ai & !bi & !ci) |
    (!in_disp & !disp6p & disp4n) | (disp6p & disp4p) | (disp6n & disp4n)
  );


endmodule