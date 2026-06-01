`ifndef INPUT_MONITOR_SV
`define INPUT_MONITOR_SV
class Input_monitor extends uvm_monitor;
  `uvm_component_utils(Input_monitor)

  uvm_analysis_port#(Input_item) analysis_port;
  Input_item m_item;
  virtual design_if m_vif; 

  function new(string name = "Input_monitor", uvm_component parent = null);
    super.new(name, parent);
    analysis_port = new("analysis_port", this);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);

    if(!uvm_config_db#(virtual design_if)::get(this, "", "top_vif", m_vif))
      `uvm_fatal(get_type_name(), "m_vif not set at top level");

  endfunction

  task run_phase(uvm_phase phase);
    forever begin
      m_item = Input_item::type_id::create("m_item");
      @(m_vif.input_cb);

      if (m_vif.wr_en && !m_vif.rd_en) begin
        m_item.rstn = m_vif.rstn;
        m_item.wr_en = m_vif.wr_en;
        m_item.din = m_vif.din;

        $display("[%0t] [INPUT MONITOR] write : %0b || din : 0x%0h", $time, m_item.wr_en, m_item.din);

        analysis_port.write(m_item);
      end

      else if (m_vif.rd_en && !m_vif.wr_en) begin
        m_item.rstn = m_vif.rstn;
        m_item.rd_en = m_vif.rd_en;

        $display("[%0t] [INPUT MONITOR] read : %0b", $time, m_item.rd_en);

        analysis_port.write(m_item);
      end

      else if (m_vif.rd_en && m_vif.wr_en) begin
        m_item.rstn = m_vif.rstn;
        m_item.wr_en = m_vif.wr_en;
        m_item.rd_en = m_vif.rd_en;
        m_item.din = m_vif.din;

        $display("[%0t] [INPUT MONITOR] write : %0b || read : %0b || din : 0x%0h", 
        $time, m_item.wr_en, m_item.rd_en, m_item.din);

        analysis_port.write(m_item);
      end

    end
  endtask
endclass
`endif // INPUT_MONITOR_SV