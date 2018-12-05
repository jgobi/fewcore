module fetch(clk,reset,pc,pcBranch,originPc,lastRd,rs1_v, rs2_v, rd,rs1,rs2, imm,code,isLoad,isBranch,pcOut, encSB);
	parameter XLEN = 32;
	parameter PCLEN = 10;
	parameter ADDRESSLEN = 4;
	
	input clk,reset,originPc;
	input [PCLEN-1:0] pcBranch;
	input [4:0] lastRd;
	input [XLEN-1:0] rs1_v, rs2_v;
	
	inout [PCLEN-1:0] pc;
	
	output [XLEN-1:0] imm;
	output [PCLEN-1:0] pcOut;
	output [4:0] rd;
	output [11:0] code;
	output [1:0] encSB;
	
	output isLoad, isBranch;
	
	output [4:0] rs1, rs2;
	
	wire [XLEN-1:0] instr;
	
	/*
		*** lastRd deve ser atualizado por alguém necessariamente na subida de clock ***
		*** 							originPc nca deve ser mudado								  ***
	*/
	
	
	//primeira metade do clock
	memory mem(
		.clk(clk),
		.reset(reset),
		.address(pc),
		.out(instr)
	);
	
	decoder dec(
		.inst(instr),
		.rs1i(_rs1),
      .rs2i(_rs2),
      .rdi(rd),
		.imm(imm),
		.code(code),
		
		.isLoad(isLoad),
		.isBranch(isBranch)
	);
	
	/*
		***	OriginPc deve ser atualizado só depois da descida do clock	***
		***       			A parte abaixo é negedge ou assincrona          *** 
	*/
	
	
	refreshSB refreshSB(
		.clk(clk),
		.lastRd(lastRd),
		.rs1(_rs1),
		.rs2(_rs2),
		.encSB(encSB)
	);	
	
	newPc newPc(
		.clk(clk),
		.pc(pc),
		.pcBranch(pcBranch),
		.originPc(originPc),
		.pcOut(pcOut)
	);
	
endmodule
