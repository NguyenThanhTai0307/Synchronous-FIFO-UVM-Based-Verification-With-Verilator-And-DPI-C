`ifndef INPUT_ITEM_SV
`define INPUT_ITEM_SV
class Input_item extends uvm_sequence_item;
  `uvm_object_utils(Input_item)

  parameter DATA_WIDTH = 8;

  rand bit rd_en, wr_en;
  rand bit rstn;
  rand bit [DATA_WIDTH - 1 : 0] din;
  

  function new(string name = "Input_item");
    super.new(name);
  endfunction
  
  constraint c_wr { wr_en dist {1 := 50, 0 := 50}; }
  constraint c_rd { rd_en dist {1 := 50, 0 := 50}; }
  constraint c_rs { rstn dist {1 := 80, 0 := 20}; }

/*  function void print(string tag = "WRITE");
    `uvm_info(get_type_name(), $sformatf("[%s] --> ADDR : 0x%0h || DIN : 0x%0h",
     tag, addr, din), UVM_LOW)
  endfunction
*/
endclass
`endif // INPUT_ITEM_SV