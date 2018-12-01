module execute(clk,operation,rs1,rs2,imm,rd,forward,need_forward,pc,reset,new_pc,resultALU,address_rd,content_rs2,originPc);

parameter  XLEN = 32;

input clk;
input [11:0] operation; //funct concatenado com opcode
input [XLEN-1:0] rs1;
input [XLEN-1:0] rs2;
input [XLEN-1:0] imm;
input [4:0] rd;
input [XLEN-1:0] forward;
input [1:0] need_forward;
input [XLEN-1:0] pc;
input reset;

output reg [XLEN-1:0] new_pc; // Deve ser determinado antes do negedge
output reg originPc; //Apenas setado apos o negedge

output reg [XLEN-1:0] resultALU; //ALU sempre acaba em meio ciclo de clock
output reg [4:0] adress_rd;
output reg [XLEN-1:0] content_rs2;


reg zero;



always @(posedge clk) begin
  case(operation)
    12'bxx0001100111: begin //JALR
                  new_pc = rs1 + imm;
                  new_pc[0:0] = 1'b0;
                      end
   12'bxxxxx0010111:  begin //AUIPC
                  new_pc = pc + imm;
                      end
    default:    begin
                  new_pc = pc + imm;
                end
end

alu alu_m(
  .clk(clk),
  .operation(operation),
  .rs1(rs1),
  .rs2(rs2),
  .imm(imm),
  .forward(forward),
  .need_forward(need_forward),
  .pc(pc),
  .reset(reset),
  .rd(resultALU),
  .zero(zero)
  );

always @(negedge clk) begin


end




endmodule
