class seq extends uvm_sequence #(dut_signals);
	`uvm_object_utils(seq);

	// declare msg type
	dut_signals mx;
	reg [23:0] upper, lower;
	function new(string name="seq");
		super.new(name);
	endfunction

	task body();
		mx = new();
		repeat(10000) begin
			start_item(mx);
			upper = $random();
			lower = $random();
		 	mx.data = {upper, lower};
	 		finish_item(mx);
		end
  // //
		// start_item(mx);
		// mx.data = 48'hE23456789F1B;
		// finish_item(mx);
  //
		start_item(mx);
		mx.data = 48'h15ffbafe9049;
		finish_item(mx);

		// start_item(mx);
		// mx.data = 48'h555555555555;
		// finish_item(mx);


	endtask: body

endclass: seq
