
--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library IEEE;
    use IEEE.STD_LOGIC_1164.ALL;


--------------------------------------------------------------------------------
-- ENTITYT
--------------------------------------------------------------------------------
entity PRBS is
    generic (
        CHK_MODE    : boolean                := false; 
        POLY_LENGTH : natural range 2 to 63  := 7;
        POLY_TAP    : natural range 1 to 62  := 6;
        TDATA_WIDTH : natural range 2 to 512 := 8
    );
    Port ( 
        AClk     : in  std_logic;
        AResetn  : in  std_logic;
        -- AXI4-Stream target
        S_TValid : in  std_logic                                := '0';
        S_TReady : out std_logic;
        S_TData  : in  std_logic_vector(TDATA_WIDTH-1 downto 0) := (others => '0');
        -- AXI4-Stream initiator
        M_TValid : out std_logic;
        M_TReady : in  std_logic;
        M_TData  : out std_logic_vector(TDATA_WIDTH-1 downto 0)
    );
begin
    --synthesis translate_off 
    assert POLY_LENGTH < 64       report "Poly lenght must be smaller than 64" severity failure;
    assert POLY_TAP < POLY_LENGTH report "Poly tap must be smaller than poly length" severity failure;
    assert TDATA_WIDTH <= 512     report "Tdata width to large. Range [0..512]" severity failure;
    --synthesis translate_on
end PRBS;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of PRBS is

    type prbs_type is array (NBITS downto 0) of std_logic_vector(1 to POLY_LENGTH);
    signal prbs : prbs_type := (others => (others => '1'));

    signal DataIn_i   : std_logic_vector(NBITS-1 downto 0);    
    signal prbs_xor_a : std_logic_vector(NBITS-1 downto 0);                                                  
    signal prbs_xor_b : std_logic_vector(NBITS-1 downto 0);                                                 
    signal prbs_msb   : std_logic_vector(NBITS downto 1); 
    
    signal S_TReady_i : std_logic;
    signal M_TValid_i : std_logic;

begin

    gen_polygon : for I in 0 to NBITS-1 generate            
        prbs_xor_a(I) <= prbs(I)(POLY_TAP) xor prbs(I)(POLY_LENGTH);
        prbs_xor_b(I) <= prbs_xor_a(I) xor S_TData(I);      
        prbs_msb(I+1) <= prbs_xor_a(I) when CHK_MODE = false else S_TData(I);        
        prbs(I+1)     <= prbs_msb(I+1) & prbs(I)(1 to POLY_LENGTH-1);      
    end generate;
        

    proc_prbs_calc: process(AClk, AResetn) is
    begin
        if AResetn = '0' then
            M_TValid_i <= '0';
            M_TData    <= (others => '1');
            prbs(0)    <= (others => '1');

        elsif rising_edge(Glob_AClk) then
            if S_TValid = '1' and S_TReady_i = '1' then
                M_TValid_i <= '1';
                M_TData    <= prbs_xor_b;
                prbs(0)    <= prbs(NBITS);
            elsif M_TValid_i = '1' and M_TReady = '1' then
                M_TValid_i <= '0';
            end if;

        end if;
    end process;


    S_TReady_i <= (M_TValid_i and M_TReady) or not M_TValid_i;
    S_TReady   <= S_TReady_i;
    M_TValid   <= M_TValid_i;

end rtl;
