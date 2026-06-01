`ifndef DUT_WRAPPER_SV
`define DUT_WRAPPER_SV
module DUT_Wrapper (design_if _if);
    sync_fifo DUT (
        .clk (_if.clk), .rstn (_if.rstn),
        .rd_en (_if.rd_en), .wr_en (_if.wr_en),
      .full (_if.full), .empty (_if.empty),
      .din (_if.din), .dout (_if.dout)
    );
endmodule
`endif // DUT_WRAPPER_SV