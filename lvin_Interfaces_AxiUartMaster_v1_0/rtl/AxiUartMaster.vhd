
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
entity AxiUartMaster is
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
      S_AXI_AWValid : in  std_logic;
      S_AXI_AWReady : out std_logic;
      S_AXI_AWAddr  : in  std_logic_vector (31 downto 0);
      S_AXI_AWLen   : in  std_logic_vector (7  downto 0);
      S_AXI_AWSize  : in  std_logic_vector (2  downto 0);
      S_AXI_AWBurst : in  std_logic_vector (1  downto 0);
      S_AXI_AWLock  : in  std_logic_vector (0  downto 0);
      S_AXI_AWCache : in  std_logic_vector (3  downto 0);
      S_AXI_AWProt  : in  std_logic_vector (2  downto 0);
      S_AXI_AWQos   : in  std_logic_vector (3  downto 0);
      S_AXI_WValid  : in  std_logic;
      S_AXI_WReady  : out std_logic;
      S_AXI_WData   : in  std_logic_vector (31 downto 0);
      S_AXI_WStrb   : in  std_logic_vector (3  downto 0);
      S_AXI_WLast   : in  std_logic;
      S_AXI_BValid  : out std_logic;
      S_AXI_BReady  : in  std_logic;
      S_AXI_BResp   : out std_logic_vector (1  downto 0);
      S_AXI_ARValid : in  std_logic;
      S_AXI_ARReady : out std_logic;
      S_AXI_ARAddr  : in  std_logic_vector (31 downto 0);
      S_AXI_ARLen   : in  std_logic_vector (7  downto 0);
      S_AXI_ARSize  : in  std_logic_vector (2  downto 0);
      S_AXI_ARBurst : in  std_logic_vector (1  downto 0);
      S_AXI_ARLock  : in  std_logic_vector (0  downto 0);
      S_AXI_ARCache : in  std_logic_vector (3  downto 0);
      S_AXI_ARProt  : in  std_logic_vector (2  downto 0);
      S_AXI_ARQos   : in  std_logic_vector (3  downto 0);
      S_AXI_RValid  : out std_logic;
      S_AXI_RReady  : in  std_logic;
      S_AXI_RData   : out std_logic_vector (31 downto 0);
      S_AXI_RResp   : out std_logic_vector (1  downto 0);
      S_AXI_RLast   : out std_logic
   );
