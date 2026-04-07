 class coverage_collector extends uvm_component;
  `uvm_component_utils(coverage_collector);

   `uvm_analysis_imp_decl(_port_main_in)
   `uvm_analysis_imp_decl(_port_main_out)  

   uvm_analysis_imp_port_main_in  #(item, coverage_collector) m_analysis_imp_main_in;
   uvm_analysis_imp_port_main_out #(item, coverage_collector) m_analysis_imp_main_out;

  covergroup cg with function sample(item m_item); 
    cp_op1: coverpoint m_item.main_op1 {
      bins lo  = {'0};
      bins mid = {['0 + 1:'1 - 1]};
      bins hi  = {'1};
    }
    cp_op2: coverpoint m_item.main_op2 {
      bins lo  = {'0};
      bins mid = {['0 + 1:'1 - 1]};
      bins hi  = {'1};
    }
    cp_main_res:coverpoint m_item.main_res {
      bins lo  = {'0};
      bins mid = {['0 + 1:'1 - 1]};
      bins hi  = {'1};
    }
    cp_comp_res:coverpoint m_item.comp_res {
      bins lo  = {'0};
      bins hi  = {'1};
    }
    cp_comm: coverpoint m_item.command {
    `ifdef SCR1_RVM_EXT
      bins  EXT =  { SCR1_IALU_CMD_MUL,      // low(unsig(op1) * unsig(op2))
                     SCR1_IALU_CMD_MULHU,    // high(unsig(op1) * unsig(op2))  
                     SCR1_IALU_CMD_MULHSU,   // high(op1 * unsig(op2))   
                     SCR1_IALU_CMD_MULH,     // high(op1 * op2)   
                     SCR1_IALU_CMD_DIV,      // op1 / op2
                     SCR1_IALU_CMD_DIVU,     // op1 u/ op2
                     SCR1_IALU_CMD_REM,      // op1 % op2
                     SCR1_IALU_CMD_REMU };   // op1 u% op2
    `endif

      bins MAIN = { SCR1_IALU_CMD_AND,         // op1 & op2
                    SCR1_IALU_CMD_OR,          // op1 | op2
                    SCR1_IALU_CMD_XOR,         // op1 ^ op2
                    SCR1_IALU_CMD_ADD,         // op1 + op2
                    SCR1_IALU_CMD_SUB,         // op1 - op2
                    SCR1_IALU_CMD_SLL,         // op1 << op2
                    SCR1_IALU_CMD_SRL,         // op1 >> op2
                    SCR1_IALU_CMD_SRA };       // op1 >>> op2

      bins COMP = { SCR1_IALU_CMD_SUB_LT,       // op1 < op2
                    SCR1_IALU_CMD_SUB_LTU,      // op1 u< op2
                    SCR1_IALU_CMD_SUB_EQ,       // op1 = op2
                    SCR1_IALU_CMD_SUB_NE,       // op1 != op2
                    SCR1_IALU_CMD_SUB_GE,       // op1 >= op2
                    SCR1_IALU_CMD_SUB_GEU };    // op1 u>= op2

       bins NONE = {SCR1_IALU_CMD_NONE};        // IALU disable  
    }

    cp_main_cross: cross cp_op1, cp_op2, cp_main_res, cp_comm {bins c_main = binsof(cp_comm.MAIN);}   
    cp_comp_cross: cross cp_op1, cp_op2, cp_comp_res, cp_comm {bins c_main = binsof(cp_comm.COMP);}
   

  endgroup

  function new(string name="coverage_collector", uvm_component parent=null);
    super.new(name, parent);
    cg = new();
    m_analysis_imp_main_in = new("m_analysis_imp_main_in", this);
    m_analysis_imp_main_out = new("m_analysis_imp_main_out", this);
  endfunction

  virtual function void write_port_main_in(item m_item);
    cg.sample(m_item);
  endfunction

  virtual function void write_port_main_out(item m_item);
    cg.sample(m_item);
  endfunction


virtual function void report_phase(uvm_phase phase);
  `uvm_info("CoverageReport", $sformatf({"\n\n", 
    "   Functional Coverage    = %.2f\n",
    "   1. Main coverage       = %.2f\n",
    "   2. Comp coverage       = %.2f\n" }, 
    cg.get_coverage(),
    cg.cp_main_cross.get_coverage(),
    cg.cp_comp_cross.get_coverage()), UVM_LOW)
  endfunction

endclass