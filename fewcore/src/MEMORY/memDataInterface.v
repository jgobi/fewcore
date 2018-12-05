module memDataInterface(clk, read_address, write_address, data_write, write_enabled, data_out);
	parameter XLEN = 32;

	input clk, write_enabled;
	input [XLEN-1:0] read_address, write_address, data_write;
	output [XLEN-1:0] data_out;

	reg [31:0] memAddress;
	memData memData_m(
		.clk(clk),
		.address(memAddress),
		.data(data_write),
		.iWrite(write_enabled),
		.out(data_out)
	);

	always @(posedge clk)
		memAddress <= write_address;
	//always @(negedge clk)
		//memAddress <= read_address;

endmodule
