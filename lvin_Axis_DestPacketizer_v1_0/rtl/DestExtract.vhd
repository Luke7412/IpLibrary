--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : AxisUart
-- File Name      : UartRx.vhd
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
entity DestExtract is
   port (
      -- Clock and reset
      AClk             : in  std_logic;
      AResetn          : in  std_logic;
      -- Axi4-Stream Target interface
      Target_TValid    : in  std_logic;
      Target_TReady    : out std_logic;
      Target_TLast     : in  std_logic;
      Target_TData     : in  std_logic_vector(7 downto 0);
      -- Axi4-Stream Initiator interface
      Initiator_TValid : out std_logic;
      Initiator_TReady : in  std_logic;
      Initiator_TLast  : out std_logic;
      Initiator_TData  : out std_logic_vector(7 downto 0);
      Initiator_TId    : out std_logic_vector(2 downto 0)
   );
end DestExtract;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture RTL of DestExtract is
   
   signal IsFirst            : std_logic;
   
   signal Target_TReady_i    : std_logic;
   signal Initiator_TValid_i : std_logic;

begin

   process (AClk, AResetn) is
   begin
      if AResetn = '0' then
         IsFirst           <= '1';
         Initiator_TId <= (others => '0');
      elsif rising_edge(AClk) then
         if Target_TValid = '1' and Target_TReady_i = '1' then
            IsFirst <= Target_TLast;
            
            if IsFirst = '1' then
               Initiator_TId <= Target_TData(Initiator_TId'range);
            end if;
         end if;
      end if;
   end process;


   Initiator_TValid_i <= '0' when IsFirst = '1' else Target_TValid;
   Target_TReady_i    <= '1' when IsFirst = '1' else Initiator_TReady;
   Initiator_TLast    <= Target_TLast;
   Initiator_TData    <= X"00" when IsFirst = '1' else Target_TData;
   
   Initiator_TValid   <= Initiator_TValid_i;
   Target_TReady      <= Target_TReady_i;

end RTL;