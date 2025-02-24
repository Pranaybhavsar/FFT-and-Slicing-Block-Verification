class dut_signals extends uvm_sequence_item;
	// inputs
	reg Reset;
	reg Pushin;
	reg FirstData;
	reg [16:0] DinR;
	reg [16:0] DinI;
	
	// outputs
	reg PushOut;
	reg [47:0] DataOut;

	// intermediate signals
	rand reg [47:0] data;

	`uvm_object_utils_begin(dut_signals)
    `uvm_field_int(Reset,UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(Pushin,UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(FirstData,UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(DinR,UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(DinI,UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(PushOut,UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(DataOut,UVM_ALL_ON | UVM_DEC)
    `uvm_field_int(data,UVM_ALL_ON | UVM_DEC)
	`uvm_object_utils_end

	function new(string name="dut_signals");
		super.new(name);
	endfunction
endclass: dut_signals

class ifft_inout extends uvm_sequence_item;
	complex queue[128];
endclass: ifft_inout


