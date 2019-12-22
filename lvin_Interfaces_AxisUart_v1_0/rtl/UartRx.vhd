--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : AxisUart
-- File Name      : UartRx.vhd
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
entity UartRx is
   Generic(
      g_AClkFrequency : natural := 200000000;
      g_BaudRate      : natural := 9600;
      g_BaudRateSim   : natural := 50000000
   );
   Port ( 
      AClk          : in  std_logic;
      AResetn       : in  std_logic;
      Uart_RxD      : in  std_logic;
      RxByte_TValid : out std_logic;
      RxByte_TReady : in  std_logic;
      RxByte_TData  : out std_logic_vector(7 downto 0)
   );
   constant BaudRate_sample : real := real(g_AClkFrequency) / real(g_AClkFrequency/g_BaudRate);
begin
   -- synthesis translate_off
   assert 10.0*(1.0-real(g_BaudRate)/BaudRate_sample) < 0.45
      report "Unsafe baudrate ratio."
      severity error;
   -- synthesis translate_on
end entity UartRx;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of UartRx is
   
   constant c_UsedBaudRate : natural  :=  g_BaudRate
                                          -- synthesis translate_off
                                          - g_BaudRate + g_BaudRateSim
                                          -- synthesis translate_on
                                          ;

   constant TicsPerBeat  : natural  := g_AClkFrequency/c_UsedBaudRate;                     
   constant CounterWidth : positive := positive(ceil(log2(real(TicsPerBeat))));

   signal RxByte_TValid_i : std_logic;

   Signal Uart_RxD_q  : std_logic;
   signal ShiftRegRxD : std_logic_vector(9 downto 0);

   signal Cnt_Beats : unsigned(5 downto 0);
   signal Cnt_Tics  : unsigned(CounterWidth-1 downto 0);

   type t_State is (s_Idle, s_Sampling, s_Outputting);
   signal State : t_State;

begin
   
   RxByte_TValid <= RxByte_TValid_i;

   process(AClk, AResetn) is
   begin
      if AResetn = '0' then
         Uart_RxD_q      <= '0';
         RxByte_TValid_i <= '0';
         State           <= s_Idle;

      elsif rising_edge(AClk) then
         Uart_RxD_q <= Uart_RxD;

         if RxByte_TValid_i = '1' and RxByte_TReady = '1' then
            RxByte_TValid_i <= '0';
         end if;

         case State is
            when s_Idle =>
               if Uart_RxD = '0' and Uart_RxD_q = '1' then
                  Cnt_Tics  <= to_unsigned(TicsPerBeat/2-1, Cnt_Tics'length);
                  Cnt_Beats <= to_unsigned(9, Cnt_Beats'length);
                  State     <= s_Sampling;
               end if;

            when s_Sampling => 
               if Cnt_Tics = 0 then
                  Cnt_Tics    <= to_unsigned(TicsPerBeat-1, Cnt_Tics'length);
                  ShiftRegRxD <= Uart_RxD & ShiftRegRxD(ShiftRegRxD'high downto 1);
                  if Cnt_Beats = 0 then
                     State <= s_Outputting;
                  else
                     Cnt_Beats <= Cnt_Beats-1;
                  end if;
               else
                  Cnt_Tics <= Cnt_Tics-1;
               end if;

            when s_Outputting =>
               State <= s_Idle;
               if RxByte_TValid_i = '0' and ShiftRegRxD(0) = '0' and ShiftRegRxD(9) = '1' then
                  RxByte_TValid_i <= '1';
                  RxByte_TData    <= ShiftRegRxD(8 downto 1);
               end if;

         end case;            
      end if;
   end process;

end architecture rtl;
