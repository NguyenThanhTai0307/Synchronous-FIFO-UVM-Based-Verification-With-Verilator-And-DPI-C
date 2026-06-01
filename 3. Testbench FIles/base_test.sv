`ifndef BASE_TEST_SV
`define BASE_TEST_SV
class Base_test extends uvm_test;
  `uvm_component_utils(Base_test)
  Environment env;
  Base_sequence b_seq;

  function new(string name = "Base_test", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    env = Environment::type_id::create("env", this);
  endfunction

  task run_phase(uvm_phase phase);
    phase.raise_objection(this);
    b_seq = Base_sequence::type_id::create("b_seq");

    b_seq.start(env.in_agt.seqr);

    if(b_seq.test_done == 1)
      repeat (5) @ (env.out_agt.mon.m_vif.input_cb);
    
    env.fcov.report_data();
    
    phase.drop_objection(this);
  endtask
endclass
`endif // BASE_TEST_SV