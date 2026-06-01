`ifndef INTERFACE_SV
`define INTERFACE_SV
interface design_if #(
  parameter WIDTH = 8, 
  parameter DEPTH = 8
) (input logic clk);

  logic rstn;
  logic rd_en, wr_en;
  logic full, empty;
  logic [WIDTH - 1 : 0] din, dout;

  clocking input_cb @(posedge clk);
    default input #1step;
    input rstn, dout, rd_en, full, empty;
  endclocking

  clocking output_cb @(posedge clk);
    default output #1;
    output rstn, rd_en, wr_en, din;
  endclocking
  
endinterface
`endif // INTERFACE_SV