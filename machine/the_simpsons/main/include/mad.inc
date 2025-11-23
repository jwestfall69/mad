MAD_ROM_START		equ $c000
MAD_ROM_SIZE		equ $4000

CURSOR_CHAR		equ $a0 ; ->
CURSOR_CLEAR_CHAR	equ $10

SOUND_NUM_SUCCESS	equ $96
SOUND_NUM_BIT_ZERO	equ $1f ; high chime
SOUND_NUM_BIT_ONE	equ $0d ; low bong?

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
VD_TILE_B0_NUM		equ $31
VD_TILE_B0_PAL_OFFSET	equ $2
VD_TILE_B1_NUM		equ $32
VD_TILE_B1_PAL_OFFSET	equ $4
VD_TILE_B2_NUM		equ $33
VD_TILE_B2_PAL_OFFSET	equ $6
VD_TILE_B3_NUM		equ $34
VD_TILE_B3_PAL_OFFSET	equ $8
VD_TILE_B4_NUM		equ $35
VD_TILE_B4_PAL_OFFSET	equ $a
VD_TILE_BA_NUM		equ $36		; all bits enabled
VD_TILE_BA_PAL_OFFSET	equ $c


; palette number used by all the tile viewers
TVC_PALETTE_NUM		equ $1
TVC_BANK_SLOT_NUM	equ $1
