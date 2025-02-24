class agent extends uvm_agent;
	`uvm_component_utils(agent);

	seqr seqr_h;
	drvr drvr_h;

	function new(string name="agent", uvm_component par);
		super.new(name, par);
	endfunction: new

	function void build_phase(uvm_phase phase);
		seqr_h = seqr::type_id::create("seqr_h", this);
		drvr_h = drvr::type_id::create("drvr_h", this);
	endfunction: build_phase;

	function void connect_phase(uvm_phase phase);
		drvr_h.seq_item_port.connect(seqr_h.seq_item_export);
	endfunction: connect_phase
endclass: agent
