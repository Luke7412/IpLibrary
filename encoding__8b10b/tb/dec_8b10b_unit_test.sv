
`include "svunit_defines.svh"
`timescale 1ns/1ns


module dec_8b10b_unit_test;
  import svunit_pkg::svunit_testcase;
  string name = "dec_8b10b_ut";
  svunit_testcase svunit_ut;


  //----------------------------------------------------------------------------
  import coding_8b10b_pkg::*;

  logic [9:0] code_10b;
  logic       disp;
  logic [7:0] code_8b;
  logic       is_k;
  logic       disp_next;
  logic       decode_err;
  logic       disp_err;


  //----------------------------------------------------------------------------
  dec_8b10b DUT (.*);


  //----------------------------------------------------------------------------
  function void build();
    svunit_ut = new(name);
  endfunction


  task setup();
    svunit_ut.setup();

    code_10b = '0;
    disp = '0;
    #1;
  endtask


  task teardown();
    svunit_ut.teardown();
    #1;
  endtask


  //----------------------------------------------------------------------------
  function automatic bit is_valid_10b_code(logic [9:0] x);
    t_entry elems [] = entries.find_first with 
        (item.code_10b_p == x || item.code_10b_n == x);
    return $size(elems) > 0;
  endfunction


  function automatic t_entry get_entry (logic [9:0] x);
    t_entry elems [] = entries.find_first with 
        (item.code_10b_p == x || item.code_10b_n == x);
    return elems [0];
  endfunction


  function automatic bit get_code_disp (t_entry entry, logic [9:0] x);
    if (entry.code_10b_p == x)
      return '1;
    else if (entry.code_10b_n == x)
      return '0;
    else
      $error("Invalid 10bit code for entry");
  endfunction


  task automatic check_decoding(t_entry entry);
    bit exp_disp = disp ^ entry.flip_rd;
    bit exp_disp_err = 0;

    if (entry.code_10b_p != entry.code_10b_n)
      exp_disp_err = disp ? (code_10b == entry.code_10b_p) : (code_10b == entry.code_10b_n);

    `FAIL_UNLESS_LOG(entry.code_8b == code_8b, 
      $sformatf("Data: %s, Exp: %08b, Got: %08b", entry.name, entry.code_8b, code_8b)
    );

    `FAIL_UNLESS_LOG(entry.is_k == is_k, 
      $sformatf("Data: %s, Exp: %010b, Got: %010b", entry.name, entry.is_k, is_k)
    );

    `FAIL_UNLESS_LOG(exp_disp_err == disp_err, 
      $sformatf("Data: %s, Exp: %1b, Got: %1b", entry.name, exp_disp_err, disp_err)
    );

    if (!exp_disp_err)
      `FAIL_UNLESS_LOG(exp_disp == disp_next, 
        $sformatf("Data: %s, Exp: %1b, Got: %1b", entry.name, exp_disp, disp_next)
      );

    `FAIL_UNLESS_LOG(0 == decode_err, 
      $sformatf("Data: %s, Exp: %1b, Got: %1b", entry.name, 0, decode_err)
    );

  endtask
  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_BEGIN


  `SVTEST(test_decode_from_pos_rd)
    disp = '1;

    foreach (entries[i]) begin
      code_10b = entries[i].code_10b_n;
      #1;
      check_decoding(entries[i]);
    end
  `SVTEST_END


 `SVTEST(test_decode_from_neg_rd)
    disp = '0;

    foreach (entries[i]) begin
      code_10b = entries[i].code_10b_p;
      #1;
      check_decoding(entries[i]);
    end
  `SVTEST_END


  `SVTEST(test_random_valid_sequence)
    t_entry entry;

    disp = '0;

    for (int i=0; i<10000; i++) begin
      entry = entries[$urandom_range(0, entries.size()-1)];
      code_10b = disp ? entry.code_10b_n : entry.code_10b_p;
      #1;
      check_decoding(entry);
      disp = disp_next;
    end
  `SVTEST_END


  `SVTEST(test_disparity_error_pos)
    t_entry entry;

    disp = '0;

    for (int i=0; i<10000; i++) begin
      entry = entries[$urandom_range(0, entries.size()-1)];
      code_10b  = entry.code_10b_p;
      #1;
      check_decoding(entry);
    end
  `SVTEST_END


  `SVTEST(test_disparity_error_neg)
    t_entry entry;

    disp = '1;

    for (int i=0; i<10000; i++) begin
      entry = entries[$urandom_range(0, entries.size()-1)];
      code_10b = entry.code_10b_n;
      #1;
      check_decoding(entry);
    end
  `SVTEST_END


  `SVTEST(test_exhaustive)
    t_entry entry;
    bit code_disp;

    for (int j=0; j<2; j++) begin : loop_disparity
      disp = j;

      for (int i=0; i<2**$bits(code_10b); i++) begin : loop_code_10b
        code_10b = i;
        #1;

        if (is_valid_10b_code(code_10b)) begin
          entry = get_entry(code_10b);
          check_decoding(entry);

        end else begin
          `FAIL_UNLESS_LOG(1 == decode_err, 
            $sformatf("Data: %b, Exp: %1b, Got: %1b", code_10b, 1, decode_err)
          );
        end

      end
    end
  `SVTEST_END


  //----------------------------------------------------------------------------
  `SVUNIT_TESTS_END

endmodule
