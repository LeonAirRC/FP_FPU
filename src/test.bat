ghdl -e test_alu
ghdl -r test_alu --vcd=test_alu.vcd
gtkwave test_alu.vcd