################################################################################
# Compile script
################################################################################

quietly set RTL_PATH "../rtl"
quietly set TB_PATH "../tb"
quietly set LIBRARY "lvin_Axi4Stream_Broadcaster_v1_0"
quietly set TOP_TB "Broadcaster_tb"

file delete -force $LIBRARY

vlib $LIBRARY

vcom -93 -quiet +acc -work $LIBRARY \
   $RTL_PATH/Broadcaster.vhd \
   $TB_PATH/Broadcaster_tb.vhd



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

# Get local wave file (under out/tcXXX). f that doesn't exist, do nothing
quietly set wave_found "true"

if { [file exists "./wave.do"] } {
  do ./wave.do
} else {
  echo "No wave.do file found, not running the simulation."
  echo "Either drag 'n drop signals to the wave and type 'run -all' in the\
        transcript or save the wave file (as wave.do) and rerun this script\
        entirely."
  quietly set wave_found "false"
}

# Only run simulation if something was added to the wave window
if {$wave_found == "true"} {
  run -all

  # fit
  wave zoomfull
}