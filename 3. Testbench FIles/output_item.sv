`ifndef OUTPUT_ITEM_SV
`define OUTPUT_ITEM_SV
class Output_item extends uvm_sequence_item;
  `uvm_object_utils(Output_item)

  parameter DATA_WIDTH = 8;

  logic [DATA_WIDTH - 1 : 0] dout;
  logic [DATA_WIDTH - 1 : 0] din;
  logic rstn, rd_en, wr_en;
  logic full, empty;

  function new(string name = "Output_item");
    super.new(name);
  endfunction

  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    Output_item _rhs;
    bit status;

    status = super.do_compare(rhs, comparer);

    if ($cast(_rhs, rhs) == 0) begin
      `uvm_error(get_type_name(), "Compare Fail: Cast failed");
      return 0;
    end

    return status && 
           (this.dout == _rhs.dout) && 
           (this.full == _rhs.full) && 
           (this.empty == _rhs.empty);
  endfunction

/*function void print(string tag = "READ");
    `uvm_info(get_type_name(), $sformatf("[%0s] ADDR : 0x%0h || DOUT : 0x%0h",
     tag, addr, dout), UVM_LOW);
  endfunction
*/ 
endclass
`endif // OUTPUT_ITEM_SV
