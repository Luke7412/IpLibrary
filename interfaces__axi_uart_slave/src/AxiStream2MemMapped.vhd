
--------------------------------------------------------------------------------
-- LIBRARIES
--------------------------------------------------------------------------------
library IEEE;
   use IEEE.STD_LOGIC_1164.ALL;
   use IEEE.NUMERIC_STD.ALL;


--------------------------------------------------------------------------------
-- ENTITY
--------------------------------------------------------------------------------
entity AxiStream2MemMapped is
   Port (
      -- Clock and Reset
      AClk            : in  std_logic;
      AResetn         : in  std_logic;      
      -- Axi4-Stream RxPacket interface
      RxPacket_TValid : in  std_logic;
      RxPacket_TReady : out std_logic;
      RxPacket_TLast  : in  std_logic;
      RxPacket_TData  : in  std_logic_vector(7 downto 0);
      RxPacket_TId    : in  std_logic_vector(2 downto 0);
      -- Axi4-Stream TxPacket interface
      TxPacket_TValid : out std_logic;
      TxPacket_TReady : in  std_logic;
      TxPacket_TLast  : out std_logic;
      TxPacket_TData  : out std_logic_vector(7 downto 0);
      TxPacket_TId    : out std_logic_vector(2 downto 0);
      -- Axi4 Interface
      M_AXI_AWValid   : out std_logic;
      M_AXI_AWReady   : in  std_logic;
      M_AXI_AWAddr    : out std_logic_vector (31 downto 0);
      M_AXI_AWLen     : out std_logic_vector (7  downto 0);
      M_AXI_AWSize    : out std_logic_vector (2  downto 0);
      M_AXI_AWBurst   : out std_logic_vector (1  downto 0);
      M_AXI_AWLock    : out std_logic_vector (0  downto 0);
      M_AXI_AWCache   : out std_logic_vector (3  downto 0);
      M_AXI_AWProt    : out std_logic_vector (2  downto 0);
      M_AXI_AWQos     : out std_logic_vector (3  downto 0);
      M_AXI_WValid    : out std_logic;
      M_AXI_WReady    : in  std_logic;
      M_AXI_WData     : out std_logic_vector (31 downto 0);
      M_AXI_WStrb     : out std_logic_vector (3  downto 0);
      M_AXI_WLast     : out std_logic;
      M_AXI_BValid    : in  std_logic;
      M_AXI_BReady    : out std_logic;
      M_AXI_BResp     : in  std_logic_vector (1  downto 0);
      M_AXI_ARValid   : out std_logic;
      M_AXI_ARReady   : in  std_logic;
      M_AXI_ARAddr    : out std_logic_vector (31 downto 0);
      M_AXI_ARLen     : out std_logic_vector (7  downto 0);
      M_AXI_ARSize    : out std_logic_vector (2  downto 0);
      M_AXI_ARBurst   : out std_logic_vector (1  downto 0);
      M_AXI_ARLock    : out std_logic_vector (0  downto 0);
      M_AXI_ARCache   : out std_logic_vector (3  downto 0);
      M_AXI_ARProt    : out std_logic_vector (2  downto 0);
      M_AXI_ARQos     : out std_logic_vector (3  downto 0);
      M_AXI_RValid    : in  std_logic;
      M_AXI_RReady    : out std_logic;
      M_AXI_RData     : in  std_logic_vector (31 downto 0);
      M_AXI_RResp     : in  std_logic_vector (1  downto 0);
      M_AXI_RLast     : in  std_logic
   );
end entity AxiStream2MemMapped;


--------------------------------------------------------------------------------
-- ARCHITECTURE
--------------------------------------------------------------------------------
architecture rtl of AxiStream2MemMapped is

   signal ShiftAW           : std_logic_vector(63 downto 0);
   signal ShiftAR           : std_logic_vector(63 downto 0);
   signal ShiftW            : std_logic_vector(39 downto 0);
   signal ShiftR            : std_logic_vector(36 downto 0);
   signal ShiftB            : std_logic_vector(1 downto 0);
      
   signal RxPacket_TReady_i : std_logic;
   signal TxPacket_TValid_i : std_logic;
   signal M_AXI_AWValid_i   : std_logic;
   signal M_AXI_WValid_i    : std_logic;
   signal M_AXI_ARValid_i   : std_logic;
   signal M_AXI_RReady_i    : std_logic;
   signal M_AXI_BReady_i    : std_logic;

   signal Cnt_ShiftR : unsigned(2 downto 0);
   signal Cnt_ShiftB : unsigned(0 downto 0);

