class out_mon extends uvm_monitor;
`uvm_component_utils(out_mon)

// declare messages
uvm_analysis_port #(dut_signals) out_mon_port;
dut_signals mx;

// declare vif
virtual dut_intf vif;

function new(string name="out_mon", uvm_component par);
    super.new(name, par);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    out_mon_port = new("out_mon_port", this);
    if (!uvm_config_db #(virtual dut_intf)::get(null, "interface", "intf", vif)) begin
        `uvm_fatal("OUT_MON", "Didn't get handle to virtual interface alu_intf!!!")
    end
    else begin
        `uvm_info("OUT_MON", "Vif obtained successfully!", UVM_MEDIUM)
    end
endfunction

task run_phase(uvm_phase phase);
    mx = new();
    forever begin
        @(posedge vif.PushOut) begin
            mx.DataOut = vif.DataOut;
            `uvm_info("OUT_MON", $sformatf("GOT AN OUTPUT!: %h", mx.DataOut), UVM_MEDIUM)
            out_mon_port.write(mx);
        end
    end
endtask
endclass
