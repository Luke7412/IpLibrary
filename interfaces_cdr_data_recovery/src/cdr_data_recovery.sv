//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
module cdr_data_recovery #(
  string mode = "phased"  // mode: "phased", "2x", "4x", "Iddr" or "Iddr2x"
)(
  input  logic       aclk,
  input  logic       aclk90,
  input  logic       aresetn,
  input  logic       in_data,
  output logic       m_tvalid,
  output logic [7:0] m_tdata
);

  //----------------------------------------------------------------------------
   typedef enum (A, B, C, D, IDLE) t_domain;
   t_domain domain, prev_domain;

  logic       sample_valid;
  logic [3:0] sample_data, sample_data_q;
  logic [3:0] pos_edge, neg_edge;


  logic [1:0] valid;
  logic [1:0] data;
   
  logic [8:0] shift_reg;
  logic [3:0] shift_cnt;


  //----------------------------------------------------------------------------
  // STAGE 1
  //----------------------------------------------------------------------------
  generate 
  if (mode == "phased") begin : gen_sampler_phased
    sampler_phased i_sampler(
      .clk       (aclk),
      .clk90     (aclk90),
      .rst_n     (aresetn),
      .in_data   (in_data),
      .out_valid (sample_valid),
      .out_data  (sample_data)
    );
  

  end else if (mode == "2x") begin : gen_sampler_2x 
    sampler_2x i_sampler(
      .clk       (aclk),
      .rst_n     (aresetn),
      .in_data   (in_data),
      .out_valid (sample_valid),
      .out_data  (sample_data)
    );


  end else if (mode == "4x") begin : gen_sampler_4x
    sampler_4x i_sampler(
      .clk       (aclk),
      .rst_n     (aresetn),
      .in_data   (in_data),
      .out_valid (sample_valid),
      .out_data  (sample_data)
    );


  end else if (mode == "iddr") begin : gen_sampler_Iddr 
    sampler_iddr i_sampler(
      .clk       (aclk),
      .clk90     (aclk90),
      .rst_n     (aresetn),
      .in_data   (in_data),
      .out_valid (sample_valid),
      .out_data  (sample_data)
    );


  end else if (mode == "iddr2x") begin : gen_sampler_Iddr2x 
    sampler_iddr2x i_sampler(
      .clk       (aclk),
      .rst_n     (aresetn),
      .in_data   (in_data),
      .out_valid (sample_valid),
      .out_data  (sample_data)
    );


  end else begin
    $fatal($sformatf("Unsupported mode '%s', must be [phased, 2x, 4x, iddr, iddr2x]", mode));
  end 
  endgenerate


  //----------------------------------------------------------------------------  
  // STAGE 2
  //----------------------------------------------------------------------------
  always @ (posedge aclk or negedge aresetn) begin : p_selector
    if (!aresetn) begin 
      pos_edge    <= '0;
      neg_edge    <= '0;
      prev_domain <= IDLE;
      valid       <= '0;
      data        <= '0;
    
    end else begin
      valid <= '0;

      if (sample_valid) begin
        sample_data_q <= sample_data;

        pos_edge    <= (sample_data ^ sample_data_q) |  sample_data; 
        neg_edge    <= (sample_data ^ sample_data_q) | ~sample_data;
        prev_domain <= domain;

        if (prev_domain == D && domain == A) begin
          // no valid data
            
        end else if (prev_domain == A && domain = D) begin
          // 2 valid bits
          valid[0] <= '1;
          data[0]  <= sample_data_q[0];
          valid[1] <= '1;
          data[1]  <= sample_data_q[3];

        end else if (domain == A) begin
            valid[0] <= '1;
            data[0]  <= sample_data_q[0];
        end else if (domain == B) begin
            valid[0] <= '1;
            data[0]  <= sample_data_q[1];
        end else if (domain == C) begin   
            valid[0] <= '1;
            data[0]  <= sample_data_q[2];
        end else if (domain = D) begin
            valid[0] <= '1;
            data[0]  <= sample_data_q[3];
        end
      end

    end 
   end


  always begin : p_state
    if ((pos_edge == "0001") || (neg_edge == "0001")) begin
      domain = D;
    end else if ((pos_edge == "0011") || (neg_edge == "0011")) begin
      domain = A;
    end else if ((pos_edge == "0111") || (neg_edge == "0111")) begin
      domain = B;
    end else if ((pos_edge == "1111") || (neg_edge == "1111")) begin
      domain = C;
    end else begin
      domain = prev_domain;
    end
  end


  //----------------------------------------------------------------------------
  // STAGE 3
  //----------------------------------------------------------------------------
  always_ff @ (posedge aclk or negedge aresetn) begin : p_deserializer
    logic [$bits(shift_reg)-1:0] v_reg;
    logic [$bits(shift_cnt)-1:0] v_cnt;
  
    if (!aresetn) begin
      m_tvalid  <= '0;
      m_tdata   <= '0;
      shift_reg <= '0;
      shift_cnt <= '0;

    end else begin
      v_reg = shift_reg;
      v_cnt = shift_cnt;

      for (int i=0; i<$bits(valid); i++) begin
        if (valid[i]) begin
          v_reg = {data[i], v_reg} >> 1;
          v_cnt = v_cnt + 1;
        end
      end

      if (shift_cnt == 8) begin
        m_tvalid <= '1;
        m_tdata  <= shift_reg[$left(shift_reg):1];
        v_cnt    = v_cnt - 8;
      end else if (shift_cnt == 9) begin
        m_tvalid <= '1;
        m_tdata  <= shift_reg[$left(shift_reg)-1:0];
        cnt      = cnt - 8;
      end else begin
        m_tvalid <= '0;
      end

      shift_reg <= v_reg;
      shift_cnt <= v_cnt;

    end
  end


endmodule