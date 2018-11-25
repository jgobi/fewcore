module alu(
input clk,
input [11:0] operation, //funct concatenado com opcode
input [31:0] rs1, 
input [31:0] rs2, 
input [31:0] imm,

output reg [31:0] rd,
output reg zero
);



    always @(posedge clk) 
	 begin
        case (operation)
            12'b000000010011:   begin // addi
										  rd = rs1 + imm;
                                end
            12'b000000110011:   begin // add	
                                rd = rs1 + rs2;
                                end                    
            12'b100000110011:   begin //sub 
                                rd = rs1 - rs2;
                                end                    
            12'b001110010011:   begin //andi
                                rd = rs1 & imm;
                                end
            12'b001110110011:   begin //and
                                rd = rs1 & rs2;
                                end
            12'b001000010011:   begin //xori
                                rd = rs1 ^ imm;
                                end
            12'b001000110011:   begin //xor
                                rd = rs1 ^ rs2;
                                end                    
            12'b001100010011:   begin //ori
                                rd = rs1 | imm;
                                end
            12'b001100110011:   begin //or
                                rd = rs1 | rs2;
                                end
            12'b000100010011:   begin //slti
                                rd = $signed(rs1) < $signed(imm);
                                end
            12'b000110010011:   begin //sltiu
                                rd = rs1 < imm;
                                end
            12'b000100110011:   begin //slt
                                rd = $signed(rs1) < $signed(rs2);
                                end
            12'b000110110011:   begin //sltu
                                rd = rs1 < rs2;
                                end                    
            12'b000001100011:   begin //beq
                                zero = rs1 == rs2;
										  rd = 32'b0;
                                end
            12'b001011100011:   begin //bge
                                zero = $signed(rs1) >= $signed(rs2);
										  rd = 32'b0;
                                end
            12'b000011100011:   begin //bne
                                zero = !(rs1 == rs2);
										  rd = 32'b0;
                                end
            12'b001001100011:   begin //blt
                                zero = $signed(rs1) <= $signed(rs2);
										  rd = 32'b0;
                                end
            12'b001101100011:   begin //bltu
                                zero = rs1 <= rs2;
										  rd = 32'b0;
                                end
            12'b001111100011:   begin //bgeu
                                zero = rs1 >= rs2;
										  rd = 32'b0;
                                end
            12'b001010110011:   begin //srl
                                rd = rs1 >> rs2[4:0];
                                end
            12'b001010010011:   begin //srli
                                rd = rs1 >> imm[4:0];
                                end                    
            12'b000010110011:   begin //sll
                                rd = rs1 << rs2[4:0];
                                end
            12'b000010010011:   begin //slli
                                rd = rs1 << imm[4:0];
                                end
            12'b101010110011:   begin //sra
                                rd = rs1 >>> rs2[4:0];
                                end
            12'b011010010011:   begin //srai
                                rd = rs1 >>> imm[4:0];
                                end
            default:            begin // Nao faz nada
                                rd = 'bx;
                                end
        endcase
    end


endmodule
