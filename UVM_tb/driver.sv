class driver extends uvm_driver #(item);
  `uvm_component_utils(driver)

  function new(string name = "driver", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual ialu_if vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual ialu_if)::get(this, "", "ialu_vif", vif)) begin
      `uvm_fatal("DRV", "Could not get vif")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item m_item;
      seq_item_port.get_next_item(m_item);
      drive_item(m_item);
      seq_item_port.item_done();
    end
  endtask

  virtual task drive_item(item m_item);
      if (m_item.command inside {ext_list}) begin
        @(posedge vif.clk);
        if (vif.rst_n) begin  //TODO
          vif.exu2ialu_rvm_cmd_vd_i <= 1;
        end
        vif.exu2ialu_main_op1_i <= m_item.main_op1;
        vif.exu2ialu_main_op2_i <= m_item.main_op2;
        vif.exu2ialu_cmd_i <= ialu_if_sv_unit::type_scr1_ialu_cmd_sel_e'(m_item.command);
        forever begin
          @(posedge vif.clk);
          if (vif.ialu2exu_rvm_res_rdy_o) begin
            break;
          end
      end
          vif.exu2ialu_rvm_cmd_vd_i <= 0;                     
        for (int i = 0; i < m_item.xact_delay; i++) begin
          @(posedge vif.clk);
        end 
      end
      else begin
        vif.exu2ialu_main_op1_i = m_item.main_op1;
        vif.exu2ialu_main_op2_i = m_item.main_op2;
        vif.exu2ialu_cmd_i = ialu_if_sv_unit::type_scr1_ialu_cmd_sel_e'(m_item.command);
        for (int i = 0; i < m_item.xact_delay; i++) begin
          #1;
        end 
      end
  endtask
endclass