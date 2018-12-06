addi x1,x0,0
addi x2,x0,0
addi x4,x0,4
LOOP: addi x2,x0,0
addi x1,x1,1
addi x2,x0,0
bne x1,x4, LOOP
addi x2,x0,0
