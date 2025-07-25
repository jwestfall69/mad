MAD_ROM_START		equ $c000
MAD_ROM_SIZE		equ $4000

CURSOR_CHAR		equ '-'
CURSOR_CLEAR_CHAR	equ $10

SOUND_NUM_SUCCESS	equ $53
SOUND_NUM_BIT_ZERO	equ $09
SOUND_NUM_BIT_ONE	equ $0a

; There aren't enough registers to save the number of passes
; work ram tests have run and we can't store it in work ram.
; Instead we need to store it in some other location..
R_WORK_RAM_PASSES	equ PALETTE_RAM + PALETTE_SIZE

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

; video dac
VD_NUM_COLORS		equ $4		; includes all/combined
VD_NUM_BITS_PER_COLOR	equ $6		; includes all/combined
VD_COLOR_BLOCK_WIDTH	equ $4
VD_COLOR_BLOCK_HEIGHT	equ $4
VD_TILE_B0_NUM		equ $14fc
VD_TILE_B0_PAL_OFFSET	equ $4
VD_TILE_B1_NUM		equ $00a0
VD_TILE_B1_PAL_OFFSET	equ $a
VD_TILE_B2_NUM		equ $18b0
VD_TILE_B2_PAL_OFFSET	equ $e
VD_TILE_B3_NUM		equ $1877
VD_TILE_B3_PAL_OFFSET	equ $10
VD_TILE_B4_NUM		equ $1c34
VD_TILE_B4_PAL_OFFSET	equ $14
VD_TILE_BA_NUM		equ $111e	; all bits enabled
VD_TILE_BA_PAL_OFFSET	equ $1e

; palette number used by all the tile viewers
TVC_PALETTE_NUM		equ $1
