//------------------------------------------------------------------------------
// Project Name   : IpLibrary
// Design Name    : Regbank
// File Name      : Regbank.vhd
//------------------------------------------------------------------------------
// Author         : Lukas Vinkx
// Description: 
//------------------------------------------------------------------------------


module regbank #(
  parameter int NOF_REGOUT = 4,
  parameter int NOF_REGIN  = 4
)( 
  input  logic        aclk,
  input  logic        aresetn,
  
  input  logic        ctrl_arvalid,
  output logic        ctrl_arready,
  input  logic [11:0] ctrl_araddr,
  output logic        ctrl_rvalid,
  input  logic        ctrl_rready,
  output logic [31:0] ctrl_rdata,
  output logic [1:0]  ctrl_rresp,
  input  logic        ctrl_awvalid,
  output logic        ctrl_awready,
  input  logic [11:0] ctrl_awaddr,
  input  logic        ctrl_wvalid,
  output logic        ctrl_wready,
  input  logic [31:0] ctrl_wdata,
  input  logic [3:0]  ctrl_wstrb,
  output logic        ctrl_bvalid,
  input  logic        ctrl_bready,
  output logic [1:0]  ctrl_bresp,
    
  output logic [31:0] reg_out [NOF_REGOUT],
  input  logic [31:0] reg_in  [NOF_REGIN ]
);


  //----------------------------------------------------------------------------

  type t_RegArr is array (integer range <>) of std_logic_vector(31 downto 0);
  signal RegArr_Out : t_RegArr(0 to g_NofRegOut-1);
  signal RegArr_In  : t_RegArr(0 to g_NofRegIn-1) ;

  signal Ctrl_ARReady_i : std_logic;
  signal Ctrl_RValid_i  : std_logic;
  signal Ctrl_AWReady_i : std_logic;
  signal Ctrl_WReady_i  : std_logic;
  signal Ctrl_BValid_i  : std_logic;

  procedure update_reg( 
    signal reg : inout std_logic_vector
  ) is
  begin
    for I in Ctrl_WStrb'range loop
      if Ctrl_WStrb(I) = '1' then
        reg(8*(I+1)-1 downto 8*I) <= Ctrl_WData(8*(I+1)-1 downto 8*I);
      end if;
    end loop;
  end procedure;

begin

  gen_RegOut : for I in 0 to g_NofRegOut-1 generate
  begin
    Reg_Out(32*(I+1)-1 downto 32*I) <= RegArr_Out(I);
  end generate;

  gen_RegIn : for I in 0 to g_NofRegIn-1 generate
  begin
    RegArr_In(I) <= Reg_In(32*(I+1)-1 downto 32*I);
  end generate;


  always_ff @(posedge aclk or negedge aresetn) begin
    variable Address : unsigned(9 downto 0);
  
    if (!aresetn) begin
      ctrl_rvalid <= '0;
      ctrl_bvalid <= '0;

      RegArr_Out <= (others => (others => '0'));

    end else if begin
      
      // Read Handshake/Data
      if (ctrl_arvalid && ctrl_arready) begin
        ctrl_rvalid <= '1;
        Address       := unsigned(Ctrl_ARAddr(11 downto 2));
        if (Address < 16) begin
          case( Address(3 downto 0))
            'h0     => Ctrl_RData <= x"DEADBEEF";
            default => Ctrl_RData <= (others => '0');
          endcase
        end else if (Address(0) == 0) begin               
          Ctrl_RData <= RegArr_Out(to_integer(Address));
        end else begin
          Ctrl_RData <= RegArr_In(to_integer(Address));
        end

      end else if (ctrl_rvalid && ctrl_rready) begin
        ctrl_rvalid <= '0;
      end


      // Write Handshake/Data
      if (ctrl_awvalid && ctrl_awready && ctrl_wvalid && ctrl_wready) begin
        ctrl_bvalid <= '1;
        Address            := unsigned(Ctrl_AWAddr(11 downto 2));

        if (Address < 16) begin
          case (Address(3 downto 0))
            'h0     : ; // Read only
            default : ; // Read only
          endcase
          
        end else if (Address(0) = '0') begin
          RegArr_Out(to_integer(Address)) <= Ctrl_WData;
        end

      end else if (ctrl_bvalid && ctrl_bready) begin
        ctrl_bvalid_i <= '0;
      end

    end
  end


  assign ctrl_arready = !ctrl_rvalid;
  assign ctrl_awready = ctrl_wvalid  && !ctrl_bvalid;
  assign ctrl_wready  = ctrl_awvalid && !ctrl_bvalid;
  
endmodule