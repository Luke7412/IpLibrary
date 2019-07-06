--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : Identifier
-- File Name      : Identifier.vhd
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

library work;
   use work.ModuleId.Id;
   use work.Functions_pkg.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity Identifier is
   Generic(
      g_AddressWidth : Natural := 32
   );
   Port ( 
      AClk         : in  std_logic;
      AResetn      : in  std_logic;
      
      Ctrl_ARValid : in  std_logic;
      Ctrl_ARReady : out std_logic;
      Ctrl_ARAddr  : in  std_logic_vector(g_AddressWidth-1 downto 0);
      Ctrl_RValid  : out std_logic;
      Ctrl_RReady  : in  std_logic;
      Ctrl_RData   : out std_logic_vector(31 downto 0);
      Ctrl_RResp   : out std_logic_vector(1 downto 0);
      
      Ctrl_AWValid : in  std_logic;
      Ctrl_AWReady : out std_logic;
      Ctrl_AWAddr  : in  std_logic_vector(g_AddressWidth-1 downto 0);
      Ctrl_WValid  : in  std_logic;
      Ctrl_WReady  : out std_logic;
      Ctrl_WData   : in  std_logic_vector(31 downto 0);
      Ctrl_WStrb   : in  std_logic_vector(3 downto 0);
      Ctrl_BValid  : out std_logic;
      Ctrl_BReady  : in  std_logic;
      Ctrl_BResp   : out std_logic_vector(1 downto 0)
   );
end entity Identifier;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of Identifier is

   signal Ctrl_ARReady_i : std_logic;
   signal Ctrl_RValid_i  : std_logic;
   signal Ctrl_AWReady_i : std_logic;
   signal Ctrl_WReady_i  : std_logic;
   signal Ctrl_BValid_i  : std_logic;

begin
   
   Ctrl_ARReady <= Ctrl_ARReady_i;
   Ctrl_RValid  <= Ctrl_RValid_i;
   Ctrl_AWReady <= Ctrl_AWReady_i;
   Ctrl_WReady  <= Ctrl_WReady_i ;
   Ctrl_BValid  <= Ctrl_BValid_i ;


   Ctrl : process(AClk, AResetn) is
      variable Address : std_logic_vector(g_AddressWidth-1 downto 0);
   begin
      if AResetn = '0' then
         Ctrl_RValid_i <= '0';
         Ctrl_BValid_i <= '0';

      elsif rising_edge(AClk) then
         
         -- Read Handshake
         if Ctrl_ARValid = '1' and Ctrl_ARReady_i = '1' then
            Ctrl_RValid_i <= '1';
            Address       := Ctrl_ARAddr;
            case Address is
               when x"00"  => Ctrl_RData <= ext(Id, Ctrl_RData'length);
               when others => Ctrl_RData <= (others => '0');
            end case;

         elsif Ctrl_RValid_i = '1' and Ctrl_RReady = '1' then
            Ctrl_RValid_i <= '0';
         end if;


         -- Write Handshake
         if Ctrl_AWValid = '1' and Ctrl_AWReady_i = '1' and Ctrl_WValid = '1' and Ctrl_WReady_i = '1' then
            Ctrl_BValid_i <= '1';
            Address       := Ctrl_ARAddr;
            case Address is
               when x"00"  => null; -- readonly
               when others => null;
            end case;

         elsif Ctrl_BValid_i = '1' and Ctrl_BReady = '1' then
            Ctrl_BValid_i <= '0';
         end if;

      end if;
   end process;


   Ctrl_ARReady_i <= not Ctrl_RValid_i;
   Ctrl_AWReady_i <= Ctrl_WValid  and not Ctrl_BValid_i;
   Ctrl_WReady_i  <= Ctrl_AWValid and not Ctrl_BValid_i;


end architecture rtl;
