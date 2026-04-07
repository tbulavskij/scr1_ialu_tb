package ialu_pkg;
  `include "uvm_macros.svh"
  import uvm_pkg::*;
  `include "scr1/src/includes/scr1_arch_description.svh"
  `include "scr1/src/includes/scr1_riscv_isa_decoding.svh"
  

  localparam type_scr1_ialu_cmd_sel_e ext_list [3:0] = '{
                                                        //SCR1_IALU_CMD_MUL, SCR1_IALU_CMD_MULHU, SCR1_IALU_CMD_MULHSU, SCR1_IALU_CMD_MULH,
                                                        SCR1_IALU_CMD_DIV, SCR1_IALU_CMD_DIVU, SCR1_IALU_CMD_REM, SCR1_IALU_CMD_REMU
                                                        };
  `define SCR1_RVM_EXT

  `include "item.sv"
  `include "sequence.sv"
  `include "driver.sv"
  `include "monitor.sv"
  `include "scoreboard.sv"
  `include "agent.sv"
  `include "coverage_collector.sv"
  `include "env.sv"
  `include "ext_test.sv"

endpackage : ialu_pkg
