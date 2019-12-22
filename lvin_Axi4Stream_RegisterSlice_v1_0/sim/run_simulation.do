################################################################################
# Compile script
################################################################################

quietly set RTL_PATH "../rtl"
quietly set TB_PATH "../tb"
quietly set LIBRARY "lvin_Axi4Stream_RegisterSlice_v1_0"
quietly set TOP_TB "RegisterSlice"

file delete -force $LIBRARY

vlib $LIBRARY

vcom -93 -quiet +acc -work $LIBRARY \
   $RTL_PATH/RegisterSlice.vhd \
   $TB_PATH/RegisterSlice_tb.vhd


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