MAD_ROM_SIZE		equ $8000

PALETTE_TEXT_COLOR	equ $0fff
PALETTE_HIGHLIGHT_COLOR	equ $0f00

; There aren't enough registers to save the number of passes
; work ram tests have run and we can't store it in work ram.
; Instead we need to store it in some other location..
R_WORK_RAM_PASSES	equ TILE_RAM

	; we are only allowed to use a/de registers
	macro SOUND_BIT_DELAY
		ld	de, $ffff
	.\@:
		WATCHDOG
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
