
`include "svunit_defines.svh"
`timescale 1ns/1ns


module enc_8b10b_unit_test;
  import svunit_pkg::svunit_testcase;
  string name = "enc_8b10b_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import coding_8b10b_pkg::*;

  logic [7:0]  code_8b;
  logic        disp;
  logic        is_k;
  logic [9:0]  code_10b;
  logic        disp_next;


  //----------------------------------------------------------------------------
  enc_8b10b DUT(.*);


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
  endfunction


  task setup();
    svunit_ut.setup();
    code_8b <= '0;
    is_k <= '0;
    disp <= '0;
    #1;
  endtask


  task teardown();
    svunit_ut.teardown();
    #1;
  endtask


  //----------------------------------------------------------------------------
  task automatic check_encoding(t_entry entry);
    logic [9:0] exp_code_10b = disp ? entry.code_10b_n : entry.code_10b_p;
    logic exp_disp_next = disp ^ entry.flip_rd;
    
    `FAIL_UNLESS_LOG(exp_code_10b == code_10b, 
      $sformatf("Data: %s, Exp: %010b, Got: %010b", entry.name, exp_code_10b, code_10b)
    );
    `FAIL_UNLESS_LOG(exp_disp_next == disp_next, 
      $sformatf("Data: %s, Exp: %b, Got: %b", entry.name, exp_disp_next, disp_next)
    );
  endtask


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN

  `SVTEST(test_encode_from_pos_rd)
    disp <= '1;

    foreach (entries[i]) begin
      code_8b <= entries[i].code_8b;
      is_k    <= entries[i].is_k;
      #1;
      check_encoding(entries[i]);
    end
  `SVTEST_END


  `SVTEST(test_encode_from_neg_rd)
    disp = '0;

    foreach (entries[i]) begin
      code_8b <= entries[i].code_8b;
      is_k    <= entries[i].is_k;
      #1;
      check_encoding(entries[i]);
    end
  `SVTEST_END
 

  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
