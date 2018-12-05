module fetch(
	clk,
	reset,
	pc,
	pcBranch,
	originPc,
	lastRd,
	rs1_v,
	rs2_v,
	rd,
	rs1,
	rs2,
	imm,
	code,
	isLoad,
	isBranch,
	pcOut,
);
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
	
	output isLoad, isBranch;

	output [4:0] rs1, rs2;

	wire [XLEN-1:0] instr;

	/*
		*** lastRd deve ser atualizado por alguém necessariamente na subida de clock ***
		*** 							originPc nca deve ser mudado								  ***
	*/


	// ================[ PRIMEIRA METADE DO CICLO ]================ [SUBIDA DO CLOCK]

	// ----------------[ FETCH DA INSTRUÇÃO ]---------------- [SÍNCRONO]
	memory mem(
		.clk(clk),
		.reset(reset),
		.address(pc),
		.out(instr)
	);

	// ----------------[ DECODE DA INSTRUÇÃO ]---------------- [ASSÍNCRONO]
	decoder dec(
		.inst(instr),
		.rs1i(rs1),
	  	.rs2i(rs2),
	  	.rdi(rd),
		.imm(imm),
		.code(code),

		.isLoad(isLoad),
		.isBranch(isBranch)
	);





// ================[ SEGUNDA METADE DO CICLO ]================ [DESCIDA DO CLOCK]

	/*
		***	OriginPc deve ser atualizado só depois da descida do clock	***
		***       			A parte abaixo é negedge ou assincrona          ***
	*/

	newPc newPc(
		.clk(clk),
		.pc(pc),
		.pcBranch(pcBranch),
		.originPc(originPc),
		.pcOut(pcOut)
	);

endmodule
