module tb_Project1;

    // Inputs
    reg reset;
    reg clock;
    reg capture;
    reg [1:0] op;
    reg [7:0] d_in;

    // Outputs
    wire [8:0] result;
    wire valid;

    // Instantiate the Unit Under Test (UUT)
    Project1 uut (
        .reset(reset),
        .clock(clock),
        .capture(capture),
        .op(op),
        .d_in(d_in),
        .result(result),
        .valid(valid)
    );

    // Clock generation
    always #5 clock = ~clock;

    // Test procedure
    initial begin
        // Initialize Inputs
        clock = 0;
        reset = 0;
        capture = 0;
        op = 2'b00;
        d_in = 8'b00000000;

        // Reset the design
        reset = 0;
        #10 reset = 1;

        // Test 1: All zeros (A = 0, B = 0, C = 0, D = 0)
        reset = 1;
        capture = 1;
        op = 2'b00;  // Load A
        d_in = 8'b00000000; // A = 0
        #10 op = 2'b01; // Load B
        d_in = 8'b00000000; // B = 0
        #10 op = 2'b10; // Load C
        d_in = 8'b00000000; // C = 0
        #10 op = 2'b11; // Load D
        d_in = 8'b00000000; // D = 0
        #10 capture = 0;
        #20; // Wait for computation
        $display("Test 1: result = %h, valid = %b", result, valid);
        
                // Reset the design
        reset = 0;
        #10 reset = 1;

        // Test 1: All zeros (A = 0, B = 0, C = 0, D = 0)
        reset = 1;
        capture = 1;
        op = 2'b00;  // Load A
        d_in = 8'b00000001; // A = 0
        #10 op = 2'b01; // Load B
        d_in = 8'b00000000; // B = 0
        #10 op = 2'b10; // Load C
        d_in = 8'b00000000; // C = 0
        #10 op = 2'b11; // Load D
        d_in = 8'b00000000; // D = 0
        #10 capture = 0;
        #20; // Wait for computation
        $display("Test 1: result = %h, valid = %b", result, valid);
        
                // Reset the design
        reset = 0;
        #10 reset = 1;

        // Test 1: All zeros (A = 0, B = 0, C = 0, D = 0)
        reset = 1;
        capture = 1;
        op = 2'b00;  // Load A
        d_in = 8'b11111111; // A = 0
        #10 op = 2'b01; // Load B
        d_in = 8'b11111111; // B = 0
        #10 op = 2'b10; // Load C
        d_in = 8'b00000000; // C = 0
        #10 op = 2'b11; // Load D
        d_in = 8'b00000000; // D = 0
        #10 capture = 0;
        #20; // Wait for computation
        $display("Test 1: result = %h, valid = %b", result, valid);

        reset = 0;
        #10 reset = 1;

        // Test 1: All zeros (A = 0, B = 0, C = 0, D = 0)
        reset = 1;
        capture = 1;
        op = 2'b00;  // Load A
        d_in = 8'b11111111; // A = 0
        #10 op = 2'b01; // Load B
        d_in = 8'b11111111; // B = 0
        #10 op = 2'b10; // Load C
        d_in = 8'b11111111; // C = 0
        #10 op = 2'b11; // Load D
        d_in = 8'b11111111; // D = 0
        #10 capture = 0;
        #20; // Wait for computation
        $display("Test 1: result = %h, valid = %b", result, valid);

        reset = 0;
        #10 reset = 1;

        // Test 1: All zeros (A = 0, B = 0, C = 0, D = 0)
        reset = 1;
        capture = 1;
        op = 2'b00;  // Load A
        d_in = 8'b11111111; // A = 0
        #10 op = 2'b01; // Load B
        d_in = 8'b11111111; // B = 0
        #10 op = 2'b10; // Load C
        d_in = 8'b11111111; // C = 0
        #10 op = 2'b11; // Load D
        d_in = 8'b11111110; // D = 0
        #10 capture = 0;
        #20; // Wait for computation
        $display("Test 1: result = %h, valid = %b", result, valid);


        reset = 0;
        #10 reset = 1;

        // Test 1: All zeros (A = 0, B = 0, C = 0, D = 0)
        reset = 1;
        capture = 1;
        op = 2'b00;  // Load A
        d_in = 8'b11111111; // A = 0
        #10 op = 2'b01; // Load B
        d_in = 8'b00000000; // B = 0
        #10 op = 2'b10; // Load C
        d_in = 8'b00000000; // C = 0
        #10 op = 2'b11; // Load D
        d_in = 8'b11111110; // D = 0
        #10 capture = 0;
        #20; // Wait for computation
        $display("Test 1: result = %h, valid = %b", result, valid);


        // Finish simulation
        $stop;
    end
endmodule
