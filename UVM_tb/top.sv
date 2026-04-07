import ialu_pkg::*;
import uvm_pkg::*;

module tb_top;
  `define SCR1_RVM_EXT

  bit clk = 0;
  
  always #10 clk = ~clk;

  ialu_if _if();

`ifdef SCR1_RVM_EXT
  assign _if.clk = clk;
`endif 

  scr1_pipe_ialu u0 (
                  `ifdef SCR1_RVM_EXT
                    .clk                   (_if.clk),
                    .rst_n                 (_if.rst_n),
                    .exu2ialu_rvm_cmd_vd_i (_if.exu2ialu_rvm_cmd_vd_i),
                    .ialu2exu_rvm_res_rdy_o(_if.ialu2exu_rvm_res_rdy_o),
                  `endif 
                    .exu2ialu_main_op1_i   (_if.exu2ialu_main_op1_i),
                    .exu2ialu_main_op2_i   (_if.exu2ialu_main_op2_i),
                    .exu2ialu_cmd_i        (_if.exu2ialu_cmd_i),
                    .ialu2exu_main_res_o   (_if.ialu2exu_main_res_o),
                    .ialu2exu_cmp_res_o    (_if.ialu2exu_cmp_res_o),

                    .exu2ialu_addr_op1_i   (_if.exu2ialu_addr_op1_i),
                    .exu2ialu_addr_op2_i   (_if.exu2ialu_addr_op2_i),
                    .ialu2exu_addr_res_o   (_if.ialu2exu_addr_res_o)
                  );

  initial begin
    uvm_config_db #(virtual ialu_if)::set(null, "uvm_test_top*", "ialu_vif", _if);
    run_test();
  end
endmodule