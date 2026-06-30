; input register and mappings
	macro GET_INPUT
		move.w	REG_INPUT, d0
		not.w	d0
		lsr.w	#$6, d0
		and.w	#$ff, d0
	endm

REG_INPUT		equ REG_INPUT_P12

INPUT_UP_BIT		equ $5
INPUT_DOWN_BIT		equ $4
INPUT_LEFT_BIT		equ $3
INPUT_RIGHT_BIT		equ $2
INPUT_B1_BIT		equ $1
INPUT_B2_BIT		equ $0

INPUT_UP		equ (1<<INPUT_UP_BIT)
INPUT_DOWN		equ (1<<INPUT_DOWN_BIT)
INPUT_LEFT		equ (1<<INPUT_LEFT_BIT)
INPUT_RIGHT		equ (1<<INPUT_RIGHT_BIT)
INPUT_B1		equ (1<<INPUT_B1_BIT)
INPUT_B2		equ (1<<INPUT_B2_BIT)
