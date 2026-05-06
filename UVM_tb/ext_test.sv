class ext_test extends uvm_test;
  `uvm_component_utils(ext_test)
  function new(string name = "ext_test", uvm_component parent=null);
    super.new(name, parent);
  endfunction

  env  				     e0;
  sequence1 		   seq;
  sequence_rst     seq_rst;
  virtual	ialu_if  vif;

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    e0 = env::type_id::create("e0", this);

    if (!uvm_config_db#(virtual ialu_if)::get(this, "", "ialu_vif", vif))
      `uvm_fatal("TEST", "Did not get vif")
    uvm_config_db#(virtual ialu_if)::set(this, "e0.a0.*", "ialu_vif", vif);

    seq = sequence1::type_id::create("seq");
    seq.randomize();

    seq_rst = sequence_rst::type_id::create("seq_rst");
    seq_rst.randomize();
    
  endfunction

  virtual task run_phase(uvm_phase phase);
     phase.raise_objection(this);
    fork 
      seq.start(e0.a0.s0);
      seq_rst.start(e0.a_rst.s_rst);
    join_any
    phase.drop_objection(this);
  endtask
endclass