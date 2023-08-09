//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
module cdr_data_recovery #(
  string MODE = "phased",  // mode: "phased", "2x", "4x", "iddr"
  int TDATA_WIDTH = 8 
)(
  input  logic                    clk,
  input  logic                    clk90,
  input  logic                    in_data,
  input  logic                    aclk,
  input  logic                    aresetn,
  output logic                    m_tvalid,
  output logic [TDATA_WIDTH-1:0]  m_tdata
);


  //----------------------------------------------------------------------------
  typedef enum {A, B, C, D, IDLE} t_domain;
  t_domain domain, prev_domain;

  logic [3:0] sample_data, sample_data_q;
  logic [3:0] pos_edge, neg_edge;


  logic [1:0] valid;
  logic [1:0] data;
   
  logic [TDATA_WIDTH:0] shift_reg;
  logic [$clog2(TDATA_WIDTH+1):0] shift_cnt;


  //----------------------------------------------------------------------------
  // STAGE 1
  //----------------------------------------------------------------------------
  generate 
  if (MODE == "phased") begin : gen_sampler_phased
    sampler_phased i_sampler(
      .clk       (clk),
      .clk90     (clk90),
      .rst_n     (aresetn),
      .in_data   (in_data),
      .out_data  (sample_data)
    );

  end else if (MODE == "iserdese2") begin : gen_sampler_iserdese2 
    sampler_iserdese2 i_sampler(
      .clk       (clk),
      .clk90     (clk90),
      .rst_n     (aresetn),
      .in_data   (in_data),
      .out_data  (sample_data)
    );

  end else if (MODE == "2x") begin : gen_sampler_2x 
    sampler_2x i_sampler(
      .clk       (clk),
      .rst_n     (aresetn),
      .in_data   (in_data),
      .out_data  (sample_data)
    );

  end else if (MODE == "iddr") begin : gen_sampler_iddr2x 
    sampler_iddr i_sampler(
      .clk       (clk),
      .rst_n     (aresetn),
      .in_data   (in_data),
      .out_data  (sample_data)
    );

  end else if (MODE == "4x") begin : gen_sampler_4x
    sampler_4x i_sampler(
      .clk       (clk),
      .rst_n     (aresetn),
      .in_data   (in_data),
      .out_data  (sample_data)
    );

  end else begin
    $fatal($sformatf("Unsupported MODE '%s', must be [phased, 2x, 4x, iddr, iddr2x]", MODE));
  end 
  endgenerate


  //----------------------------------------------------------------------------  
  // STAGE 2
  //----------------------------------------------------------------------------
  always @(posedge aclk or negedge aresetn) begin : p_selector
    if (!aresetn) begin 
      pos_edge    <= '0;
      neg_edge    <= '0;
      prev_domain <= IDLE;
      valid       <= '0;
      data        <= '0;
    
    end else begin
      valid <= '0;

      sample_data_q <= sample_data;

      pos_edge    <= (sample_data ^ sample_data_q) |  sample_data; 
      neg_edge    <= (sample_data ^ sample_data_q) | ~sample_data;
      prev_domain <= domain;

      if (prev_domain == D && domain == A) begin
        // no valid data
          
      end else if (prev_domain == A && domain == D) begin
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
      end else if (domain == D) begin
        valid[0] <= '1;
        data[0]  <= sample_data_q[3];
      end

    end 
  end


  always_comb begin : p_state
    if ((pos_edge == 'b0001) || (neg_edge == 'b0001)) begin
      domain = D;
    end else if ((pos_edge == 'b0011) || (neg_edge == 'b0011)) begin
      domain = A;
    end else if ((pos_edge == 'b0111) || (neg_edge == 'b0111)) begin
      domain = B;
    end else if ((pos_edge == 'b1111) || (neg_edge == 'b1111)) begin
      domain = C;
    end else begin
      domain = prev_domain;
    end
  end


  //----------------------------------------------------------------------------
  // STAGE 3
  //----------------------------------------------------------------------------
  always_ff @(posedge aclk or negedge aresetn) begin : p_deserializer
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

      if (shift_cnt == TDATA_WIDTH) begin
        m_tvalid <= '1;
        m_tdata  <= shift_reg[$left(shift_reg):1];
        v_cnt    = v_cnt - TDATA_WIDTH;
      end else if (shift_cnt == TDATA_WIDTH+1) begin
        m_tvalid <= '1;
        m_tdata  <= shift_reg[$left(shift_reg)-1:0];
        v_cnt    = v_cnt - TDATA_WIDTH;
      end else begin
        m_tvalid <= '0;
      end

      shift_reg <= v_reg;
      shift_cnt <= v_cnt;

    end
  end


endmodule