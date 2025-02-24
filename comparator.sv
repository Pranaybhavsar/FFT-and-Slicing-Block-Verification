class comparator extends uvm_scoreboard;
`uvm_component_utils(comparator)

// declare msgs
uvm_tlm_analysis_fifo #(dut_signals) comparator_fifo0;
uvm_tlm_analysis_fifo #(dut_signals) comparator_fifo1;
dut_signals actual, expected;

function new(string name="comparator", uvm_component par);
	super.new(name, par);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);
	comparator_fifo0 = new("comparator_fifo0", this);
	comparator_fifo1 = new("comparator_fifo1", this);
endfunction

task run_phase(uvm_phase phase);
	expected = new();
	actual = new();

	forever begin
		comparator_fifo0.get(actual);
		comparator_fifo1.get(expected);
		//`uvm_info("COMPARATOR", "GOT AN OUTPUT!", UVM_MEDIUM)
		if (actual.DataOut != expected.DataOut) begin
			`uvm_error("ERROR: COMPARATOR", $sformatf("Expected:%h, Actual: %h",
			expected.DataOut,
			actual.DataOut
		))
		end
		
	end
endtask
endclass
