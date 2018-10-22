module bancoRegistrador (clk, RAddress1, RAddress2, dataWrite, RWhich, writeEnabled, R1, R2);
	parameter XLEN=32;
	parameter AMOUNT=16;
	parameter ADDRESSLEN=4;
	parameter READ_DELAY=20;
	
	input [ADDRESSLEN-1:0] RAddress1, RAddress2, RWhich;
	input writeEnabled;
	input [XLEN-1:0] dataWrite;
	
	input clk;
	
	output reg [XLEN-1:0] R1, R2;
	
	reg [XLEN-1:0] registers [AMOUNT-1:0];
	
	always @(negedge clk) begin
		if (writeEnabled) registers[RWhich] <= dataWrite;
	end
	
	always @(posedge clk) begin
		R1 <= registers[RAddress1];
		R2 <= registers[RAddress2];
	end
endmodule
