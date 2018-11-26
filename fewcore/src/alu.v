module alu(clk,operation,rs1,rs2,imm,forward,need_forward,reset,rd,zero);

parameter XLEN = 32; 

input clk;
input [11:0] operation; //funct concatenado com opcode
input [XLEN-1:0] rs1; 
input [XLEN-1:0] rs2; 
input [XLEN-1:0] imm;
input [XLEN-1:0] forward;
input [1:0] need_forward;
input reset;

output reg [XLEN-1:0] rd;
output reg zero;


reg [XLEN-1:0] opr2;


    always @(posedge clk) 
	 begin
        case (operation)
            12'b000000010011,12'b000000110011:   begin // addi, add
								rd = rs1 + opr2;
                                end                  
            12'b100000110011:   begin //sub 
                                rd = rs1 - opr2;
                                end                    
            12'b001110010011,12'b001110110011:   begin //andi, and
                                rd = rs1 & opr2;
                                end
            12'b001000010011,12'b001000110011:   begin //xori, xor
                                rd = rs1 ^ opr2;
                                end                 
            12'b001100010011,12'b001100110011:   begin //ori, or
                                rd = rs1 | opr2;
                                end
            12'b000100010011,12'b000100110011:   begin //slti, slt
                                rd = $signed(rs1) < $signed(opr2);
                                end
            12'b000110010011,12'b000110110011:   begin //sltiu, stlu
                                rd = rs1 < opr2;
                                end                
            12'b000001100011:   begin //beq
                                zero = rs1 == opr2;
								rd = 'b0;
                                end
            12'b001011100011:   begin //bge
                                zero = $signed(rs1) >= $signed(opr2);
								rd = 'b0;
                                end
            12'b000011100011:   begin //bne
                                zero = !(rs1 == opr2);
								rd = 'b0;
                                end
            12'b001001100011:   begin //blt
                                zero = $signed(rs1) <= $signed(opr2);
								rd = 'b0;
                                end
            12'b001101100011:   begin //bltu
                                zero = rs1 <= opr2;
								rd = 'b0;
                                end
            12'b001111100011:   begin //bgeu
                                zero = rs1 >= opr2;
								rd = 'b0;
                                end
            12'b001010110011,12'b001010010011:   begin //srl, srli
                                rd = rs1 >> opr2[4:0];
                                end                
            12'b000010110011,12'b000010010011:   begin //sll, slli
                                rd = rs1 << opr2[4:0];
                                end
            12'b101010110011,12'b011010010011:   begin //sra, srai
                                rd = rs1 >>> opr2[4:0];
                                end
            default:            begin // Nao faz nada
                                rd = 'bx;
                                end
        endcase
    end


endmodule
