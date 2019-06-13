----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/20/2018 08:17:36 PM
-- Design Name: 
-- Module Name: RegSlice - rtl
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;

entity RegSlice is
    Generic(
        NumByteLanes : natural := 1;
        UserWidth    : natural := 0;
        IdWidth      : natural := 0;
        DestWidth    : natural := 0
    );
    Port ( 
        Glob_AClk        : in  std_logic;
        Glob_AResetn     : in  std_logic;
        Target_TValid    : in  std_logic;
        Target_TReady    : out std_logic;
        Target_TData     : in  std_logic_vector(8*NumByteLanes-1 downto 0)         := (others => '0');
        Target_TStrb     : in  std_logic_vector(NumByteLanes-1 downto 0)           := (others => '1');
        Target_TKeep     : in  std_logic_vector(NumByteLanes-1 downto 0)           := (others => '1');
        Target_TUser     : in  std_logic_vector(UserWidth*NumByteLanes-1 downto 0) := (others => '0');
        Target_TId       : in  std_logic_vector(IdWidth-1 downto 0)                := (others => '0');
        Target_TDest     : in  std_logic_vector(DestWidth-1 downto 0)              := (others => '0');
        Target_TLast     : in  std_logic                                           := '1';
        Initiator_TValid : out std_logic;
        Initiator_TReady : in  std_logic;
        Initiator_TData  : out std_logic_vector(8*NumByteLanes-1 downto 0);
        Initiator_TStrb  : out std_logic_vector(NumByteLanes-1 downto 0);
        Initiator_TKeep  : out std_logic_vector(NumByteLanes-1 downto 0);
        Initiator_TUser  : out std_logic_vector(UserWidth*NumByteLanes-1 downto 0);
        Initiator_TId    : out std_logic_vector(IdWidth-1 downto 0);
        Initiator_TDest  : out std_logic_vector(DestWidth-1 downto 0);
        Initiator_TLast  : out std_logic
    );
end RegSlice;

architecture rtl of RegSlice is

    signal Initiator_TValid_i : std_logic;
    signal Target_TReady_i    : std_logic;
    
    signal Reg_Resetn         : std_logic;
    signal Reg_TValid         : std_logic;
    signal Reg_TData          : std_logic_vector(8*NumByteLanes-1 downto 0);
    signal Reg_TStrb          : std_logic_vector(NumByteLanes-1 downto 0);
    signal Reg_TKeep          : std_logic_vector(NumByteLanes-1 downto 0);
    signal Reg_TUser          : std_logic_vector(UserWidth*NumByteLanes-1 downto 0);
    signal Reg_TId            : std_logic_vector(IdWidth-1 downto 0);
    signal Reg_TDest          : std_logic_vector(DestWidth-1 downto 0);
    signal Reg_TLast          : std_logic;

begin

    Target_TReady_i <= not Reg_TValid and Reg_Resetn;

    Initiator_TValid <= Initiator_TValid_i;
    Target_TReady    <= Target_TReady_i;


    process(Glob_AClk, Glob_AResetn) is
    begin

        if Glob_AResetn = '0' then
            Initiator_TValid_i <= '0';
            Reg_TValid         <= '0';
            Reg_Resetn         <= '0';

        elsif rising_edge(Glob_AClk) then
            Reg_Resetn <= '1';

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
                if (Initiator_TValid_i = '1' and Initiator_TReady = '1') or Initiator_TValid_i = '0' then
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


end rtl;
