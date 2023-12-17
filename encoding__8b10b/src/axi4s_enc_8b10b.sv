
module axi4s_enc_8b10b (
  input  logic aclk,
  input  logic aresetn,
  // AXI4-Stream slave interface
  input  logic       s_tvalid,
  output logic       s_tready,
  input  logic [7:0] s_tdata,
  input  logic       s_tuser,
  // AXI4-Stream master interface
  output logic       m_tvalid,
  input  logic       m_tready,
  output logic [9:0] m_tdata,
  // Control
  input  logic restart
);


  //----------------------------------------------------------------------------
  logic disp, disp_next;    // 0: disp-1, 1: disp+1
  logic [9:0] code_10b;


  //----------------------------------------------------------------------------
  assign s_tready = m_tready;


  enc_8b10b i_enc_8b10b (
    .code_8b   (s_tdata),   
    .is_k      (s_tuser),      
    .disp      (restart ? '0 : disp),
    .code_10b  (code_10b),  
    .disp_next (disp_next)
  );
  

  always_ff @ (posedge aclk or negedge aresetn) begin
    if (!aresetn) begin
      disp     <= '0;
      m_tvalid <= '0;
      m_tdata  <= '0;

    end else begin
      if (m_tvalid && m_tready) begin
        m_tvalid <= '0;
      end

      if (s_tvalid && s_tready) begin
        disp     <= disp_next;
        m_tvalid <= '1;
        m_tdata  <= code_10b;
      end

    end 
  end


endmodule