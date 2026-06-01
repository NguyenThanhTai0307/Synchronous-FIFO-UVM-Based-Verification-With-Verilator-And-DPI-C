`ifndef FUNCTIONAL_COVERAGE_SV
`define FUNCTIONAL_COVERAGE_SV
import "DPI-C" context function void dpi_c_sample_coverage(byte rstn, byte wr_en, byte rd_en, byte full, byte empty, int fill_level, int depth);
import "DPI-C" context function void dpi_c_report_coverage();

class Functional_coverage extends uvm_subscriber#(Input_item);
    `uvm_component_utils(Functional_coverage)

    function new(string name = "Functional_coverage", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void sample(bit rstn, bit wr_en, bit rd_en, bit full, bit empty, int fill_level, int depth);
        dpi_c_sample_coverage(
            {7'b0, rstn},
            {7'b0, wr_en},
            {7'b0, rd_en},
            {7'b0, full},
            {7'b0, empty},
            int'(fill_level),
            int'(depth)
        );
    endfunction

    function void report_data();
        dpi_c_report_coverage();
    endfunction
    
    function void report_phase(uvm_phase phase);
        super.report_phase(phase);
    endfunction

// SystemVerilog covergroup defined for industry-standard compatibility (VCS/Questa).

// Functional coverage implemented via DPI-C for Verilator performance/compatibility.
/*
    Input_item fc_item;

  covergroup cg;
    c_rstn : coverpoint fc_item.rstn {
      bins rst = {0};
      bins no_rst = {1};
    }
    c_rd_en : coverpoint fc_item.rd_en {
      bins rd = {1};
      bins no_rd = {0};
    }
    c_wr_en : coverpoint fc_item.wr_en {
      bins wr = {1};
      bins no_wr = {0};
    }
    c_full : coverpoint fc_item.full {
      bins fll = {1};
      bins no_fll = {0};
    }
    c_empty : coverpoint fc_item.empty {
      bins empt = {1};
      bins no_empt = {0};
    }
    
    c_fill_level : coverpoint fc_item.fill_level {
      bins empty = {0};
      bins near_empty = {1};
      bins mid_range = {[2 : DEPTH - 2]};
      bins near_full = {DEPTH - 1};
      bins full = {DEPTH};
    }
    // Corner cases
    // Overflow Attempt
    cross_rstn_0 : cross c_rstn, c_wr_en, c_rd_en {
      ignore_bins c_wr_en_0 = binsof(c_rstn.rst) && binsof(c_wr_en);
      ignore_bins c_rd_en_0 = binsof(c_rstn.rst) && binsof(c_rd_en);

    }

    cross_write_when_full : cross c_wr_en, c_full {
      bins write_full = binsof(c_wr_en.wr) && binsof(c_full.fll);
    }
    // Underflow Attempt
    cross_read_when_empty : cross c_rd_en, c_empty {
      bins read_empty = binsof(c_rd_en.rd) && binsof(c_empty.empt);
    }
    // Simulatneous Read-Write across various range
    cross_read_write_simultaneous : cross c_rd_en, c_wr_en, c_fill_level {
      // Specifically targets the boundaries
      bins rd_wr_at_full = binsof(c_rd_en.rd) && binsof(c_wr_en.wr) && binsof(c_fill_level.full);
      bins rd_wr_at_empty = binsof(c_rd_en.rd) && binsof(c_wr_en.wr) && binsof(c_fill_level.empty);
      bins rd_wr_at_mid_range = binsof(c_rd_en.rd) && binsof(c_wr_en.wr) && binsof(c_fill_level.mid_range);
    }
    // Reset timing
    cross_reset_full_empty : cross c_rstn, c_full, c_empty {
      bins reset_at_full = binsof(c_rstn.rst) && binsof(c_full.fll);
      bins reset_at_empty = binsof(c_rstn.rst) && binsof(c_empty.empt);
    }
  endgroup

    function new(string name = "Functional_coverage", uvm_component parent = null);
        super.new(name, parent);
        cg = new();
    endfunction

    function void write(Input_item t);
        this.fc_item = t;
        this.cg.sample();
    endfunction
*/
endclass
`endif // FUNCTIONAL_COVERAGE_SV