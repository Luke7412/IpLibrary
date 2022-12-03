################################################################################
# Compile script
################################################################################

quietly set RTL_PATH "../src"
quietly set TB_PATH "../tb"
quietly set LIBRARY "work"
quietly set TOP_TB "uart_tb"

file delete -force $LIBRARY

vlib $LIBRARY

vlog -64 -sv -incr -work $LIBRARY -f files.f -outf outf.f


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

vsim -t ps -lib $LIBRARY $TOP_TB_OPT

#set NumericStdNoWarnings 1
#set StdArithNoWarnings 1

# Load wave if exists
if { [file exists "./wave.do"] } {
   do ./wave.do
}

# Run simulation
run -all
wave zoomfull