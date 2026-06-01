`ifndef SEQUENCER_SV
`define SEQUENCER_SV
class Sequencer extends uvm_sequencer #(Input_item);
  `uvm_component_utils(Sequencer)

  function new(string name = "Sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
  endfunction
endclass
`endif // SEQUENCER_SV