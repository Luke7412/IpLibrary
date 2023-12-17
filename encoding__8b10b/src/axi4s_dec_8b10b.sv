
module axi4s_dec_8b10b (
  input  logic aclk,
  input  logic aresetn,
  // AXI4-Stream slave interface
  input  logic       s_tvalid,
  output logic       s_tready,
  input  logic [9:0] s_tdata,
  // AXI4-Stream master interface
  output logic       m_tvalid,
  input  logic       m_tready,
  output logic [7:0] m_tdata,
  output logic [2:0] m_tuser,  // [0]: is_k, [1]: disp_err, [2]: decode_err
  // Control
  input  logic restart
);


  //----------------------------------------------------------------------------
  logic disp, disp_next;    // 0: disp-1, 1: disp+1

  logic [7:0] code_8b;
  logic       is_k;
  logic       decode_err;
  logic       disp_err;


  //----------------------------------------------------------------------------
  assign s_tready = m_tready;


  dec_8b10b_stage i_dec_8b10b (
    .code_10b   (s_tdata),   
    .disp       (restart ? '0 : disp),
    .code_8b    (code_8b),  
    .is_k       (is_k),      
    .disp_next  (disp_next),
    .decode_err (decode_err),
    .disp_err   (disp_err)
  );
  

  always_ff @ (posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      disp     <= '0;
      m_tvalid <= '0;
      m_tdata  <= '0;
      m_tuser  <= '0;

    end else begin
      if (m_tvalid && m_tready) begin
        m_tvalid <= '0;
      end

      if (s_tvalid && s_tready) begin
        disp     <= disp_next;
        m_tvalid <= '1;
        m_tdata  <= code_8b;
        m_tuser  <= {decode_err, disp_err, is_k};
      end 

    end 
  end


endmodule