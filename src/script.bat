ghdl -a vhdl/shift_amount.vhdl
ghdl -a vhdl/add_inner.vhdl
ghdl -a vhdl/add_outer.vhdl
ghdl -a vhdl/sub_inner.vhdl
ghdl -a vhdl/sub_outer.vhdl
ghdl -a vhdl/add.vhdl
ghdl -a vhdl/sub.vhdl
ghdl -a vhdl/mul_inner.vhdl
ghdl -a vhdl/mul_outer.vhdl
ghdl -a vhdl/alu.vhdl
ghdl -a vhdl/test_alu.vhdl
ghdl -e test_alu
ghdl -r test_alu --vcd=test_alu.vcd