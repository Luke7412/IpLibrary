
--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library IEEE;
   use IEEE.STD_LOGIC_1164.ALL;
   use IEEE.NUMERIC_STD.ALL;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity InsertEscape is
   Generic(
      g_EscapeByte : std_logic_vector(7 downto 0) := x"00";
      g_StartByte  : std_logic_vector(7 downto 0) := x"01";
      g_StopByte   : std_logic_vector(7 downto 0) := x"02"
   );
   Port (
      -- Clock and Reset
      AClk             : in  std_logic;
      AResetn          : in  std_logic;
      -- Axi4Stream Target Interface
      Target_TValid    : in  std_logic;
      Target_TReady    : out std_logic;
      Target_TData     : in  std_logic_vector(7 downto 0);
      Target_TLast     : in  std_logic;
      -- Axi4Stream Initiator Interface
      Initiator_TValid : out std_logic;
      Initiator_TReady : in  std_logic;
      Initiator_TData  : out std_logic_vector(7 downto 0);
      Initiator_TLast  : out std_logic
   );
end entity InsertEscape;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture RTL of InsertEscape is
   
   signal Match              : boolean;
   signal IsFromPacket       : boolean;
   signal IsToPacket         : boolean;
   
   signal Insert_TValid      : std_logic;
   signal Insert_TReady      : std_logic;
   
   signal Target_TReady_i    : std_logic;
   signal Initiator_TValid_i : std_logic;

begin

   Match <= (Target_TData = g_StartByte or Target_TData = g_StopByte or Target_TData = g_EscapeByte);


   RegProc : process (AClk, AResetn)
   begin
      if AResetn = '0' then
         IsFromPacket  <= True;
      elsif rising_edge(AClk) then
         if Target_TValid = '1' and Target_TReady_i = '1' then
            IsFromPacket <= True;
         end if;
         if Insert_TValid = '1' and Insert_TReady = '1' then
            IsFromPacket <= False;
         end if;
      end if;
   end process RegProc;


   -- Identify bytes to escape
   CombProc : process (Target_TValid, Match)
   begin
      IsToPacket <= False;
      if Target_TValid = '1' then
         if Match then
            IsToPacket <= True;
         end if;
      end if;
   end process CombProc;


   -- Make Insert packet when the transition of packets is found
   Insert_TValid <= '1' when IsFromPacket and IsToPacket else '0';
 
   -- Mux packet, priority goes to Insert
   Initiator_TValid_i <= Target_TValid or Insert_TValid;
   Initiator_TData    <= g_EscapeByte when Insert_TValid = '1' else Target_TData;
   Initiator_TLast    <= '0'          when Insert_TValid = '1' else Target_TLast;
   
   -- Demux TReady, priority goes to Insert
   Insert_TReady      <= Initiator_TReady  when Insert_TValid = '1' else '0';
   Target_TReady_i    <= '0'               when Insert_TValid = '1' else Initiator_TReady;
   
   -- Internal version of output signals
   Target_TReady      <= Target_TReady_i;
   Initiator_TValid   <= Initiator_TValid_i;

end RTL;