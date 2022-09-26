ghdl -e test_au
ghdl -r test_au --vcd=test_au.vcd
gtkwave test_au.vcd