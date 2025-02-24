class tb extends uvm_test;
	`uvm_component_utils(tb)
	// create environment
	env env_h0;
	//env env_h1;

	
	complex a, b, c;
	bit [16:0] d;
	function new(string name="tb", uvm_component par);
		super.new(name, par);
	endfunction: new
	
	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env_h0 = env::type_id::create("env0", this);

		//env_h1 = env::type_id::create("env1", this);
	endfunction: build_phase

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction: connect_phase
	
	function void end_of_elaboration_phase(uvm_phase phase);
		uvm_top.print_topology();
	endfunction: end_of_elaboration_phase
	
	task run_phase(uvm_phase phase);
		seq bob = new();
		phase.raise_objection(this);
		bob.start(env_h0.agent_h.seqr_h);
		phase.drop_objection(this); 
	endtask: run_phase	


endclass: tb
