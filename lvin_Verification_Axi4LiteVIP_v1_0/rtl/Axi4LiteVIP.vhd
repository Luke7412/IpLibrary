--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : Axi4LiteVIP
-- File Name      : Axi4LiteVIP.vhd
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
   use IEEE.STD_LOGIC_ARITH.ALL;

library lvin_Verification_Axi4LiteIntf_v1_0;
   use lvin_Verification_Axi4LiteIntf_v1_0.Axi4LiteIntf_pkg.all;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity Axi4LiteVIP is
   Generic (
      IntfIndex : natural := 0;
      AddrWidth : natural := 32;
      Mode      : string  := "Passthrough"  -- "Master", "Passthrough"
   );
   Port (
      -- Clock and Reset
      AClk           : in  std_logic;
      AResetn        : in  std_logic;
      -- Axi4Stream Slave Interface
      Slave_ARValid  : in  std_logic                              := '0';
      Slave_ARReady  : out std_logic;
      Slave_ARAddr   : in  std_logic_vector(AddrWidth-1 downto 0) := (others => '0');
      Slave_ARProt   : in  std_logic_vector(2 downto 0)           := (others => '0');
      Slave_RValid   : out std_logic;
      Slave_RReady   : in  std_logic                              := '0';
      Slave_RData    : out std_logic_vector(31 downto 0);
      Slave_RResp    : out std_logic_vector(1 downto 0);
      Slave_AWValid  : in  std_logic                              := '0';
      Slave_AWReady  : out std_logic;
      Slave_AWAddr   : in  std_logic_vector(AddrWidth-1 downto 0) := (others => '0');
      Slave_AWProt   : in  std_logic_vector(2 downto 0)           := (others => '0');
      Slave_WValid   : in  std_logic                              := '0';
      Slave_WReady   : out std_logic;
      Slave_WData    : in  std_logic_vector(31 downto 0)          := (others => '0');
      Slave_WStrb    : in  std_logic_vector(3 downto 0)           := (others => '0');
      Slave_BValid   : out std_logic;
      Slave_BReady   : in  std_logic                              := '0';
      Slave_BResp    : out std_logic_vector(1 downto 0);
      -- Axi4Stream Master Interface
      Master_ARValid : out std_logic;
      Master_ARReady : in  std_logic;
      Master_ARAddr  : out std_logic_vector(AddrWidth-1 downto 0);
      Master_ARProt  : out std_logic_vector(2 downto 0);
      Master_RValid  : in  std_logic;
      Master_RReady  : out std_logic;
      Master_RData   : in  std_logic_vector(31 downto 0);
      Master_RResp   : in  std_logic_vector(1 downto 0);
      Master_AWValid : out std_logic;
      Master_AWReady : in  std_logic;
      Master_AWAddr  : out std_logic_vector(AddrWidth-1 downto 0);
      Master_AWProt  : out std_logic_vector(2 downto 0);
      Master_WValid  : out std_logic;
      Master_WReady  : in  std_logic;
      Master_WData   : out std_logic_vector(31 downto 0);
      Master_WStrb   : out std_logic_vector(3 downto 0);
      Master_BValid  : in  std_logic;
      Master_BReady  : out std_logic;
      Master_BResp   : in  std_logic_vector(1 downto 0)           
   );
   constant MaxNofIntf : natural := lvin_Verification_Axi4LiteIntf_v1_0.Axi4LiteIntf_pkg.nofIntfs;
begin
   -- synthesis translate_off
   assert IntfIndex < MaxNofIntf
      report "IntfIndex must be smaller than " & integer'image(MaxNofIntf)
      severity failure;
   -- synthesis translate_on
end entity Axi4LiteVIP;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of Axi4LiteVIP is

   constant Simulation : boolean := false
                                 -- synthesis translate_off
                                 or true
                                 -- synthesis translate_on
;

   alias Ctrl : t_Axi4LiteIntf is lvin_Verification_Axi4LiteIntf_v1_0.Axi4LiteIntf_pkg.Axi4LiteIntfArray(IntfIndex);

