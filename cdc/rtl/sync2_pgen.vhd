----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/02/2020 08:32:27 PM
-- Design Name: 
-- Module Name: sync2_pgen - rtl
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity sync2_pgen is
   port ( 
      clk   : in  std_logic;
      din   : in  std_logic;
      dout  : out std_logic;
      pulse : out std_logic
   );
end sync2_pgen;

architecture rtl of sync2_pgen is
   
   signal sync, sync_q : std_logic;

begin

   i_sync : entity work.sync
      port map( 
         clk  => clk,
         din  => din,
         dout => sync
      );


   process(clk)
   begin
      if rising_edge(clk) then
         sync_q <= sync;
      end if;
   end process;


   dout  <= sync;
   pulse <= sync xor sync_q;

end rtl;
