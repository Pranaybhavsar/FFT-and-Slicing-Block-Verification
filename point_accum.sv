class point_accum extends uvm_scoreboard;
`uvm_component_utils(point_accum)

// declare msgs
uvm_tlm_analysis_fifo #(dut_signals) point_fifo;
dut_signals dut_signals_h;

uvm_analysis_port #(ifft_inout) point_port;
ifft_inout ifft_inout_h;

function new(string name="point_accum", uvm_component par);
	super.new(name, par);
endfunction

function void build_phase(uvm_phase phase);
	super.build_phase(phase);

	point_fifo = new("point_fifo", this);
	point_port = new("point_port", this);
endfunction

complex arr[128];
complex a;
int count = 0;
real SF = 30517578125e-15;  //2**-15
 
task run_phase(uvm_phase phase);
	dut_signals_h = new();
	ifft_inout_h = new();
	forever begin
		point_fifo.get(dut_signals_h);
		// `uvm_info("POINT_ACCUM", $sformatf("RECEIVED FROM IN_MON! %d", count), UVM_MEDIUM)
		if (count < 128) begin
			a.r = $itor($signed(dut_signals_h.DinR)*SF);
			a.i = $itor($signed(dut_signals_h.DinI)*SF);
			arr[count] = a;
           	//`uvm_info("POINT_ACCUM", $sformatf("DinR=%f, DinI=%f", a.r, a.i), UVM_MEDIUM)
			count++;
			if (count == 128) begin
				ifft_inout_h.queue = arr;
				point_port.write(ifft_inout_h);
				// $display("send");

				//`uvm_info("POINT_ACCUM:SEND", "WRITING TO POINT PORT", UVM_MEDIUM);
			end

		end
		else begin

			count = 0;
			a.r = $itor($signed(dut_signals_h.DinR)*SF);
			a.i = $itor($signed(dut_signals_h.DinI)*SF);
			arr[count] = a;
           	//`uvm_info("POINT_ACCUM", $sformatf("DinR=%f, DinI=%f", a.r, a.i), UVM_MEDIUM)
           	count ++;
		end
		
	end
endtask
endclass