begin

   gen_Simulation : if Simulation generate
      type t_state is (s_IDLE, s_SLAVE, s_CTRL);
      signal state : t_state;
   begin

      process(AClk, AResetn)
      begin
         if AResetn = '0' then
            state <= s_IDLE;

         elsif rising_edge(AClk) then
            case state is
               when s_IDLE =>
                  if Ctrl.ARValid = '1' or Ctrl.AWValid = '1' or Ctrl.WValid = '1' then
                     state <= s_CTRL;
                  elsif Slave_ARValid = '1' or Slave_AWValid = '1' or Slave_WValid = '1' then
                     state <= s_SLAVE;
                  end if;

               when s_CTRL =>
                  if (Master_RValid = '1' and Ctrl.RReady = '1') or 
                     (Master_BValid = '1' and Ctrl.BReady = '1') then
                     state <= s_IDLE;
                  end if;

               when s_SLAVE =>
                  if (Master_RValid = '1' and Slave_RReady = '1') or 
                     (Master_BValid = '1' and Slave_BReady = '1') then
                     state <= s_IDLE;
                  end if;

            end case;
         end if;
      end process;


      Ctrl.AClk      <= AClk;
      Ctrl.AResetn   <= AResetn;

      Master_ARValid <= Slave_ARValid  when state = s_SLAVE else Ctrl.ARValid                when state = s_CTRL else '0';
      Master_ARAddr  <= Slave_ARAddr   when state = s_SLAVE else ext(Ctrl.ARAddr, AddrWidth) when state = s_CTRL else (others => '0');
      Master_ARProt  <= Slave_ARProt   when state = s_SLAVE else Ctrl.ARProt                 when state = s_CTRL else (others => '0');
      Master_RReady  <= Slave_RReady   when state = s_SLAVE else Ctrl.RReady                 when state = s_CTRL else '0';
      Master_AWValid <= Slave_AWValid  when state = s_SLAVE else Ctrl.AWValid                when state = s_CTRL else '0';
      Master_AWAddr  <= Slave_AWAddr   when state = s_SLAVE else ext(Ctrl.AWAddr, AddrWidth) when state = s_CTRL else (others => '0');
      Master_AWProt  <= Slave_AWProt   when state = s_SLAVE else Ctrl.AWProt                 when state = s_CTRL else (others => '0');
      Master_WValid  <= Slave_WValid   when state = s_SLAVE else Ctrl.WValid                 when state = s_CTRL else '0';
      Master_WData   <= Slave_WData    when state = s_SLAVE else Ctrl.WData                  when state = s_CTRL else (others => '0');
      Master_WStrb   <= Slave_WStrb    when state = s_SLAVE else Ctrl.WStrb                  when state = s_CTRL else (others => '0');
      Master_BReady  <= Slave_BReady   when state = s_SLAVE else Ctrl.BReady                 when state = s_CTRL else '0';
      
      Ctrl.ARReady   <= Master_ARReady when state = s_CTRL else '0';
      Ctrl.RValid    <= Master_RValid  when state = s_CTRL else '0';
      Ctrl.RData     <= Master_RData   when state = s_CTRL else (others => '0');
      Ctrl.RResp     <= Master_RResp   when state = s_CTRL else (others => '0');
      Ctrl.AWReady   <= Master_AWReady when state = s_CTRL else '0';
      Ctrl.WReady    <= Master_WReady  when state = s_CTRL else '0';
      Ctrl.BValid    <= Master_BValid  when state = s_CTRL else '0';
      Ctrl.BResp     <= Master_BResp   when state = s_CTRL else (others => '0');

      Slave_ARReady  <= Master_ARReady when state = s_SLAVE else '0';
      Slave_RValid   <= Master_RValid  when state = s_SLAVE else '0';
      Slave_RData    <= Master_RData   when state = s_SLAVE else (others => '0');
      Slave_RResp    <= Master_RResp   when state = s_SLAVE else (others => '0');
      Slave_AWReady  <= Master_AWReady when state = s_SLAVE else '0';
      Slave_WReady   <= Master_WReady  when state = s_SLAVE else '0';
      Slave_BValid   <= Master_BValid  when state = s_SLAVE else '0';
      Slave_BResp    <= Master_BResp   when state = s_SLAVE else (others => '0');

   end generate gen_Simulation;


   gen_Synthesis : if not Simulation generate
   begin
      Master_ARValid <= Slave_ARValid;
      Slave_ARReady  <= Master_ARReady;
      Master_ARAddr  <= Slave_ARAddr;
      Master_ARProt  <= Slave_ARProt;
      Slave_RValid   <= Master_RValid;
      Master_RReady  <= Slave_RReady;
      Slave_RData    <= Master_RData;
      Slave_RResp    <= Master_RResp;
      Master_AWValid <= Slave_AWValid;
      Slave_AWReady  <= Master_AWReady;
      Master_AWAddr  <= Slave_AWAddr;
      Master_AWProt  <= Slave_AWProt;
      Master_WValid  <= Slave_WValid;
      Slave_WReady   <= Master_WReady;
      Master_WData   <= Slave_WData;
      Master_WStrb   <= Slave_WStrb;
      Slave_BValid   <= Master_BValid;
      Master_BReady  <= Slave_BReady;
      Slave_BResp    <= Master_BResp;
   end generate gen_Synthesis;

end architecture rtl;
