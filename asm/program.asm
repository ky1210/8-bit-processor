# selfcheck.asm
# DMEM[20] = 1   -> PASS
# DMEM[20] = 255 -> FAIL

ADDI R1, R0, 5
ADDI R2, R0, 2

ADD  R3, R1, R2
ADDI R4, R0, 7
BNE  R3, R4, fail

SUB  R5, R1, R2
ADDI R4, R0, 3
BNE  R5, R4, fail

BEQ  R1, R1, beq_ok
JMP  fail

beq_ok:
BNE  R1, R2, bne_ok
JMP  fail

bne_ok:
JMP  pass
ADDI R6, R0, 31

pass:
ADDI R7, R0, 1
ST   R7, 20
HALT

fail:
ADDI R7, R0, -1
ST   R7, 20
HALT