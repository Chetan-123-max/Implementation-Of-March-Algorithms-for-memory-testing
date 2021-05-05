//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 15.04.2021 12:16:12
// Design Name: 
// Module Name: MarchX_tb
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

module MarchX_tb;

parameter CAWIDTH = 2;
parameter RAWIDTH = 2;

integer maxsize = 2**RAWIDTH;
integer i,j;

reg clk;
reg Test;
reg status;
reg [3:0] state;
reg rst;

//signals and registers used to input the data into the memory through the system
reg [RAWIDTH-1:0] RA;
reg [CAWIDTH-1:0] CA;
reg we,re;
reg datain;
wire dataout;

//internal registers
reg [31:0]count;
reg element_done;
reg [1:0]element_operation;
reg fresh_state;
reg [3:0]nextstate;

initial
begin
    clk = 0;
    forever
    #1 clk = ~clk;
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
    #4;
    Test = 1;
    rst = 0;
    status = 0;
    state = 3'd0;
end

always @(posedge clk)
begin
if(Test == 1)
begin

    case(state)
    
    3'd0:
		begin
		status = 0;
		// W0 (updown)
		if(fresh_state == 1)
			begin
			//set the variables to 0 and 0
			RA = 0; 
			CA = 0;
			$display("W0 (updown) beginning");			
			end 
		else 
			begin 
				count = count+1; 
				if(CA == maxsize-1)
				begin 
					RA = RA+1; 
					CA = 0; 
				end 
				else 
				begin 
					CA = CA+1; 
				end
			end
			
		datain = 0;
		we = 1;
		fresh_state = 0;
		
		if(count == maxsize**2) 
		begin
			$display("W0 (updown) done");
			nextstate = 3'd1;
		end
		
		end
    
    
    3'd1:
		begin
		status = 0;
		// R0,W1 (up)

		if(fresh_state==1)
		begin 
			$display("R0,W1 (up) beginning");
			RA = 0; 
			CA = 0; 
		end
		else 
			if(element_done)
			begin 
				element_done = 0; 
				count = count+1;
				if(CA == maxsize-1)
				begin 
					RA = RA+1; 
					CA = 0; 
				end  
				else 
					CA = CA+1;
			end
			
		fresh_state=0;
		
		case(element_operation)
			2'b00: 
				//R0
				begin 
				we=0;
				re=1;          
				element_operation=2'b01; 
				end
					
			2'b01: 
				//W1
				begin 
				if(dataout != 0)
					status=1; 
				we=1;
				re=0;         
				datain=1;
				element_done=1;
				element_operation=2'b00;
				end
		endcase       
				
		if(count == maxsize**2) 
		begin
			$display("R0,W1 (up) done");
			nextstate = 3'd2;
		end

		end

    3'd2:
		begin
		status = 0;
		// R1,W0 (down)
		if(fresh_state==1)
		begin
			$display("R1,W0 (down) beginning");
			RA=maxsize-1; CA=maxsize-1;
		end
		else 
			if(element_done)
			begin 
				element_done=0; 
				count=count+1;
				if(CA==0)
				begin 
					RA=RA-1; 
					CA=maxsize-1; 
				end  
				else 
					CA=CA-1;
			end
			
		fresh_state=0;
		
		case(element_operation)
			2'b0: 
				//R1
				begin 
				we=0;
				re=1;          
				element_operation=2'b1; 
				end
					
			2'b1: 
				//W0
				begin 
				if(dataout != 1)
					status=1;
				we=1;
				re=0;         
				datain=0;
				element_done=1;
				element_operation=2'b0;
				end
		endcase                    
			
		if(count == maxsize**2) 
		begin
			$display("R1,W0 (down) done");
			nextstate = 3'd3;
		end

		end
    

    3'd3:
		begin
		status = 0;
		// R0
		if(fresh_state==1)
		begin
			$display("R0 (updown) beginning");
			RA=0; 
			CA=0;
		end
		else 
			begin 
			count=count+1; 
			if(CA==maxsize-1)
			begin 
				RA=RA+1; 
				CA=0; 
			end 
			else 
				CA=CA+1; 
			end
		
		fresh_state=0;
		
		we=0;
		re=1;
		if(dataout != 0)
			status=1;
		
		if(count == maxsize**2) 
		begin
			$display("R0 (updown) done");
			Test = 0;
			$finish;
		end

		end
    
    endcase

end
end

//Define variables for every state
always @(state)
begin 
    count <= 0;
	element_operation <= 0;
	fresh_state <= 1; 
end

always@(nextstate)
begin
	state=nextstate;
end

//Print the test result
always @(Test, status)
begin
if(Test)
	if(status)
		begin
		$display("Error found !!");
		$display("Memory Test Failed");
		end
end

always @(negedge clk)
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