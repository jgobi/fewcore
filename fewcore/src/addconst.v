module addconst (clk, in, out);
	parameter XLEN = 32;
	parameter CONST = 4;
	
	input clk;
	input [XLEN-1:0] in;
	output reg [XLEN-1:0] out;
	
	always @(posedge clk) begin
		out = in + CONST;
	end
	
endmodule
