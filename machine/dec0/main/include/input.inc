; input register and mappings
REG_INPUT		equ REG_INPUT_P1

INPUT_UP_BIT		equ $0
INPUT_DOWN_BIT		equ $1
INPUT_LEFT_BIT		equ $2
INPUT_RIGHT_BIT		equ $3
INPUT_B1_BIT		equ $4
INPUT_B2_BIT		equ $5

INPUT_UP		equ (1<<INPUT_UP_BIT)
INPUT_DOWN		equ (1<<INPUT_DOWN_BIT)
INPUT_LEFT		equ (1<<INPUT_LEFT_BIT)
INPUT_RIGHT		equ (1<<INPUT_RIGHT_BIT)
INPUT_B1		equ (1<<INPUT_B1_BIT)
INPUT_B2		equ (1<<INPUT_B2_BIT)