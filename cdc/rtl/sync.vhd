----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/02/2020 08:17:12 PM
-- Design Name: 
-- Module Name: sync - rtl
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

entity sync is
   port ( 
      clk  : in  std_logic;
      din  : in  std_logic;
      dout : out std_logic
   );
end sync;

architecture rtl of sync is

   signal sync : std_logic_vector(1 downto 0);

begin

   process(clk)
   begin
      if rising_edge(clk) then
         sync <= sync(sync'high-1 downto 0) & din;
      end if;
   end process;

   dout <= sync(sync'high);

end rtl;
