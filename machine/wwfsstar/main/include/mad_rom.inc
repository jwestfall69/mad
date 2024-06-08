
SP_INIT_ADDR		equ $1c3ff0
MAD_ROM_SIZE		equ $8000

CURSOR_CHAR		equ '*'
CURSOR_CLEAR_CHAR	equ ' '

SOUND_NUM_SUCCESS	equ $1
SOUND_NUM_BIT_ZERO	equ $30	; slap sound
SOUND_NUM_BIT_ONE	equ $2f	; punch sound

	; when playing a byte, how long to delay between bits
	macro SOUND_BIT_DELAY
		move.l	#$7ffff, d0
		DSUB	delay
	endm

; video dac
VD_NUM_COLORS		equ $4		; includes all/combined
VD_NUM_BITS_PER_COLOR	equ $5		; includes all/combined
VD_COLOR_BLOCK_WIDTH	equ $4
VD_COLOR_BLOCK_HEIGHT	equ $4
VD_TILE_B0_NUM		equ $100fc
VD_TILE_B0_PAL_OFFSET	equ $18
VD_TILE_B1_NUM		equ $3000b
VD_TILE_B1_PAL_OFFSET	equ $14
VD_TILE_B2_NUM		equ $600fa
VD_TILE_B2_PAL_OFFSET	equ $1e
VD_TILE_B3_NUM		equ $b00f9
VD_TILE_B3_PAL_OFFSET	equ $4
VD_TILE_BA_NUM		equ $f0000	; all bits enabled
VD_TILE_BA_PAL_OFFSET	equ $2
