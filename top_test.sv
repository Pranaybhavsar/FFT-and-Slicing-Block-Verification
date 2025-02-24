`include "complex_pkg.sv"

package complex_tb_pkg;
import complex_pkg::*;
import uvm_pkg::*;


//----- test -----//
class test extends uvm_test;
`uvm_component_utils(test)

function new(string name="test", uvm_component par);
	super.new(name, par);
endfunction

task run_phase(uvm_phase phase);
	
endtask


endclass;

endpackage;


module real_to_q1_15_converter;

    // Function to convert a real number to Q1.15 fixed-point binary representation
    function bit [15:0] real_to_q1_15(real value);
        real scaled_value;
        bit [15:0] binary_representation; // Binary representation with 1 integer bit and 15 fractional bits

        scaled_value = value * 2**15; // Scale the real number by 2^15
        integer rounded_value;
        // rounded_value = $rtoi(scaled_value); // Round to the nearest integer

        // Convert the rounded integer to binary
        $display(value * 2**15);
        $display(scaled_value);


        return binary_representation; // Return the Q1.15 binary representation
    endfunction

    // Testbench
    initial begin
        real input_real = 3.14; // Input real number
        bit [15:0] q1_15_representation; // Variable to store Q1.15 representation

        // Convert the real number to Q1.15 format
        q1_15_representation = real_to_q1_15(input_real);

        // Display the Q1.15 representation
        $display("Q1.15 representation of %f: %b", input_real, q1_15_representation);
    end

endmodule
