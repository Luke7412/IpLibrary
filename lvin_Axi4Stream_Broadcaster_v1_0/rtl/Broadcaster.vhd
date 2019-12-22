--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : Broadcaster
-- File Name      : Broadcaster.vhd
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
   use IEEE.STD_LOGIC_UNSIGNED.ALL;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity Broadcaster is
   Generic(
      -- Interface parameters
      g_NumByteLanes  : natural  := 1;
      g_UseTKeep      : natural  := 1;
      g_UseTStrb      : natural  := 1;
      g_TUserWidth    : natural  := 0;
      g_TIdWidth      : natural  := 0;
      g_TDestWidth    : natural  := 0;
      -- Others
      g_NofInitiators : positive := 2
   );
   Port (
      -- Clock and Reset
      AClk             : in  std_logic;
      AResetn          : in  std_logic;
      -- Axi4-Stream Target Interface 
      Target_TValid    : in  std_logic;
      Target_TReady    : out std_logic;
      Target_TData     : in  std_logic_vector(8*g_NumByteLanes-1 downto 0)          := (others => '0');
      Target_TStrb     : in  std_logic_vector(g_UseTKeep*g_NumByteLanes-1 downto 0) := (others => '1');
      Target_TKeep     : in  std_logic_vector(g_UseTStrb*g_NumByteLanes-1 downto 0) := (others => '1');
      Target_TUser     : in  std_logic_vector(g_TUserWidth-1 downto 0)              := (others => '0');
      Target_TId       : in  std_logic_vector(g_TIdWidth-1 downto 0)                := (others => '0');
      Target_TDest     : in  std_logic_vector(g_TDestWidth-1 downto 0)              := (others => '0');
      Target_TLast     : in  std_logic                                              := '0';
      -- Axi4-Stream Initiator Interface 
      Initiator_TValid : out std_logic_vector(g_NofInitiators-1 downto 0);
      Initiator_TReady : in  std_logic_vector(g_NofInitiators-1 downto 0)           := (others => '1');
      Initiator_TData  : out std_logic_vector(g_NofInitiators*8*g_NumByteLanes-1 downto 0);
      Initiator_TStrb  : out std_logic_vector(g_NofInitiators*g_UseTKeep*g_NumByteLanes-1 downto 0);
      Initiator_TKeep  : out std_logic_vector(g_NofInitiators*g_UseTStrb*g_NumByteLanes-1 downto 0);
      Initiator_TUser  : out std_logic_vector(g_NofInitiators*g_TUserWidth-1 downto 0);
      Initiator_TId    : out std_logic_vector(g_NofInitiators*g_TIdWidth-1 downto 0);
      Initiator_TDest  : out std_logic_vector(g_NofInitiators*g_TDestWidth-1 downto 0);
      Initiator_TLast  : out std_logic_vector(g_NofInitiators-1 downto 0)            
   );
end entity Broadcaster;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of Broadcaster is

   function duplicate(x: std_logic; count: natural) return std_logic_vector is
      variable y : std_logic_vector(count-1 downto 0);
   begin
      for I in 0 to count-1 loop
         y(I) := x;
      end loop;
      return y;
   end function duplicate;

   function duplicate(x: std_logic_vector; count: natural) return std_logic_vector is
      variable y : std_logic_vector(x'length*count-1 downto 0);
   begin
      for I in 0 to count-1 loop
         y(x'length*(I+1)-1 downto x'length*I) := x;
      end loop;
      return y;
   end function duplicate;

   signal Target_TReady_i    : std_logic;
   signal Initiator_TValid_i : std_logic_vector(Initiator_TValid'range);

begin

   Target_TReady_i  <= '1' when not(Initiator_TReady or not Initiator_TValid_i) = 0 else '0';
   
   Target_TReady    <= Target_TReady_i;
   Initiator_TValid <= Initiator_TValid_i;

   process(AClk, AResetn) is
   begin
      if AResetn = '0' then
         Initiator_TValid_i <= (others => '0');

      elsif rising_edge(AClk) then
         for I in 0 to g_NofInitiators-1 loop
            if Initiator_TValid_i(I) = '1' and Initiator_TReady(I) = '1' then
               Initiator_TValid_i(I) <= '0';
            end if;
         end loop;

         if Target_TValid = '1' and Target_TReady_i = '1' then
            Initiator_TValid_i <= (others => '1');
            Initiator_TData   <= duplicate(Target_TData, g_NofInitiators);
            Initiator_TStrb   <= duplicate(Target_TStrb, g_NofInitiators);
            Initiator_TKeep   <= duplicate(Target_TKeep, g_NofInitiators);
            Initiator_TUser   <= duplicate(Target_TUser, g_NofInitiators);
            Initiator_TId     <= duplicate(Target_TId, g_NofInitiators);
            Initiator_TDest   <= duplicate(Target_TDest, g_NofInitiators);
            Initiator_TLast   <= duplicate(Target_TLast, g_NofInitiators);
         end if;

      end if;
   end process;

end architecture rtl;
