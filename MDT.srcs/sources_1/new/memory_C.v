`timescale 1ns / 1ps

//(1)Transaction of only bit is allowed(i.e datain and dataout are of 1 bit each) 
//   since march algorithm is primarily useful for cell testing.
//(2)4x4 memory array created. A cell can be selected by giving both row address(RA)
//   and column address(CA)


module memory_C#(parameter RAWIDTH = 2,  CAWIDTH = 2) //RAWIDTH=Row Adress Width and CAWIDTH=Column address width
				(
				// Clock and Reset
				input clk,
				input rst,

				//Column and Row address
				input [RAWIDTH-1:0]RA,
				input [CAWIDTH-1:0]CA,

				// Write Interface
				input we,
				input datain,

				// Read Interface
				input re,
				output reg dataout  //one bit data coming out from one cell
				);
//create memory model
localparam rDEPTH = 2**RAWIDTH;
localparam cDEPTH = 2**CAWIDTH;

reg [cDEPTH-1:0] memory [rDEPTH-1:0];

integer i,j;

always @(posedge clk)
begin
	if(rst)
	begin
		for(i=0; i < 2**RAWIDTH ;i=i+1)
			begin
			for(j=0; j < 2**CAWIDTH;j=j+1)
				begin
					memory[i][j] <= 0;
				end
			end
	end
	else
		begin
			if(we)
				memory[RA][CA] <= datain;
		end
		
end

always@(memory[2][2])
if(memory[2][2]==1)
begin
    memory[2][0]=1;
end


always @ (posedge clk)
begin
	if(re)
		dataout <= memory[RA][CA];
end

endmodule   
