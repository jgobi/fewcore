module write(clk,writeEnabled,code,rd,dataAlu,memAddress,rdAddress,writeEnabled_echo,dataOut);
	input clk, writeEnabled;
	input [11:0] code;
	input [4:0] rd;
	input [31:0] dataAlu;
	
	output reg [31:0] memAddress;

	output reg writeEnabled_echo;
	output reg [4:0] rdAddress;
	output reg [31:0] dataOut;

	// Execute dará os dados de SW,SH, SB e tds outros

	always @(posedge clk) begin
		memAddress <= dataAlu;
		rdAddress  <= rd;
		writeEnabled_echo <= writeEnabled;
		dataOut <= dataAlu;
	end

endmodule
