class driver_rst extends uvm_driver #(item_rst);
  `uvm_component_utils(driver_rst)

  function new(string name = "driver_rst", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  virtual ialu_if vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual ialu_if)::get(this, "", "ialu_vif", vif)) begin
      `uvm_fatal("DRV(rst)", "Could not get vif")
    end
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      item_rst m_item;
      seq_item_port.get_next_item(m_item);
      //`uvm_info("DRV_rst", "check", UVM_LOW)
      drive_item(m_item);
      seq_item_port.item_done();
    end
  endtask

  virtual task drive_item(item_rst m_item);
    vif.rst_n = 0;
    //vif.exu2ialu_rvm_cmd_vd_i = 0;
    for (int i = 0; i < m_item.rst_duration; i++) begin
      @(posedge vif.clk);
    end
    vif.rst_n = 1;
    for (int i = 0; i < m_item.rst_delay; i++) begin
      @(posedge vif.clk);
    end
  endtask
endclass