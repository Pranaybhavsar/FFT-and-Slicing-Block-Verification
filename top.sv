`include "complex_pkg.sv"

package tb_pkg;
import uvm_pkg::*;
import complex_pkg::*;

`include "ifftw.sv"
`include "fftw.sv"
`include "msg_items.sv"
`include "seq.sv"
`include "seqr.sv"
`include "drvr.sv"
`include "agent.sv"
`include "ifft_sb.sv"
`include "fft_sb.sv"
`include "encode.sv"
`include "point_accum.sv"
`include "comparator.sv"
`include "in_mon.sv"
`include "out_mon.sv"
`include "decode.sv"
`include "env.sv"
`include "test.sv"

endpackage: tb_pkg

import uvm_pkg::*;

// interface definition
`include "intf.sv"
module top();

	// define clk and start it
	logic clk;

	initial begin
		clk = 0;
		// repeat(50000) #10 clk = ~clk;
		forever #10 clk = ~clk;
	end

	// define interface
	dut_intf dut_intf_h(clk);

	// define the dut
	ofdmdec dut(
		.Clk (clk),
		.Reset (dut_intf_h.Reset),
		.Pushin (dut_intf_h.Pushin),
		.FirstData (dut_intf_h.FirstData),
		.DinR (dut_intf_h.DinR),
		.DinI (dut_intf_h.DinI),

		.PushOut (dut_intf_h.PushOut),
		.DataOut (dut_intf_h.DataOut)
	);

	initial begin
		uvm_config_db #(virtual dut_intf)::set(null, "interface", "intf", dut_intf_h);
		run_test("tb");
	end	

	// initial begin
	// 	$dumpfile("dut.vpd");
	// 	$dumpvars(9,top);
 //
	// end

endmodule: top
