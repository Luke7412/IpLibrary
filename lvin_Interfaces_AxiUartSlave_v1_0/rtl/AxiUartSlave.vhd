
--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library IEEE;
   use IEEE.STD_LOGIC_1164.ALL;

library lvin_Interfaces_AxisUart_v1_0;
   use lvin_Interfaces_AxisUart_v1_0.AxisUart;

library lvin_Axi4Stream_Framing_v1_0;
   use lvin_Axi4Stream_Framing_v1_0.Framing;

library lvin_Axi4Stream_DestPacketizer_v1_0;
   use lvin_Axi4Stream_DestPacketizer_v1_0.DestPacketizer;

library axi_mm2s_mapper_v1_1_19;
   use axi_mm2s_mapper_v1_1_19.axi_mm2s_mapper_v1_1_19_top;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity AxiUartSlave is
   Generic(
      g_AClkFrequency : natural := 200000000;
      g_BaudRate      : natural := 9600;
      g_BaudRateSim   : natural := 50000000;
      g_EscapeByte    : std_logic_vector(7 downto 0) := x"7F";
      g_StartByte     : std_logic_vector(7 downto 0) := x"7D";
      g_StopByte      : std_logic_vector(7 downto 0) := x"7E"
   );
   Port (
      -- Clock and Reset
      AClk          : in  std_logic;
      AResetn       : in  std_logic;
      -- Uart Interface
      Uart_TxD      : out std_logic;
      Uart_RxD      : in  std_logic;
      -- Axi4 Interface
      M_AXI_AWValid : out std_logic;
      M_AXI_AWReady : in  std_logic;
      M_AXI_AWAddr  : out std_logic_vector (31 downto 0);
      M_AXI_AWLen   : out std_logic_vector (7  downto 0);
      M_AXI_AWSize  : out std_logic_vector (2  downto 0);
      M_AXI_AWBurst : out std_logic_vector (1  downto 0);
      M_AXI_AWLock  : out std_logic_vector (0  downto 0);
      M_AXI_AWCache : out std_logic_vector (3  downto 0);
      M_AXI_AWProt  : out std_logic_vector (2  downto 0);
      M_AXI_AWQos   : out std_logic_vector (3  downto 0);
      M_AXI_WValid  : out std_logic;
      M_AXI_WReady  : in  std_logic;
      M_AXI_WData   : out std_logic_vector (31 downto 0);
      M_AXI_WStrb   : out std_logic_vector (3  downto 0);
      M_AXI_WLast   : out std_logic;
      M_AXI_BValid  : in  std_logic;
      M_AXI_BReady  : out std_logic;
      M_AXI_BResp   : in  std_logic_vector (1  downto 0);
      M_AXI_ARValid : out std_logic;
      M_AXI_ARReady : in  std_logic;
      M_AXI_ARAddr  : out std_logic_vector (31 downto 0);
      M_AXI_ARLen   : out std_logic_vector (7  downto 0);
      M_AXI_ARSize  : out std_logic_vector (2  downto 0);
      M_AXI_ARBurst : out std_logic_vector (1  downto 0);
      M_AXI_ARLock  : out std_logic_vector (0  downto 0);
      M_AXI_ARCache : out std_logic_vector (3  downto 0);
      M_AXI_ARProt  : out std_logic_vector (2  downto 0);
      M_AXI_ARQos   : out std_logic_vector (3  downto 0);
      M_AXI_RValid  : in  std_logic;
      M_AXI_RReady  : out std_logic;
      M_AXI_RData   : in  std_logic_vector (31 downto 0);
      M_AXI_RResp   : in  std_logic_vector (1  downto 0);
      M_AXI_RLast   : in  std_logic
   );
