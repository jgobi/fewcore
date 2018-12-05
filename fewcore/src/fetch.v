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
	writeEnabled,
	pcOut,
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

	output [4:0] rs1, rs2;
	output reg writeEnabled;


	reg [31:0] pc;

	wire [XLEN-1:0] instr;

	/*
		*** lastRd deve ser atualizado por alguÃƒÂ©m necessariamente na subida de clock ***
		*** 							originPc nca deve ser mudado								  ***
	*/


	// ================[ PRIMEIRA METADE DO CICLO ]================ [SUBIDA DO CLOCK]

	// ----------------[ FETCH DA INSTRUÃƒâ€¡ÃƒÆ’O ]---------------- [SÃƒÂNCRONO]
	memory mem(
		.clk(clk),
		.reset(reset),
		.address(pc),
		.out(instr)
	);

	// ----------------[ DECODE DA INSTRUÃƒâ€¡ÃƒÆ’O ]---------------- [ASSÃƒÂNCRONO]
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
		***	OriginPc deve ser atualizado sÃƒÂ³ depois da descida do clock	***
		***       			A parte abaixo ÃƒÂ© negedge ou assincrona          ***
	*/

	// newPc newPc(
	// 	.clk(clk),
	// 	.pc(pc),
	// 	.pcBranch(pcBranch),
	// 	.originPc(originPc),
	// 	.pcOut(pcOut)
	// );


	// -------------------- [ ATUALIZAR O PC ] --------------------
	reg [31:0] lastPc;
	wire changePc;
	reg  lastOriginPc;

	assign changePc = lastOriginPc ? 32'b0: originPc;

	always @(posedge clk) begin
		lastPc = pc;
	end
	/*Temos que ter originPc setado antes da descida do clock*/
	always @(negedge clk) begin
		if(reset) begin
			pc = 32'b0;
		end
		else begin
			pcOut = lastPc;
			case(changePc)
				1'b1:
					pc = pcBranch;
				1'b0:
					pc = pc + 32'b100;
			endcase

			writeEnabled  = ~originPc;
			lastOriginPc = originPc;
		end
	end
	// -------------------- [ FIM DA ATUALIZAÃƒâ€¡ÃƒÆ’O PC ] --------------------
endmodule
