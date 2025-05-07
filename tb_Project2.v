`timescale 1ns / 1ps

module Project2_tb;
    // Inputs
    reg clock;
    reg reset;
    reg din;

    // Output
    wire result;
//    wire[6:0] counter;
//    wire[15:0] variable1;
//    wire[15:0] variable2;
//    wire operate;
//    wire[19:0] staticresult;
//    wire[7:0] detectstream;
//    wire[27:0] fullout;
//    wire qout;

    // Instantiate the DUT (Device Under Test)
    Project2 uut (
        .clock(clock),
        .reset(reset),
        .din(din),
        .result(result)
//        ,.counter(counter),
//        .variable1(variable1),
//        .variable2(variable2),
//        .operate(operate),
//        .staticresult(staticresult),
//        .detectstream(detectstream),
//        .fullout(fullout),
//        .qout(qout)
    );

    // Clock generation
    initial begin
        clock = 0;
        forever #5 clock = ~clock; // 10ns clock period
    end

    // Task to send data serially
    task send_serial_data(input [40:0] data);
        integer i;
        begin
            for (i = 40; i >= 0; i = i - 1) begin
                din = data[i];
                #10; // Wait for one clock cycle
            end
        end
    endtask

    // Main test sequence
    initial begin
        // Initialize inputs
        reset = 1;
        din = 0;

        // Reset sequence
        #20;
        reset = 0;
        #10;

        // Test case 1: Valid CONTROLBITS "5A", operation bit = 0 (addition)
        // a = 1234, b = 5678, operation = 0
        $display("Test Case 1: Valid CONTROLBITS with Addition");
        send_serial_data({8'b01011010, 1'b0, 16'h9999, 16'h0001}); // Control bits, operation, inputs
        #300;


        // Finish simulation
        $stop;
    end

    // Monitor to check the serial output
    initial begin
        $monitor("Time: %0d, din: %b, result: %b", $time, din, result);
    end
endmodule

//, variable1: %b, variable2: %b, operate: %b
//, variable1, variable2, operate