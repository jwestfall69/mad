MAD_ROM_SIZE		equ $4000
ERROR_ADDRESS_BASE	equ $2000

CURSOR_CHAR		equ $0a ; (c)
CURSOR_CLEAR_CHAR	equ $10

SOUND_NUM_BIT_ZERO	equ $0	; low tone
SOUND_NUM_BIT_ONE	equ $ff	; high tone

; There aren't enough registers to save the number of passes
; work ram tests have run.  With the work ram chip housing all
; ram on the machine it also means we have no ram location to
; store the passes either.  So just setting this to $0, which
; is the start of rom.
R_WORK_RAM_PASSES	equ $0

	; we are only allowed to use a/de registers
	macro SOUND_BIT_DELAY
		ld	de, $3fff
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
