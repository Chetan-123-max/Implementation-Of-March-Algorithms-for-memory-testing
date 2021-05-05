//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.04.2021 12:12:38
// Design Name: 
// Module Name: error_tb
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
`timescale 1ns / 1ps

module error_tb;

parameter CAWIDTH = 2;
parameter RAWIDTH = 2;
integer maxsize = 2**RAWIDTH;
integer i,j;

reg clk;
reg Test;
reg rst;

//signals and registers used to input the data into the memory through the system
reg [RAWIDTH-1:0] RA;
reg [CAWIDTH-1:0] CA;
reg we,re;
reg datain;
wire dataout;

//Objects for Waveform viewer
//reg SA;
//reg T;
//reg C1;
//reg C2;
//reg MSA1;
//reg MSA2;
//reg IdC1_a;
//reg IdC2_v;
//reg InvC1_a;
//reg InvC2_v;

initial
begin
    clk = 0;
    forever
    #50 clk = ~clk;
end

// Choose the type of memory
// Using just "memory" will run the standard model
// add "_SA" for Stuck at fault
// add "_T" for Transition fault
// add "_C" for Coupling fault
// add "_MSA" for Multiple select address fault
// add "_InvC" for Inversion coupling fault
// add "_IdC" for Idempotent coupling fault
memory u(   //Clock and Reset
            .clk(clk),
            .rst(rst),
            //Row and Column Address
            .RA(RA),
            .CA(CA),
            //Write Interface
            .we(we),
            .datain(datain),
            //Read Interface
            .re(re),
            .dataout(dataout)
        );

initial
begin
    Test = 0;
    rst = 1;  //forces all the cells to go to zero and takes controller to ideal state
    #100;
    Test = 1;
    rst = 0;
    
    //inputs to test if the errors are introduced properly
    we=1; RA=0; CA=0; datain=1;
    #100;
    we=1; RA=1; CA=3; datain=1;
    #100;
    we=1; RA=1; CA=3; datain=0;
    #100
    we=1; RA=2; CA=0; datain=1;
    #100;
    we=1; RA=2; CA=2; datain=0;
    #100;
    we=1; RA=3; CA=3; datain=1;
    #100;
    we=1; RA=1; CA=2; datain=1;
    #100;
    we=1; RA=2; CA=3; datain=1;
    #100;
    we=1; RA=1; CA=3; datain=1;
    #200 
    $finish;
end

//always@*
//begin
//    SA=u.memory[0][0];
//    T=u.memory[1][3];
//    C1=u.memory[2][0];
//    C2=u.memory[2][2];
//    MSA1=u.memory[3][3];
//    MSA2=u.memory[0][3];
//    IdC1_a=u.memory[1][2];
//    IdC2_v=u.memory[2][1];
//    InvC1_a=u.memory[2][3];
//    InvC2_v=u.memory[0][2];
//end


always @(posedge clk)
begin
    for(i=0; i<maxsize; i=i+1)
    begin
        for(j=0; j<maxsize; j=j+1)
        begin
            $write("%b",u.memory[i][j]);
        end
        $display();
    end
    $display();
end

endmodule
