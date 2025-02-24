interface dut_intf (input clk);
    // inputs
    reg Reset;
    reg Pushin;
    reg FirstData;
    reg signed [16:0] DinR;
    reg signed [16:0] DinI;

    // outputs
    reg PushOut;
    reg [47:0] DataOut;
endinterface
