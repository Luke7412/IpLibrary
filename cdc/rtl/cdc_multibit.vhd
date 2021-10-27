--------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/02/2020 08:23:18 PM
-- Design Name: 
-- Module Name: cdc_multibit - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library IEEE;
   use IEEE.STD_LOGIC_1164.ALL;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity cdc_multibit is
   generic (
      TDATA_NUM_BYTES : natural := 1
   );
   port (
      S_AClk    : in  std_logic;
      S_AResetn : in  std_logic;
      S_TValid  : in  std_logic;
      S_TReady  : out std_logic;
      S_TData   : in  std_logic_vector(8*TDATA_NUM_BYTES-1 downto 0);

      M_AClk      : in  std_logic;
      M_AResetn   : in  std_logic;
      M_TValid    : out std_logic;
      M_TReady    : in  std_logic;
      M_TData     : out std_logic_vector(8*TDATA_NUM_BYTES-1 downto 0)
   );
end cdc_multibit;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of cdc_multibit is

   signal TData      : std_logic_vector(8*TDATA_NUM_BYTES-1 downto 0);
   
   signal S_TReady_i : std_logic := '1';
   signal M_TValid_i : std_logic := '0';
   
   signal req        : std_logic := '0';
   signal req_sync   : std_logic;
   signal req_pulse  : std_logic;
   signal ack        : std_logic := '0'; 
   signal ack_pulse  : std_logic;

begin

   S_TReady <= S_TReady_i;
   M_TValid <= M_TValid_i;


   process(S_AClk)
   begin
      if rising_edge(S_AClk) then

         if S_TValid = '1' and S_TReady_i = '1' then
            S_TReady_i <= '0';
            TData           <= S_TData;
            req           <= not req;
         end if;

         if ack_pulse = '1' then
            S_TReady_i <= '1';
         end if;

      end if;
   end process;


   req_sync2_pgen : entity work.sync2_pgen
      port map( 
         clk   => M_AClk,
         din   => req,
         dout  => req_sync,
         pulse => req_pulse
      );


   process(M_AClk)
   begin
      if rising_edge(M_AClk) then

         if M_TValid_i = '1' and M_TReady = '1' then
            M_TValid_i <= '0';
            ack           <= not ack;
         end if;

         if req_pulse = '1' then
            M_TValid_i <= '1';
            M_TData    <= TData;
         end if;

      end if;
   end process;


   ack_sync2_pgen : entity work.sync2_pgen
      port map( 
         clk   => S_AClk,
         din   => ack,
         dout  => open,
         pulse => ack_pulse
      );


end rtl;
