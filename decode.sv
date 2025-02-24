class decode_sb extends uvm_scoreboard;
`uvm_component_utils(decode_sb)

// declare msgs
uvm_tlm_analysis_fifo #(ifft_inout) decode_fifo;
ifft_inout ifft_inout_h; 

uvm_analysis_port #(dut_signals) decode_port;
dut_signals dut_signals_h;

function new(string name="decode", uvm_component par);
	super.new(name, par);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	decode_fifo = new("decode_fifo", this);
	decode_port = new("decode_port", this);
endfunction

// variables
logic [47:0] res;
logic [47:0] bv;
real fsq;
complex arr[128];
// real SF = 30517578125e-15;  //2**-15
// real SF1 = 2**15;
task run_phase(uvm_phase phase);
	ifft_inout_h = new();
	dut_signals_h = new();
	forever begin
		decode_fifo.get(ifft_inout_h);
		//`uvm_info("DECODE", "NEW INPUT!!", UVM_MEDIUM)
		arr = ifft_inout_h.queue;
		// foreach (arr[i]) begin
		// 	`uvm_info("DECODE", $sformatf("ix: %0d, real=%f, imag=%f", i, arr[i].r, arr[i].i), UVM_MEDIUM)
		// end
		decode(arr, res);
		dut_signals_h.DataOut = res;
		`uvm_info("DECODE", $sformatf("The decoded message: %h", res), UVM_MEDIUM);
		decode_port.write(dut_signals_h);
	end
endtask

function real max(input real a, input real b);
	max = (a>b) ? a : b;
endfunction;


task decode(input complex arr[128], output logic [47:0] res);
	real tpoints[4] = '{0.0, 0.333, 0.666, 1.0};
	real full_scale = max(complex_abs(arr[55]), complex_abs(arr[57]));
	real fspoints[4];
	real decision_points[3];
	// `uvm_info("DECODE: decode", $sformatf("%f",complex_abs(arr[55])), UVM_MEDIUM)
	// `uvm_info("DECODE: decode", $sformatf("%f",complex_abs(arr[57])), UVM_MEDIUM)
	// `uvm_info("DECODE: decode", $sformatf("%f",max(complex_abs(arr[55]), complex_abs(arr[57]))), UVM_MEDIUM)
	// `uvm_info("DECODE: decode", $sformatf("%f", full_scale), UVM_MEDIUM)

	foreach (tpoints[i]) begin
		fspoints[i] = tpoints[i] * full_scale;
		// `uvm_info("DECODE: decode", $sformatf("%f", fspoints[i]), UVM_MEDIUM)

	end

	
	decision_points = '{
		((0.166666)*full_scale)**2,
		((0.166666+0.333333)*full_scale)**2,
		((0.166666+0.60000)*full_scale)**2
	};
	// foreach (decision_points[i]) begin
	// `uvm_info("DECODE: decode", $sformatf("decision point %d: %f",i, decision_points[i]), UVM_MEDIUM)
	// end

	res = 0; 
	for (int x=4; x<52; x += 2) begin
		fsq = complex_abs(arr[x]);
		bv = 3;
		for (int dx=0; dx<3; dx++) begin
			if (fsq<decision_points[dx]) begin
				bv = dx;
				break;
			end
		end	
		//`uvm_info("DECODE", $sformatf("%d, %f, %d", x, fsq, bv), UVM_MEDIUM)
		bv = bv<<(x-4);
		res = res|bv;
		// `uvm_info("DECODE", $sformatf("%h", res), UVM_MEDIUM)
	end

endtask
endclass
