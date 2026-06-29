`ifndef FIFO_BASE_SEQ_SV
`define FIFO_BASE_SEQ_SV

class Fifo_base_seq extends Base_sequence;
  `uvm_object_utils(Fifo_base_seq)
  
  function new(string name = "Fifo_base_seq");
    super.new(name);
  endfunction

  virtual task drive_tx(bit r_rstn, bit r_wr_en, bit r_rd_en, logic [DATA_WIDTH-1:0] r_din);
    seq_item = Input_item::type_id::create("seq_item");
    seq_item.c_wr.constraint_mode(0);
    seq_item.c_rd.constraint_mode(0);
    seq_item.c_rs.constraint_mode(0);
    
    wait_for_grant();
    if(seq_item.randomize() with {
      rstn == r_rstn;
      wr_en == r_wr_en;
      rd_en == r_rd_en;
      din == r_din;
    } == 0) begin
      `uvm_fatal(get_type_name(), $sformatf("Randomization Failed!"))
    end
    send_request(seq_item);
    wait_for_item_done();
  endtask

  virtual task pre_body();
    data_pool = new[DEPTH];
    foreach (data_pool[i]) data_pool[i] = 8'(i);
    data_pool.shuffle();
    test_done = 0;
  endtask
endclass
`endif // FIFO_BASE_SEQ_SV
