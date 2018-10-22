module branchAdder (clk, pc, increment, out);
	parameter XLEN = 32;
	
	input clk;
	input [XLEN-1:0] pc;
	input [XLEN-1:0] increment;
	output reg [XLEN-1:0] out;
	
	always @(posedge clk) begin
		out <= pc + (increment<<1);
	end
	
endmodule
