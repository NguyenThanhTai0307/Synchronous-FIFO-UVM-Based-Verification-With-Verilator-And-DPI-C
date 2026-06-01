`ifndef TEST_5_SV
`define TEST_5_SV
//===============================================================================
// Continuously write until overflow, then read until underflow
//===============================================================================
class Overflow_underflow_seq extends Fifo_base_seq;
  `uvm_object_utils(Overflow_underflow_seq)
  function new(string name = "Fill_drain_seq"); super.new(name); endfunction

  task body();
    // 1. Write when already FULL
    for(int i = 0; i < DEPTH + 1; i++) begin
      drive_tx(.r_rstn(1), .r_wr_en(1), .r_rd_en(0), .r_din(data_pool[i]));
    end

    // 2. Read when already EMPTY
    for(int i = 0; i < DEPTH + 1; i++) begin
      drive_tx(.r_rstn(1), .r_wr_en(0), .r_rd_en(1), .r_din(8'h00));
    end
    
    test_done = 1;
  endtask
endclass
`endif // TEST_5_SV