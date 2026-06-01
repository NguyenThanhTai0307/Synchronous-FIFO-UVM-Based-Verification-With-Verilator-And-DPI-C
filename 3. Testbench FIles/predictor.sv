`ifndef PREDICTOR_SV
`define PREDICTOR_SV
class Predictor extends uvm_subscriber #(Input_item);
  `uvm_component_utils(Predictor)
  uvm_analysis_port#(Output_item) analysis_port;
  Output_item exp_item;
  Functional_coverage fcov;

  parameter DEPTH = 8;
  
  // 1. Add internal memory to model the RTL FIFO
  logic [DEPTH - 1 : 0] internal_fifo[$]; 

  // 2. Struct for collecting data for the functional coverage
  typedef struct {
    bit reset;
    bit read;
    bit write;
    bit full;
    bit empty;
    int fill_level;
    int depth;
  } coverage_collection;

  coverage_collection cov_col;

  function new(string name = "Predictor", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
    fcov = Functional_coverage::type_id::create("fcov", this);
  endfunction

  function void write(Input_item t);
    bit valid_read = t.rd_en && (internal_fifo.size() > 0);
    bit valid_write = t.wr_en && (internal_fifo.size() < DEPTH);
    bit [7:0] popped_data;

    // 0. Update coverage collection struct
    cov_col.reset = t.rstn;
    cov_col.read = t.rd_en;
    cov_col.write = t.wr_en;
    cov_col.full = (internal_fifo.size() == DEPTH);
    cov_col.empty = (internal_fifo.size() == 0);
    cov_col.fill_level = internal_fifo.size();
    cov_col.depth = DEPTH;

    // Sample functional coverage via DPI-C
    fcov.sample(cov_col.reset, cov_col.write, cov_col.read, cov_col.full, cov_col.empty, cov_col.fill_level, cov_col.depth);

    // 1. Reset Handling
    if (!t.rstn) begin
      internal_fifo.delete();
      $display("[PREDICTOR] Reset Asserted -> FIFO Cleared");
    end

    // 2. Execute Read (Pop)
    if (valid_read) begin
      popped_data = internal_fifo.pop_front();
    end 
    else if (t.rd_en) begin
      $display("[PREDICTOR] Pop Expected -> EMPTY");
    end

    // 3. Execute Write (Push)
    if (valid_write) begin
      internal_fifo.push_back(t.din);
      $display("[PREDICTOR] Push Expected At 0x%0h -> din : 0x%0h", internal_fifo.size(), t.din);
    end 
    else if (t.wr_en) begin
      $display("[PREDICTOR] Push Expected -> FULL");
    end

    // 3. Broadcast ONLY after both operations update the FIFO size
    if (valid_read) begin
      exp_item = Output_item::type_id::create("exp_item");
      exp_item.dout = popped_data;
      
      // Calculate flags based on the FINAL state
      exp_item.full = (internal_fifo.size() == DEPTH);
      exp_item.empty = (internal_fifo.size() == 0);

      $display("[PREDICTOR] Pop Expected -> dout : 0x%0h || full : %0b || empty : %0b", 
               exp_item.dout, exp_item.full, exp_item.empty);
               
      analysis_port.write(exp_item);
    end
  endfunction
endclass
`endif // PREDICTOR_SV