end entity AxiUartMaster;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of AxiUartMaster is

   signal TxByte_TValid   : std_logic;
   signal TxByte_TReady   : std_logic;
   signal TxByte_TData    : std_logic_vector(7 downto 0);
   
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

         s_axi_awvalid  : in  std_logic                                       ;
         s_axi_awready  : out std_logic;
         s_axi_awid     : in  std_logic_vector(C_AXI_ID_WIDTH-1 downto 0)     := (others => '0');
         s_axi_awaddr   : in  std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0)   ;
         s_axi_awlen    : in  std_logic_vector(8-1 downto 0)                  ;
         s_axi_awsize   : in  std_logic_vector(3-1 downto 0)                  ;
         s_axi_awburst  : in  std_logic_vector(2-1 downto 0)                  ;
         s_axi_awlock   : in  std_logic_vector(1-1 downto 0)                  ;
         s_axi_awcache  : in  std_logic_vector(4-1 downto 0)                  ;
         s_axi_awprot   : in  std_logic_vector(3-1 downto 0)                  ;
         s_axi_awregion : in  std_logic_vector(4-1 downto 0)                  := (others => '0');
         s_axi_awqos    : in  std_logic_vector(4-1 downto 0)                  ;
         s_axi_awuser   : in  std_logic_vector(C_AXI_AWUSER_WIDTH-1 downto 0) := (others => '0');
         s_axi_wvalid   : in  std_logic                                       ;
         s_axi_wready   : out std_logic;
         s_axi_wdata    : in  std_logic_vector(C_AXI_DATA_WIDTH-1   downto 0) ;
         s_axi_wstrb    : in  std_logic_vector(C_AXI_DATA_WIDTH/8-1 downto 0) ;
         s_axi_wuser    : in  std_logic_vector(C_AXI_WUSER_WIDTH-1 downto 0)  := (others => '0');
         s_axi_wlast    : in  std_logic                                       ;
         s_axi_bvalid   : out std_logic;
         s_axi_bready   : in  std_logic                                       ;
         s_axi_buser    : out std_logic_vector(C_AXI_BUSER_WIDTH-1 downto 0)  := (others => '0');
         s_axi_bid      : out std_logic_vector(C_AXI_ID_WIDTH-1 downto 0)     := (others => '0');
         s_axi_bresp    : out std_logic_vector(2-1 downto 0);
         s_axi_arvalid  : in  std_logic                                       ;
         s_axi_arready  : out std_logic;
         s_axi_arid     : in  std_logic_vector(C_AXI_ID_WIDTH-1 downto 0)     := (others => '0');
         s_axi_araddr   : in  std_logic_vector(C_AXI_ADDR_WIDTH-1 downto 0)   ;
         s_axi_arlen    : in  std_logic_vector(8-1 downto 0)                  ;
         s_axi_arsize   : in  std_logic_vector(3-1 downto 0)                  ;
         s_axi_arburst  : in  std_logic_vector(2-1 downto 0)                  ;
         s_axi_arlock   : in  std_logic_vector(1-1 downto 0)                  ;
         s_axi_arcache  : in  std_logic_vector(4-1 downto 0)                  ;
         s_axi_arprot   : in  std_logic_vector(3-1 downto 0)                  ;
         s_axi_arregion : in  std_logic_vector(4-1 downto 0)                  := (others => '0');
         s_axi_arqos    : in  std_logic_vector(4-1 downto 0)                  ;
         s_axi_aruser   : in  std_logic_vector(C_AXI_ARUSER_WIDTH-1 downto 0) := (others => '0');
         s_axi_rvalid   : out std_logic;                    
         s_axi_rready   : in  std_logic                                       ;         
         s_axi_rdata    : out std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0);   
         s_axi_ruser    : out std_logic_vector(C_AXI_RUSER_WIDTH-1 downto 0)  := (others => '0');   
         s_axi_rid      : out std_logic_vector(C_AXI_ID_WIDTH-1 downto 0)     := (others => '0');   
         s_axi_rresp    : out std_logic_vector(2-1 downto 0);            
         s_axi_rlast    : out std_logic;                   

         m_axi_awvalid  : out std_logic;
         m_axi_awready  : in  std_logic                                       := '0';
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
         m_axi_wready   : in  std_logic                                       := '0';
         m_axi_wdata    : out std_logic_vector(C_AXI_DATA_WIDTH-1   downto 0);
         m_axi_wstrb    : out std_logic_vector(C_AXI_DATA_WIDTH/8-1 downto 0);
         m_axi_wuser    : out std_logic_vector(C_AXI_WUSER_WIDTH-1 downto 0);
         m_axi_wlast    : out std_logic;
         m_axi_bvalid   : in  std_logic                                       := '0';
         m_axi_bready   : out std_logic;
         m_axi_buser    : in  std_logic_vector(C_AXI_BUSER_WIDTH-1 downto 0)  := (others => '0');
         m_axi_bid      : in  std_logic_vector(C_AXI_ID_WIDTH-1 downto 0)     := (others => '0');
         m_axi_bresp    : in  std_logic_vector(2-1 downto 0)                  := (others => '0');
         m_axi_arvalid  : out std_logic;
         m_axi_arready  : in  std_logic                                       := '0';
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
         m_axi_rvalid   : in  std_logic                                       := '0';                    
         m_axi_rready   : out std_logic;                      
         m_axi_rdata    : in  std_logic_vector(C_AXI_DATA_WIDTH-1 downto 0)   := (others => '0');   
         m_axi_ruser    : in  std_logic_vector(C_AXI_RUSER_WIDTH-1 downto 0)  := (others => '0');   
         m_axi_rid      : in  std_logic_vector(C_AXI_ID_WIDTH-1 downto 0)     := (others => '0');   
         m_axi_rresp    : in  std_logic_vector(2-1 downto 0)                  := (others => '0');            
         m_axi_rlast    : in  std_logic                                       := '0';

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

      s_axi_awvalid => S_AXI_AWValid,
      s_axi_awready => S_AXI_AWReady,
      s_axi_awaddr  => S_AXI_AWAddr ,
      s_axi_awlen   => S_AXI_AWLen  ,
      s_axi_awsize  => S_AXI_AWSize ,
      s_axi_awburst => S_AXI_AWBurst,
      s_axi_awlock  => S_AXI_AWLock ,
      s_axi_awcache => S_AXI_AWCache,
      s_axi_awprot  => S_AXI_AWProt ,
      s_axi_awqos   => S_AXI_AWQos  ,
      s_axi_wvalid  => S_AXI_WValid ,
      s_axi_wready  => S_AXI_WReady ,
      s_axi_wdata   => S_AXI_WData  ,
      s_axi_wstrb   => S_AXI_WStrb  ,
      s_axi_wlast   => S_AXI_WLast  ,
      s_axi_bvalid  => S_AXI_BValid ,
      s_axi_bready  => S_AXI_BReady ,
      s_axi_bresp   => S_AXI_BResp  ,
      s_axi_arvalid => S_AXI_ARValid,
      s_axi_arready => S_AXI_ARReady,
      s_axi_araddr  => S_AXI_ARAddr ,
      s_axi_arlen   => S_AXI_ARLen  ,
      s_axi_arsize  => S_AXI_ARSize ,
      s_axi_arburst => S_AXI_ARBurst,
      s_axi_arlock  => S_AXI_ARLock ,
      s_axi_arcache => S_AXI_ARCache,
      s_axi_arprot  => S_AXI_ARProt ,
      s_axi_arqos   => S_AXI_ARQos  ,
      s_axi_rvalid  => S_AXI_RValid ,
      s_axi_rready  => S_AXI_RReady ,
      s_axi_rdata   => S_AXI_RData  ,
      s_axi_rresp   => S_AXI_RResp  ,
      s_axi_rlast   => S_AXI_RLast  ,

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
