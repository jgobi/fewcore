module memory(clk,reset,address,out);
	parameter XLEN = 32;
	parameter TAM = 1024;
	parameter ADDRESSLEN = 10;
	input  clk,reset;
	input  [(ADDRESSLEN - 1):0] address;
	output reg [(XLEN - 1):0] out;
	
	reg [(XLEN - 1):0] mem [(TAM-1):0];	
	
	always @(posedge clk) begin
		if(reset) begin
			$readmemb("C:/Users/Elves/Desktop/fewcore/fewcore/src/data.txt", mem);
		end
		out <= mem[address >> 2];
	end
	
endmodule
