`ifndef BASE_SEQUENCE_SV
`define BASE_SEQUENCE_SV
class Base_sequence extends uvm_sequence #(Input_item);
  `uvm_object_utils(Base_sequence)
  
  parameter DATA_WIDTH = 8;
  parameter DEPTH = 8;

  Input_item seq_item;
  logic [DATA_WIDTH - 1 : 0] data_pool[];

  int test_done;

  function new(string name = "Main_sequence");
    super.new(name);
  endfunction

  virtual task body();
  endtask
endclass
`endif // BASE_SEQUENCE_SV