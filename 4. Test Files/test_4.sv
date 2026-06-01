`ifndef TEST_4_SV
`define TEST_4_SV
//==========================================================================================
// Assert rstn in the middle of active reads/writes, at full capacity, and empty capacity.
//==========================================================================================
class Reset_stress_seq extends Fifo_base_seq;
  `uvm_object_utils(Reset_stress_seq)
  function new(string name = "Reset_stress_seq"); super.new(name); endfunction

  task body();
    // 1. Fill to FULL
    for(int i = 0; i < DEPTH; i++) begin
      drive_tx(.r_rstn(1), .r_wr_en(1), .r_rd_en(0), .r_din(data_pool[i]));
    end
    
    // 2. HARD RESET AT FULL CAPACITY
    drive_tx(.r_rstn(0), .r_wr_en(1), .r_rd_en(0), .r_din(8'h00));

    // 3. Write a few items (Mid-range)
    repeat(4) drive_tx(.r_rstn(1), .r_wr_en(1), .r_rd_en(0), .r_din(8'hFF));

    // 4. HARD RESET DURING ACTIVE READ
    drive_tx(.r_rstn(0), .r_wr_en(0), .r_rd_en(1), .r_din(8'h00));

    // 5. Write a few items (Mid-range)
    repeat(4) drive_tx(.r_rstn(1), .r_wr_en(1), .r_rd_en(0), .r_din(8'hFF));

    // 6. Read until empty
    repeat(4) drive_tx(.r_rstn(1), .r_wr_en(0), .r_rd_en(1), .r_din(8'h00));

    // 7. HARD RESET AT EMPTY
    drive_tx(.r_rstn(0), .r_wr_en(1), .r_rd_en(0), .r_din(8'h00));

    test_done = 1;
  endtask
endclass
`endif // TEST_4_SV
