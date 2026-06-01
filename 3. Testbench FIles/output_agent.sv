`ifndef OUTPUT_AGENT_SV
`define OUTPUT_AGENT_SV
class Output_agent extends uvm_agent;
  `uvm_component_utils(Output_agent)
  Output_monitor mon;

  function new(string name = "Output_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon = Output_monitor::type_id::create("mon", this);
  endfunction
endclass
`endif // OUTPUT_AGENT_SV