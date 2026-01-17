MAD_ROM_START		equ $c000
MAD_ROM_SIZE		equ $4000

CURSOR_CHAR		equ $e1
CURSOR_CLEAR_CHAR	equ $10

SOUND_NUM_SUCCESS	equ $8c
SOUND_NUM_BIT_ZERO	equ $41
SOUND_NUM_BIT_ONE	equ $40

; There aren't enough registers to save the number of passes
; work ram tests have run and we can't store it in work ram.
; Instead we need to store it in some other location..
R_WORK_RAM_PASSES	equ PALETTE_RAM

; video dac
VD_NUM_COLORS		equ $4		; includes all/combined
VD_NUM_BITS_PER_COLOR	equ $6		; includes all/combined
VD_COLOR_BLOCK_WIDTH	equ $4
VD_COLOR_BLOCK_HEIGHT	equ $4
VD_TILE_B0_NUM		equ $f1
VD_TILE_B0_PAL_OFFSET	equ $2
VD_TILE_B1_NUM		equ $f2
VD_TILE_B1_PAL_OFFSET	equ $4
VD_TILE_B2_NUM		equ $f3
VD_TILE_B2_PAL_OFFSET	equ $6
VD_TILE_B3_NUM		equ $f4
VD_TILE_B3_PAL_OFFSET	equ $8
VD_TILE_B4_NUM		equ $f5
VD_TILE_B4_PAL_OFFSET	equ $a
VD_TILE_BA_NUM		equ $f6		; all bits enabled
VD_TILE_BA_PAL_OFFSET	equ $c

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
