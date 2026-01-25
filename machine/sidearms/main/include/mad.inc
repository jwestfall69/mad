MAD_ROM_SIZE		equ $8000
ERROR_ADDRESS_BASE	equ $6000

CURSOR_CHAR		equ $2e ; *
CURSOR_CLEAR_CHAR	equ $27

SOUND_NUM_SUCCESS	equ $2e
SOUND_NUM_BIT_ZERO	equ $04
SOUND_NUM_BIT_ONE	equ $06

; There aren't enough registers to save the number of passes
; work ram tests have run and we can't store it in work ram.
; Instead we need to store it in some other location..
R_WORK_RAM_PASSES	equ TILE_RAM

	; we are only allowed to use a/de registers
	macro SOUND_BIT_DELAY
		ld	de, $ffff
	.\@:
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		dec	de		; 6 cycles
		ld	a, e		; 4 cycles
		or	d		; 4 cycles
		jr	nz, .\@		; 12? cycles
	endm
