	include "cpu/z80/include/common.inc"

	global delay_dsub
	global r_scratch

	ifnd _HEADLESS_

	global joystick_update_byte
	global joystick_lr_update_byte
	global joystick_lr_update_word
	global print_b2_return_to_menu
	global print_passes
	global sound_play_byte_dsub

	endif

	section code

; params:
;  bc = loops
delay_dsub:
		exx
	.loop:
		WATCHDOG		; ??
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		cp	$0		; 7 cycles
		dec	bc		; 6 cycles
		ld	a, c		; 4 cycles
		or	b		; 4 cycles
		jr	nz, .loop	; 12 cycles
	DSUB_RETURN

	ifnd _HEADLESS_

; params:
;  a = mask
;  ix = r_input_edge|r_input_raw
;  iy = ptr to byte
joystick_update_byte:
		ld	(r_mask), a

		ld	b, (ix)
		bit	INPUT_UP_BIT, b
		jr	z, .up_not_pressed
		inc	(iy)

	.up_not_pressed:
		bit	INPUT_DOWN_BIT, b
		jr	z, .down_not_pressed
		ld	a, (iy)
		sub	$1
		ld	(iy), a

	.down_not_pressed:
		bit	INPUT_LEFT_BIT, b
		jr	z, .left_not_pressed
		ld	a, (iy)
		sub	$10
		ld	(iy), a

	.left_not_pressed:
		bit	INPUT_RIGHT_BIT, b
		jr	z, .right_not_pressed
		ld	a, (iy)
		add	a, $10
		ld	(iy), a

	.right_not_pressed:
		ld	a, (r_mask)
		ld	b, a
		ld	a, (iy)
		and	b
		ld	(iy), a
		ret

; Looking at joystick left/right, adjust the byte in memory
; -$1 for LEFT
; +$1 for RIGHT
; If b1 is held down, then inc/dec is $10
; Then apply the mask to the byte
; params:
;  a = mask
;  ix = r_input_edge|r_input_raw
;  iy = ptr to byte
; returns:
;  a = 0 no change, 1 = change
joystick_lr_update_byte:
		ld	(r_mask), a

		ld	b, (ix)
		ld	ix, r_scratch	; using for inc/dec amount
		ld	(ix), $1

		; don't allow $10 inc/dec mount if mask wouldn't allow
		; a value of >= $10
		cp	$10
		jp	c, .b1_not_pressed

		ld	a, (r_input_raw)
		bit	INPUT_B1_BIT, a
		jr	z, .b1_not_pressed
		ld	(ix), $10

	.b1_not_pressed:
		bit	INPUT_LEFT_BIT, b
		jr	z, .left_not_pressed
		ld	a, (iy)
		sub	(ix)
		ld	(iy), a
		jr	.apply_mask_return

	.left_not_pressed:
		bit	INPUT_RIGHT_BIT, b
		jr	z, .return_no_change
		ld	a, (iy)
		add	a, (ix)
		ld	(iy), a

	.apply_mask_return:
		ld	ix, r_mask
		ld	a, (iy)
		and	(ix)
		ld	(iy), a
		ld	a, $1
		ret

	.return_no_change:
		xor	a
		ret

; Looking at joystick left/right, adjust the byte in memory
; -$1 for LEFT
; +$1 for RIGHT
; If b1 is held down, then inc/dec is $10
; Then apply the mask to the byte
; params:
;  bc = mask
;  ix = r_input_edge|r_input_raw
;  iy = ptr to byte
; returns:
;  a = 0 no change, 1 = change
joystick_lr_update_word:
		ld	(r_mask), bc

		ld	h, (iy + 1)
		ld	l, (iy + 0)

		ld	bc, $1

		ld	a, (r_input_raw)
		bit	INPUT_B1_BIT, a
		jr	z, .b1_not_pressed
		ld	bc, $10

	.b1_not_pressed:
		ld	a, (ix)
		bit	INPUT_LEFT_BIT, a
		jr	z, .left_not_pressed
		or	a	; clear carry
		sbc	hl, bc
		jr	.apply_mask_return

	.left_not_pressed:
		bit	INPUT_RIGHT_BIT, a
		jr	z, .return_no_change
		add	hl, bc

	.apply_mask_return:
		ld	bc, (r_mask)
		ld	a, h
		and	b
		ld	(iy + 1), a
		ld	a, l
		and	c
		ld	(iy + 0), a
		ld	a, $1
		ret

	.return_no_change:
		xor	a
		ret

; these 2 print function help de-dupe some common
; strings in many tests/menu items
print_b2_return_to_menu:
		SEEK_XY	SCREEN_START_X, SCREEN_B2_Y
		ld	de, d_str_b2_return_to_menu
		RSUB	print_string
		ret

print_passes:
		SEEK_XY	SCREEN_START_X, SCREEN_PASSES_Y
		ld	de, d_str_passes
		RSUB	print_string
		ret

; params:
;  b = byte to play
sound_play_byte_dsub:
		exx

		ld	l, $8
		ld	h, b

	.loop_next_bit:
		WATCHDOG
		sla	h
		jr	nc, .is_zero

		ld	a, SOUND_NUM_BIT_ONE
		jr	.sound_play

	.is_zero:
		ld	a, SOUND_NUM_BIT_ZERO

	.sound_play:
		SOUND_PLAY

	; if the machine can only generate tones, we need to
	; stop playing it after a bit
	ifd _SOUND_TONE_
		SOUND_BIT_DELAY
		SOUND_STOP
	endif

		SOUND_BIT_DELAY

		dec	l
		jp	nz, .loop_next_bit
		DSUB_RETURN

	section data

d_str_b2_return_to_menu:	STRING "B2 - RETURN TO MENU"
d_str_passes:			STRING "PASSES"

	endif

	section bss

; The cpu doesn't support register to register add/sub/cp/etc
; instructions, this is a global scratch location that can be
; used to help work around this (after work ram is tested good).
; ie:
;		stb	r_scratch
;		adda	r_scratch
r_scratch:		dcb.w 1
r_mask			dcb.w 1
