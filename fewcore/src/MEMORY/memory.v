module memory(clk,reset,address,out);
	parameter XLEN = 32;
	parameter TAM = 16;
	parameter ADDRESSLEN = 10;
	input  clk,reset;
	input  [(ADDRESSLEN - 1):0] address;
	output reg [(XLEN - 1):0] out;

	reg [(XLEN - 1):0] mem [(TAM-1):0];

	initial
		$readmemb("data.txt", mem);

	always @(posedge clk) begin
		if(reset) out <= 'b0;
		out <= mem[address[ADDRESSLEN-1:2]];
	end

endmodule
