class drvr extends uvm_driver #(dut_signals);
	`uvm_component_utils(drvr);

	// declacre vif
	virtual dut_intf vif;

	// declare messages
	uvm_analysis_port #(dut_signals) enc_in;
	dut_signals mx_to_dut, mx_to_enc;

	uvm_tlm_analysis_fifo #(ifft_inout) ifft_out;
	ifft_inout mx_from_ifft;

	function new(string name="drvr", uvm_component par);
		super.new(name, par);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);

		enc_in = new("enc_in", this);
		ifft_out = new("ifft_out", this);

		if (!uvm_config_db #(virtual dut_intf)::get(null, "interface", "intf", vif)) begin
			`uvm_fatal("DRVR", "Didn't get handle to virtual interface alu_intf!!!");
		end
		else begin
			`uvm_info("DRVR", "Vif obtained successfully!", UVM_MEDIUM)
		end
	endfunction: build_phase

	real SF = 2**15;

	task run_phase(uvm_phase phase);
		mx_to_dut = new();
		mx_to_enc = new();
		mx_from_ifft = new();

		vif.Reset = 1;
		#20 vif.Reset = 0;

		forever begin
			seq_item_port.get_next_item(mx_to_enc);

			enc_in.write(mx_to_enc);
			mx_to_dut.copy(mx_to_enc);
			ifft_out.get(mx_from_ifft);
			mx_to_dut.FirstData = 1;
			`uvm_info("DRVR", $sformatf("Starting new sequence!!: %h", mx_to_dut.data), UVM_MEDIUM)
			foreach (mx_from_ifft.queue[i]) begin
				mx_to_dut.DinR = $rtoi(mx_from_ifft.queue[i].r * SF);
				//$display("%b",mx_to_dut.DinR);
				mx_to_dut.DinI = $rtoi(mx_from_ifft.queue[i].i * SF);
				// $display("%b",mx_to_dut.DinI);

				@ (posedge vif.clk) begin
					// `uvm_info("DRVR", $sformatf("push %d: r=%h, i=%h", i, mx_to_dut.DinR, mx_to_dut.DinI), UVM_MEDIUM);
					// vif.Reset = mx_to_dut.Reset;
					vif.Pushin = 1;
					vif.FirstData = mx_to_dut.FirstData;
					vif.DinR = mx_to_dut.DinR;
					vif.DinI = mx_to_dut.DinI;

				end
				mx_to_dut.FirstData = 0;
			end
			#30 vif.Pushin = 0;

			@ (posedge vif.PushOut) begin
				seq_item_port.item_done();

			end
			// @ (posedge vif.PushOut) begin
   //
			// 	// `uvm_info("DRVR: OUTPUT", "GOT AN OUTPUT!", UVM_MEDIUM)
			// 	if (mx_to_dut.data != vif.DataOut) begin
			// 	`uvm_info("ERROR", $sformatf("Sent:%h, Got: %h",
			// 	mx_to_dut.data,
			// 	vif.DataOut
			// 	), UVM_MEDIUM)
			// 	end
			// end
			// #5000;
		end
	endtask: run_phase
endclass: drvr
