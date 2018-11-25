module ROM(clk, address, out);
	parameter XLEN = 32;
	parameter TAM = 1024;
	parameter ADDRESSLEN = 10;
	input  clk;
	input  [(ADDRESSLEN - 1):0] address;
	output reg [(XLEN - 1):0] out;
	
	reg [(XLEN - 1):0] mem [(TAM-1):0];	
	
	always @(posedge clk) begin
		out <= mem[address];
	end
	
endmodule
