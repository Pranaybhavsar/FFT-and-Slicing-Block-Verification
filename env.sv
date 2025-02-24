class env extends uvm_env;
	`uvm_component_utils(env)
	
	agent agent_h;
	encodebit encodebit_h;
	ifft_sb ifft_sb_h;
	fft_sb fft_sb_h;
	point_accum point_accum_h;
	comparator comparator_h;
	in_mon in_mon_h;
	out_mon out_mon_h;
	decode_sb decode_sb_h;

	function new(string name="env", uvm_component par);
		super.new(name, par);
	endfunction: new
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);	
		agent_h = agent::type_id::create("agent_h", this);
		encodebit_h = encodebit::type_id::create("encodebit_h", this);
		ifft_sb_h = ifft_sb::type_id::create("ifft_sb_h", this);
		fft_sb_h = fft_sb::type_id::create("fft_sb_h", this);
		point_accum_h = point_accum::type_id::create("point_accum_h", this);
		comparator_h = comparator::type_id::create("comparator_h", this);
		in_mon_h = in_mon::type_id::create("in_mon_h", this);
		out_mon_h = out_mon::type_id::create("out_mon_h", this);
		decode_sb_h = decode_sb::type_id::create("decode_sb_h", this);
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		agent_h.drvr_h.enc_in.connect(encodebit_h.enc_fifo.analysis_export);
		encodebit_h.enc_out.connect(ifft_sb_h.ifft_in_fifo.analysis_export);
		ifft_sb_h.ifft_out.connect(agent_h.drvr_h.ifft_out.analysis_export);
		in_mon_h.in_mon_port.connect(point_accum_h.point_fifo.analysis_export);
		out_mon_h.out_mon_port.connect(comparator_h.comparator_fifo0.analysis_export);
		decode_sb_h.decode_port.connect(comparator_h.comparator_fifo1.analysis_export);
		point_accum_h.point_port.connect(fft_sb_h.fft_in.analysis_export);
		fft_sb_h.fft_out.connect(decode_sb_h.decode_fifo.analysis_export);
	endfunction: connect_phase

endclass: env
