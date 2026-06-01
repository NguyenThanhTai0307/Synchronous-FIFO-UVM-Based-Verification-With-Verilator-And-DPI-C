`ifndef TEST_1_SV
`define TEST_1_SV
//===============================================================================
// Continuously write until exactly full (DEPTH), then read until exactly empty
//===============================================================================
class Fill_drain_seq extends Fifo_base_seq;
  `uvm_object_utils(Fill_drain_seq)
  function new(string name = "Fill_drain_seq"); super.new(name); endfunction

  task body();
    // 1. Write until FULL (Exactly DEPTH times)
    for(int i = 0; i < DEPTH; i++) begin
      drive_tx(.r_rstn(1), .r_wr_en(1), .r_rd_en(0), .r_din(data_pool[i]));
    end

    // 2. Read until EMPTY (Exactly DEPTH times)
    for(int i = 0; i < DEPTH; i++) begin
      drive_tx(.r_rstn(1), .r_wr_en(0), .r_rd_en(1), .r_din(8'h00));
    end
    
    test_done = 1;
  endtask
endclass
`endif // TEST_1_SV