class item_rst extends item;
  `uvm_object_utils(item_rst)

    rand int rst_delay;
    rand int rst_duration;

  function new(string name = "item_rst");
    super.new();
  endfunction

  constraint item_c{
    rst_delay      inside {[80: 100]};
    rst_duration   inside {[1: 10]};
  }

  virtual function string convert2string();
    return $sformatf("delay = %0d, duration = %0d", rst_delay, rst_duration);
  endfunction
endclass