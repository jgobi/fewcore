module write(clk,rd,dataAlu,rs2,memAddress,dataOut_m,dataOut_r);
	input clk;
	input [4:0] rd;
	input [31:0] dataAlu;
	input [31:0] rs2;

	output reg [31:0] memAddress;

	output reg [31:0] dataOut_r, dataOut_m;

	// Execute dará os dados de SW,SH, SB e tds outros

	always @(posedge clk) begin
		memAddress <= dataAlu;
		dataOut_r <= dataAlu;
		dataOut_m <= rs2;
	end

endmodule
