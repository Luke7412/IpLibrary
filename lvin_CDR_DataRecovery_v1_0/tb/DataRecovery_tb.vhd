
--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library ieee;
   use ieee.std_logic_1164.all;
   use ieee.numeric_std.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity DataRecovery_tb is
end DataRecovery_tb;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture Behavioral of DataRecovery_tb is

   signal clk_1x, clk_2x, clk_4x                      : std_logic;
   signal clk_1x_90                                   : std_logic;
   signal resetn                                      : std_logic;
   signal in_data                                     : std_logic;
   signal A_valid, B_valid, C_valid, D_valid, E_valid : std_logic;
   signal A_data , B_data , C_data , D_data , E_data  : std_logic_vector(7 downto 0);

   constant c_PeriodClk : time    := 10 ns;
   signal ClockEnable   : boolean := False;

   signal PeriodDataClk : time    := 10 ns;
   signal DataClk       : std_logic;
   signal data          : std_logic_vector(7 downto 0);

begin

   -----------------------------------------------------------------------------
   p_Clk_1x : process
   begin
      clk_1x    <= '0';
      clk_1x_90 <= '0';
      wait until ClockEnable = True;
      while ClockEnable loop
         clk_1x    <= not clk_1x;
         wait for c_PeriodClk/4;
         clk_1x_90 <= not clk_1x_90;
         wait for c_PeriodClk/4;
      end loop;
      wait;
   end process;

   p_Clk_2x : process
   begin
      clk_2x <= '0';
      wait until ClockEnable = True;
      while ClockEnable loop
         clk_2x <= not clk_2x;
         wait for c_PeriodClk/4;
      end loop;
      wait;
   end process;

   p_Clk_4x : process
   begin
      clk_4x <= '0';
      wait until ClockEnable = True;
      while ClockEnable loop
         clk_4x <= not clk_4x;
         wait for c_PeriodClk/8;
      end loop;
      wait;
   end process;


   p_data_clk : process
   begin
      DataClk <= '0';
      wait until ClockEnable = True;
      while ClockEnable loop
         DataClk <= not DataClk;
         wait for PeriodDataClk/2;
      end loop;
      wait;
   end process;


   -----------------------------------------------------------------------------
   DUT_phased: entity work.DataRecovery
      generic map(
         mode => "phased"
      )
      port map(
         clk        => clk_1x,  
         clk90      => clk_1x_90,
         resetn     => resetn ,
         in_data    => in_data,
         out_valid  => A_valid,
         out_data   => A_data
      );

   DUT_2x: entity work.DataRecovery
      generic map(
         mode => "2x"
      )
      port map(
         clk        => clk_2x,
         clk90      => '0',
         resetn     => resetn ,
         in_data    => in_data,
         out_valid  => B_valid,
         out_data   => B_data
      );

   DUT_4x: entity work.DataRecovery
      generic map(
         mode => "4x"
      )
      port map(
         clk        => clk_4x,
         clk90      => '0',
         resetn     => resetn ,
         in_data    => in_data,
         out_valid  => C_valid,
         out_data   => C_data
      );

   DUT_Iddr: entity work.DataRecovery
      generic map(
         mode => "Iddr"
      )
      port map(
         clk        => clk_1x,
         clk90      => clk_1x_90,
         resetn     => resetn ,
         in_data    => in_data,
         out_valid  => D_valid,
         out_data   => D_data
      );

   DUT_Iddr2x: entity work.DataRecovery
      generic map(
         mode => "Iddr2x"
      )
      port map(
         clk        => clk_2x,
         clk90      => '0',
         resetn     => resetn ,
         in_data    => in_data,
         out_valid  => E_valid,
         out_data   => E_data
      );

   -----------------------------------------------------------------------------
   process(DataClk)
      variable index : integer := 0;
   begin
      if rising_edge(DataClk) then
         in_data <= data(index);
         index   := (index + 1) mod data'length;
      end if;
   end process;


   -----------------------------------------------------------------------------
   process
      procedure WaitTics(
         constant NofTics : natural := 1
      ) is
      begin
         for I in 0 to NofTics-1 loop
            wait until rising_edge(Clk_1x);
         end loop;
      end procedure;
 
   begin

      Resetn <= '0';
      data   <= (others => '0');

      wait for 10*c_PeriodClk;
      ClockEnable <= True;

      WaitTics(10);
      Resetn <= '1';

      WaitTics(10);
      --------------------------------------------------------------------------

      data <= "10000101";

      for I in -20 to 20 loop
         PeriodDataClk <= c_PeriodClk + I * 0.1 ns;
         WaitTics(100);
      end loop;


      --------------------------------------------------------------------------
      WaitTics(10);
      Resetn <= '0';
      WaitTics(10);
      ClockEnable <= False;
      wait for 10*c_PeriodClk;
      report "Simulation Finished";
      wait;
   end process;




end Behavioral;
