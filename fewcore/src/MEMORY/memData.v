module memData(clk,writeAddress,readAddress,data,writeEnabled,readEnabled,out);
	parameter XLEN = 32;
	parameter TAM = 32;
	parameter ADDRESSLEN = 32;

	input clk,writeEnabled,readEnabled;
	input [(ADDRESSLEN - 1):0] writeAddress,readAddress;
	input [(XLEN-1):0] data;

	output reg [(XLEN - 1):0] out;

	reg [(XLEN - 1):0] mem [(TAM-1):0];

	always @(writeEnabled) begin
		if (writeEnabled)
			mem[writeAddress[ADDRESSLEN-1:2]] <= data;
	end

	always @(negedge clk) begin
		if (readEnabled)
			out <= mem[readAddress[ADDRESSLEN-1:2]];
	end

endmodule
