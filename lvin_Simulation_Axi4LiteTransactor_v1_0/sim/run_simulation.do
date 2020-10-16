################################################################################
# Compile script
################################################################################

quietly set PATH_IPLIBRARY "../.."
quietly set PATH_RTL "../rtl"
quietly set PATH_TB "../tb"

################################################################################
# External IPs

quietly set LIBRARY "lvin_Simulation_Axi4LiteIntf_v1_0"

file delete -force $LIBRARY
vlib $LIBRARY

vcom -93 -quiet +acc -work $LIBRARY \
   $PATH_IPLIBRARY/$LIBRARY/rtl/Axi4LiteIntf_pkg.vhd


################################################################################
# Main sources

quietly set LIBRARY "lvin_Simulation_Axi4LiteTransactor_v1_0"

file delete -force $LIBRARY
vlib $LIBRARY

vcom -93 -quiet +acc -work $LIBRARY \
   $PATH_RTL/Axi4LiteTransactor_pkg.vhd \
   $PATH_TB/Axi4LiteTransactor_tb.vhd

quietly set TOP_TB "Axi4LiteTransactor_tb"


################################################################################
# Elaborate script
################################################################################

quietly set TOP_TB_OPT ${TOP_TB}_OPT

vopt +acc -l elaborate.log \
   -work $LIBRARY $LIBRARY.$TOP_TB \
   -o $TOP_TB_OPT



################################################################################
# Simulate script
################################################################################

vsim -t fs -lib $LIBRARY $TOP_TB_OPT

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

# Load wave if exists
if { [file exists "./wave.do"] } {
   do ./wave.do
}

# Run simulation
run -all
wave zoomfull