----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/02/2020 09:01:24 PM
-- Design Name: 
-- Module Name: cdc_multibit_tb - Behavioral
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
----------------------------------------------------------------------------------


library IEEE;
   use IEEE.STD_LOGIC_1164.ALL;
   use IEEE.NUMERIC_STD.ALL;


entity cdc_multibit_tb is
end cdc_multibit_tb;


architecture Behavioral of cdc_multibit_tb is

   signal Source_AClk   : std_logic := '1';
   signal Source_TValid : std_logic;
   signal Source_TReady : std_logic;
   signal Source_TData  : std_logic_vector(7 downto 0);

   signal Dest_AClk     : std_logic := '1';
   signal Dest_TValid   : std_logic;
   signal Dest_TReady   : std_logic;
   signal Dest_TData    : std_logic_vector(7 downto 0);

   constant PERIOD_SOURCEACLK : time := 5 ns;
   constant PERIOD_DESTACLK   : time := 7 ns;

begin

   process
   begin
      wait for PERIOD_SOURCEACLK/2;
      Source_AClk <= not Source_AClk;
   end process;

   process
   begin
      wait for PERIOD_DESTACLK/2;
      Dest_AClk <= not Dest_AClk;
   end process;


   DUT : entity work.cdc_multibit
      port map(
         Source_AClk   => Source_AClk  ,
         Source_TValid => Source_TValid,
         Source_TReady => Source_TReady,
         Source_TData  => Source_TData ,

         Dest_AClk     => Dest_AClk    ,
         Dest_TValid   => Dest_TValid  ,
         Dest_TReady   => Dest_TReady  ,
         Dest_TData    => Dest_TData
      );


   process 
      procedure WaitTics(tics : natural) is
      begin
         for I in 0 to tics-1 loop
            wait until rising_edge(Source_AClk);
         end loop;
      end procedure;

      procedure SendData(NofBeats : natural) is
      begin
         for I in 0 to NofBeats-1 loop
            Source_TValid <= '1';
            Source_TData  <= std_logic_vector(to_unsigned(I, Source_TData'length));

            L0 : loop
               wait until rising_edge(Source_AClk);
               if Source_TValid = '1' and Source_TReady = '1' then
                  Source_TValid <= '0';
                  exit L0;
               end if;
            end loop;
         end loop;
      end procedure;

   begin

      Source_TValid <= '0';
      Dest_TReady   <= '0';

      WaitTics(20);
      Dest_TReady <= '1';

      WaitTics(20);
      SendData(1);

      WaitTics(20);
      SendData(4);

      wait;
   end process;

end Behavioral;
