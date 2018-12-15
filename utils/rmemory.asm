addi x15,x0,1
addi x1,x0,1
add x15,x15,x1
sll x15,x15,x1
addi x6,x0,6
sw x6,0(x0)
lw x15,0(x0)
beq x15,x6,OUT
jal ERRO

OUT: addi x15,x0,4
add x15,x0,x15
ERRO: addi x15,x0,1
