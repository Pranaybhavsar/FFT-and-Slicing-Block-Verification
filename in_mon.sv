class in_mon extends uvm_monitor;
`uvm_component_utils(in_mon)

// declare messages
uvm_analysis_port #(dut_signals) in_mon_port;
dut_signals mx;

// declare vif
virtual dut_intf vif;

function new(string name="in_mon", uvm_component par);
    super.new(name, par);
endfunction

function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    in_mon_port = new("in_mon_port", this);
    if (!uvm_config_db #(virtual dut_intf)::get(null, "interface", "intf", vif)) begin
        `uvm_fatal("IN_MON", "Didn't get handle to virtual interface alu_intf!!!")
    end
    else begin
        `uvm_info("IN_MON", "Vif obtained successfully!", UVM_MEDIUM)
    end
endfunction

real SF = 30517578125e-15;
task run_phase(uvm_phase phase);
    mx = new();

    forever begin
        @ (posedge vif.clk) begin
            if (vif.Pushin) begin
                // `uvm_info("IN_MON", "SENDING MX", UVM_MEDIUM)

                mx.DinR = vif.DinR;
                mx.DinI = vif.DinI;
                in_mon_port.write(mx);

            end

           //`uvm_info("IN_MON", $sformatf("DinR=%f, DinI=%f", $itor($signed(mx.DinR )* SF), $itor($signed(mx.DinI) * SF)), UVM_MEDIUM)

        end
    end
endtask

endclass
