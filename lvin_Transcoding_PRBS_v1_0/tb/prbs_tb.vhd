
--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library IEEE;
   use IEEE.STD_LOGIC_1164.ALL;


--------------------------------------------------------------------------------
-- ENTITYT
--------------------------------------------------------------------------------
entity PRBS_tb is
end PRBS_tb;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture Behavioral of PRBS_tb is

   constant TDATA_WIDTH : natural := 8;

   signal AClk                            : std_logic;
   signal AResetn                         : std_logic;
   signal S_TValid, PRBS_TValid, M_TValid : std_logic;
   signal S_TReady, PRBS_TReady, M_TReady : std_logic;
   signal S_TData , PRBS_TData , M_TData  : std_logic_vector(TDATA_WIDTH-1 downto 0);
   
   constant c_PeriodAClk : time    := 5 ns;
   signal ClockEnable    : boolean := False;

   signal toggleBit    : std_logic_vector(TDATA_WIDTH-1 downto 0) := (others => '0');
   
   signal manualValid  : std_logic;
   signal toggledValid : std_logic;

begin

   DUT_generator : entity work.PRBS
      generic map(
         CHK_MODE    => false,
         POLY_LENGTH => 15,
         POLY_TAP    => 14,
         TDATA_WIDTH => TDATA_WIDTH
      )
      Port map(
         AClk     => AClk,
         AResetn  => AResetn,
         S_TValid => S_TValid,
         S_TReady => S_TReady,
         S_TData  => S_TData,
         M_TValid => PRBS_TValid,
         M_TReady => PRBS_TReady
      );

   toggledValid <= PRBS_TValid and manualValid;


   DUT_checker : entity work.PRBS
      generic map(
         CHK_MODE    => true,
         POLY_LENGTH => 15,
         POLY_TAP    => 14,
         TDATA_WIDTH => TDATA_WIDTH
      )
      Port map(
         AClk     => AClk,
         AResetn  => AResetn,
         S_TValid => toggledValid,
         S_TReady => PRBS_TReady,
         S_TData  => PRBS_TData,
         M_TValid => M_TValid,
         M_TReady => M_TReady,
         M_TData  => M_TData
      );


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


   process(AClk, AResetn)
      variable divCnt : natural := 0;
   begin
      if AResetn = '0' then
         M_TReady <= '0';
      elsif rising_edge(Glob_AClk) then
         if divCnt = 0 then
            M_TReady <= '1';
            divCnt := 0;
         else
            M_TReady <= '0';
            divCnt := divCnt - 1;
         end if;
      end if;
   end process;


   -----------------------------------------------------------------------------
   process
      procedure pulseTValid is
      begin
         S_TValid <= '1';
         L1 : loop
            wait until rising_edge(AClk);
            if S_TValid = '1' and S_TReady = '1' then
               S_TValid <= '0';
               exit L1;
            end if;
         end loop;
      end procedure;

      procedure WaitTics(
         constant NofTics : natural := 1
      ) is
      begin
         for I in 0 to NofTics-1 loop
            wait until rising_edge(AClk);
         end loop;
      end procedure;

   begin

      AResetn     <= '0';
      S_TValid    <= '0';
      S_TData     <= (others => '0');
      manualValid <= '0';

      WaitTics(10);
      wait until rising_edge(AClk);
      AResetn <= '1';

      WaitTics(10);
      --------------------------------------------------------------------------

      Target_TValid <= '1';
      WaitTics(100);


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
