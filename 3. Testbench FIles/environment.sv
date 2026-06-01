`ifndef ENVIRONMENT_SV
`define ENVIRONMENT_SV
class Environment extends uvm_env;
  `uvm_component_utils(Environment)
  Input_agent in_agt;
  Output_agent out_agt;
  Scoreboard scb;
  Predictor pred;
  Functional_coverage fcov;

  function new(string name = "Environment", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    in_agt = Input_agent::type_id::create("in_agt", this);
    out_agt = Output_agent::type_id::create("out_agt", this);
    scb = Scoreboard::type_id::create("scb", this);
    pred = Predictor::type_id::create("pred", this);
    fcov = Functional_coverage::type_id::create("fcov", this);
  endfunction

  function void connect_phase(uvm_phase phase);
    in_agt.mon.analysis_port.connect(pred.analysis_export);
    pred.analysis_port.connect(scb.exp_analysis_export);
    out_agt.mon.analysis_port.connect(scb.act_analysis_export);
    // in_agt.mon.analysis_port.connect(fcov.analysis_export);
  endfunction
endclass
`endif // ENVIRONMENT_SV