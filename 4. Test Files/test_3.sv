`ifndef TEST_3_SV
`define TEST_3_SV
//====================================================================================
// Fully randomized delays between writes and reads to stress the pointer arbitration. 
//====================================================================================
class Randomized_seq extends Fifo_base_seq;
  `uvm_object_utils(Randomized_seq)
  function new(string name = "Randomized_seq"); super.new(name); endfunction

  task body();
    // Run 50 fully randomized transactions relying on Input_item constraints
    for(int i = 0; i < 50; i++) begin
      seq_item = Input_item::type_id::create("seq_item");
      seq_item.c_rs.constraint_mode(0);
      wait_for_grant();
      // Only forcing rstn to avoid random resets disrupting the test
      if(seq_item.randomize() with { rstn == 1; } == 0) begin
         `uvm_fatal(get_type_name(), "Randomization Failed")
      end
      send_request(seq_item);
      wait_for_item_done();
    end
    test_done = 1;
  endtask
endclass
`endif // TEST_3_SV