class scoreboard extends uvm_scoreboard;
  `uvm_component_utils(scoreboard)
  function new(string name="scoreboard", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  `uvm_analysis_imp_decl(_port_main_in) 
  `uvm_analysis_imp_decl(_port_main_out) 
  `uvm_analysis_imp_decl(_port_rst)  

  uvm_analysis_imp_port_main_in #(item, scoreboard) m_analysis_imp_main_in;
  uvm_analysis_imp_port_main_out #(item, scoreboard) m_analysis_imp_main_out;

  item item_queue[$];

  logic [`SCR1_XLEN*2 - 1:0] mul_res;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_analysis_imp_main_in = new("m_analysis_imp_main_in", this);
    m_analysis_imp_main_out = new("m_analysis_imp_main_out", this);
  endfunction

  virtual function void write_port_main_in(item m_item);
    item_queue.push_back(m_item);
  endfunction

  virtual function void write_port_main_out(item m_item);
    if (item_queue.size() > 0) begin
      m_item.main_op1 = item_queue[0].main_op1;
      m_item.main_op2 = item_queue[0].main_op2;
      m_item.command  = item_queue[0].command;
      m_item.xact_num = item_queue[0].xact_num;
      void'(item_queue.pop_front());   
    end
    else begin
      if  (type_scr1_ialu_cmd_sel_e'(m_item.command) inside {ext_list}) begin
        `uvm_fatal("SB", $sformatf("Invalid input data\n%s", m_item.convert2string()))
      end
    end

    `uvm_info("SB" , $sformatf("Received xact # %d  \n%s", m_item.xact_num, m_item.convert2string()), UVM_LOW)

    case(m_item.command) 
      SCR1_IALU_CMD_NONE: begin
        void'(item_queue.pop_front());
      end
      SCR1_IALU_CMD_AND: begin
        if ((m_item.main_op1 & m_item.main_op2) != m_item.main_res) begin 
          `uvm_fatal("SB", $sformatf("AND is incorrect\n%s,  expected: %d", m_item.convert2string(), (m_item.main_op1 & m_item.main_op2)));
        end
      end
      SCR1_IALU_CMD_OR: begin
        if ((m_item.main_op1 | m_item.main_op2) != m_item.main_res) begin
          `uvm_fatal("SB", $sformatf("OR is incorrect\n%s,  expected: %d", m_item.convert2string(), (m_item.main_op1 | m_item.main_op2)));
        end
      end
      SCR1_IALU_CMD_XOR: begin
        if ((m_item.main_op1 ^ m_item.main_op2) != m_item.main_res) begin
          `uvm_fatal("SB", $sformatf("XOR is incorrect\n%s,  expected: %d", m_item.convert2string(), (m_item.main_op1 ^ m_item.main_op2)));
        end
      end
      SCR1_IALU_CMD_ADD: begin
        if ((m_item.main_op1 + m_item.main_op2) != m_item.main_res) begin
          `uvm_fatal("SB", $sformatf("ADD is incorrect\n%s,  expected: %d", m_item.convert2string(), (m_item.main_op1 + m_item.main_op2)));
        end
      end
      SCR1_IALU_CMD_SUB: begin
        if ((m_item.main_op1 - m_item.main_op2) != m_item.main_res) begin
          `uvm_fatal("SB", $sformatf("SUB is incorrect\n%s,  expected: %d", m_item.convert2string(), (m_item.main_op1 - m_item.main_op2)));
        end
      end
      SCR1_IALU_CMD_SUB_LT: begin
        if (($signed(m_item.main_op1) < $signed(m_item.main_op2)) != m_item.comp_res) begin
          `uvm_fatal("SB", $sformatf("SUB_LT is incorrect\n%s,  expected: %d", m_item.convert2string(), ( $signed(m_item.main_op1) < $signed(m_item.main_op2))));
        end
      end
      SCR1_IALU_CMD_SUB_LTU: begin
        if (($unsigned(m_item.main_op1) < $unsigned(m_item.main_op2)) != m_item.comp_res) begin
          `uvm_fatal("SB", $sformatf("SUB_LTU is incorrect\n%s,  expected: %d", m_item.convert2string(), ($unsigned(m_item.main_op1) < $unsigned(m_item.main_op2))));
        end
      end
      SCR1_IALU_CMD_SUB_EQ: begin
        if ((m_item.main_op1 == m_item.main_op2) != m_item.comp_res) begin
          `uvm_fatal("SB", $sformatf("SUB_EQ is incorrect\n%s,  expected: %d", m_item.convert2string(), (m_item.main_op1 == m_item.main_op2)));
        end
      end
      SCR1_IALU_CMD_SUB_NE: begin
         if ((m_item.main_op1 != m_item.main_op2) != m_item.comp_res) begin
          `uvm_fatal("SB", $sformatf("SUB_NE is incorrect\n%s,  expected: %d", m_item.convert2string(), (m_item.main_op1 != m_item.main_op2)));
        end
      end
      SCR1_IALU_CMD_SUB_GE: begin
        if (($signed(m_item.main_op1) >= $signed(m_item.main_op2)) != m_item.comp_res) begin
          `uvm_fatal("SB", $sformatf("SUB_GE is incorrect\n%s,  expected: %d", m_item.convert2string(), ($signed(m_item.main_op1) >= $signed(m_item.main_op2))));
        end
      end
      SCR1_IALU_CMD_SUB_GEU: begin
        if (($unsigned(m_item.main_op1) >= $unsigned(m_item.main_op2)) != m_item.comp_res) begin
          `uvm_fatal("SB", $sformatf("SUB_GEU is incorrect\n%s,  expected: %d", m_item.convert2string(), ($unsigned(m_item.main_op1) >= $unsigned(m_item.main_op2))));
        end
      end
      SCR1_IALU_CMD_SLL: begin
        if ((m_item.main_op1 << (m_item.main_op2 % `SCR1_XLEN)) != m_item.main_res) begin
          `uvm_fatal("SB", $sformatf("SLL is incorrect\n%s,  expected: %d", m_item.convert2string(), (m_item.main_op1 << (m_item.main_op2 % `SCR1_XLEN))));
        end
      end
      SCR1_IALU_CMD_SRL: begin
        if ((m_item.main_op1 >> (m_item.main_op2 % `SCR1_XLEN)) != m_item.main_res) begin
          `uvm_fatal("SB", $sformatf("SRL is incorrect\n%s,  expected: %d", m_item.convert2string(), (m_item.main_op1 >> (m_item.main_op2 % `SCR1_XLEN))));
        end
      end
      SCR1_IALU_CMD_SRA: begin
        if ((m_item.main_op1 >>> (m_item.main_op2 % `SCR1_XLEN)) != m_item.main_res) begin
          `uvm_fatal("SB", $sformatf("SRA is incorrect\n%s,  expected: %d", m_item.convert2string(), (m_item.main_op1 >>> (m_item.main_op2 % `SCR1_XLEN))));
        end
      end
    `ifdef SCR1_RVM_EXT
      SCR1_IALU_CMD_MUL: begin
        if (($unsigned(m_item.main_op1) * $unsigned(m_item.main_op2)) != m_item.main_res) begin 
          `uvm_fatal("SB", $sformatf("MUL is incorrect\n%s,  expected: %d", m_item.convert2string(), ($unsigned(m_item.main_op1) * $unsigned(m_item.main_op2))));
        end
      end
      SCR1_IALU_CMD_MULHU: begin
        mul_res = $unsigned(m_item.main_op1) * $unsigned(m_item.main_op2); 
        if ((mul_res[`SCR1_XLEN*2-1:`SCR1_XLEN]) != m_item.main_res) begin
          `uvm_fatal("SB", $sformatf("MULHU is incorrect\n%s,  expected: %d", m_item.convert2string(), (mul_res[`SCR1_XLEN*2-1:`SCR1_XLEN])));
        end
      end
      SCR1_IALU_CMD_MULHSU: begin
        mul_res = $signed(m_item.main_op1) * $unsigned(m_item.main_op2);
        if ((mul_res[`SCR1_XLEN*2-1:`SCR1_XLEN]) != m_item.main_res) begin // TODO fix bug
          `uvm_fatal("SB", $sformatf("MULHSU is incorrect\n%s,,  expected: %d", m_item.convert2string(), (mul_res[`SCR1_XLEN*2-1:`SCR1_XLEN])));
        end
      end
      SCR1_IALU_CMD_MULH: begin
        mul_res = m_item.main_op1 * m_item.main_op2;
        if ((mul_res[`SCR1_XLEN*2-1:`SCR1_XLEN]) != m_item.main_res) begin //TODO fix bug
          `uvm_fatal("SB", $sformatf("MULH is incorrect\n%s,  expected: %d", m_item.convert2string(), (mul_res[`SCR1_XLEN*2-1:`SCR1_XLEN])));
        end
      end
      SCR1_IALU_CMD_DIV: begin
        if (m_item.main_op2 == '0) begin
          if (m_item.main_res != '1) begin
            `uvm_fatal("SB", $sformatf("DIV by 0 is incorrect\n%s,  expected: %d", m_item.convert2string(), ('1)));
          end
        end
        else begin
          if ((m_item.main_op1 / m_item.main_op2) != m_item.main_res) begin
            `uvm_fatal("SB", $sformatf("DIV is incorrect\n%s,  expected: %d", m_item.convert2string(), ((m_item.main_op1 / m_item.main_op2))));
          end
        end
      end
      SCR1_IALU_CMD_DIVU: begin
        if (m_item.main_op2 == '0) begin
          if (m_item.main_res != '1) begin
            `uvm_fatal("SB", $sformatf("DIV by 0 is incorrect\n%s,  expected: %d", m_item.convert2string(), ('1)));
          end
        end
        else begin
          if (($unsigned(m_item.main_op1) / $unsigned(m_item.main_op2)) != m_item.main_res) begin
          `uvm_fatal("SB", $sformatf("DIV is incorrect\n%s,  expected: %d", m_item.convert2string(), ($unsigned(m_item.main_op1) / $unsigned(m_item.main_op2))));
          end  
        end
      end
      SCR1_IALU_CMD_REM: begin
         if ((m_item.main_op1 % m_item.main_op2) != m_item.main_res) begin
          `uvm_fatal("SB", $sformatf("REM is incorrect\n%s,  expected: %d", m_item.convert2string(), (m_item.main_op1 % m_item.main_op2)));
        end     
      end
      SCR1_IALU_CMD_REMU: begin
        if (($unsigned(m_item.main_op1) % $unsigned(m_item.main_op2)) != m_item.main_res) begin
          `uvm_fatal("SB", $sformatf("REMU is incorrect\n%s,  expected: %d", m_item.convert2string(), ($unsigned(m_item.main_op1) % $unsigned(m_item.main_op2))));
        end
      end 
    `endif
    default: begin
      `uvm_error("SB(out)",$sformatf("Unidentified xact - %s", m_item.convert2string()));
      void'(item_queue.pop_front());
    end
    endcase

  endfunction

endclass