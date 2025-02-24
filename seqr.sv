class seqr extends uvm_sequencer #(dut_signals);
	`uvm_component_utils(seqr)

	function new(string name="seqr", uvm_component par);
		super.new(name, par);
	endfunction: new

endclass: seqr
