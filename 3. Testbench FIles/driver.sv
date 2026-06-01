`ifndef DRIVER_SV
`define DRIVER_SV
class Driver extends uvm_driver #(Input_item);
  `uvm_component_utils(Driver)
  virtual design_if d_vif;
  Input_item d_item;

  function new(string name = "Driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase (uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db#(virtual design_if)::get(this, "", "top_vif", d_vif))
    	`uvm_fatal(get_type_name(), "d_vif not get at top level");
  endfunction

  task run_phase(uvm_phase phase);
    forever begin

      seq_item_port.try_next_item(d_item);

      if (d_item != null) begin
        @(d_vif.output_cb);
        d_vif.output_cb.rstn <= d_item.rstn;
        d_vif.output_cb.din <= d_item.din;
        d_vif.output_cb.wr_en <= d_item.wr_en;
        d_vif.output_cb.rd_en <= d_item.rd_en;
        seq_item_port.item_done();
      end 
      else begin
        // Idle state when no sequence is running
        @(d_vif.output_cb);
        d_vif.output_cb.wr_en <= 0;
        d_vif.output_cb.rd_en <= 0;
      end
    end
  endtask
endclass
`endif // DRIVER_SV