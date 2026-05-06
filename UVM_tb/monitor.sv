class monitor extends uvm_monitor;
  `uvm_component_utils(monitor)
  function new(string name="monitor", uvm_component parent=null);
    super.new(name, parent);
  endfunction


  uvm_analysis_port  #(item) mon_analysis_port_in;
  uvm_analysis_port  #(item) mon_analysis_port_out;
  virtual ialu_if vif;

  int xact_counter = 0;
  logic [`SCR1_XLEN-1:0] prev_op1 = 0;
  logic [`SCR1_XLEN-1:0] prev_op2 = 0;

  type_scr1_ialu_cmd_sel_e prev_command;

  semaphore vld_lock = new(0);

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual ialu_if)::get(this, "", "ialu_vif", vif))
      `uvm_fatal("MON", "Could not get vif")
      mon_analysis_port_in = new("mon_analysis_port_in", this);
      mon_analysis_port_out = new("mon_analysis_port_out", this);
  endfunction


  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
        fork
          forever begin
            @(posedge vif.clk)
            if (!vif.rst_n) begin
             // vld_lock.put(1);

            end
          end
          forever begin
            @(posedge vif.clk)
            if (type_scr1_ialu_cmd_sel_e'(vif.exu2ialu_cmd_i) inside {ext_list}) begin
              if (vif.exu2ialu_rvm_cmd_vd_i) begin 
                item m_item = item::type_id::create("m_item");
                m_item.main_op1 = vif.exu2ialu_main_op1_i;
                m_item.main_op2 = vif.exu2ialu_main_op2_i;
                m_item.command  = type_scr1_ialu_cmd_sel_e'(vif.exu2ialu_cmd_i);
                m_item.xact_num = xact_counter;
                mon_analysis_port_in.write(m_item); 
                xact_counter++ ;
                vld_lock.get(1);
              end
            end
          end
          forever begin
            @(posedge vif.clk)
            if (type_scr1_ialu_cmd_sel_e'(vif.exu2ialu_cmd_i) inside {ext_list}) begin
              if (vif.ialu2exu_rvm_res_rdy_o & vif.exu2ialu_rvm_cmd_vd_i) begin
                item m_item;
                m_item = item::type_id::create("m_item");
                m_item.main_res = vif.ialu2exu_main_res_o;
                mon_analysis_port_out.write(m_item);  
                vld_lock.put(1);
              end
            end
          end
          forever begin
          if (!(type_scr1_ialu_cmd_sel_e'(vif.exu2ialu_cmd_i) inside {ext_list})) begin
              if ((vif.exu2ialu_main_op1_i != prev_op1) || (vif.exu2ialu_main_op2_i != prev_op2) || (vif.exu2ialu_cmd_i != prev_command)) begin
                item m_item = item::type_id::create("m_item");
                m_item.main_op1 = vif.exu2ialu_main_op1_i;
                m_item.main_op2 = vif.exu2ialu_main_op2_i;
                m_item.command  = type_scr1_ialu_cmd_sel_e'(vif.exu2ialu_cmd_i);
                m_item.main_res = vif.ialu2exu_main_res_o;
                m_item.comp_res = vif.ialu2exu_cmp_res_o;
                m_item.xact_num = xact_counter;
                prev_op1 = vif.exu2ialu_main_op1_i;
                prev_op2 = vif.exu2ialu_main_op2_i;
                prev_command = type_scr1_ialu_cmd_sel_e'(vif.exu2ialu_cmd_i);
                mon_analysis_port_out.write(m_item);    
                xact_counter++ ;      
              end
            end
            #1;
          end
        join
  endtask

endclass
