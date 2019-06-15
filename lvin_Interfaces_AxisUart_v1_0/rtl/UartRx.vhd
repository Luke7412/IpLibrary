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
      g_BaudRate      : natural := 9600
   );
   Port ( 
      AClk             : in  std_logic;
      AResetn          : in  std_logic;
      UART_RX          : in  std_logic;
      Initiator_TValid : out std_logic;
      Initiator_TReady : in  std_logic;
      Initiator_TData  : out std_logic_vector(7 downto 0)
   );
end entity UartRx;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of UartRx is

   constant TicsPerBeat  : natural  := g_AClkFrequency/g_BaudRate;
   constant CounterWidth : positive := positive(ceil(log2(real(TicsPerBeat))));

   signal Initiator_TValid_i : std_logic;

   Signal Uart_RX_q : std_logic;
   signal ShiftRegRX : std_logic_vector(9 downto 0);

   signal Cnt_Beats : unsigned(5 downto 0);
   signal Cnt_Tics  : unsigned(CounterWidth-1 downto 0);

   type t_State is (s_Idle, s_Sampling, s_Outputting);
   signal State : t_State;

begin
   
   Initiator_TValid <= Initiator_TValid_i;

   process(AClk, AResetn) is
   begin
      if AResetn = '0' then
         Uart_RX_q          <= '0';
         Initiator_TValid_i <= '0';
         State              <= s_Idle;

      elsif rising_edge(AClk) then
         Uart_RX_q <= Uart_RX;

         if Initiator_TValid_i = '1' and Initiator_TReady = '1' then
            Initiator_TValid_i <= '0';
         end if;

         case State is
            when s_Idle =>
               if Uart_RX = '0' and Uart_RX_q = '1' then
                  Cnt_Tics  <= to_unsigned(TicsPerBeat/2-1, Cnt_Tics'length);
                  Cnt_Beats <= to_unsigned(9, Cnt_Beats'length);
                  State     <= s_Sampling;
               end if;

            when s_Sampling => 
               if Cnt_Tics = 0 then
                  Cnt_Tics   <= to_unsigned(TicsPerBeat-1, Cnt_Tics'length);
                  ShiftRegRX <= Uart_RX & ShiftRegRX(ShiftRegRX'high downto 1);
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
               if Initiator_TValid_i = '0' and ShiftRegRX(0) = '0' and ShiftRegRX(9) = '1' then
                  Initiator_TValid_i <= '1';
                  Initiator_TData    <= ShiftRegRX(8 downto 1);
               end if;

         end case;            
      end if;

   end process;

end architecture rtl;
