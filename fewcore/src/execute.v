module execute(clk,operation,rs1,rs2,imm,rd,forward,rs1_fwd,rs2_fwd,pc,reset,new_pc,execOut,address_rd,content_rs2,lastRd,originPc, memData);

parameter  XLEN = 32;

input clk;
input [11:0] operation; //funct concatenado com opcode
input [XLEN-1:0] rs1;
input [XLEN-1:0] rs2;
input [XLEN-1:0] imm;
input [4:0] rd;
input [XLEN-1:0] forward;
input rs1_fwd;
input rs2_fwd;
input [XLEN-1:0] pc;
input reset;

input [31:0] memData;

output reg [XLEN-1:0] new_pc; // Deve ser determinado antes do negedge
output reg originPc; //Apenas setado apos o negedge

output reg [XLEN-1:0] execOut;
output reg [4:0] address_rd, lastRd;
output reg [XLEN-1:0] content_rs2;


wire zero;

wire [XLEN-1:0] resultALU; //ALU sempre acaba em meio ciclo de clock

wire [31:0] operando1, operando2;

assign operando1 = rs1_fwd ? forward : rs1;
assign operando2 = ((operation[6:0] == 7'b0110011 || operation[6:0] == 7'b1100011)) ? (rs2_fwd ? forward : rs2) : imm;

alu alu_m(
	.clk(clk),
	.operation(operation),
	.opr1(operando1),
	.opr2(operando2),
	.pc(pc),
	.alu_out(resultALU),
	.zero(zero)
);

always @(posedge clk) begin
	lastRd <= rd;
	case(operation[9:0])
		10'b0001100111: begin //JALR
			new_pc = rs1 + imm;
			new_pc[0:0] = 1'b0;
		end
		default: begin
			new_pc = pc + imm;
		end
	endcase
end

always @(~clk) begin
	// load da memória
	case(operation[9:0])
		10'b0000000011: begin //LB
			execOut <= {{24{memData[31]}}, memData[31:24]};
		end
		10'b0010000011: begin //LH
			execOut <= {{16{memData[31]}}, memData[31:16]};
		end
		10'b0100000011: begin //LW
			execOut <= memData;
		end
		10'b1000000011: begin //LBU
			execOut <= {{24{1'b0}}, memData[31:24]};
		end
		10'b1010000011: begin //LHU
			execOut <= {{16{1'b0}}, memData[31:16]};
		end

		default: // ALUIPC, LUI, instruções lógica-aritméticas
			execOut <= resultALU;
	endcase

end

endmodule
