module bancoRegistrador(clk,reset,rs1, rs2, data, rd, wEn, r1, r2);
	parameter XLEN=32;
	parameter AMOUNT=16;
	parameter ADDRESSLEN=4;
	parameter READ_DELAY=20;
	
	input [ADDRESSLEN-1:0] rs1, rs2, rd;
	input wEn, reset;
	input [XLEN-1:0] data;
	
	input clk;
	
	output reg [XLEN-1:0] r1, r2;
	
	reg [XLEN-1:0] registers [AMOUNT-1:0];
	
	always @(posedge clk) begin
		if(reset) begin
			$readmemb("C:/Users/Elves/Desktop/fewcore/fewcore/src/dataRegisters.txt", registers);
		end
		if (wEn) registers[rd] <= data;
	end
	
	always @(negedge clk) begin
		r1 <= registers[rs1];
		r2 <= registers[rs2];
	end
endmodule
