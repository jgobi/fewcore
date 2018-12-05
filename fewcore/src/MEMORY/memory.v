module memory(clk,reset,address,out);
	parameter XLEN = 32;
	parameter TAM = 32;
	parameter ADDRESSLEN = 32;
	input  clk,reset;
	input  [(ADDRESSLEN - 1):0] address;
	output reg [(XLEN - 1):0] out;

	reg [(XLEN - 1):0] mem [(TAM-1):0];

	always @(posedge clk) begin
		if(reset) $readmemb("C:/Users/Joao/Documents/ufmg/OC2/fewcore/fewcore/src/MEMORY/data.txt", mem);
		out <= mem[address[(ADDRESSLEN-1):2]];
	end

endmodule
