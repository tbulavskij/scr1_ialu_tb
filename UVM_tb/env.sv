class env extends uvm_env;
  `uvm_component_utils(env)
  function new(string name="env", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  agent 		a0; 	
  agent_rst a_rst;
  scoreboard	sb0;
  coverage_collector cc0; 	

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    a0 = agent::type_id::create("a0", this);
    a_rst = agent_rst::type_id::create("a_rst", this);
    sb0 = scoreboard::type_id::create("sb0", this);
    cc0 = coverage_collector::type_id::create("cc0", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    a0.m0.mon_analysis_port_in.connect(sb0.m_analysis_imp_main_in);
    a0.m0.mon_analysis_port_out.connect(sb0.m_analysis_imp_main_out);
    a_rst.m_rst.mon_rst_analysis_port.connect(sb0.m_analysis_imp_rst);

    a0.m0.mon_analysis_port_in.connect(cc0.m_analysis_imp_main_in);
    a0.m0.mon_analysis_port_out.connect(cc0.m_analysis_imp_main_out);
    a_rst.m_rst.mon_rst_analysis_port.connect(cc0.m_analysis_imp_rst);

  endfunction
endclass