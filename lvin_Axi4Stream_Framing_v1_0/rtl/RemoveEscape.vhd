
--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library IEEE;
   use IEEE.STD_LOGIC_1164.ALL;
   use IEEE.NUMERIC_STD.ALL;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity RemoveEscape is
   Generic(
      g_EscapeByte : std_logic_vector(7 downto 0) := x"00"
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
end entity RemoveEscape;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of RemoveEscape is

   signal Target_TReady_i    : std_logic;
   signal Initiator_TValid_i : std_logic;

   type t_State is (s_RemoveEscape, s_FeedThrough);
   signal State : t_State;

begin

   Target_TReady_i  <= Initiator_TReady;

   Target_TReady    <= Target_TReady_i;
   Initiator_TValid <= Initiator_TValid_i;


   process (AClk, AResetn) is
   begin
      if AResetn = '0' then
         state <= s_RemoveEscape;

      elsif rising_edge(AClk) then
         if Target_TValid = '1' or Target_TReady_i = '1' then
            case state is
               when s_RemoveEscape => 
                  if Target_TData = g_EscapeByte then
                     state <= s_FeedThrough;
                  end if;

               when s_FeedThrough =>
                  state <= s_RemoveEscape;

            end case;

         end if;
      end if;
   end process; 

   Initiator_TValid_i <= Target_TValid when state = s_FeedThrough or Target_TData /= g_EscapeByte else '0';
   Initiator_TData    <= Target_TData;
   Initiator_TLast    <= Target_TLast;

end architecture rtl;
