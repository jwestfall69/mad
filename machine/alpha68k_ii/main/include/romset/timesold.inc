CURSOR_CHAR		equ '*'
CURSOR_CLEAR_CHAR	equ ' '

	macro ROMSET_PALETTE_SETUP
		move.w	#PALETTE_TEXT_COLOR, PALETTE_RAM_START + $2
		move.w	#PALETTE_TEXT_SHADOW_COLOR, PALETTE_RAM_START + $a
	endm

ROMSET_TILE_OFFSET_MASK	equ $7ff

SOUND_NUM_SUCCESS	equ $1f
SOUND_NUM_BIT_ZERO	equ $44		; low pitch sound
SOUND_NUM_BIT_ONE	equ $5a		; high pitch sound

; video dac
VD_TILE_B0_NUM		equ $11
VD_TILE_B0_PAL_OFFSET	equ $2
VD_TILE_B1_NUM		equ $12
VD_TILE_B1_PAL_OFFSET	equ $4
VD_TILE_B2_NUM		equ $13
VD_TILE_B2_PAL_OFFSET	equ $6
VD_TILE_B3_NUM		equ $14
VD_TILE_B3_PAL_OFFSET	equ $8
VD_TILE_BA_NUM		equ $15		; all bits enabled
VD_TILE_BA_PAL_OFFSET	equ $a