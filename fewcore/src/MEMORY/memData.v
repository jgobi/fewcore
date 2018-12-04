module memData(clk,address,data,iWrite,out);
	parameter XLEN = 32;
	parameter TAM = 16;
	parameter ADDRESSLEN = 32;

	input clk,iWrite;
	input [(ADDRESSLEN - 1):0] address;
	input [(XLEN-1):0] data;

	output reg [(XLEN - 1):0] out;

	reg [(XLEN - 1):0] mem [(TAM-1):0];

	always @(posedge clk) begin
		if (iWrite)
			mem[address[ADDRESSLEN-1:2]] <= data;
	end

	always @(negedge clk) begin
		out <= mem[address[ADDRESSLEN-1:2]];
	end

endmodule
