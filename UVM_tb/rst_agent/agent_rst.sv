class agent_rst extends uvm_agent;
  `uvm_component_utils(agent_rst)
  function new(string name="agent_rst", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  driver_rst 		d_rst; 		
  monitor_rst 	m_rst; 	
  uvm_sequencer #(item_rst)	s_rst; 		

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    s_rst = uvm_sequencer#(item_rst)::type_id::create("s_rst", this);
    d_rst = driver_rst::type_id::create("d_rst", this);
    m_rst = monitor_rst::type_id::create("m_rst", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    d_rst.seq_item_port.connect(s_rst.seq_item_export);
  endfunction
endclass 