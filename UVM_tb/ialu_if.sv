`include "scr1/src/includes/scr1_arch_description.svh"
`include "scr1/src/includes/scr1_riscv_isa_decoding.svh"
  `define SCR1_RVM_EXT

interface ialu_if();
  `ifdef SCR1_RVM_EXT
    logic                           clk;                        // IALU clock
    logic                           rst_n;                      // IALU reset
    logic                           exu2ialu_rvm_cmd_vd_i;      // MUL/DIV command valid
    logic                           ialu2exu_rvm_res_rdy_o;     // MUL/DIV result ready
  `endif // SCR1_RVM_EXT

    // Main adder  
    logic [`SCR1_XLEN-1:0]          exu2ialu_main_op1_i;        // main ALU 1st operand
    logic [`SCR1_XLEN-1:0]          exu2ialu_main_op2_i;        // main ALU 2nd operand
    type_scr1_ialu_cmd_sel_e        exu2ialu_cmd_i;             // IALU command
    logic [`SCR1_XLEN-1:0]          ialu2exu_main_res_o;        // main ALU result
    logic                           ialu2exu_cmp_res_o;         // IALU comparison result

    // Address adder
    logic [`SCR1_XLEN-1:0]          exu2ialu_addr_op1_i;        // Address adder 1st operand
    logic [`SCR1_XLEN-1:0]          exu2ialu_addr_op2_i;        // Address adder 2nd operand
    logic [`SCR1_XLEN-1:0]          ialu2exu_addr_res_o;        // Address adder result

endinterface
