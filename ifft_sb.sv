// ifft sb
class ifft_sb extends uvm_scoreboard;
`uvm_component_utils(ifft_sb)

// declare messages
uvm_tlm_analysis_fifo #(ifft_inout) ifft_in_fifo;
ifft_inout ifft_in_h;

uvm_analysis_port #(ifft_inout) ifft_out;
ifft_inout ifft_out_h;

function new(string name="ifft_sb", uvm_component par);
    super.new(name, par);
endfunction: new

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ifft_in_fifo = new("ifft_in_fifo", this);
    ifft_out = new("ifft_out", this);
endfunction: build_phase

complex complex_arr[128];
complex reversed_arr[128];

task run_phase(uvm_phase phase);
    ifft_in_h = new();
    ifft_out_h = new();

    forever begin
        ifft_in_fifo.get(ifft_in_h);
        //`uvm_info("IFFT_SB", "Got a message!", UVM_MEDIUM)

        complex_arr = ifft_in_h.queue;
        ifft(complex_arr, reversed_arr);
        ifft_out_h.queue = reversed_arr;
 //        foreach (reversed_arr[i]) begin
	// 	`uvm_info("IFFT_SB", $sformatf("Frequence %0d: Real = %0f, Imag = %0f", i, reversed_arr[i].r, reversed_arr[i].i), UVM_MEDIUM);
	// end

        ifft_out.write(ifft_out_h);
    end

	// foreach (ifft_inout_h.in_queue[i]) begin
	// 	`uvm_info("IFFT_SB: RUN_PHASE", $sformatf("Frequence %0d: Real = %0f, Imag = %0f", i, ifft_inout_h.in_queue[i].r, ifft_inout_h.in_queue[i].i), UVM_MEDIUM);
	// end



    // gen_test_case();
    // br(complex_arr, reversed_arr);
endtask: run_phase

task ifft(input complex d[128], output complex reversed_arr[128]);
    int spread, bs, i1, i2;
    logic [5:0] twix;
    logic [45:0] t;
    real SF = 30517578125e-15;  //2**-15

    logic [22:0] bit_r, bit_i;
        // `uvm_info("TEST", $sformatf("%d, %d", SF, SF1), UVM_MEDIUM);

    complex complex_t, v, a, b;

    br(d, reversed_arr);

    spread = 2;
    for (int lvl=0; lvl<7; lvl++) begin
        bs = 0;
        // foreach (reversed_arr[i]) begin
        //     `uvm_info("IFFT_SB: IFFT", $sformatf("level=%0d, index=%0d, real=%f, imag=%f", lvl, i, reversed_arr[i].r, reversed_arr[i].i), UVM_MEDIUM)
        // end
        while (bs<128) begin
            for (int ix=bs; ix<$rtoi(bs+spread/2); ix++) begin
                // `uvm_info("IFFT_SB: IFFT", $sformatf(), UVM_MEDIUM)
                twix = (ix%spread)*($rtoi(128/spread));
                i1 = ix;
                i2 = $rtoi(ix+spread/2);
                t = ifftwiddle(twix);
                bit_r = t[45:23];
                bit_i = t[22:0];
                // $display("%f", bit_r[16:0]*SF);
                // $display("%f", bit_i[16:0]*SF);
                // convert 8.15 to 2.15

                // $display("%b", bit_r);
                // $display("%b", bit_i);
                complex_t.r = $itor($signed(bit_r[16:0]) * SF);
                complex_t.i = $itor($signed(bit_i[16:0]) * SF);
                // $display("reversed_arr.r = %f, reversed_arr.i = %f,\ncomplex_t.r = %f, complex_t.i = %f", reversed_arr[i2].r,
                // reversed_arr[i2].i,
                // complex_t.r, complex_t.i);
                v = complex_mul(reversed_arr[i2], complex_t);
                // $display(reversed_arr[i2]);
                // $display(complex_t);
                // $display("%d", bit_r);
                // `uvm_info("IFFT_SB: IFFT", $sformatf("lvl:%0d, bs: %0d, ix: %d real: %0f, imag: %0f", lvl, bs, ix, complex_t.r, complex_t.i), UVM_MEDIUM)
                 // `uvm_info("IFFT_SB: IFFT", $sformatf("lvl: %0d, bs: %0d, ix: %0d real: %0f, imag: %0f", lvl, bs, ix, v.r, v.i), UVM_MEDIUM)
                a = complex_add(reversed_arr[i1], v);
                b = complex_sub(reversed_arr[i1], v);
                reversed_arr[i1] = a;
                reversed_arr[i2] = b;
            end
            bs += spread;

        end
        spread *= 2;
    end

    foreach(reversed_arr[i]) begin
        reversed_arr[i].r /= 128;
        reversed_arr[i].i = 0;
    end





 //    foreach (reversed_arr[i]) begin
 //        `uvm_info("IFFT_SB: IFFT", $sformatf("Frequence %0d: Real = %0f, Imag = %0f", i, ifft_inout_h.in_queue[i].r, ifft_inout_h.in_queue[i].i), UVM_MEDIUM);
	// end

endtask

task br(input complex d[128], output complex reversed_arr[128]);

    int wx, rx;
    for (int ix=0; ix<128; ix++) begin
        wx = ix;
        rx = 0;
        for (int qq=0; qq<7; qq++) begin
            rx = rx * 2;
            if (wx&1 != 0) begin
                rx = rx|1;
            end
            wx = wx>>1;
        end
        reversed_arr[ix] = d[rx];

    end

    // for (int i = 0; i<128; i++) begin
    //     $display("Complex element %0d: Real = %f, Imaginary = %f", i, reversed_arr[i].r, reversed_arr[i].i);
    // end

endtask

endclass: ifft_sb
