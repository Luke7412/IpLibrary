
--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library IEEE;
   use IEEE.STD_LOGIC_1164.ALL;
   use IEEE.numeric_std.all;

library work;
   use work.ModuleId.Id;
   use work.Functions_pkg.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity Identifier is
   Generic(
      g_Name         : String  := "TEST";
      g_MajorVersion : natural := 1;
      g_MinorVersion : natural := 0
   );
   Port (
      AClk         : in  std_logic;
      AResetn      : in  std_logic;

      Ctrl_ARValid : in  std_logic;
      Ctrl_ARReady : out std_logic;
      Ctrl_ARAddr  : in  std_logic_vector(7 downto 0);
      Ctrl_RValid  : out std_logic;
      Ctrl_RReady  : in  std_logic;
      Ctrl_RData   : out std_logic_vector(31 downto 0);
      Ctrl_RResp   : out std_logic_vector(1 downto 0)
   );
end entity Identifier;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of Identifier is

   function ext_str(str : string; nof_char : natural) return string is
      variable e_str : string(1 to nof_char) := (others => ' ');
   begin
      e_str(str'range) := str;
      return e_str;
   end function;

   function to_slv(str : string) return std_logic_vector is
      alias str_norm : string(str'length downto 1) is str;
      variable slv   : std_logic_vector(8*str'length-1 downto 0);
   begin
      for I in str_norm'range loop
         slv(8*I-1 downto 8*(I-1)) :=
            std_logic_vector(to_unsigned(character'pos(str_norm(I)), 8));
      end loop;
      return slv;
   end function;

   function to_slv(int : natural; length : natural) return std_logic_vector is
   begin
      return std_logic_vector(to_unsigned(int, length));
   end function;

   function Conv_Addr(addr : std_logic_vector) return integer is
   begin
      return to_integer(unsigned(addr(addr'high downto 2) & "00"));
   end function;


   constant c_ExtName : string(1 to 16) := ext_str(g_Name, 16);

   signal Ctrl_ARReady_i : std_logic;
   signal Ctrl_RValid_i  : std_logic;

begin

   Ctrl_ARReady <= Ctrl_ARReady_i;
   Ctrl_RValid  <= Ctrl_RValid_i;


   Ctrl : process(AClk, AResetn) is
   begin
      if AResetn = '0' then
         Ctrl_RValid_i <= '0';

      elsif rising_edge(AClk) then

         -- Read Handshake
         if Ctrl_ARValid = '1' and Ctrl_ARReady_i = '1' then
            Ctrl_RValid_i <= '1';
            case Conv_Addr(Ctrl_ARAddr) is
               when 16#00# => Ctrl_RData <= ext(Id, Ctrl_RData'length);
               when 16#04# => Ctrl_RData <= ext(to_slv(c_ExtName(1 to 4)),   Ctrl_RData'length);
               when 16#08# => Ctrl_RData <= ext(to_slv(c_ExtName(5 to 8)),   Ctrl_RData'length);
               when 16#0C# => Ctrl_RData <= ext(to_slv(c_ExtName(9 to 12)),  Ctrl_RData'length);
               when 16#10# => Ctrl_RData <= ext(to_slv(c_ExtName(13 to 16)), Ctrl_RData'length);
               when 16#14# => Ctrl_RData <= to_slv(g_MajorVersion, Ctrl_RData'length/2) &
                                            to_slv(g_MinorVersion, Ctrl_RData'length/2);

               when others => Ctrl_RData <= (others => '0');
            end case;

         elsif Ctrl_RValid_i = '1' and Ctrl_RReady = '1' then
            Ctrl_RValid_i <= '0';
         end if;

      end if;
   end process;


   Ctrl_ARReady_i <= not Ctrl_RValid_i;


end architecture rtl;