end entity AxiUartSlave;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of AxiUartSlave is

   signal TxByte_TValid   : std_logic;
   signal TxByte_TReady   : std_logic;
   signal TxByte_TData    : std_logic_vector(7 downto 0);
   signal TxByte_TKeep    : std_logic_vector(0 downto 0);
   
   signal RxByte_TValid   : std_logic;
   signal RxByte_TReady   : std_logic;
   signal RxByte_TData    : std_logic_vector(7 downto 0);
   
   signal RxFrame_TValid  : std_logic;
   signal RxFrame_TReady  : std_logic;
   signal RxFrame_TLast   : std_logic;
   signal RxFrame_TData   : std_logic_vector(7 downto 0);
   
   signal TxFrame_TValid  : std_logic;
   signal TxFrame_TReady  : std_logic;
   signal TxFrame_TLast   : std_logic;
   signal TxFrame_TData   : std_logic_vector(7 downto 0);
   
   signal RxPacket_TValid : std_logic;
   signal RxPacket_TReady : std_logic;
   signal RxPacket_TLast  : std_logic;
   signal RxPacket_TData  : std_logic_vector(7 downto 0);
   signal RxPacket_TId    : std_logic_vector(2 downto 0);
   
   signal TxPacket_TValid : std_logic;
   signal TxPacket_TReady : std_logic;
   signal TxPacket_TLast  : std_logic;
   signal TxPacket_TData  : std_logic_vector(7 downto 0);
   signal TxPacket_TId    : std_logic_vector(2 downto 0);

   component axi_mm2s_mapper_v1_1_19_top
      generic (
         C_FAMILY                      : string  := "artix7";
         C_AXI_ID_WIDTH                : integer := 1;
         C_AXI_ADDR_WIDTH              : integer := 32;
         C_AXI_DATA_WIDTH              : integer := 32;
         C_AXI_SUPPORTS_USER_SIGNALS   : integer := 0;
         C_AXI_SUPPORTS_REGION_SIGNALS : integer := 0;
         C_AXI_AWUSER_WIDTH            : integer := 1;
         C_AXI_ARUSER_WIDTH            : integer := 1;
         C_AXI_WUSER_WIDTH             : integer := 1;
         C_AXI_RUSER_WIDTH             : integer := 1;
         C_AXI_BUSER_WIDTH             : integer := 1;
         C_AXIS_TDATA_WIDTH            : integer := 8;
         C_AXIS_TID_WIDTH              : integer := 3  
      );
      port (
         aclk           : in  std_logic;
         aresetn        : in  std_logic;

         s_axi_awvalid  : in  std_logic                                       := '0';
         s_axi_awready  : out std_logic;
         s_axi_awid     : in  std_logic_vector(C_AXI_ID_WIDTH-1 downto 0)     := (others => '0');
         s_axi_awaddr   : in  std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0)   := (others => '0');
         s_axi_awlen    : in  std_logic_vector(8-1 downto 0)                  := (others => '0');
         s_axi_awsize   : in  std_logic_vector(3-1 downto 0)                  := (others => '0');
         s_axi_awburst  : in  std_logic_vector(2-1 downto 0)                  := (others => '0');
         s_axi_awlock   : in  std_logic_vector(1-1 downto 0)                  := (others => '0');
         s_axi_awcache  : in  std_logic_vector(4-1 downto 0)                  := (others => '0');
         s_axi_awprot   : in  std_logic_vector(3-1 downto 0)                  := (others => '0');
         s_axi_awregion : in  std_logic_vector(4-1 downto 0)                  := (others => '0');
         s_axi_awqos    : in  std_logic_vector(4-1 downto 0)                  := (others => '0');
         s_axi_awuser   : in  std_logic_vector(C_AXI_AWUSER_WIDTH-1 downto 0) := (others => '0');
         s_axi_wvalid   : in  std_logic                                       := '0';
         s_axi_wready   : out std_logic;
         s_axi_wdata    : in  std_logic_vector(C_AXI_DATA_WIDTH-1   downto 0) := (others => '0');
         s_axi_wstrb    : in  std_logic_vector(C_AXI_DATA_WIDTH/8-1 downto 0) := (others => '0');
         s_axi_wuser    : in  std_logic_vector(C_AXI_WUSER_WIDTH-1 downto 0)  := (others => '0');
         s_axi_wlast    : in  std_logic                                       := '0';
         s_axi_bvalid   : out std_logic;
         s_axi_bready   : in  std_logic                                       := '0';
         s_axi_buser    : out std_logic_vector(C_AXI_BUSER_WIDTH-1 downto 0);
         s_axi_bid      : out std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
         s_axi_bresp    : out std_logic_vector(2-1 downto 0);
         s_axi_arvalid  : in  std_logic                                       := '0';
         s_axi_arready  : out std_logic;
         s_axi_arid     : in  std_logic_vector(C_AXI_ID_WIDTH-1 downto 0)     := (others => '0');
         s_axi_araddr   : in  std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0)   := (others => '0');
         s_axi_arlen    : in  std_logic_vector(8-1 downto 0)                  := (others => '0');
         s_axi_arsize   : in  std_logic_vector(3-1 downto 0)                  := (others => '0');
         s_axi_arburst  : in  std_logic_vector(2-1 downto 0)                  := (others => '0');
         s_axi_arlock   : in  std_logic_vector(1-1 downto 0)                  := (others => '0');
         s_axi_arcache  : in  std_logic_vector(4-1 downto 0)                  := (others => '0');
         s_axi_arprot   : in  std_logic_vector(3-1 downto 0)                  := (others => '0');
         s_axi_arregion : in  std_logic_vector(4-1 downto 0)                  := (others => '0');
         s_axi_arqos    : in  std_logic_vector(4-1 downto 0)                  := (others => '0');
         s_axi_aruser   : in  std_logic_vector(C_AXI_ARUSER_WIDTH-1 downto 0) := (others => '0');
         s_axi_rvalid   : out std_logic;                    
         s_axi_rready   : in  std_logic                                       := '0';                      
         s_axi_rdata    : out std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);   
         s_axi_ruser    : out std_logic_vector(C_AXI_RUSER_WIDTH-1 downto 0);   
         s_axi_rid      : out std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);   
         s_axi_rresp    : out std_logic_vector(2-1 downto 0);            
         s_axi_rlast    : out std_logic;                   

         m_axi_awvalid  : out std_logic;
         m_axi_awready  : in  std_logic;
         m_axi_awid     : out std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
         m_axi_awaddr   : out std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
         m_axi_awlen    : out std_logic_vector(8-1 downto 0);
         m_axi_awsize   : out std_logic_vector(3-1 downto 0);
         m_axi_awburst  : out std_logic_vector(2-1 downto 0);
         m_axi_awlock   : out std_logic_vector(1-1 downto 0);
         m_axi_awcache  : out std_logic_vector(4-1 downto 0);
         m_axi_awprot   : out std_logic_vector(3-1 downto 0);
         m_axi_awregion : out std_logic_vector(4-1 downto 0);
         m_axi_awqos    : out std_logic_vector(4-1 downto 0);
         m_axi_awuser   : out std_logic_vector(C_AXI_AWUSER_WIDTH-1 downto 0);
         m_axi_wvalid   : out std_logic;
         m_axi_wready   : in  std_logic;
         m_axi_wdata    : out std_logic_vector(C_AXI_DATA_WIDTH-1   downto 0);
         m_axi_wstrb    : out std_logic_vector(C_AXI_DATA_WIDTH/8-1 downto 0);
         m_axi_wuser    : out std_logic_vector(C_AXI_WUSER_WIDTH-1 downto 0);
         m_axi_wlast    : out std_logic;
         m_axi_bvalid   : in  std_logic;
         m_axi_bready   : out std_logic;
         m_axi_buser    : in  std_logic_vector(C_AXI_BUSER_WIDTH-1 downto 0);
         m_axi_bid      : in  std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
         m_axi_bresp    : in  std_logic_vector(2-1 downto 0);
         m_axi_arvalid  : out std_logic;
         m_axi_arready  : in  std_logic;
         m_axi_arid     : out std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);
         m_axi_araddr   : out std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0);
         m_axi_arlen    : out std_logic_vector(8-1 downto 0);
         m_axi_arsize   : out std_logic_vector(3-1 downto 0);
         m_axi_arburst  : out std_logic_vector(2-1 downto 0);
         m_axi_arlock   : out std_logic_vector(1-1 downto 0);
         m_axi_arcache  : out std_logic_vector(4-1 downto 0);
         m_axi_arprot   : out std_logic_vector(3-1 downto 0);
         m_axi_arregion : out std_logic_vector(4-1 downto 0);
         m_axi_arqos    : out std_logic_vector(4-1 downto 0);
         m_axi_aruser   : out std_logic_vector(C_AXI_ARUSER_WIDTH-1 downto 0);
         m_axi_rvalid   : in  std_logic;                    
         m_axi_rready   : out std_logic;                      
         m_axi_rdata    : in  std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);   
         m_axi_ruser    : in  std_logic_vector(C_AXI_RUSER_WIDTH-1 downto 0);   
         m_axi_rid      : in  std_logic_vector(C_AXI_ID_WIDTH-1 downto 0);   
         m_axi_rresp    : in  std_logic_vector(2-1 downto 0);            
         m_axi_rlast    : in  std_logic;

         s_axis_tvalid  : in  std_logic;
         s_axis_tready  : out std_logic;
         s_axis_tdata   : in  std_logic_vector(C_AXIS_TDATA_WIDTH-1 downto 0);  
         s_axis_tkeep   : in  std_logic_vector(C_AXIS_TDATA_WIDTH/8-1 downto 0); 
         s_axis_tid     : in  std_logic_vector(C_AXIS_TID_WIDTH-1 downto 0);
         s_axis_tlast   : in  std_logic;

         m_axis_tvalid  : out std_logic;
         m_axis_tready  : in  std_logic;
         m_axis_tdata   : out std_logic_vector(C_AXIS_TDATA_WIDTH-1 downto 0);  
         m_axis_tkeep   : out std_logic_vector(C_AXIS_TDATA_WIDTH/8-1 downto 0); 
         m_axis_tid     : out std_logic_vector(C_AXIS_TID_WIDTH-1 downto 0);
         m_axis_tlast   : out std_logic
      );
   end component;

