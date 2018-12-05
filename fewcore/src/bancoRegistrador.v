module bancoRegistrador(clk,reset,rs1, rs2, data, rd, wEn, r1, r2);
	parameter XLEN=32;
	parameter AMOUNT=16;
	parameter ADDRESSLEN=4;
	
	input [ADDRESSLEN-1:0] rs1, rs2, rd;
	input wEn, reset;
	input [XLEN-1:0] data;
	
	input clk;
	
	output reg [XLEN-1:0] r1, r2;
	
	reg [XLEN-1:0] registers [AMOUNT-1:1];
	
	always @(posedge clk) begin
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
