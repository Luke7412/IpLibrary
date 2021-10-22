
--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library IEEE;
   use IEEE.STD_LOGIC_1164.ALL;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity DeFramer is
   Generic(
      g_EscapeByte : std_logic_vector(7 downto 0) := x"00";
      g_StartByte  : std_logic_vector(7 downto 0) := x"01";
      g_StopByte   : std_logic_vector(7 downto 0) := x"02"
   );
   Port ( 
      -- Clock and Reset
      AClk             : in  std_logic;
      AResetn          : in  std_logic;
      -- Axi4-Stream Target Interface
      Target_TValid    : in  std_logic;
      Target_TReady    : out std_logic;
      Target_TData     : in  std_logic_vector(7 downto 0);
      -- Axi4-Stream Initiator Interface
      Initiator_TValid : out std_logic;
      Initiator_TReady : in  std_logic;
      Initiator_TData  : out std_logic_vector(7 downto 0) := (others => '0');
      Initiator_TLast  : out std_logic
   );
end entity DeFramer;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of DeFramer is

   type t_State is (s_RemoveStart, s_Running);
   signal State : t_State;

   signal Target_TReady_i    : std_logic;
   signal Initiator_TValid_i : std_logic;

   signal Reg_TValid   : std_logic;
   signal Reg_TData    : std_logic_vector(7 downto 0);
   signal Reg_IsEscape : boolean;

begin
   
   Target_TReady    <= Target_TReady_i;
   Initiator_TValid <= Initiator_TValid_i;

   process(AClk, AResetn) is
   begin
      if AResetn = '0' then
         Initiator_TValid_i <= '0';
         Reg_TValid         <= '0';
         State              <= s_RemoveStart;

      elsif rising_edge(AClk) then
         if Initiator_TValid_i = '0' or Initiator_TReady = '1' then
            Initiator_TValid_i <= '0';
         end if;
         
         if Target_TValid = '1' and Target_TReady_i = '1' then
            Reg_TData          <= Target_TData;
            Initiator_TValid_i <= Reg_TValid;
            Initiator_TData    <= Reg_TData;

            case State is
               when s_RemoveStart =>
                  Reg_IsEscape       <= False;
                  if Target_TData = g_StartByte then
                     State <= s_Running;
                  end if;

               when s_Running =>
                  
                  if Target_TData = g_EscapeByte then
                     Reg_IsEscape <= not Reg_IsEscape;
                  else
                     Reg_IsEscape <= False;
                  end if;

                  if Target_TData = g_StopByte and not Reg_IsEscape then
                     Reg_TValid      <= '0';
                     Initiator_TLast <= '1';
                     State           <= s_RemoveStart;
                  else
                     Reg_TValid      <= '1';
                     Initiator_TLast <= '0';
                  end if;

            end case;

         end if;
      end if;
   end process;


   Target_TReady_i <= Initiator_TReady or not Initiator_TValid_i; 

end architecture rtl;
