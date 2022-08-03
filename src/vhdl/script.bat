ghdl -a shift_amount.vhdl
ghdl -a add_inner.vhdl
ghdl -a add_outer.vhdl
ghdl -a sub_inner.vhdl
ghdl -a sub_outer.vhdl
ghdl -a add.vhdl
ghdl -a sub.vhdl
ghdl -a mul_inner.vhdl
ghdl -a mul_outer.vhdl
ghdl -a alu.vhdl
ghdl -a test_alu.vhdl
ghdl -e test_alu
ghdl -r test_alu --vcd=test_alu.vcd