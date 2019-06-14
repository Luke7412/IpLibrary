--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : UartSlave
-- File Name      : UartSlave.vhd
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
entity UartSlave is
   Generic(
      g_AClkFrequency : natural := 200000000;
      g_BaudRate      : natural := 9600
   );
   Port ( 
      AClk             : in  std_logic;
      AResetn          : in  std_logic;
      UART_TX          : out std_logic;
      UART_RX          : in  std_logic;
      Target_TValid    : in  std_logic;
      Target_TReady    : out std_logic;
      Target_TData     : in  std_logic_vector(7 downto 0) := (others => '0');
      Target_TKeep     : in  std_logic_vector(0 downto 0) := (others => '1');
      Initiator_TValid : out std_logic;
      Initiator_TReady : in  std_logic;
      Initiator_TData  : out std_logic_vector(7 downto 0)
   );
end entity UartSlave;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of UartSlave is

   constant TicsPerBeat : natural := g_AClkFrequency/g_BaudRate;

   signal Target_TReady_i : std_logic;

   signal ShiftRegTX : std_logic_vector(8 downto 0);

   signal Cnt_Beats : unsigned(5 downto 0);
   signal Cnt_Tics  : unsigned(16 downto 0);

   type t_State is (s_Idle, s_Running);
   signal State : t_State;

begin
   
   Target_TReady <= Target_TReady_i;

   process(AClk, AResetn) is
   begin
      if AResetn = '0' then
         Target_TReady_i <= '0';
         ShiftRegTX(0)   <= '1';
         State           <= s_Idle;

      elsif rising_edge(AClk) then
         case State is
            when s_Idle =>
               Target_TReady_i <= '1';
               if Target_TValid = '1' and Target_TReady_i = '1' then
                  Target_TReady_i <= '0';
                  ShiftRegTX      <= Target_TData & '0';
                  Cnt_Tics        <= to_unsigned(TicsPerBeat-1, Cnt_Tics'length);
                  Cnt_Beats       <= to_unsigned(9, Cnt_Beats'length);
                  State           <= s_Running;
               end if;

            when s_Running => 
               if Cnt_Tics = 0 then
                  Cnt_Tics   <= to_unsigned(TicsPerBeat-1, Cnt_Tics'length);
                  ShiftRegTX <= '1' & ShiftRegTX(ShiftRegTX'high downto 1);
                  if Cnt_Beats = 0 then
                     Target_TReady_i <= '1';
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

   UART_TX <= ShiftRegTX(0);

end architecture rtl;
