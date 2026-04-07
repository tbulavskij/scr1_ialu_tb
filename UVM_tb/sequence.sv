class sequence1 extends uvm_sequence;
  `uvm_object_utils(sequence1)
  function new(string name="sequence1");
    super.new(name);
  endfunction

  rand int item_num ;
  
  constraint c1 {item_num inside {[100:500]};}

  virtual task body();
    if ($value$plusargs("ITEM_NUM=%d", item_num)) begin
      `uvm_info("SEQ", $sformatf("Start generation of %0d items(plusarg)", item_num), UVM_LOW)
    end
    else begin
      `uvm_info("SEQ", $sformatf("Start generation of %0d items(constraint)", item_num), UVM_LOW)
    end
    for (int i = 0; i < item_num; i++) begin
    	item m_item = item::type_id::create("m_item");
    	start_item(m_item);
    	void'(m_item.randomize());
      finish_item(m_item);
    end
    `uvm_info("SEQ", $sformatf("Done generation of %0d items", item_num), UVM_LOW)
  endtask
endclass