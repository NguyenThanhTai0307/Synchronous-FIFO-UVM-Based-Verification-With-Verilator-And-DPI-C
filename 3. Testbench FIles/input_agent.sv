`ifndef INPUT_AGENT_SV
`define INPUT_AGENT_SV
class Input_agent extends uvm_agent;
  `uvm_component_utils(Input_agent)
  Driver drv;
  Sequencer seqr;
  Input_monitor mon;

  function new(string name = "Input_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon = Input_monitor::type_id::create("mon", this);

    if(get_is_active == UVM_ACTIVE) begin
      drv = Driver::type_id::create("drv", this);
      seqr = Sequencer::type_id::create("seqr", this);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    if(get_is_active == UVM_ACTIVE) begin 
      drv.seq_item_port.connect(seqr.seq_item_export);
    end
  endfunction
endclass
`endif // INPUT_AGENT_SV