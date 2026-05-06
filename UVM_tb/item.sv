class item extends uvm_sequence_item;
  `uvm_object_utils(item)

  rand logic [`SCR1_XLEN-1:0]   main_op1;
  rand logic [`SCR1_XLEN-1:0]   main_op2;
  logic      [`SCR1_XLEN-1:0]   main_res;
  logic                         comp_res;
  rand type_scr1_ialu_cmd_sel_e command;

  rand logic [`SCR1_XLEN-1:0]   addr_op1;
  rand logic [`SCR1_XLEN-1:0]   addr_op2;
  logic      [`SCR1_XLEN-1:0]   addr_res; 

  bit rst_val;

  rand int xact_delay;
  int xact_num;

  function new(string name = "item");
    super.new();
  endfunction

  constraint item_c{
    xact_delay dist {1:=20, [1:5]:/80};
    main_op1 inside {[500:1000]};
    main_op2 inside {[0:500]};
   //(command inside { SCR1_IALU_CMD_MULHU});
  }

  virtual function string convert2string();
    return $sformatf("op1 = %0d, op2 = %0d, command = %0s, main_res = %d, comp_res = %0d", main_op1, main_op2, command, main_res, comp_res);
  endfunction
endclass