begin

   M_AXI_AWValid <= M_AXI_AWValid_i;
   M_AXI_AWAddr  <= ShiftAW(31 downto 0);
   M_AXI_AWProt  <= ShiftAW(34 downto 32);
   M_AXI_AWSize  <= ShiftAW(37 downto 35);
   M_AXI_AWBurst <= ShiftAW(39 downto 38);
   M_AXI_AWCache <= ShiftAW(43 downto 40);
   M_AXI_AWLen   <= ShiftAW(51 downto 44);
   M_AXI_AWLock  <= ShiftAW(52 downto 52);
   M_AXI_AWQos   <= ShiftAW(57 downto 54);

   M_AXI_ARValid <= M_AXI_ARValid_i;
   M_AXI_ARAddr  <= ShiftAR(31 downto 0);
   M_AXI_ARProt  <= ShiftAR(34 downto 32);
   M_AXI_ARSize  <= ShiftAR(37 downto 35);
   M_AXI_ARBurst <= ShiftAR(39 downto 38);
   M_AXI_ARCache <= ShiftAR(43 downto 40);
   M_AXI_ARLen   <= ShiftAR(51 downto 44);
   M_AXI_ARLock  <= ShiftAR(52 downto 52);
   M_AXI_ARQos   <= ShiftAR(57 downto 54);

   M_AXI_WValid  <= M_AXI_WValid_i;
   M_AXI_WData   <= ShiftW(31 downto 0);
   M_AXI_WStrb   <= ShiftW(35 downto 32);
   M_AXI_WLast   <= ShiftW(36);


   process(AClk, AResetn) 
   begin
      if AResetn = '0' then
         M_AXI_AWValid_i <= '0';
         M_AXI_ARValid_i <= '0';
         M_AXI_WValid_i  <= '0';

      elsif rising_edge(AClk) then
         if M_AXI_AWValid_i = '1' and M_AXI_AWReady = '1' then
            M_AXI_AWValid_i <= '0';
         end if;

         if M_AXI_ARValid_i = '1' and M_AXI_ARReady = '1' then
            M_AXI_ARValid_i <= '0';
         end if;

         if M_AXI_WValid_i = '1' and M_AXI_WReady = '1' then
            M_AXI_WValid_i <= '0';
         end if;


         if RxPacket_TValid = '1' and RxPacket_TReady_i = '1' then

            if RxPacket_TId = "001" then
               ShiftAW <= RxPacket_TData & ShiftAW(ShiftAW'high downto 8);
               if RxPacket_TLast = '1' then
                  M_AXI_AWValid_i <= '1';
               end if;
            end if;

            if RxPacket_TId = "010" then
               ShiftAR <= RxPacket_TData & ShiftAR(ShiftAR'high downto 8);
               if RxPacket_TLast = '1' then
                  M_AXI_ARValid_i <= '1';
               end if;
            end if;

            if RxPacket_TId = "100" then
               ShiftW <= RxPacket_TData & ShiftW(ShiftW'high downto 8);
               if RxPacket_TLast = '1' then
                  M_AXI_WValid_i <= '1';
               end if;
            end if;

         end if;
      end if;
   end process;


   RxPacket_TReady_i <= '0' when 
      (RxPacket_TId = "001" and M_AXI_AWValid_i = '1') or
      (RxPacket_TId = "010" and M_AXI_ARValid_i = '1') or
      (RxPacket_TId = "100" and M_AXI_WValid_i = '1') else '1';

   RxPacket_TReady <= RxPacket_TReady_i;



   process(AClk, AResetn) 
   begin
      if AResetn = '0' then
         Cnt_ShiftR        <= (others => '0');
         Cnt_ShiftB        <= (others => '0');
         TxPacket_TValid_i <= '0';

      elsif rising_edge(AClk) then
         if M_AXI_RValid = '1' and M_AXI_RReady_i = '1' then
            Cnt_ShiftR           <= to_unsigned(5, Cnt_ShiftR'length);
            ShiftR(31 downto  0) <= M_AXI_RData;
            ShiftR(33 downto 32) <= M_AXI_RResp;
            ShiftR(34)           <= M_AXI_RLast;
         end if;

         if M_AXI_BValid = '1' and M_AXI_BReady_i = '1' then
            Cnt_ShiftB         <= to_unsigned(1, Cnt_ShiftB'length);
            ShiftB(1 downto 0) <= M_AXI_BResp;
         end if;


         if TxPacket_TValid_i = '1' and TxPacket_TReady = '1' then
            TxPacket_TValid_i <= '0';
         end if;

         if TxPacket_TValid_i = '0' or TxPacket_TReady = '1' then
            if Cnt_ShiftR /= 0 then
               Cnt_ShiftR        <= Cnt_ShiftR - 1;
               TxPacket_TValid_i <= '1';
               ShiftR            <= x"00" & ShiftR(ShiftR'high downto 8);
               TxPacket_TData    <= ShiftR(7 downto 0);
               TxPacket_TId      <= "011";
               TxPacket_TLast    <= '0';
               if Cnt_ShiftR = 1 then
                  TxPacket_TLast <= '1';
               end if;

            elsif Cnt_ShiftB /= 0 then
               Cnt_ShiftB        <= Cnt_ShiftB - 1;
               TxPacket_TValid_i <= '1';
               TxPacket_TData    <= "000000" & ShiftB;
               TxPacket_TId      <= "000";
               TxPacket_TLast    <= '1';
            end if;
         end if;

      end if;
   end process;


   M_AXI_RReady_i  <= '1' when Cnt_ShiftR = 0 and Cnt_ShiftB = 0 else '0';
   M_AXI_BReady_i  <= '1' when Cnt_ShiftR = 0 and Cnt_ShiftB = 0 else '0';
   
   TxPacket_TValid <= TxPacket_TValid_i;
   M_AXI_RReady    <= M_AXI_RReady_i;
   M_AXI_BReady    <= M_AXI_BReady_i;

end architecture rtl;
