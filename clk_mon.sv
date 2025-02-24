class clk_mon extends uvm_monitor;
	`uvm_component_utils(clk_mon)

	
	function new(string name="clk_mon", uvm_component par);
		super.new(name, par);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction: build_phase

	task run_phase(uvm_phase phase);
		forever begin

		end
	endtask: run_phase
endclass: clk_mon
