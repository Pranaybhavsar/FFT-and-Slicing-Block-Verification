class encodebit extends uvm_component;
    `uvm_component_utils(encodebit)
	
	// Declare msgs
	uvm_analysis_port #(ifft_inout) enc_out;
	ifft_inout ifft_inout_h;
	
	uvm_tlm_analysis_fifo #(dut_signals) enc_fifo;
	dut_signals dut_signals_h;
		

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);;
		enc_out = new("enc_out", this);
		enc_fifo = new("enc_fifo", this);
	endfunction

	bit [47:0] input_data;
	task run_phase(uvm_phase phase);
		dut_signals_h = new();
		ifft_inout_h = new();

		forever begin
			enc_fifo.get(dut_signals_h);
			input_data = dut_signals_h.data;
			init_arr(ifft_inout_h.queue);
			encode(input_data, ifft_inout_h.queue);
			enc_out.write(ifft_inout_h);
		end
	endtask;

    // Encode method
 task encode(input bit [47:0] input_data, output complex amplitude[128]);
    // Declare variables at the beginning of the function
    real amp[4] = '{0.0, 0.333, 0.666, 1.0};
    int fbin = 4;
    logic [47:0] data = input_data;  // Assign input data to the class variable

    while (fbin < 52) begin
        int idx = data & 3;
        amplitude[fbin].r = amp[idx];
        amplitude[128 - fbin].r = amp[idx];  // Mirror the amplitude
        data = data >> 2;
        fbin += 2;
    end

    // Fixed amplitudes at specific frequencies
    amplitude[55].r = 1.0;
    amplitude[128 - 55].r = 1.0;

    // Reporting results
 //    for (int i = 0; i < 128; i++) begin
 //        `uvm_info("ENCODEBIT", $sformatf("Frequency %0d: Amplitude = %0f", i, amplitude[i].r), UVM_LOW)
	// end
endtask

task init_arr(input complex amplitude[128]);
	foreach (amplitude[i]) begin
		complex a;
		a.r = 0;
		a.i = 0;
		amplitude[i] = a;
		// `uvm_info("ENCODEBIT: INIT_ARR", $sformatf("Frequence %0d: Real = %0f, Imag = %0f", i, amplitude[i].r, amplitude[i].i), UVM_MEDIUM);
	end	
endtask
endclass
