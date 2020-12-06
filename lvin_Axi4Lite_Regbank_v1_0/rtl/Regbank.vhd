--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : Regbank
-- File Name      : Regbank.vhd
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
   use IEEE.numeric_std.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity Regbank is
   Generic (
      g_NofRegOut : natural := 4;
      g_NofRegIn  : natural := 4
   );
   Port ( 
      AClk         : in  std_logic;
      AResetn      : in  std_logic;
      
      Ctrl_ARValid : in  std_logic;
      Ctrl_ARReady : out std_logic;
      Ctrl_ARAddr  : in  std_logic_vector(11 downto 0);
      Ctrl_RValid  : out std_logic;
      Ctrl_RReady  : in  std_logic;
      Ctrl_RData   : out std_logic_vector(31 downto 0);
      Ctrl_RResp   : out std_logic_vector(1 downto 0);
      Ctrl_AWValid : in  std_logic;
      Ctrl_AWReady : out std_logic;
      Ctrl_AWAddr  : in  std_logic_vector(11 downto 0);
      Ctrl_WValid  : in  std_logic;
      Ctrl_WReady  : out std_logic;
      Ctrl_WData   : in  std_logic_vector(31 downto 0);
      Ctrl_WStrb   : in  std_logic_vector(3 downto 0);
      Ctrl_BValid  : out std_logic;
      Ctrl_BReady  : in  std_logic;
      Ctrl_BResp   : out std_logic_vector(1 downto 0);
      
      Reg_Out      : out std_logic_vector(32*g_NofRegOut-1 downto 0); 
      Reg_In       : in  std_logic_vector(32*g_NofRegIn-1  downto 0) := (others => '0')
   );
end entity Regbank;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of Regbank is

   type t_RegArr is array (integer range <>) of std_logic_vector(31 downto 0);
   signal RegArr_Out : t_RegArr(0 to g_NofRegOut-1);
   signal RegArr_In  : t_RegArr(0 to g_NofRegIn-1) ;

   signal Ctrl_ARReady_i : std_logic;
   signal Ctrl_RValid_i  : std_logic;
   signal Ctrl_AWReady_i : std_logic;
   signal Ctrl_WReady_i  : std_logic;
   signal Ctrl_BValid_i  : std_logic;

   procedure update_reg( 
      signal reg : inout std_logic_vector
   ) is
   begin
      for I in Ctrl_WStrb'range loop
         if Ctrl_WStrb(I) = '1' then
            reg(8*(I+1)-1 downto 8*I) <= Ctrl_WData(8*(I+1)-1 downto 8*I);
         end if;
      end loop;
   end procedure;

begin

   gen_RegOut : for I in 0 to g_NofRegOut-1 generate
   begin
      Reg_Out(32*(I+1)-1 downto 32*I) <= RegArr_Out(I);
   end generate;

   gen_RegIn : for I in 0 to g_NofRegIn-1 generate
   begin
      RegArr_In(I) <= Reg_In(32*(I+1)-1 downto 32*I);
   end generate;


   Ctrl : process(AClk, AResetn) is
      variable Address : unsigned(9 downto 0);
   begin
      if AResetn = '0' then
         Ctrl_RValid_i <= '0';
         Ctrl_BValid_i <= '0';

         RegArr_Out <= (others => (others => '0'));

      elsif rising_edge(AClk) then
         
         -- Read Handshake
         if Ctrl_ARValid = '1' and Ctrl_ARReady_i = '1' then
            Ctrl_RValid_i <= '1';
            Address       := unsigned(Ctrl_ARAddr(11 downto 2));
            if Address < 16 then
               case Address(3 downto 0) is
                  when x"0"   => Ctrl_RData <= x"DEADBEEF";
                  when others => Ctrl_RData <= (others => '0');
               end case;
            elsif Address(0) = '0' then               
               Ctrl_RData <= RegArr_Out(to_integer(Address));
            else
               Ctrl_RData <= RegArr_In(to_integer(Address));
            end if;

         elsif Ctrl_RValid_i = '1' and Ctrl_RReady = '1' then
            Ctrl_RValid_i <= '0';
         end if;


         -- Write Handshake
         if Ctrl_AWValid = '1' and Ctrl_AWReady_i = '1' and Ctrl_WValid = '1' and Ctrl_WReady_i = '1' then
            Ctrl_BValid_i      <= '1';
            Address            := unsigned(Ctrl_AWAddr(11 downto 2));

            if Address < 16 then
               case Address(3 downto 0) is
                  when x"0"   => null; -- Read only
                  when others => null; -- Read only
               end case;
               
            elsif Address(0) = '0' then               
               RegArr_Out(to_integer(Address)) <= Ctrl_WData;
            end if;

         elsif Ctrl_BValid_i = '1' and Ctrl_BReady = '1' then
            Ctrl_BValid_i <= '0';
         end if;

      end if;
   end process;


   Ctrl_ARReady_i <= not Ctrl_RValid_i;
   Ctrl_AWReady_i <= Ctrl_WValid  and not Ctrl_BValid_i;
   Ctrl_WReady_i  <= Ctrl_AWValid and not Ctrl_BValid_i;
   
   Ctrl_ARReady   <= Ctrl_ARReady_i;
   Ctrl_RValid    <= Ctrl_RValid_i;
   Ctrl_AWReady   <= Ctrl_AWReady_i;
   Ctrl_WReady    <= Ctrl_WReady_i ;
   Ctrl_BValid    <= Ctrl_BValid_i ;

end architecture rtl;
