module write(clk,writeEnabled,code,rd,dataAlu,memAddress,rdAddress,writeEnabled_echo,dataOut);
	input clk, writeEnabled;
	input [11:0] code;
	input [4:0] rd;
	input [31:0] dataAlu, memAddress;
	
	output writeEnabled_echo;
	output [4:0] rdAddress;
	output [31:0] dataOut;
	
	// Execute dará os dados de SW,SH, SB e tds outros
	
	always @(posedge clk) begin
		rdAddress <= rd;
		writeEnabled_echo <= writeEnabled;
		dataOut <= dataAlu;
	end
	
endmodule 