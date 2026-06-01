`ifndef TEST_2_SV
`define TEST_2_SV
//======================================================
// Assert wr_en and rd_en simultaneously across 
// different fill levels (empty, mid-range, full).
//======================================================
class Concurrent_rw_seq extends Fifo_base_seq;
  `uvm_object_utils(Concurrent_rw_seq)
  function new(string name = "Concurrent_rw_seq"); super.new(name); endfunction

  task body();
    // 1. Concurrent access at EMPTY
    drive_tx(.r_rstn(1), .r_wr_en(1), .r_rd_en(1), .r_din(8'hAA));

    // 2. Fill to MID-RANGE (4 items)
    for(int i = 0; i < DEPTH/2; i++) begin
      drive_tx(.r_rstn(1), .r_wr_en(1), .r_rd_en(0), .r_din(data_pool[i]));
    end

    // 3. Concurrent access at MID-RANGE
    repeat(3) drive_tx(.r_rstn(1), .r_wr_en(1), .r_rd_en(1), .r_din(8'hBB));

    // 4. Fill to FULL
    for(int i = 0; i < DEPTH/2; i++) begin
      drive_tx(.r_rstn(1), .r_wr_en(1), .r_rd_en(0), .r_din(data_pool[i]));
    end

    // 5. Concurrent access at FULL
    drive_tx(.r_rstn(1), .r_wr_en(1), .r_rd_en(1), .r_din(8'hCC));

    // Drain to finish safely
    repeat(DEPTH) drive_tx(.r_rstn(1), .r_wr_en(0), .r_rd_en(1), .r_din(8'h00));
    test_done = 1;
  endtask
endclass
`endif // TEST_2_SV