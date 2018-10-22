module fetch(clk,pc,rd,rs1,rs2,imm,code,pcOut);
	parameter XLEN = 32;
	parameter ADDRESSLEN = 4;
	
	input clk;
	input [XLEN-1:0] pc;
	
	output [XLEN-1:0] imm, pcOut;
	output [4:0] rs1, rs2, rd;
	output [11:0] code;
	
	wire [XLEN-1:0] instr;
	wire [5:0] drs1, drs2;
	
	memory mem(
		.clk(clk),
		.address(pc),
		.out(instr)
	);
	decoder dec(
		.clk(clk),
		.inst(instr),
		.rs1i(rs1),
      .rs2i(rs2),
      .rdi(rd),
		.imm(imm),
		.code(code)
	);
endmodule
