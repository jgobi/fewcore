addi x1,x0,4
add x2,x1,x1
lui x3, 0x10010
sw x2, 0(x3)
lw x4, 0(x3)
jal x0, A
jal x0, B


A: addi x10,x0,10
addi x11,x0,11
addi x12,x0,12

B: addi x10,x0,111