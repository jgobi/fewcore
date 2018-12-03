module alu(clk,operation,rs1,rs2,imm,forward,need_forward,pc,reset,rd,zero);

parameter XLEN = 32; 

input clk;
input [11:0] operation; //funct concatenado com opcode
input [XLEN-1:0] rs1; 
input [XLEN-1:0] rs2; 
input [XLEN-1:0] imm;
input [XLEN-1:0] forward;
input [1:0] need_forward;
	input [XLEN-1:0] pc; 
input reset;

output reg [XLEN-1:0] rd;
output reg zero;


reg [XLEN-1:0] opr2;
reg [XLEN-1:0] opr1;


    always @* begin
        case (operation[6:0])
				7'b0110011,7'b1100011: begin //R, B
								case(need_forward)
									2'b00: begin //Sem encaminhamento
											opr2 = rs2;
											opr1 = rs1;
											end
									2'b01: begin //Encaminhamento para rs2
									       	opr2 = forward;
									       	opr1 = rs1;
									      	 end
									2'b10: begin //Encaminhamento para rs1
									       	opr2 = rs2;
										opr1 = forward;
										end
									2'b11: begin //Encaminhamento para rs1 e rs2
										opr2 = forward;
										opr1 = forward;
										end
								endcase
							end
											  
            7'b0010011,7'b0000011,7'b0100011,: begin //I, S
								case(need_forward[1:1])
									1'b0: begin //Sem encaminhamento
										opr2 = imm;
										opr1 = rs1;
										end
									2'b1: begin //Encaminhamento para rs1
										opr2 = imm;
										opr1 = forward;
																			end
								endcase
                                               end
															  
            default:            begin // NO TYPE
                                opr2 = 'bx;
                                end
        endcase
    end





    always @(posedge clk) 
	 begin
        case (operation)
            12'b000000010011,12'b000000110011, 12'bxxxxx0000011,12'bxxxxx0100011:   begin // addi, add, load, stores
										  rd = opr1 + opr2;
                                end                  
            12'b100000110011:   						 begin //sub 
                                rd = opr1 - opr2;
                                end                    
            12'b001110010011,12'b001110110011:   begin //andi, and
                                rd = opr1 & opr2;
                                end
            12'b001000010011,12'b001000110011:   begin //xori, xor
                                rd = opr1 ^ opr2;
                                end                 
            12'b001100010011,12'b001100110011:   begin //ori, or
                                rd = opr1 | opr2;
                                end
            12'b000100010011,12'b000100110011:   begin //slti, slt
                                rd = $signed(opr1) < $signed(opr2);
                                end
            12'b000110010011,12'b000110110011:   begin //sltiu, stlu
                                rd = opr1 < opr2;
                                end                
            12'b000001100011:   						 begin //beq
                                zero = opr1 == opr2;
										  rd = 'b0;
                                end
            12'b001011100011:   						 begin //bge
                                zero = $signed(opr1) >= $signed(opr2);
								        rd = 'b0;
                                end
            12'b000011100011:  						 begin //bne
                                zero = !(opr1 == opr2);
								        rd = 'b0;
                                end
            12'b001001100011:  						 begin //blt
                                zero = $signed(opr1) <= $signed(opr2);
								        rd = 'b0;
                                end
            12'b001101100011:  						 begin //bltu
                                zero = opr1 <= opr2;
								        rd = 'b0;
                                end
            12'b001111100011:  						 begin //bgeu
                                zero = opr1 >= opr2;
								        rd = 'b0;
                                end
            12'b001010110011,12'b001010010011:   begin //srl, srli
                                rd = opr1 >> opr2[4:0];
                                end                
            12'b000010110011,12'b000010010011:   begin //sll, slli
                                rd = opr1 << opr2[4:0];
                                end
            12'b101010110011,12'b011010010011:   begin //sra, srai
                                rd = opr1 >>> opr2[4:0];
                                end
	    12'bxxxxx1101111,12'bxx0001100111:   begin //jumps
                                rd = pc + 2'b100;
                                end
   	    12'bxxxxx0010111:  	begin //AUIPC
										rd = pc + imm;
										end
            default:           	begin // Nao faz nada
                                rd = 'bx;
                                end
        endcase
    end


endmodule
