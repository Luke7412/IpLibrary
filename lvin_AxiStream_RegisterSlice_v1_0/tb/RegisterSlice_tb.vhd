----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/20/2018 08:29:01 PM
-- Design Name: 
-- Module Name: RegSlie_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;


entity RegSlie_tb is
--  Port ( );
end RegSlie_tb;

architecture Behavioral of RegSlie_tb is

    component RegSlice is
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
    end component RegSlice;

    constant NumByteLanes : natural := 1;
    constant UserWidth    : natural := 0;
    constant IdWidth      : natural := 0;
    constant DestWidth    : natural := 0;

    signal Glob_AClk        : std_logic;
    signal Glob_AResetn     : std_logic;
    signal Target_TValid    : std_logic;
    signal Target_TReady    : std_logic;
    signal Target_TData     : std_logic_vector(8*NumByteLanes-1 downto 0)         ;
    signal Target_TStrb     : std_logic_vector(NumByteLanes-1 downto 0)           ;
    signal Target_TKeep     : std_logic_vector(NumByteLanes-1 downto 0)           ;
    signal Target_TUser     : std_logic_vector(UserWidth*NumByteLanes-1 downto 0) ;
    signal Target_TId       : std_logic_vector(IdWidth-1 downto 0)                ;
    signal Target_TDest     : std_logic_vector(DestWidth-1 downto 0)              ;
    signal Target_TLast     : std_logic                                           ;
    signal Initiator_TValid : std_logic;
    signal Initiator_TReady : std_logic;
    signal Initiator_TData  : std_logic_vector(8*NumByteLanes-1 downto 0);
    signal Initiator_TStrb  : std_logic_vector(NumByteLanes-1 downto 0);
    signal Initiator_TKeep  : std_logic_vector(NumByteLanes-1 downto 0);
    signal Initiator_TUser  : std_logic_vector(UserWidth*NumByteLanes-1 downto 0);
    signal Initiator_TId    : std_logic_vector(IdWidth-1 downto 0);
    signal Initiator_TDest  : std_logic_vector(DestWidth-1 downto 0);
    signal Initiator_TLast  : std_logic;


    constant c_PERIOD_200MHZ : time := 5 ns;
    signal Clk_200MHz : std_logic := '1';

begin

    Clk_200MHz <= not Clk_200MHz after c_PERIOD_200MHZ/2;
    Glob_AClk  <= Clk_200MHz;


    DUT : RegSlice
        Port map( 
            Glob_AClk        => Glob_AClk       ,
            Glob_AResetn     => Glob_AResetn    ,
            Target_TValid    => Target_TValid   ,
            Target_TReady    => Target_TReady   ,
            Target_TData     => Target_TData    ,
            Target_TStrb     => Target_TStrb    ,
            Target_TKeep     => Target_TKeep    ,
            Target_TUser     => Target_TUser    ,
            Target_TId       => Target_TId      ,
            Target_TDest     => Target_TDest    ,
            Target_TLast     => Target_TLast    ,
            Initiator_TValid => Initiator_TValid,
            Initiator_TReady => Initiator_TReady,
            Initiator_TData  => Initiator_TData ,
            Initiator_TStrb  => Initiator_TStrb ,
            Initiator_TKeep  => Initiator_TKeep ,
            Initiator_TUser  => Initiator_TUser ,
            Initiator_TId    => Initiator_TId   ,
            Initiator_TDest  => Initiator_TDest ,
            Initiator_TLast  => Initiator_TLast 
        );


    process(Glob_AResetn, Glob_AClk) is
        variable cnt : unsigned(7 downto 0);
    begin
        if Glob_AResetn = '0' then
            Target_TValid <= '0';
            cnt           := (others => '0');

        elsif rising_edge(Glob_AClk) then
            if (Target_TValid = '1' and Target_TReady = '1') or Target_TValid = '0' then
                Target_TValid <= '1';
                Target_TData  <= std_logic_vector(cnt);
                cnt           := cnt + 1;
            end if;
        end if;
    end process;



    process
        procedure WaitCycles(
            constant NofClkCycles : positive
        ) is
        begin
            wait for (NofClkCycles-1)*c_PERIOD_200MHZ;
            wait until rising_edge(Glob_AClk);
        end procedure;

    begin

        Glob_AResetn     <= '0';
        Initiator_TReady <= '0';

        WaitCycles(10);
        Glob_AResetn <= '1';

        WaitCycles(10);
        Initiator_TReady <= '1';


        WaitCycles(10);
        Initiator_TReady <= '0';
        WaitCycles(1);
        Initiator_TReady <= '1'; 


        wait;
    end process;

end Behavioral;
