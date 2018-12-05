module fetch(
	clk,
	reset,
	//pc,
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
	
	output [XLEN-1:0] imm;
	output reg [PCLEN-1:0] pcOut;
	output [4:0] rd;
	output [11:0] code;

	output isLoad, isBranch;

	output [4:0] rs1, rs2;

	reg [31:0] pc;

	wire [XLEN-1:0] instr;

	/*
		*** lastRd deve ser atualizado por alguÃ©m necessariamente na subida de clock ***
		*** 							originPc nca deve ser mudado								  ***
	*/


	// ================[ PRIMEIRA METADE DO CICLO ]================ [SUBIDA DO CLOCK]

	// ----------------[ FETCH DA INSTRUÃ‡ÃƒO ]---------------- [SÃNCRONO]
	memory mem(
		.clk(clk),
		.reset(reset),
		.address(pc),
		.out(instr)
	);

	// ----------------[ DECODE DA INSTRUÃ‡ÃƒO ]---------------- [ASSÃNCRONO]
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
		***	OriginPc deve ser atualizado sÃ³ depois da descida do clock	***
		***       			A parte abaixo Ã© negedge ou assincrona          ***
	*/

	// newPc newPc(
	// 	.clk(clk),
	// 	.pc(pc),
	// 	.pcBranch(pcBranch),
	// 	.originPc(originPc),
	// 	.pcOut(pcOut)
	// );

	
	// -------------------- [ ATUALIZAR O PC ] --------------------
	reg [31:0] pcPlus4, lastPc;
	
	always @(originPc) begin
		case(originPc)
			1'b1: 
				pc <= pcBranch;
			1'b0: 
				pc <= pcPlus4;
		endcase		
	end

	always @(posedge clk) begin
		lastPc <= pc;
	end

	always @(negedge clk) begin
		pcOut     <= lastPc;
		pcPlus4   <= pc + 10'b100;
	end
	// -------------------- [ FIM DA ATUALIZAÃ‡ÃƒO PC ] --------------------
endmodule
