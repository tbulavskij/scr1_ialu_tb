class monitor_rst extends uvm_monitor;
  `uvm_component_utils(monitor_rst)
  function new(string name="monitor_rst", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  uvm_analysis_port  #(item_rst) mon_rst_analysis_port;
  virtual ialu_if vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual ialu_if)::get(this, "", "ialu_vif", vif))
      `uvm_fatal("MON_R", "Could not get vif")
    mon_rst_analysis_port = new("mon_rst_analysis_port", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item_rst m_item;
      @(vif.rst_n);
      m_item = item_rst::type_id::create("m_item");
      m_item.rst_val = vif.rst_n;
      mon_rst_analysis_port.write(m_item);
	  end
  endtask
endclass