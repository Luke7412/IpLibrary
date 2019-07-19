--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : Framing
-- File Name      : InsertEscape.vhd
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
   use IEEE.NUMERIC_STD.ALL;
   use ieee.math_real.all;


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
--architecture rtl of InsertEscape is

--   type t_State is (s_InsertEscape, s_FeedThrough);
--   signal State : t_State;

--   signal Target_TReady_i    : std_logic;
--   signal Initiator_TValid_i : std_logic;

--   signal Match : boolean;

--begin
   
--   Target_TReady    <= Target_TReady_i;
--   Initiator_TValid <= Initiator_TValid_i;

--   process (AClk, AResetn) is
--   begin
--      if AResetn = '0' then
--         Initiator_TValid_i <= '0';
--         state              <= s_InsertEscape;

--      elsif rising_edge(AClk) then
--         if Initiator_TValid_i = '1' and Initiator_TReady = '1' then
--            Initiator_TValid_i <= '0';
--         end if;


--         case state is
--            when s_InsertEscape => 

--               if Target_TValid = '1' then
--                  if Match then
--                     Initiator_TValid_i <= '1';
--                     Initiator_TData    <= g_EscapeByte;
--                     Initiator_TLast    <= '0';
--                     state              <= s_FeedThrough;
--                  elsif Target_TReady_i = '1' then
--                     Initiator_TValid_i <= '1';
--                     Initiator_TData    <= Target_TData;
--                     Initiator_TLast    <= Target_TLast;
--                  end if;
--               end if;

--            when s_FeedThrough =>
--               if Target_TValid = '1' and Target_TReady_i = '1' then
--                  Initiator_TValid_i <= '1';
--                  Initiator_TData    <= Target_TData;
--                  Initiator_TLast    <= Target_TLast;
--                  state              <= s_InsertEscape;
--               end if;

--         end case;

--      end if;
--   end process; 


--   Match <= (Target_TData = g_StartByte or Target_TData = g_StopByte or Target_TData = g_EscapeByte);

--   Target_TReady_i <= Initiator_TReady or not Initiator_TValid_i;
    
--end architecture rtl;



architecture rtl of InsertEscape is

   type t_State is (s_InsertEscape, s_FeedThrough);
   signal State : t_State;

   signal Target_TReady_i    : std_logic;
   signal Initiator_TValid_i : std_logic;

   signal Match : boolean;

begin
   
   Target_TReady    <= Target_TReady_i;
   Initiator_TValid <= Initiator_TValid_i;

   process (AClk, AResetn) is
   begin
      if AResetn = '0' then
         state              <= s_InsertEscape;

      elsif rising_edge(AClk) then
         case state is
            when s_InsertEscape => 
               if Initiator_TValid_i = '1' and Initiator_TReady = '1' then
                  if Match then
                     State <= s_FeedThrough;
                  end if;
               end if;

            when s_FeedThrough =>
               if Initiator_TValid_i = '1' and Initiator_TReady = '1' then
                  State <= s_InsertEscape;
               end if;

         end case;

      end if;
   end process; 


   Match <= (Target_TData = g_StartByte or Target_TData = g_StopByte or Target_TData = g_EscapeByte);
   
   Target_TReady_i    <= '0'          when Match and State = s_InsertEscape else Initiator_TReady;
   Initiator_TValid_i <= '1'          when Match and State = s_InsertEscape else Target_TValid;
   Initiator_TData    <= g_EscapeByte when Match and State = s_InsertEscape else Target_TData;
   Initiator_TLast    <= '0'          when Match and State = s_InsertEscape else Target_TLast;

end architecture rtl;