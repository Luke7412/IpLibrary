--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : AxisUart
-- File Name      : UartTx.vhd
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


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity UartTx is
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
end entity UartTx;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of UartTx is

   constant c_UsedBaudRate : natural  :=  g_BaudRate
                                          -- synthesis translate_off
                                          - g_BaudRate + g_BaudRateSim
                                          -- synthesis translate_on
                                          ;

   constant TicsPerBeat  : natural  := g_AClkFrequency/c_UsedBaudRate;                           

   signal TxByte_TReady_i : std_logic;

   signal ShiftRegTxD : std_logic_vector(8 downto 0);

   signal Cnt_Beats : natural range 0 to 9;
   signal Cnt_Tics  : natural range 0 to TicsPerBeat-1;

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
         case State is
            when s_Idle =>
               TxByte_TReady_i <= '1';
               if TxByte_TValid = '1' and TxByte_TReady_i = '1' and TxByte_TKeep = "1" then
                  TxByte_TReady_i <= '0';
                  ShiftRegTxD     <= TxByte_TData & '0';
                  Cnt_Tics        <= TicsPerBeat-1;
                  Cnt_Beats       <= 9;
                  State           <= s_Running;
               end if;

            when s_Running => 
               if Cnt_Tics = 0 then
                  Cnt_Tics    <= TicsPerBeat-1;
                  ShiftRegTxD <= '1' & ShiftRegTxD(ShiftRegTxD'high downto 1);
                  if Cnt_Beats = 0 then
                     TxByte_TReady_i <= '1';
                     State           <= s_Idle;
                  else
                     Cnt_Beats <= Cnt_Beats-1;
                  end if;
               else
                  Cnt_Tics <= Cnt_Tics-1;
               end if;

         end case;            
      end if;

   end process;

   Uart_TxD <= ShiftRegTxD(0);

end architecture rtl;
