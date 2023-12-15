# IpLibrary
Library containing various VHDL IPs


## Running SVUnit
```bash
# Activate python venv
.venv/Scripts/Activate.ps1

# Navigate to sim dir
cd tb/sim

# Run in Gui Mode
RunSVUnit -s modelsim -o sim -f sim.f 

# Run in Console Mode
runsvunit -s modelsim -o sim -f sim.f -r="-c"
```
