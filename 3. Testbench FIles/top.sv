`ifndef TOP_SV
`define TOP_SV

`include "uvm_macros.svh"
import uvm_pkg::*;
import fifo_pkg::*;

module top (input clk);
  design_if top_if(clk);
  DUT_Wrapper dut_wrapper (._if (top_if));
  //single_port_sync_ram DUT (top_if);

    bind sync_fifo Assertion #(
      .WIDTH(8), .DEPTH(8)) a0 
      (
      .clk (clk), .rstn (rstn),
      .full (full), .empty (empty),
      .wr_pt (wr_pt), .rd_pt (rd_pt),
      .wr_en (wr_en), .rd_en (rd_en),
      .din (din), .dout (dout),
      .count (count)
      );

  initial begin
    uvm_config_db#(virtual design_if)::set(uvm_root::get(), "*", "top_vif", top_if);
  end
  
  initial begin
    run_test("Base_test");
  end
  
endmodule
`endif // TOP_SV