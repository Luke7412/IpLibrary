
--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library IEEE;
   use IEEE.STD_LOGIC_1164.ALL;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity Framer is
   Generic(
      g_StartByte : std_logic_vector(7 downto 0) := x"01";
      g_StopByte  : std_logic_vector(7 downto 0) := x"02"
   );
   Port (
      -- Clock and Reset
      AClk             : in  std_logic;
      AResetn          : in  std_logic;
      -- Axi4-Stream Target Interface
      Target_TValid    : in  std_logic;
      Target_TReady    : out std_logic;
      Target_TData     : in  std_logic_vector(7 downto 0) := (others => '0');
      Target_TLast     : in  std_logic;
      -- Axi4-Stream Initiator Interface
      Initiator_TValid : out std_logic;
      Initiator_TReady : in  std_logic;
      Initiator_TData  : out std_logic_vector(7 downto 0)
   );
end entity Framer;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of Framer is

   type t_State is (s_InsertStart, s_Running, s_InsertStop);
   signal State : t_State;

   signal Target_TReady_i    : std_logic;
   signal Initiator_TValid_i : std_logic;

begin
  
   Target_TReady    <= Target_TReady_i;
   Initiator_TValid <= Initiator_TValid_i;

   process(AClk, AResetn) is
   begin
      if AResetn = '0' then
         Initiator_TValid_i <= '0';
         State              <= s_InsertStart;

      elsif rising_edge(AClk) then
         if Initiator_TValid_i = '1' and Initiator_TReady = '1' then
            Initiator_TValid_i <= '0';
         end if;

         case State is
            when s_InsertStart =>
               if Target_TValid = '1' and (Initiator_TValid_i = '0' or Initiator_TReady = '1') then
                  Initiator_TValid_i <= '1';
                  Initiator_TData    <= g_StartByte;
                  State              <= s_Running;
               end if;

            when s_Running =>
               if Target_TValid = '1' and Target_TReady_i = '1' then
                  Initiator_TValid_i <= '1';
                  Initiator_TData <= Target_TData;
                  if Target_TLast = '1' then
                     State <= s_InsertStop;
                  end if;
               end if;

            when s_InsertStop =>
               if Initiator_TValid_i = '1' and Initiator_TReady = '1' then
                  Initiator_TValid_i <= '1';
                  Initiator_TData    <= g_StopByte;
                  State              <= s_InsertStart;
               end if;

         end case;
      end if;
   end process;


   Target_TReady_i <= Initiator_TReady when State = s_Running else '0';

end architecture rtl;
