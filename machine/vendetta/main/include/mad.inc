MAD_ROM_START		equ $c000
MAD_ROM_SIZE		equ $4000

CURSOR_CHAR		equ $0a ; (c)
CURSOR_CLEAR_CHAR	equ $10

SOUND_NUM_SUCCESS	equ $83
SOUND_NUM_BIT_ZERO	equ $10 ; swing?
SOUND_NUM_BIT_ONE	equ $13	; punch

	; we are only allowed to use d register
	macro SOUND_BIT_DELAY
		ldd	#$ffff
	.\@:
		WATCHDOG
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		cmpd	#0		; 4 cycles
		subd	#$1
		bne	.\@		; 2 cycles
	endm

; There aren't enough registers to save the number of passes
; work ram tests have run and we can't store it in work ram.
; Instead we need to store it in some other location..
R_WORK_RAM_PASSES	equ TILE_RAM

; video dac
VD_NUM_COLORS		equ $4		; includes all/combined
VD_NUM_BITS_PER_COLOR	equ $6		; includes all/combined
VD_COLOR_BLOCK_WIDTH	equ $4
VD_COLOR_BLOCK_HEIGHT	equ $4
VD_TILE_B0_NUM		equ $39
VD_TILE_B0_PAL_OFFSET	equ $12
VD_TILE_B1_NUM		equ $3a
VD_TILE_B1_PAL_OFFSET	equ $14
VD_TILE_B2_NUM		equ $3b
VD_TILE_B2_PAL_OFFSET	equ $16
VD_TILE_B3_NUM		equ $3c
VD_TILE_B3_PAL_OFFSET	equ $18
VD_TILE_B4_NUM		equ $3d
VD_TILE_B4_PAL_OFFSET	equ $1a
VD_TILE_BA_NUM		equ $3e		; all bits enabled
VD_TILE_BA_PAL_OFFSET	equ $1c

; palette number used by all the tile viewers
TVC_PALETTE_NUM		equ $1
