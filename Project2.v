`timescale 1ns / 1ps


module Project2(
    input clock,
    input reset,
    input din,
    output reg result
    );
    
    reg[7:0] CONTROLBITS = 8'b01011010; //5A comparison
    reg[7:0] RESULTBITS = 8'b10010110;
    
    reg[40:0] input_reg; //8 bits control, 1 bit operation, 2 * 16 numbers
    reg[27:0] output_reg; //8 bits result alert, 20 bits bcd numbers
    reg[6:0] count; //bit counter
    reg startoutputting; //load enable
    reg compute; //start computing
    reg operation; //operation bit
    reg shift;
    reg[5:0] shift_counter;
    
    reg[3:0] a3, a2, a1, a0; //input1
    reg[3:0] b3, b2, b1, b0; //input2
    reg[3:0] f4, f3, f2, f1, f0;

    reg [4:0] sum0, sum1, sum2, sum3; // 5-bit sum to handle carry
    reg [3:0] a[3:0], b[3:0];
    reg [3:1] carry;
    reg [4:0] diff0, diff1, diff2, diff3; // 5-bit to handle borrow
    reg [3:1] borrow;
    
    //Serial input, parallel output
    always@(posedge clock) begin
        if(reset) begin
            input_reg = 41'b0;
            count = 6'b0;
            startoutputting = 1'b0;
            shift = 1'b0;
            shift_counter = 1'b0;
            output_reg = 28'b0;
        end else begin
            input_reg = {input_reg[39:0], din};
            count = count + 1'b1;//increment counter

            if(count == 8) begin
               //check if equal to 5A
               if(input_reg[7:0] == CONTROLBITS) begin
               //i guess do nothing
                count = count; //keep counter going
               end
               else begin
               count = count - 1; //reset counter if not true
               end
            end
                if(count == 41) begin
                    compute = 1'b1;
                    output_reg[27:20] = RESULTBITS;    

                    end
               end
    end
    
    
    always @(posedge clock) begin
        if (reset || (shift_counter == 28)) begin
            shift = 1'b0;
            startoutputting = 1'b0;
            shift_counter = 5'b0;
        end else if (startoutputting) begin
            shift = 1;
            result = output_reg[27];
            output_reg = {output_reg[26:0], 1'b0};
            shift_counter = shift_counter + 1;

        end
    end
    
    //ALU data execution
    always @(*) begin
        if (compute) begin
                a3 = input_reg[31:28];
                a2 = input_reg[27:24];
                a1 = input_reg[23:20];
                a0 = input_reg[19:16];
                
                b3 = input_reg[15:12];
                b2 = input_reg[11:8];
                b1 = input_reg[7:4];
                b0 = input_reg[3:0];
                
                
            if(input_reg[32] == 0) begin
                //perform BCD addition
                // Compute BCD addition for each digit
                        // Digit 0
                        sum0 = a0 + b0 + 1'b0;
                        if (sum0 > 9) begin
                            f0 = sum0 - 10;
                            carry[1] = 1;
                        end else begin
                            f0 = sum0[3:0];
                            carry[1] = 0;
                        end
                
                        // Digit 1
                        sum1 = a1+ b1 + carry[1];
                        if (sum1 > 9) begin
                            f1 = sum1 - 10;
                            carry[2] = 1;
                        end else begin
                            f1 = sum1[3:0];
                            carry[2] = 0;
                        end
                
                        // Digit 2
                        sum2 = a2 + b2 + carry[2];
                        if (sum2 > 9) begin
                            f2 = sum2 - 10;
                            carry[3] = 1;
                        end else begin
                            f2 = sum2[3:0];
                            carry[3] = 0;
                        end
                
                        // Digit 3
                        sum3 = a3 + b3 + carry[3];
                        if (sum3 > 9) begin
                            f3 = sum3 - 10;
                            f4 = 4'b0001; // Set F4 to 1 to indicate carry out
                        end else begin
                            f3 = sum3[3:0];
                            f4 = 4'b0000;
        end
                
                output_reg[19:16] = f4;
                output_reg[15:12] = f3;
                output_reg[11:8] = f2;
                output_reg[7:4] = f1;
                output_reg[3:0] = f0;
                startoutputting = 1'b1;
                compute = 1'b0;     

                
            end else begin    
        // Compute BCD subtraction for each digit
        // Digit 0
                    diff0 = a0 - b0;
                    if (diff0[4] == 1) begin
                        f0 = diff0 + 10; // Add 10 if borrow occurred
                        borrow[1] = 1;
                    end else begin
                        f0 = diff0[3:0];
                        borrow[1] = 0;
                    end
            
                    // Digit 1
                    diff1 = a1 - b1 - borrow[1];
                    if (diff1[4] == 1) begin
                        f1 = diff1 + 10;
                        borrow[2] = 1;
                    end else begin
                        f1 = diff1[3:0];
                        borrow[2] = 0;
                    end
            
                    // Digit 2
                    diff2 = a2 - b2 - borrow[2];
                    if (diff2[4] == 1) begin
                        f2 = diff2 + 10;
                        borrow[3] = 1;
                    end else begin
                        f2 = diff2[3:0];
                        borrow[3] = 0;
                    end
            
                    // Digit 3
                    diff3 = a3 - b3 - borrow[3];
                    if (diff3[4] == 1) begin
                        f3 = diff3 + 10;
                        f4 = 4'b0001; // Set F4 to indicate borrow out
                    end else begin
                        f3 = diff3[3:0];
                        f4 = 4'b0000;
        end
                
                 
                output_reg[19:16] = f4;
                output_reg[15:12] = f3;
                output_reg[11:8] = f2;
                output_reg[7:4] = f1;
                output_reg[3:0] = f0;
                startoutputting = 1'b1;
                compute = 1'b0;       


                 
                 
                 
            end
        end
    end
   
endmodule
