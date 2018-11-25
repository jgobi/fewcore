module main(clk, in1, in2, out, zero);

	input clk;
	input [8:0] in1;
	input [8:0] in2;
	output [17:0] out;
	output zero;
	
	wire [13:0] lixo;
	wire [31:0] lixo2;
	wire [22:0] zero_r;
	
	assign zero_r = 23'b0;
	
	wire [11:00] op;
	assign op = 12'b100000110011;
	
	//alu alu_m(clk, op, {in1[8],zero_r,in1[7:0]}, {in2[8],zero_r,in2[7:0]}, {zero_r,zero_r[8:0]}, {out[17],lixo,out[16:0]}, zero);
	
	
	bancoRegistrador banco_m(clk, in1[7:4], in1[7:4], {in1[3:0], in2}, in1[7:4], in1[8], {lixo,out[17:0]}, lixo2);
	
endmodule
