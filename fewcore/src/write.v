module write(clk,code,rd,dataAlu,rs2,memAddress,rdAddress,dataOut_m,dataOut_r);
	input clk;
	input [11:0] code;
	input [4:0] rd;
	input [31:0] dataAlu;
	input [31:0] rs2;

	output reg [31:0] memAddress;

	output reg [4:0] rdAddress;
	output reg [31:0] dataOut_r, dataOut_m;

	// Execute dará os dados de SW,SH, SB e tds outros

	always @(posedge clk) begin
		memAddress <= dataAlu;
		rdAddress  <= rd;
		dataOut_r <= dataAlu;
		dataOut_m <= rs2;
	end

endmodule
