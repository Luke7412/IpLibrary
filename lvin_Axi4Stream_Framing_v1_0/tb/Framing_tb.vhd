--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : Framing
-- File Name      : Framing_tb.vhd
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
   use IEEE.std_logic_arith.ext;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity Framing_tb is
end entity Framing_tb;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture Behavioral of Framing_tb is

   constant c_EscapeByte : std_logic_vector(7 downto 0) := x"ff";
   constant c_StartByte  : std_logic_vector(7 downto 0) := x"aa";
   constant c_StopByte   : std_logic_vector(7 downto 0) := x"bb";

   signal AClk           : std_logic;
   signal AResetn        : std_logic;
   signal RxByte_TValid  : std_logic;
   signal RxByte_TReady  : std_logic;
   signal RxByte_TData   : std_logic_vector(7 downto 0);
   signal RxFrame_TValid : std_logic;
   signal RxFrame_TReady : std_logic;
   signal RxFrame_TData  : std_logic_vector(7 downto 0);
   signal RxFrame_TLast  : std_logic;
   signal TxByte_TValid  : std_logic;
   signal TxByte_TReady  : std_logic;
   signal TxByte_TData   : std_logic_vector(7 downto 0);
   signal TxFrame_TValid : std_logic;
   signal TxFrame_TReady : std_logic;
   signal TxFrame_TData  : std_logic_vector(7 downto 0);
   signal TxFrame_TLast  : std_logic;

   constant c_PeriodAClk : time    := 5 ns;
   signal ClockEnable    : boolean := False;

   type t_TestResult is (PASS, FAIL, BUSY);
   signal TestResult : t_TestResult := BUSY;

   type t_Beat is record
      TData : std_logic_vector(7 downto 0);
      TLast : std_logic;
   end record t_Beat;

   type t_BeatQueue is array(natural range <>) of t_Beat;
   constant QueueDepth : natural := 16;
   signal BeatQueue : t_BeatQueue(0 to QueueDepth-1);
   signal ReadPtr   : natural := 0;
   signal WritePtr  : natural := 0;

   function ToUInt(x : std_logic_vector) return integer is
   begin
      return to_integer(unsigned(x));
   end function;

begin

   -----------------------------------------------------------------------------
   p_AClk : process
   begin
      AClk <= '0';
      wait until ClockEnable = True;
      while ClockEnable loop
         AClk <= not AClk;
         wait for c_PeriodAClk/2;
      end loop;
      wait;
   end process;


   -----------------------------------------------------------------------------
   Dut : entity work.Framing
      Generic map(
         g_EscapeByte => c_EscapeByte,
         g_StartByte  => c_StartByte ,
         g_StopByte   => c_StopByte  
      )
      Port map( 
         AClk           => AClk          ,
         AResetn        => AResetn       ,
         RxByte_TValid  => RxByte_TValid ,
         RxByte_TReady  => RxByte_TReady ,
         RxByte_TData   => RxByte_TData  ,
         RxFrame_TValid => RxFrame_TValid,
         RxFrame_TReady => RxFrame_TReady,
         RxFrame_TData  => RxFrame_TData ,
         RxFrame_TLast  => RxFrame_TLast ,
         TxByte_TValid  => TxByte_TValid ,
         TxByte_TReady  => TxByte_TReady ,
         TxByte_TData   => TxByte_TData  ,
         TxFrame_TValid => TxFrame_TValid,
         TxFrame_TReady => TxFrame_TReady,
         TxFrame_TData  => TxFrame_TData ,
         TxFrame_TLast  => TxFrame_TLast
      );

   RxByte_TValid <= TxByte_TValid;
   TxByte_TReady <= RxByte_TReady;
   RxByte_TData  <= TxByte_TData;


   -----------------------------------------------------------------------------
   process(AClk, AResetn) is
      variable ReceivedBeat, ExpectedBeat : t_Beat;

      procedure CompareBeats(ReceivedBeat, ExpectedBeat : t_Beat) is
      begin
         if ReceivedBeat.TData /= ExpectedBeat.TData then
            TestResult <= FAIL;
            report "Wrong TData. Got: " & integer'image(ToUInt(ReceivedBeat.TData)) & " Expected: " & integer'image(ToUInt(ExpectedBeat.TData))
               severity error;
         end if;

         if ReceivedBeat.TLast /= ExpectedBeat.TLast then
            TestResult <= FAIL;
            report "Wrong TLast. Got: " & std_logic'image(ReceivedBeat.TLast) & " Expected: " & std_logic'image(ExpectedBeat.TLast)
               severity error;
         end if;
      end procedure;

   begin

      if AResetn = '0' then

      elsif rising_edge(AClk) then
         if RxFrame_TValid = '1' and RxFrame_TReady = '1' then
            ReceivedBeat := (RxFrame_TData, RxFrame_TLast);
            ExpectedBeat := BeatQueue(ReadPtr);
            ReadPtr      <= (ReadPtr + 1) mod QueueDepth;
            CompareBeats(ReceivedBeat, ExpectedBeat);
         end if;
      end if;
   end process;


   -----------------------------------------------------------------------------
   process
      procedure WaitTics(
         constant NofTics : natural
      ) is
      begin
         for I in 0 to NofTics-1 loop
            wait until rising_edge(AClk);
         end loop;
      end procedure;

      procedure SendBeat(
         TData : std_logic_vector(7 downto 0);
         TLast : std_logic
      ) is
         variable Beat : t_Beat := (TData, TLast);
      begin
         BeatQueue(WritePtr) <= Beat;
         WritePtr <= (WritePtr + 1) mod QueueDepth;

         TxFrame_TValid <= '1';
         TxFrame_TData  <= ext(TData, TxFrame_TData'length);
         TxFrame_TLast  <= TLast;

         L1 : loop
            wait until rising_edge(AClk);
            if TxFrame_TValid = '1' and TxFrame_TReady = '1' then
               TxFrame_TValid <= '0';
               exit L1;
            end if;
         end loop;
         TxFrame_TData  <= x"00";
         TxFrame_TLast  <= '0';
      end procedure;
 
   begin

      AResetn        <= '0';
      RxFrame_TReady <= '0';
      TxFrame_TValid <= '0';

      wait for 10*c_PeriodAClk;
      ClockEnable <= True;

      WaitTics(10);
      AResetn <= '1';

      WaitTics(10);
      RxFrame_TReady <= '1';
      --------------------------------------------------------------------------

      WaitTics(10);
      SendBeat(x"00", '0');
      SendBeat(x"01", '0');
      SendBeat(x"02", '0');
      SendBeat(x"03", '1');

      WaitTics(10);
      SendBeat(x"03", '1');

      WaitTics(10);
      SendBeat(x"00", '0');
      SendBeat(c_StopByte, '0');
      SendBeat(x"02", '0');
      SendBeat(x"03", '1');   

      WaitTics(10);
      SendBeat(x"00", '0');
      SendBeat(x"01", '0');
      SendBeat(x"02", '0');
      SendBeat(c_StopByte, '1'); 

      WaitTics(10);
      SendBeat(c_StopByte, '0');
      SendBeat(x"01", '0');
      SendBeat(x"02", '0');
      SendBeat(x"03", '1'); 

      WaitTics(10);
      SendBeat(c_StopByte, '1');

      WaitTics(10);
      SendBeat(c_StopByte, '1');

      --------------------------------------------------------------------------
      WaitTics(10);
      AResetn <= '0';
      WaitTics(10);
      ClockEnable <= False;
      wait for 10*c_PeriodAClk;
      report "Simulation Finished";
      wait;
   end process;

end Behavioral;
