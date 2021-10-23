
--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity DataRecovery is
   generic(
      -- mode: "phased", "2x", "4x", "Iddr" or "Iddr2x"
      mode: string := "phased"
   );
   port (
      AClk       : in  std_logic;
      AClk90     : in  std_logic;
      AResetn    : in  std_logic;
      In_Data    : in  std_logic;
      Out_TValid : out std_logic;
      Out_TData  : out std_logic_vector(7 downto 0)
   );
end entity DataRecovery;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of DataRecovery is


   type t_domain is (A, B, C, D, IDLE);
   signal domain, prev_domain : t_domain;

   signal sample_valid               : std_logic;
   signal sample_data, sample_data_q : std_logic_vector(3 downto 0);
   signal pos_edge, neg_edge         : std_logic_vector(3 downto 0);


   signal valid     : std_logic_vector(1 downto 0);
   signal data      : std_logic_vector(1 downto 0);
   
   signal shift_reg : std_logic_vector(8 downto 0);
   signal shift_cnt : unsigned(3 downto 0);

begin
   
   -----------------------------------------------------------------------------
   -- STAGE 1
   -----------------------------------------------------------------------------
   gen_sampler_phased : if mode = "phased" generate
   begin
      i_sampler : entity work.SamplerPhased
         port map(
            clk       => clk         ,
            clk90     => clk90       ,
            resetn    => resetn      ,
            in_data   => in_data     ,
            out_valid => sample_valid,
            out_data  => sample_data 
         );
   end generate;

   gen_sampler_2x : if mode = "2x" generate
   begin
      i_sampler : entity work.Sampler2x
         port map(
            clk       => clk         ,
            clk90     => '0'         ,
            resetn    => resetn      ,
            in_data   => in_data     ,
            out_valid => sample_valid,
            out_data  => sample_data 
         );
   end generate;


   gen_sampler_4x : if mode = "4x" generate
   begin
      i_sampler : entity work.Sampler4x
         port map(
            clk       => clk         ,
            clk90     => '0'         ,
            resetn    => resetn      ,
            in_data   => in_data     ,
            out_valid => sample_valid,
            out_data  => sample_data 
         );
   end generate;


   gen_sampler_Iddr : if mode = "Iddr" generate
   begin
      i_sampler : entity work.SamplerIddr
         port map(
            clk       => clk         ,
            clk90     => clk90       ,
            resetn    => resetn      ,
            in_data   => in_data     ,
            out_valid => sample_valid,
            out_data  => sample_data 
         );
   end generate;

   gen_sampler_Iddr2x : if mode = "Iddr2x" generate
   begin
      i_sampler : entity work.SamplerIddr2x
         port map(
            clk       => clk         ,
            clk90     => '0'         ,
            resetn    => resetn      ,
            in_data   => in_data     ,
            out_valid => sample_valid,
            out_data  => sample_data 
         );
   end generate;

   -----------------------------------------------------------------------------
   -- STAGE 2
   -----------------------------------------------------------------------------
   p_selector : process(clk, resetn)
   begin
      if resetn = '0' then
         pos_edge    <= (others => '0');
         neg_edge    <= (others => '0');
         prev_domain <= IDLE;
         valid       <= (others => '0');
         data        <= (others => '0');

      elsif rising_edge(clk) then
         valid <= (others => '0');

         if sample_valid = '1' then
            sample_data_q <= sample_data;

            pos_edge    <= (sample_data xor sample_data_q) and     sample_data; 
            neg_edge    <= (sample_data xor sample_data_q) and not sample_data;
            prev_domain <= domain;

            if prev_domain = D and domain = A then
               -- no valid data
            
            elsif prev_domain = A and domain = D then
               -- 2 valid bits
               valid(0) <= '1';
               data(0)  <= sample_data_q(0);
               valid(1) <= '1';
               data(1)  <= sample_data_q(3);

            elsif domain = A then
               valid(0) <= '1';
               data(0)  <= sample_data_q(0);
            elsif domain = B then
               valid(0) <= '1';
               data(0)  <= sample_data_q(1);
            elsif domain = C then   
               valid(0) <= '1';
               data(0)  <= sample_data_q(2);
            elsif domain = D then
               valid(0) <= '1';
               data(0)  <= sample_data_q(3);
            end if;
         end if;

      end if;
   end process;


   p_state : process(pos_edge, neg_edge, prev_domain)
   begin
      if    (pos_edge = "0001") or (neg_edge = "0001") then
         domain <= D;
      elsif (pos_edge = "0011") or (neg_edge = "0011") then
         domain <= A;
      elsif (pos_edge = "0111") or (neg_edge = "0111") then
         domain <= B;
      elsif (pos_edge = "1111") or (neg_edge = "1111") then
         domain <= C;
      else
         domain <= prev_domain;
      end if;
   end process;


   -----------------------------------------------------------------------------
   -- STAGE 3
   -----------------------------------------------------------------------------
   p_deserializer : process(clk, resetn)
      variable reg : std_logic_vector(shift_reg'range);
      variable cnt : unsigned(shift_cnt'range);
   begin
      if resetn = '0' then
         out_valid <= '0';
         out_data  <= (others => '0');
         shift_reg <= (others => '0');
         shift_cnt <= (others => '0');

      elsif rising_edge(clk) then
         reg := shift_reg;
         cnt := shift_cnt;

         if valid(0) = '1' then
            reg := data(0) & reg(reg'high downto 1);
            cnt := cnt + 1;
         end if;

         if valid(1) = '1' then
            reg := data(1) & reg(reg'high downto 1);
            cnt := cnt + 1;
         end if;

         if shift_cnt = 8 then 
            out_valid <= '1';
            out_data  <= shift_reg(shift_reg'high downto 1);
            cnt       := cnt-8;
         elsif shift_cnt  = 9 then
            out_valid <= '1';
            out_data  <= shift_reg(shift_reg'high-1 downto 0);
            cnt       := cnt-8;
         else
            out_valid <= '0';
         end if;

         shift_reg <= reg;
         shift_cnt <= cnt;
      end if;
   end process;

end architecture rtl;