module bancoRegistrador(clk,reset,rs1, rs2, data, rd, wEn, r1, r2);
	parameter XLEN=32;
	parameter AMOUNT=16;
	parameter ADDRESSLEN=5;

	input [ADDRESSLEN-1:0] rs1, rs2, rd;
	input wEn, reset;
	input [XLEN-1:0] data;

	input clk;

	output reg [XLEN-1:0] r1, r2;

	reg [XLEN-1:0] registers [AMOUNT-1:0];

	always @* begin
		if (reset) begin
			registers[0]  <= 0;
			registers[1]  <= 0;
			registers[2]  <= 0;
			registers[3]  <= 0;
			registers[4]  <= 0;
			registers[5]  <= 0;
			registers[6]  <= 0;
			registers[7]  <= 0;
			registers[8]  <= 0;
			registers[9]  <= 0;
			registers[10] <= 0;
			registers[11] <= 0;
			registers[12] <= 0;
			registers[13] <= 0;
			registers[14] <= 0;
			registers[15] <= 0;
		end
		if (wEn) registers[rd] <= data;
	end
	always @(negedge clk) begin
		if (rs1 == 0)
			r1 <= 'b0;
		else
			r1 <= registers[rs1];
		if (rs2 == 0)
			r2 <= 'b0;
		else
			r2 <= registers[rs2];
	end
endmodule
