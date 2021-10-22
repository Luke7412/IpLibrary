--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : AxisHandShakeRandomizer
-- File Name      : AxisHandShakeRandomizer.vhd
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


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity AxisHandShakeRandomizer is
   Generic(
      g_MaxWaitTValid : Natural := 5;
      g_MaxWaitTReady : Natural := 5;

      g_NumByteLanes : natural := 1;
      g_UseTKeep     : natural := 1;
      g_UseTStrb     : natural := 1;
      g_TUserWidth   : natural := 0;
      g_TIdWidth     : natural := 0;
      g_TDestWidth   : natural := 0
   );
   Port ( 
      AClk             : in  std_logic;
      AResetn          : in  std_logic;
      
      Target_TValid    : in  std_logic;
      Target_TReady    : out std_logic;
      Target_TData     : in  std_logic_vector(8*g_NumByteLanes-1 downto 0)          := (others => '0');
      Target_TStrb     : in  std_logic_vector(g_UseTKeep*g_NumByteLanes-1 downto 0) := (others => '1');
      Target_TKeep     : in  std_logic_vector(g_UseTStrb*g_NumByteLanes-1 downto 0) := (others => '1');
      Target_TUser     : in  std_logic_vector(g_TUserWidth-1 downto 0)              := (others => '0');
      Target_TId       : in  std_logic_vector(g_TIdWidth-1 downto 0)                := (others => '0');
      Target_TDest     : in  std_logic_vector(g_TDestWidth-1 downto 0)              := (others => '0');
      Target_TLast     : in  std_logic                                             := '1';
      
      Initiator_TValid : out std_logic;
      Initiator_TReady : in  std_logic;
      Initiator_TData  : out std_logic_vector(8*g_NumByteLanes-1 downto 0);
      Initiator_TStrb  : out std_logic_vector(g_UseTKeep*g_NumByteLanes-1 downto 0);
      Initiator_TKeep  : out std_logic_vector(g_UseTStrb*g_NumByteLanes-1 downto 0);
      Initiator_TUser  : out std_logic_vector(g_TUserWidth-1 downto 0);
      Initiator_TId    : out std_logic_vector(g_TIdWidth-1 downto 0);
      Initiator_TDest  : out std_logic_vector(g_TDestWidth-1 downto 0);
      Initiator_TLast  : out std_logic;

      Mode             : in  std_logic_vector(3 downto 0)
   );
end entity AxisHandShakeRandomizer;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of AxisHandShakeRandomizer is

begin
   

    : process(AClk, AResetn) is
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
