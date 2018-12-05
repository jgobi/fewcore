module fetch(
	clk,
	reset,
	//pc,
	pcBranch,
	originPc,
	rd,
	rs1,
	rs2,
	imm,
	code,
	isLoad,
	isBranch,
	pcOut,
	writeEnabled
);
	parameter XLEN = 32;
	parameter PCLEN = 10;
	parameter ADDRESSLEN = 4;

	input clk,reset,originPc;
	input [31:0] pcBranch;
	output [XLEN-1:0] imm;
	output reg [31:0] pcOut;
	output [4:0] rd;
	output [11:0] code;

	output isLoad, isBranch;

	output reg writeEnabled;

	output [4:0] rs1, rs2;

	reg [31:0] pc;

	wire [XLEN-1:0] instr;

	/*
		*** lastRd deve ser atualizado por alguÃƒÆ’Ã‚Â©m necessariamente na subida de clock ***
		*** 							originPc nca deve ser mudado								  ***
	*/


	// ================[ PRIMEIRA METADE DO CICLO ]================ [SUBIDA DO CLOCK]

	// ----------------[ FETCH DA INSTRUÃƒÆ’Ã¢â‚¬Â¡ÃƒÆ’Ã†â€™O ]---------------- [SÃƒÆ’Ã‚ÂNCRONO]
	memory mem(
		.clk(clk),
		.reset(reset),
		.address(pc),
		.out(instr)
	);

	// ----------------[ DECODE DA INSTRUÃƒÆ’Ã¢â‚¬Â¡ÃƒÆ’Ã†â€™O ]---------------- [ASSÃƒÆ’Ã‚ÂNCRONO]
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

	// -------------------- [ ATUALIZAR O PC ] --------------------
	reg [31:0] lastPc;

	always @(posedge clk) begin
		if(reset) pc <= 32'b0;
		lastPc <= pc;
	end
	/*Temos que ter originPc setado antes da descida do clock*/
	always @(negedge clk) begin
		pcOut     = lastPc;
		case(originPc)
			1'b1:
				pc = pcBranch;
			1'b0:
				pc = pc + 32'b100;
		endcase
		writeEnabled <= ~originPc;
	end
	// -------------------- [ FIM DA ATUALIZAÃƒÆ’Ã¢â‚¬Â¡ÃƒÆ’Ã†â€™O PC ] --------------------
endmodule
