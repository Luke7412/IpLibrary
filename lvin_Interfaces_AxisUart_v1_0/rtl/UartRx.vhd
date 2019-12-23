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
   use ieee.std_logic_unsigned.all;


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

   signal RxByte_TValid_i : std_logic;

   type t_State is (s_WaitForStart, s_Sampling, s_Outputting);
   signal State : t_State;

   signal Cnt_Beats : natural range 0 to 9;
   signal Cnt_Tics  : natural range 0 to TicsPerBeat-1;

   signal DeglitchReg : std_logic_vector(3 downto 0);
   signal RxD_deglitch : std_logic;
   signal ShiftRegRxD : std_logic_vector(9 downto 0);

begin
   
   RxByte_TValid <= RxByte_TValid_i;

   process(AClk, AResetn) is
   begin
      if AResetn = '0' then
         DeglitchReg  <= (others => '1');
         RxD_deglitch <= '1';

         RxByte_TValid_i <= '0';
         State           <= s_WaitForStart;

      elsif rising_edge(AClk) then

         DeglitchReg <= Uart_RxD & DeglitchReg(DeglitchReg'high downto 1);
         if DeglitchReg = 0 then
           RxD_deglitch <= '0';
         elsif not(DeglitchReg) = 0 then
           RxD_deglitch <= '1';
         end if;

         if RxByte_TValid_i = '1' and RxByte_TReady = '1' then
            RxByte_TValid_i <= '0';
         end if;

         case State is
            when s_WaitForStart =>
               if RxD_deglitch = '0' then
                  Cnt_Tics  <= TicsPerBeat/2-2;
                  Cnt_Beats <= 9;
                  State     <= s_Sampling;
               end if;

            when s_Sampling => 
               if Cnt_Tics = 0 then
                  Cnt_Tics    <= TicsPerBeat-1;
                  ShiftRegRxD <= RxD_deglitch & ShiftRegRxD(ShiftRegRxD'high downto 1);
                  if Cnt_Beats = 0 then
                     State <= s_Outputting;
                  else
                     Cnt_Beats <= Cnt_Beats-1;
                  end if;
               else
                  Cnt_Tics <= Cnt_Tics-1;
               end if;

            when s_Outputting =>
               State <= s_WaitForStart;
               if RxByte_TValid_i = '0' and ShiftRegRxD(0) = '0' and ShiftRegRxD(9) = '1' then
                  RxByte_TValid_i <= '1';
                  RxByte_TData    <= ShiftRegRxD(8 downto 1);
               end if;

         end case;            
      end if;
   end process;

end architecture rtl;
