`ifndef OUTPUT_MONITOR_SV
`define OUTPUT_MONITOR_SV
class Output_monitor extends uvm_monitor;
  `uvm_component_utils(Output_monitor)
  uvm_analysis_port#(Output_item) analysis_port;
  Output_item m_item;
  virtual design_if m_vif;

  function new(string name = "Output_monitor", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual design_if)::get(this, "", "top_vif", m_vif))
      `uvm_fatal(get_type_name(), "m_vif not set at top level");
  endfunction

task run_phase(uvm_phase phase);
    bit read_pending = 0;

    forever begin 
      @(m_vif.input_cb);
      
      // 1. Process data from the PREVIOUS cycle's read request
      if (read_pending) begin
        m_item = Output_item::type_id::create("m_item");
        m_item.rstn = m_vif.input_cb.rstn;
        m_item.rd_en = 1; 
        m_item.dout  = m_vif.input_cb.dout;
        m_item.full  = m_vif.input_cb.full;
        m_item.empty = m_vif.input_cb.empty;
        
        analysis_port.write(m_item);
      end

      // 2. Check CURRENT cycle to set the pending flag for the NEXT cycle
      read_pending = (m_vif.input_cb.rd_en && !m_vif.input_cb.empty);
    end
  endtask
endclass
`endif // OUTPUT_MONITOR_SV