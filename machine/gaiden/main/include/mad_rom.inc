SP_INIT_ADDR		equ WORK_RAM_START + (WORK_RAM_SIZE - 2)
MAD_ROM_SIZE		equ $8000

CURSOR_CHAR		equ $5f		; copyright symbol
CURSOR_CLEAR_CHAR	equ ' '

SOUND_NUM_SUCCESS	equ $93
SOUND_NUM_BIT_ZERO	equ $49		; longer lower fire sound
SOUND_NUM_BIT_ONE	equ $47		; short fire sound

	; when playing a byte, how long to delay between bits
	macro SOUND_BIT_DELAY
		move.l	#$7ffff, d0
		DSUB	delay
	endm

; video dac
VD_NUM_COLORS		equ $4		; includes all/combined
VD_NUM_BITS_PER_COLOR	equ $4		; includes all/combined
VD_COLOR_BLOCK_WIDTH	equ $4
VD_COLOR_BLOCK_HEIGHT	equ $4
VD_TILE_B0_NUM		equ $11
VD_TILE_B0_PAL_OFFSET	equ $0
VD_TILE_B1_NUM		equ $1c
VD_TILE_B1_PAL_OFFSET	equ $16
VD_TILE_B2_NUM		equ $1d
VD_TILE_B2_PAL_OFFSET	equ $18
VD_TILE_BA_NUM		equ $1f		; all bits enabled
VD_TILE_BA_PAL_OFFSET	equ $1c
