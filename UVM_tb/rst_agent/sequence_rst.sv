class sequence_rst extends uvm_sequence;
  `uvm_object_utils(sequence_rst)
  function new(string name="sequence_rst");
    super.new(name);
  endfunction

  virtual task body();
    forever begin
      item_rst m_item = item_rst::type_id::create("m_item");
      start_item(m_item);
      void'(m_item.randomize());
      finish_item(m_item);
      #1;
    end
  endtask
endclass