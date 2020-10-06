--------------------------------------------------------------------------------
-- Project Name   : IpLibrary
-- Design Name    : Axi4LiteTransactor
-- File Name      : Axi4LiteTransactor.vhd
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
   use IEEE.std_logic_arith.all;

library lvin_Simulation_Axi4LiteIntf_v1_0;
   use lvin_Simulation_Axi4LiteIntf_v1_0.Axi4LiteIntf_pkg.all;


--------------------------------------------------------------------------------
-- PACKAGE HEADER
--------------------------------------------------------------------------------
package Axi4LiteTransactor_pkg is

   procedure InitAxi(
      signal AxiIntf : inout t_Axi4LiteIntf
   );

   procedure Idle (
      signal AxiIntf : inout t_Axi4LiteIntf;
      constant Tics  : in    natural := 1
   );

   procedure WriteAxi(
      signal AxiIntf : inout t_Axi4LiteIntf;
      constant Addr  : in std_logic_vector;
      constant Data  : in std_logic_vector
   );

   procedure WriteAxi(
      signal AxiIntf : inout t_Axi4LiteIntf;
      constant Addr  : in std_logic_vector;
      constant Data  : in std_logic_vector;
      variable Resp  : out std_logic_vector
   );

   procedure ReadAxi(
      signal AxiIntf : inout t_Axi4LiteIntf;
      constant Addr  : in  std_logic_vector;
      variable Data  : out std_logic_vector
   );

   procedure ReadAxi(
      signal AxiIntf : inout t_Axi4LiteIntf;
      constant Addr  : in  std_logic_vector;
      variable Data  : out std_logic_vector;
      variable Resp  : out std_logic_vector
   );

end package Axi4LiteTransactor_pkg;


--------------------------------------------------------------------------------
-- PACKAGE BODY
--------------------------------------------------------------------------------
package body Axi4LiteTransactor_pkg is

   -----------------------------------------------------------------------------
   procedure InitAxi(
      signal AxiIntf : inout t_Axi4LiteIntf
   ) is
   begin
      AxiIntf.AClk    <= 'Z';
      AxiIntf.AResetn <= 'Z';
      AxiIntf.ARValid <= '0';
      AxiIntf.ARReady <= 'Z';
      AxiIntf.ARAddr  <= (others => '0');
      AxiIntf.ARProt  <= (others => '0');
      AxiIntf.RValid  <= 'Z';
      AxiIntf.RReady  <= '0';
      AxiIntf.RData   <= (others => 'Z');
      AxiIntf.RResp   <= (others => 'Z');
      AxiIntf.AWValid <= '0';
      AxiIntf.AWReady <= 'Z';
      AxiIntf.AWAddr  <= (others => '0');
      AxiIntf.AWProt  <= (others => '0');
      AxiIntf.WValid  <= '0';
      AxiIntf.WReady  <= 'Z';
      AxiIntf.WData   <= (others => '0');
      AxiIntf.WStrb   <= (others => '0');
      AxiIntf.BValid  <= 'Z';
      AxiIntf.BReady  <= '0';
      AxiIntf.BResp   <= (others => 'Z');
   end procedure InitAxi;

   -----------------------------------------------------------------------------
   procedure Idle (
      signal AxiIntf : inout t_Axi4LiteIntf;
      constant Tics  : in    natural := 1
   ) is
   begin
      report "Entering wait loop for " & integer'image(Tics) & " tics";
      for Tic in 0 to Tics-1 loop
         wait until rising_edge(AxiIntf.AClk);
      end loop;
   end Idle;

   -----------------------------------------------------------------------------
   procedure WriteAxi(
      signal AxiIntf : inout t_Axi4LiteIntf;
      constant Addr  : in  std_logic_vector;
      constant Data  : in  std_logic_vector
   ) is
      variable Resp  : std_logic_vector(AxiIntf.BResp'range);
   begin
      WriteAxi(AxiIntf, Addr, Data, Resp);
   end procedure;

   -----------------------------------------------------------------------------
   procedure WriteAxi(
      signal AxiIntf : inout t_Axi4LiteIntf;
      constant Addr  : in  std_logic_vector;
      constant Data  : in  std_logic_vector;
      variable Resp  : out std_logic_vector
   ) is
      variable AWDone, WDone, BDone : boolean := True;
   begin
      AxiIntf.AWValid <= '1';
      AxiIntf.AWAddr  <= ext(Addr, AxiIntf.AWAddr'length);
      AxiIntf.WValid  <= '1';
      AxiIntf.WData   <= ext(Data, AxiIntf.Wdata'length);
      AxiIntf.WStrb   <= (others => '1');
      AxiIntf.BReady  <= '1';

      L1 : loop
         wait until rising_edge(AxiIntf.AClk);
         if AxiIntf.AWValid = '1' and AxiIntf.AWReady = '1' then
            AxiIntf.AWValid <= '0';
            AWDone          := False;
         end if;

         if AxiIntf.WValid = '1' and AxiIntf.WReady = '1' then
            AxiIntf.WValid <= '0';
            WDone          := False;
         end if;

         if AxiIntf.BValid = '1' and AxiIntf.BReady = '1' then
            AxiIntf.BReady <= '0';
            Resp           := AxiIntf.BResp;
            BDone          := False;
         end if;

         if AWDone and WDone and BDone then
            exit L1;
         end if; 
      end loop;
   end procedure;

   -----------------------------------------------------------------------------
   procedure ReadAxi(
      signal AxiIntf : inout t_Axi4LiteIntf;
      constant Addr  : in  std_logic_vector;
      variable Data  : out std_logic_vector
   ) is
      variable Resp  : std_logic_vector(t_Axi4LiteIntf.RResp'range);
   begin
      ReadAxi(AxiIntf, Addr, Data, Resp);
   end procedure;

   -----------------------------------------------------------------------------
   procedure ReadAxi(
      signal AxiIntf : inout t_Axi4LiteIntf;
      constant Addr  : in  std_logic_vector;
      variable Data  : out std_logic_vector;
      variable Resp  : out std_logic_vector
   ) is
      variable ARDone, RDone : boolean := False;
   begin
      AxiIntf.ARValid <= '1';
      AxiIntf.ARAddr  <= ext(Addr, AxiIntf.ARAddr'length);
      AxiIntf.RReady  <= '1';

      L1 : loop
         wait until rising_edge(AxiIntf.AClk);
         if AxiIntf.ARValid = '1' and AxiIntf.ARReady = '1' then
            AxiIntf.ARValid <= '0';
            ARDone          := True;
         end if;

         if AxiIntf.RValid = '1' and AxiIntf.RReady = '1' then
            AxiIntf.RReady <= '0';
            Data           := ext(AxiIntf.RData, Data'length);
            Resp           := ext(AxiIntf.RResp, Resp'length);
            RDone          := True;
         end if;

         if ARDone and RDone then
            exit L1;
         end if; 
      end loop;
   end procedure;

end package body Axi4LiteTransactor_pkg;