begin
   
   i_AxisUart: entity lvin_Interfaces_AxisUart_v1_0.AxisUart
      Generic map(
         g_AClkFrequency => g_AClkFrequency,
         g_BaudRate      => g_BaudRate     ,
         g_BaudRateSim   => g_BaudRateSim
      )
      Port map(
         -- Clock and Reset
         AClk          => AClk         ,
         AResetn       => AResetn      ,
         Uart_TxD      => Uart_TxD     ,
         Uart_RxD      => Uart_RxD     ,
         -- Axi4-Stream TxByte Interface
         TxByte_TValid => TxByte_TValid,
         TxByte_TReady => TxByte_TReady,
         TxByte_TData  => TxByte_TData ,
         TxByte_TKeep  => TxByte_TKeep ,
         -- Axi4-Stream RxByte Interface
         RxByte_TValid => RxByte_TValid,
         RxByte_TReady => RxByte_TReady,
         RxByte_TData  => RxByte_TData
      );


   i_Framing: entity lvin_Axi4Stream_Framing_v1_0.Framing
      Generic map(
         g_EscapeByte => g_EscapeByte,
         g_StartByte  => g_StartByte ,
         g_StopByte   => g_StopByte  
      )
      Port map(
         -- Clock and Reset
         AClk           => AClk   ,
         AResetn        => AResetn,
         -- Axi4-Stream RxByte Interface
         RxByte_TValid  => RxByte_TValid,
         RxByte_TReady  => RxByte_TReady,
         RxByte_TData   => RxByte_TData ,
         -- Axi4-Stream RxFrame Interface
         RxFrame_TValid => RxFrame_TValid,
         RxFrame_TReady => RxFrame_TReady,
         RxFrame_TData  => RxFrame_TData ,
         RxFrame_TLast  => RxFrame_TLast ,
         -- Axi4-Stream TxByte Interface
         TxByte_TValid  =>  TxByte_TValid,
         TxByte_TReady  =>  TxByte_TReady,
         TxByte_TData   =>  TxByte_TData ,
         -- Axi4-Stream TxFrame Interface
         TxFrame_TValid => TxFrame_TValid,
         TxFrame_TReady => TxFrame_TReady,
         TxFrame_TData  => TxFrame_TData ,
         TxFrame_TLast  => TxFrame_TLast 
      );


   i_DestPacketizer: entity lvin_Axi4Stream_DestPacketizer_v1_0.DestPacketizer
      port map(
         -- Clock and reset
         AClk            => AClk   ,
         AResetn         => AResetn,
         -- Axi4-Stream RxFrame interface
         RxFrame_TValid  => RxFrame_TValid,
         RxFrame_TReady  => RxFrame_TReady,
         RxFrame_TLast   => RxFrame_TLast ,
         RxFrame_TData   => RxFrame_TData ,
         -- Axi4-Stream TxFrame interface
         TxFrame_TValid  => TxFrame_TValid,
         TxFrame_TReady  => TxFrame_TReady,
         TxFrame_TLast   => TxFrame_TLast ,
         TxFrame_TData   => TxFrame_TData ,
         -- Axi4-Stream RxPacket interface
         RxPacket_TValid => RxPacket_TValid,
         RxPacket_TReady => RxPacket_TReady,
         RxPacket_TLast  => RxPacket_TLast ,
         RxPacket_TData  => RxPacket_TData ,
         RxPacket_TId    => RxPacket_TId   ,
         --RxPacket_TKeep  : out std_logic_vector(0 downto 0);
         -- Axi4-Stream TxPacket interface
         TxPacket_TValid => TxPacket_TValid,
         TxPacket_TReady => TxPacket_TReady,
         TxPacket_TLast  => TxPacket_TLast ,
         TxPacket_TData  => TxPacket_TData ,
         TxPacket_TId    => TxPacket_TId  
      );


  i_Axi4Stream_2_Axi4MM : axi_mm2s_mapper_v1_1_19_top
   port map (
      aclk           => aclk,
      aresetn        => aresetn,

      m_axi_awvalid  => m_axi_awvalid,
      m_axi_awready  => m_axi_awready,
      m_axi_awid     => open,
      m_axi_awaddr   => m_axi_awaddr,
      m_axi_awlen    => m_axi_awlen,
      m_axi_awsize   => m_axi_awsize,
      m_axi_awburst  => m_axi_awburst,
      m_axi_awlock   => m_axi_awlock,
      m_axi_awcache  => m_axi_awcache,
      m_axi_awprot   => m_axi_awprot,
      m_axi_awregion => open,
      m_axi_awqos    => m_axi_awqos,
      m_axi_awuser   => open,
      m_axi_wvalid   => m_axi_wvalid,
      m_axi_wready   => m_axi_wready,
      m_axi_wdata    => m_axi_wdata,
      m_axi_wstrb    => m_axi_wstrb,
      m_axi_wlast    => m_axi_wlast,
      m_axi_wuser    => open,
      m_axi_bvalid   => m_axi_bvalid,
      m_axi_bready   => m_axi_bready,
      m_axi_bid      => (others => '0'),
      m_axi_bresp    => m_axi_bresp,
      m_axi_buser    => (others => '0'),
      m_axi_arvalid  => m_axi_arvalid,
      m_axi_arready  => m_axi_arready,
      m_axi_arid     => open,
      m_axi_araddr   => m_axi_araddr,
      m_axi_arlen    => m_axi_arlen,
      m_axi_arsize   => m_axi_arsize,
      m_axi_arburst  => m_axi_arburst,
      m_axi_arlock   => m_axi_arlock,
      m_axi_arcache  => m_axi_arcache,
      m_axi_arprot   => m_axi_arprot,
      m_axi_arregion => open,
      m_axi_arqos    => m_axi_arqos,
      m_axi_aruser   => open,
      m_axi_rvalid   => m_axi_rvalid,
      m_axi_rready   => m_axi_rready,
      m_axi_rdata    => m_axi_rdata,
      m_axi_ruser    => (others => '0'),
      m_axi_rid      => (others => '0'),
      m_axi_rresp    => m_axi_rresp,
      m_axi_rlast    => m_axi_rlast,

      s_axis_tvalid  => RxPacket_tvalid,
      s_axis_tready  => RxPacket_tready,
      s_axis_tdata   => RxPacket_tdata,
      s_axis_tkeep   => (others => '0'),
      s_axis_tid     => RxPacket_tid,
      s_axis_tlast   => RxPacket_tlast,

      m_axis_tvalid  => TxPacket_TValid,
      m_axis_tready  => TxPacket_TReady,
      m_axis_tdata   => TxPacket_TData,
      m_axis_tkeep   => open,
      m_axis_tid     => TxPacket_TId,
      m_axis_tlast   => TxPacket_TLast
   );


end architecture rtl;
