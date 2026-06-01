`ifndef TESTS_SV
`define TESTS_SV

// 1. Fill and Drain Test
class Fill_drain_test extends Base_test;
  `uvm_component_utils(Fill_drain_test)
  function new(string name = "Fill_drain_test", uvm_component parent = null); super.new(name, parent); endfunction

  task run_phase(uvm_phase phase);
    Fill_drain_seq seq = Fill_drain_seq::type_id::create("seq");
    phase.raise_objection(this);
    seq.start(env.in_agt.seqr);
    if(seq.test_done == 1) repeat (5) @ (env.out_agt.mon.m_vif.input_cb);
    env.fcov.report_data();
    phase.drop_objection(this);
  endtask
endclass

// 2. Concurrent Read/Write Test
class Concurrent_rw_test extends Base_test;
  `uvm_component_utils(Concurrent_rw_test)
  function new(string name = "Concurrent_rw_test", uvm_component parent = null); super.new(name, parent); endfunction
  
  task run_phase(uvm_phase phase);
    // FIXED: Instantiating the sequence, not the test
    Concurrent_rw_seq seq = Concurrent_rw_seq::type_id::create("seq");
    phase.raise_objection(this);
    seq.start(env.in_agt.seqr);
    if(seq.test_done == 1) repeat (5) @ (env.out_agt.mon.m_vif.input_cb);
    env.fcov.report_data();
    phase.drop_objection(this);
  endtask
endclass

// 3. Overflow/Underflow Test
class Overflow_underflow_test extends Base_test;
  `uvm_component_utils(Overflow_underflow_test)
  function new(string name = "Overflow_underflow_test", uvm_component parent = null); super.new(name, parent); endfunction

  task run_phase(uvm_phase phase);
    Overflow_underflow_seq seq = Overflow_underflow_seq::type_id::create("seq");
    phase.raise_objection(this);
    seq.start(env.in_agt.seqr);
    if(seq.test_done == 1) repeat (5) @ (env.out_agt.mon.m_vif.input_cb);
    env.fcov.report_data();
    phase.drop_objection(this);
  endtask
endclass

// 4. Randomized Back-to-Back Test
class Randomized_test extends Base_test;
  `uvm_component_utils(Randomized_test)
  function new(string name = "Randomized_test", uvm_component parent = null); super.new(name, parent); endfunction
  
  task run_phase(uvm_phase phase);
    // FIXED: Instantiating the sequence, not the test
    Randomized_seq seq = Randomized_seq::type_id::create("seq");
    phase.raise_objection(this);
    seq.start(env.in_agt.seqr);
    if(seq.test_done == 1) repeat (5) @ (env.out_agt.mon.m_vif.input_cb);
    env.fcov.report_data();
    phase.drop_objection(this);
  endtask
endclass

// 5. Reset Stress Test
class Reset_stress_test extends Base_test;
  `uvm_component_utils(Reset_stress_test)
  function new(string name = "Reset_stress_test", uvm_component parent = null); super.new(name, parent); endfunction

  task run_phase(uvm_phase phase);
    // FIXED: Instantiating the sequence, not the test
    Reset_stress_seq seq = Reset_stress_seq::type_id::create("seq");
    phase.raise_objection(this);
    seq.start(env.in_agt.seqr);
    if(seq.test_done == 1) repeat (5) @ (env.out_agt.mon.m_vif.input_cb);
    env.fcov.report_data();
    phase.drop_objection(this);
  endtask
endclass

`endif // TESTS_SV