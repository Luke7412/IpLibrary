--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : RegisterSlice
-- File Name      : RegisterSlice.vhd
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
entity RegisterSlice is
   Generic(
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
      Target_TLast     : in  std_logic                                              := '1';
      Initiator_TValid : out std_logic;
      Initiator_TReady : in  std_logic;
      Initiator_TData  : out std_logic_vector(8*g_NumByteLanes-1 downto 0);
      Initiator_TStrb  : out std_logic_vector(g_UseTKeep*g_NumByteLanes-1 downto 0);
      Initiator_TKeep  : out std_logic_vector(g_UseTStrb*g_NumByteLanes-1 downto 0);
      Initiator_TUser  : out std_logic_vector(g_TUserWidth-1 downto 0);
      Initiator_TId    : out std_logic_vector(g_TIdWidth-1 downto 0);
      Initiator_TDest  : out std_logic_vector(g_TDestWidth-1 downto 0);
      Initiator_TLast  : out std_logic
   );
   begin
      assert g_UseTKeep = 0 or g_UseTKeep = 1
         report "g_UseTKeep Must be 0 or 1."
         severity failure;
      assert g_UseTStrb = 0 or g_UseTStrb = 1
         report "g_UseTStrb Must be 0 or 1."
         severity failure;
end entity RegisterSlice;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of RegisterSlice is

   signal Initiator_TValid_i : std_logic;
   signal Target_TReady_i    : std_logic;
   
   signal Reg_TValid : std_logic;
   signal Reg_TData  : std_logic_vector(8*g_NumByteLanes-1 downto 0);
   signal Reg_TStrb  : std_logic_vector(g_NumByteLanes-1 downto 0);
   signal Reg_TKeep  : std_logic_vector(g_NumByteLanes-1 downto 0);
   signal Reg_TUser  : std_logic_vector(g_TUserWidth-1 downto 0);
   signal Reg_TId    : std_logic_vector(g_TIdWidth-1 downto 0);
   signal Reg_TDest  : std_logic_vector(g_TDestWidth-1 downto 0);
   signal Reg_TLast  : std_logic;

begin

   Target_TReady_i  <= not Reg_TValid;

   Initiator_TValid <= Initiator_TValid_i;
   Target_TReady    <= Target_TReady_i;


   process(AClk, AResetn) is
   begin
      if AResetn = '0' then
         Initiator_TValid_i <= '0';
         Reg_TValid         <= '0';

      elsif rising_edge(AClk) then

         if Initiator_TValid_i = '1' and Initiator_TReady = '1' then
            Reg_TValid         <= '0';
            Initiator_TValid_i <= Reg_TValid;
            Initiator_TData    <= Reg_TData;
            Initiator_TStrb    <= Reg_TStrb;
            Initiator_TKeep    <= Reg_TKeep;
            Initiator_TUser    <= Reg_TUser;
            Initiator_TId      <= Reg_TId  ;
            Initiator_TDest    <= Reg_TDest;
            Initiator_TLast    <= Reg_TLast;
         end if;

         if Target_TValid = '1' and Target_TReady_i = '1' then
            --if (Initiator_TValid_i = '1' and Initiator_TReady = '1') or Initiator_TValid_i = '0' then
            if Initiator_TReady = '1' or Initiator_TValid_i = '0' then
               Initiator_TValid_i <= Target_TValid;
               Initiator_TData    <= Target_TData;
               Initiator_TStrb    <= Target_TStrb;
               Initiator_TKeep    <= Target_TKeep;
               Initiator_TUser    <= Target_TUser;
               Initiator_TId      <= Target_TId  ;
               Initiator_TDest    <= Target_TDest;
               Initiator_TLast    <= Target_TLast;
            else
               Reg_TValid <= Target_TValid;
               Reg_TData  <= Target_TData;
               Reg_TStrb  <= Target_TStrb;
               Reg_TKeep  <= Target_TKeep;
               Reg_TUser  <= Target_TUser;
               Reg_TId    <= Target_TId  ;
               Reg_TDest  <= Target_TDest;
               Reg_TLast  <= Target_TLast;
            end if;
         end if;

      end if;
   end process;


end architecture rtl;
