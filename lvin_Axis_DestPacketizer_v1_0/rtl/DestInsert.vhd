--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : DestInsert
-- File Name      : DestInsert.vhd
--------------------------------------------------------------------------------
-- Author         : Lukas Vinkx
-- Description: 
-- 
-- 
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library ieee;
   use ieee.std_logic_1164.all;
   use ieee.std_logic_unsigned.all;
   use ieee.std_logic_arith.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity DestInsert is
   port (
      -- Clock and Reset
      AClk             : in  std_logic;
      AResetn          : in  std_logic;
      -- Axi4-Stream Target interface
      Target_TValid    : in  std_logic;
      Target_TReady    : out std_logic;
      Target_TLast     : in  std_logic;
      Target_TData     : in  std_logic_vector(7 downto 0);
      Target_TId       : in  std_logic_vector(2 downto 0);
      -- Axi4-Stream Initiator interface
      Initiator_TValid : out std_logic;
      Initiator_TReady : in  std_logic;
      Initiator_TLast  : out std_logic;
      Initiator_TData  : out std_logic_vector(7 downto 0)
   );
end DestInsert;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture RTL of DestInsert is

   signal IsFirst : std_logic;

   type t_State is (Feedthrough, InsertId);
   signal State              : t_State;
   signal NextState          : t_State;
   signal Target_TReady_i    : std_logic;
   signal Initiator_TValid_i : std_logic;

begin

   RegProc : process (AClk, AResetn) is
   begin
      if AResetn = '0' then
         IsFirst   <= '1';
         State <= Feedthrough;
      elsif rising_edge(AClk) then
         if Target_TValid = '1' and Target_TReady_i = '1' then
            IsFirst <= Target_TLast;
         end if;
         if Initiator_TValid_i = '1' and Initiator_TReady = '1' then
            State <= NextState;
         end if;
      end if;
   end process RegProc;


   CtrlProc : process(State, Target_TValid, Target_TData, IsFirst)
   begin
      NextState <= State;
      case State is
         when Feedthrough =>
            if Target_TValid = '1' and IsFirst = '1' then
               NextState <= InsertId;
            end if;

         when InsertId =>
            NextState <= Feedthrough;

         when others => null;

      end case;
   end process CtrlProc;


   Initiator_TValid_i <= '1' when NextState = InsertId else Target_TValid;
   Target_TReady_i    <= '0' when NextState = InsertId else Initiator_TReady;
   Initiator_TLast    <= '0' when NextState = InsertId else Target_TLast;
   Initiator_TData    <= ext(Target_TId, Initiator_TData'length) when NextState = InsertId else Target_TData;
   
   Initiator_TValid   <= Initiator_TValid_i;
   Target_TReady      <= Target_TReady_i;

end RTL;