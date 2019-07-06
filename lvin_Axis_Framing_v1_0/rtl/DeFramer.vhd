--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : Framing
-- File Name      : DeFramer.vhd
--------------------------------------------------------------------------------
-- Author         : Lukas Vinkx
-- Description: 
-- 
-- 
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library IEEE;
   use IEEE.STD_LOGIC_1164.ALL;
   use IEEE.NUMERIC_STD.ALL;
   use ieee.math_real.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity DeFramer is
   Generic(
      g_AClkFrequency : natural := 200000000;
      g_BaudRate      : natural := 9600;
      g_BaudRateSim   : natural := 50000000
   );
   Port ( 
      AClk          : in  std_logic;
      AResetn       : in  std_logic;
      Uart_TxD      : out std_logic;
      TxByte_TValid : in  std_logic;
      TxByte_TReady : out std_logic;
      TxByte_TData  : in  std_logic_vector(7 downto 0) := (others => '0');
      TxByte_TKeep  : in  std_logic_vector(0 downto 0) := (others => '1')
   );
end entity DeFramer;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of DeFramer is

   constant c_UsedBaudRate : natural  :=  g_BaudRate
                                          -- synthesis translate_off
                                          - g_BaudRate + g_BaudRateSim
                                          -- synthesis translate_on
                                          ;

   constant TicsPerBeat  : natural  := g_AClkFrequency/c_UsedBaudRate;                           
   constant CounterWidth : positive := positive(ceil(log2(real(TicsPerBeat))));

   signal TxByte_TReady_i : std_logic;

   signal ShiftRegTxD : std_logic_vector(8 downto 0);

   signal Cnt_Beats : unsigned(5 downto 0);
   signal Cnt_Tics  : unsigned(CounterWidth-1 downto 0);

   type t_State is (s_Idle, s_Running);
   signal State : t_State;

begin
   
   TxByte_TReady <= TxByte_TReady_i;

   process(AClk, AResetn) is
   begin
      if AResetn = '0' then
         TxByte_TReady_i <= '0';
         ShiftRegTxD(0)  <= '1';
         State           <= s_Idle;

      elsif rising_edge(AClk) then
           
      end if;

   end process;



end architecture rtl;
