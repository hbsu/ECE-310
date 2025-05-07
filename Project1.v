`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/21/2024 10:33:51 PM
// Design Name: 
// Module Name: Project4
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Project1(
    input reset,
    input clock,
    input capture,
    input [1:0] op,
    input[7:0] d_in,
    output [8:0] result,
    output valid
    );
    
   wire[7:0] A, B, C, D;
   wire flagall;
  
  //controller for all the flags
   controller c1(flagall, A, B, C, D, d_in, clock, capture,reset, op[1], op[0]);
   
   //calculates the result of (A+B) -(C+D) and assigns it into result. 
   datapath dp(result, valid, clock, reset, flagall, A, B, C, D);

endmodule




module datapath(
    output[8:0] result, output valid,
    input clock, reset, flagall,
    input [7:0] A, B, C, D
);
    wire[8:0] out;
    fullProcess fP(out, A, B, C, D); //full process of the system. (A+B) - (C+D);
   
    validff v1(valid, clock, reset, flagall);
   
    dffResult finalres(result, clock, flagall, out, reset); //final d flip flop, output result if valid. Equivalent to not computing unless on. 

endmodule

module controller(
    output flagall, output [7:0] A, B, C, D, 
    input[7:0] d_in,
    input clock,
    input capture,
    input reset,
    input a, b
);
   wire flagA, flagB, flagC, flagD;
   wire enableA, enableB, enableC, enableD, flagall;

//these couple lines emulate a "demux", where the input line gets funneled depending on the select bits.
   assign enableA = capture & (~a & ~b) & reset; //control unit to check if A, B, C, or D should be updated at all, like a flag 
   assign enableB = capture & (~a & b) &  reset;
   assign enableC = capture & (a & ~b) & reset;
   assign enableD = capture & (a & b) & reset;
   
   loadABCD lA(A, d_in,clock, reset, enableA); //Loads values only on the condition that the reset is not active and the corresponding enable is active. 
   loadABCD lB(B, d_in, clock, reset, enableB);
   loadABCD lC(C, d_in, clock, reset, enableC);
   loadABCD lD(D, d_in, clock, reset, enableD);
   
   flagff fA(flagA, clock, reset, enableA); //Active flag if corresponding value is on.
   flagff fB(flagB, clock, reset, enableB);
   flagff fC(flagC, clock, reset, enableC);
   flagff fD(flagD, clock, reset, enableD);
   
   assign flagall = flagA & flagB & flagC & flagD; //control for the flag, and them all together, so if all equal 1, flagall turns on. 

endmodule


//valid dff
module validff(
    output reg valid,
    input clock,
    input reset,
    input flagall
);

always @(posedge clock)
    valid <= (flagall & ~valid)& reset;

endmodule

//Flag d flip flop.
module flagff(
    output reg flagout,
    input clock,
    input reset,
    input enable
);

always @(posedge clock)
    flagout <= ((enable) | (~enable & flagout)) & reset;

endmodule

//(A+B) - (C+D)
module fullProcess(
    output[8:0] out,
    input[7:0] A, B, C, D
);
    wire[8:0] u1, u2 ,u3;
    bitAdder AB(u1, A, B);
    bitAdder CD(u2, C, D);
    subtraction ABCD(out, u1, u2);

endmodule


//(Nots the second value, adds 1 (two's complement transition), and adds it to first value to perform subtraction
module subtraction(
    output [8:0]out,
    input[8:0] X, Y
);
    //NOT Y
    wire[8:0] notY, minusY;
    wire[8:0] uno = 9'b000000001;
    bitNot nY(notY, Y);
    bitAdder8 ba8(minusY, uno, notY); //negate and add 1
    bitAdder8 baf(out, X, minusY); //X - Y

endmodule


//Not all the bits of a 9 bit value
module bitNot(
    output[8:0] Z,
    input [8:0] X
    );
    
    assign Z[0] = ~X[0];
    assign Z[1] = ~X[1];
    assign Z[2] = ~X[2];
    assign Z[3] = ~X[3];
    assign Z[4] = ~X[4];
    assign Z[5] = ~X[5];
    assign Z[6] = ~X[6];
    assign Z[7] = ~X[7];
    assign Z[8] = ~X[8];

    
endmodule

//Adder for two 9 bit values, outputs a 9 bit binary number
module bitAdder8(
    output[8:0] Z,
    input [8:0] X,
    input [8:0] Y
    );
    wire [8:0] Carry;
    fullAdder fbfa0(X[0],Y[0], 1'b0, Z[0], Carry[0] );
    fullAdder fbfa1(X[1],Y[1], Carry[0], Z[1], Carry[1] );
    fullAdder fbfa2(X[2],Y[2], Carry[1], Z[2], Carry[2] );
    fullAdder fbfa3(X[3],Y[3], Carry[2], Z[3], Carry[3] );
    fullAdder fbfa4(X[4],Y[4], Carry[3], Z[4], Carry[4] );
    fullAdder fbfa5(X[5],Y[5], Carry[4], Z[5], Carry[5] );
    fullAdder fbfa6(X[6],Y[6], Carry[5], Z[6], Carry[6] );
    fullAdder fbfa7(X[7],Y[7], Carry[6], Z[7], Carry[7] );
    fullAdder fbfa8(X[8],Y[8], Carry[7], Z[8], Carry[8] );

endmodule

//Adder for two 8 bit values, outputs a 9 bit binary number
module bitAdder(
    output[8:0] Z,
    input [7:0] X,
    input [7:0] Y
    );
    wire [7:0] Carry;
    fullAdder f0(X[0],Y[0], 1'b0, Z[0], Carry[0] );
    fullAdder f1(X[1],Y[1], Carry[0], Z[1], Carry[1] );
    fullAdder f2(X[2],Y[2], Carry[1], Z[2], Carry[2] );
    fullAdder f3(X[3],Y[3], Carry[2], Z[3], Carry[3] );
    fullAdder f4(X[4],Y[4], Carry[3], Z[4], Carry[4] );
    fullAdder f5(X[5],Y[5], Carry[4], Z[5], Carry[5] );
    fullAdder f6(X[6],Y[6], Carry[5], Z[6], Carry[6] );
    fullAdder f7(X[7],Y[7], Carry[6], Z[7], Carry[7] );
    assign Z[8] = Carry[7];

endmodule

//Simple full adder implementation.
module fullAdder(
    input A,
    input B,
    input Cin,
    output X,
    output Cout
);

    wire u1, u2, u3;
    xor(u1, A, B);
    xor(X, u1, Cin);
    and(u2,u1,Cin);
    and(u3,A, B);
    or(Cout, u3, u2);

endmodule


//Final d flip flop for choosing if to "calculate" the result.
module dffResult(
    
    output wire[8:0] out,
    input clock,
    input valid,
    input[8:0] in,
    input reset
);

    dff dfr0(clock, valid, in[0], reset, out[0]);
    dff dfr1(clock, valid, in[1], reset, out[1]);
    dff dfr2(clock, valid, in[2], reset, out[2]);
    dff dfr3(clock, valid, in[3], reset, out[3]);
    dff dfr4(clock, valid, in[4], reset, out[4]);
    dff dfr5(clock, valid, in[5], reset, out[5]);
    dff dfr6(clock, valid, in[6], reset, out[6]);
    dff dfr7(clock, valid, in[7], reset, out[7]);
    dff dfr8(clock, valid, in[8], reset, out[8]);

endmodule


//loads corresponding ABCD if flag is on. 
module loadABCD(
    output[7:0] out,
    input[7:0] in,
    input clock,
    input reset,
    input enable
  );
  
  dff b0(clock, enable, in[0], reset, out[0]);
  dff b1(clock, enable, in[1], reset, out[1]);
  dff b2(clock, enable, in[2], reset, out[2]);
  dff b3(clock, enable, in[3], reset, out[3]);
  dff b4(clock, enable, in[4], reset, out[4]);
  dff b5(clock, enable, in[5], reset, out[5]);
  dff b6(clock, enable, in[6], reset, out[6]);
  dff b7(clock, enable, in[7], reset, out[7]);
  
endmodule

//d flip flop implementation
module dff(
    input clock,
    input enable,
    input D,
    input reset,
    output reg Q
);
    always @(posedge clock)
        Q <= ((enable & D) | (~enable & Q)) & reset;

endmodule
