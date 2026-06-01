`ifndef SCOREBOARD_SV
`define SCOREBOARD_SV
`uvm_analysis_imp_decl(_exp)
`uvm_analysis_imp_decl(_act)

class Scoreboard extends uvm_scoreboard;
  `uvm_component_utils(Scoreboard)
  uvm_comparer custom_comparer;

  parameter DATA_WIDTH = 8;

  uvm_analysis_imp_exp#(Output_item, Scoreboard) exp_analysis_export;
  uvm_analysis_imp_act#(Output_item, Scoreboard) act_analysis_export;

  Output_item exp_queue[$], data_queue[$];
  Output_item latency_queue[$];

  function new(string name = "Scoreboard", uvm_component parent = null);
    super.new(name, parent);

    exp_analysis_export = new("exp_analysis_export", this);
    act_analysis_export = new("act_analysis_export", this);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    custom_comparer = new("custom_comparer");
    custom_comparer.show_max = 0;
  endfunction

  function void write_exp(Output_item item);
    exp_queue.push_back(item);
  endfunction

function void write_act(Output_item item);
    Output_item exp_item;

    if (!item.rstn) begin
      exp_queue.delete();
      return;
    end
    else begin
      if (item.rd_en) begin
        if (exp_queue.size() > 0) begin
          exp_item = exp_queue.pop_front();

          if (exp_item.compare(item, custom_comparer))
            `uvm_info(get_type_name(), $sformatf("[SCB] DATA MATCH: DOUT - 0x%0h", item.dout), UVM_LOW)
          else
            `uvm_info(get_type_name(), $sformatf("[SCB] DATA MISMATCH: DOUT - 0x%0h (EXP) vs 0x%0h (ACT) || FULL - %0b vs %0b || EMPTY - %0b vs %0b",
            exp_item.dout, item.dout, exp_item.full, item.full, exp_item.empty, item.empty), UVM_LOW)
          
        end 
        else begin
          `uvm_error(get_type_name(), "[SCB] Actual read received from monitor, but expected queue is empty!")
        end
      end
    end
  endfunction
endclass
`endif // SCOREBOARD_SV