module alu(clk,operation,opr1,opr2,pc,alu_out,zero);

parameter XLEN = 32;

input clk;
input [11:0] operation; //funct concatenado com opcode
input [XLEN-1:0] opr1;
input [XLEN-1:0] opr2;
input [XLEN-1:0] pc;

output reg [XLEN-1:0] alu_out;
output reg zero;


	always @*
	 begin
		case (operation)
			12'b000000010011,12'b000000110011, 12'b000000000011,12'b000010000011,12'b000100000011,12'b001000000011,12'b001010000011,12'b000000100011,12'b000010100011,12'b000100100011: begin // addi, add, load, stores
				alu_out <= opr1 + opr2;
				zero    <= 1'b0;
			end
			12'b100000110011: begin //sub
				alu_out <= opr1 - opr2;
				zero    <= 1'b0;
			end
			12'b001110010011,12'b001110110011: begin //andi, and
				alu_out <= opr1 & opr2;
				zero    <= 1'b0;
			end
			12'b001000010011,12'b001000110011: begin //xori, xor
				alu_out <= opr1 ^ opr2;
				zero    <= 1'b0;
			end
			12'b001100010011,12'b001100110011: begin //ori, or
				alu_out <= opr1 | opr2;
				zero    <= 1'b0;
			end
			12'b000100010011,12'b000100110011: begin //slti, slt
				alu_out <= $signed(opr1) < $signed(opr2);
				zero    <= 1'b0;
			end
			12'b000110010011,12'b000110110011: begin //sltiu, stlu
				alu_out <= opr1 < opr2;
				zero    <= 1'b0;
			end
			12'b000001100011: begin //beq
				alu_out <= 'b0;
				zero    <= opr1 == opr2;
			end
			12'b001011100011: begin //bge
				alu_out <= 'b0;
				zero    <= $signed(opr1) >= $signed(opr2);
			end
			12'b000011100011: begin //bne
				alu_out <= 'b0;
				zero    <= !(opr1 == opr2);
			end
			12'b001001100011: begin //blt
				alu_out <= 'b0;
				zero    <= $signed(opr1) <= $signed(opr2);
			end
			12'b001101100011: begin //bltu
				alu_out <= 'b0;
				zero    <= opr1 <= opr2;
			end
			12'b001111100011: begin //bgeu
				alu_out <= 'b0;
				zero    <= opr1 >= opr2;
			end
			12'b001010110011,12'b001010010011: begin //srl, srli
				alu_out <= opr1 >> opr2[4:0];
				zero    <= 1'b0;
			end
			12'b000010110011,12'b000010010011: begin //sll, slli
				alu_out <= opr1 << opr2[4:0];
				zero    <= 1'b0;
			end
			12'b101010110011,12'b011010010011: begin //sra, srai
				alu_out <= opr1 >>> opr2[4:0];
				zero    <= 1'b0;
			end
			12'b000001101111,12'b000001100111: begin //jumps
				alu_out <= pc + 3'b100;
				zero    <= 1'b1;
			end
			12'b000000010111: begin //AUIPC
				alu_out <= pc + opr2;
				zero    <= 1'b0;
			end
			12'b000000110111: begin //LUI
				alu_out <= opr2;
				zero    <= 1'b0;
			end
			default: begin // Nao faz nada
				alu_out <= 'b1;
				zero    <= 1'b0;
			end
		endcase
	end

endmodule
