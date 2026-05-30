	include "cpu/z80/include/common.inc"
	include "cpu/z80/include/handlers/memory_tests.inc"
	include "cpu/z80/include/tests/ram_test_logic.inc"

	; palette ram consists of 3x 4bit ram chips.  The high nibble
	; of even addresses are not mapped to anything and will always
	; be $f
	global auto_palette_ram_tests
	global manual_palette_ram_tests


	section code

	auto_palette_ram_tests:

		; output test is untested.  There are 2x 74LS245's
		; between the palette ram and the cpu.
		ld	hl, PALETTE_RAM
		RSUB	palette_output_even_test
		cp	0
		jp	nz, .test_failed_output

		ld	hl, PALETTE_RAM + 1
		RSUB	memory_output_test
		cp	0
		jp	nz, .test_failed_output

		ld	hl, PALETTE_RAM
		ld	c, $f
		RSUB	palette_write_test
		cp	0
		jr	nz, .test_failed_write

		ld	hl, PALETTE_RAM + 1
		ld	c, $f
		RSUB	palette_write_test
		cp	0
		jr	nz, .test_failed_write

		ld	hl, PALETTE_RAM + 1
		ld	c, $f0
		RSUB	palette_write_test
		cp	0
		jr	nz, .test_failed_write

		ld	hl, PALETTE_RAM
		ld	de, PALETTE_RAM_SIZE
		ld	b, $00
		RSUB	palette_data_pattern_test
		cp	0
		jr	nz, .test_failed_data

		ld	hl, PALETTE_RAM
		ld	de, PALETTE_RAM_SIZE
		ld	b, $55
		RSUB	palette_data_pattern_test
		cp	0
		jr	nz, .test_failed_data

		ld	hl, PALETTE_RAM
		ld	de, PALETTE_RAM_SIZE
		ld	b, $aa
		RSUB	palette_data_pattern_test
		cp	0
		jr	nz, .test_failed_data

		ld	hl, PALETTE_RAM
		ld	de, PALETTE_RAM_SIZE
		ld	b, $ff
		RSUB	palette_data_pattern_test
		cp	0
		jr	nz, .test_failed_data

		ld	hl, PALETTE_RAM
		ld	b, PALETTE_RAM_ADDRESS_LINES
		RSUB	palette_address_test
		cp	0
		jr	nz, .test_failed_address

		ld	hl, PALETTE_RAM
		ld	de, PALETTE_RAM_SIZE
		RSUB	palette_march_test
		cp	0
		jr	nz, .test_failed_march
		ret

	.test_failed_address:
		ld	a, EC_PALETTE_RAM_ADDRESS
		ret

	.test_failed_data:
		ld	a, EC_PALETTE_RAM_DATA
		ret

	.test_failed_march:
		ld	a, EC_PALETTE_RAM_MARCH
		ret

	.test_failed_output:
		ld	a, EC_PALETTE_RAM_OUTPUT
		ret

	.test_failed_write:
		ld	a, EC_PALETTE_RAM_WRITE
		ret

	manual_palette_ram_tests:
		ld	de, d_screen_xys_list
		call	print_xy_string_list
		call	print_passes
		call	print_b2_return_to_menu

		ld	bc, 0		; # of passes

	.loop_next_pass:
		WATCHDOG

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		push	bc
		RSUB	print_hex_word

		call	auto_palette_ram_tests
		jr	nz, .test_failed

		call	input_update
		ld	a, (r_input_edge)
		bit	INPUT_B2_BIT, a
		jr	nz, .test_exit

		bit	INPUT_B1_BIT, a
		jr	nz, .test_paused

		pop	bc
		inc	bc

		jr	.loop_next_pass

	.test_failed:
		call	error_handler

	.test_paused:
		RSUB	screen_init

		ld	de, d_screen_xys_list
		call	print_xy_string_list
		call	print_passes
		call	print_b2_return_to_menu

		SEEK_XY	SCREEN_PASSES_VALUE_X, SCREEN_PASSES_Y
		pop	bc
		push	bc
		RSUB	print_hex_word

		ld	b, INPUT_B1
		call	wait_button_release
		pop	bc
		jr	.loop_next_pass

	.test_exit:
; Write an incrementing data value at incrementing addresses
; params:
;  hl = start address
;  b = number of address lines
; returns:
;  a = 0 (pass), 1 (fail)
;  Z = 1 (pass), 0 (fail)
;  hl = error address
;  b = expected
;  c = actual
palette_address_test_dsub:
		exx

		; backup hl and b to hl' and b'
		ld	a, h
		exx
		ld	h, a
		exx
		ld	a, l
		exx
		ld	l, a
		exx

		dec	b

		ld	a, b
		exx
		ld	b, a
		exx

		ld	a, $11
		ld	de, $2

		ld	(hl), a
		inc	hl
		ld	(hl), a
		dec	hl

		add	$11

	.loop_next_write_address:
		add	hl, de
		ld	(hl), a
		inc	hl
		ld	(hl), a
		dec	hl
		or	a		; clear carry
		sbc	hl, de

		add	$11
		rl	e
		rl	d
		djnz	.loop_next_write_address

		WATCHDOG

		; switch to our backup copy of hl and b
		; then re-read the data to verify its correct
		exx

		ld	a, $11
		ld	de, $2

		ld	(r_scratch), a
		and	$f
		ld	c, a
		ld	a, (hl)
		and	$f
		cp	c
		jr	nz, .test_failed_even

		ld	a, (r_scratch)
		inc	hl
		ld	c, (hl)
		cp	c
		jr	nz, .test_failed

		dec	hl
		add	$11

	.loop_next_read_address:
		add	hl, de
		ld	(r_scratch), a
		and	$f
		ld	c, a
		ld	a, (hl)
		and	$f
		cp	c
		jr	nz, .test_failed_even

		ld	a, (r_scratch)
		inc	hl
		ld	c, (hl)
		cp	c
		jr	nz, .test_failed

		dec	hl
		or	a		; clear carry
		sbc	hl, de

		add	$11
		rl	e
		rl	d
		djnz	.loop_next_read_address

		WATCHDOG

		xor a
		DSUB_RETURN

	.test_failed_even:
		ld	c, a
		ld	a, (r_scratch)
		and	$f

	.test_failed:

		WATCHDOG
		ld	b, a
		xor	a
		inc	a
		DSUB_RETURN
		pop bc
		ret


; params:
;  hl = start address
;  de = size
;  b = pattern
; returns:
;  Z = 0 (error), 1 = (pass)
;  a = 0 (pass), 1 = (fail)
;  hl = error address
;  b = expected
;  c = actual
palette_data_pattern_test_dsub:
		exx

	.loop_next_address:
		; test even addresses with $f mask
		ld	a, b
		and	$f
		ld	c, a
		ld	(hl), c
		ld	a, (hl)
		and	$f
		cp	c
		jr	nz, .test_failed_even_abort

		inc	hl
		dec	de

		; test odd addresses with $ff mask
		ld	a, b
		ld	(hl), a
		ld	c, (hl)
		cp	c
		jr	nz, .test_failed_abort

		inc	hl
		dec	de
		ld	a, d
		or	e
		jr	nz, .loop_next_address

		WATCHDOG

		xor	a
		DSUB_RETURN

	.test_failed_even_abort:
		ld	c, a
		ld	a, b
		and	$f
		ld	b, a

	.test_failed_abort:

		WATCHDOG

		xor	a
		inc	a
		DSUB_RETURN


; params:
;  hl = start address
;  de = size
; returns
;  Z = 0 (error), 1 = (pass)
;  a = 0 (pass), 1 = (fail)
;  hl = error address
;  b = expected
;  c = actual
palette_march_test_dsub:
		exx

		; backup de to de'
		ld	a, d
		exx
		ld	d, a
		exx
		ld	a, e
		exx
		ld	e, a
		exx

		; fill the region with $0
		ld	b, $0
	.loop_fill_zero:
		ld	(hl), b
		inc	hl
		dec	de
		ld	a, d
		or	e
		jr	nz, .loop_fill_zero

		WATCHDOG

		; restore de from backup
		exx
		ld	a, d
		exx
		ld	d, a
		exx
		ld	a, e
		exx
		ld	e, a

		; s, verify $0, write $ff
		or	a		; clear carry
		sbc	hl, de

	.loop_up_test:

		; even address
		ld	a, (hl)
		and	$f
		cp	$0
		jr	nz, .test_failed_even
		ld	(hl), $ff

		inc	hl
		dec	de

		; odd address
		xor	a
		ld	c, (hl)
		cp	c
		jr	nz, .test_failed
		ld	(hl), $ff
		inc	hl
		dec	de


		ld	a, d
		or	e
		jr	nz, .loop_up_test

		WATCHDOG

		; march down, verify $ff, write $0
		exx
		ld	a, d
		exx
		ld	d, a
		exx
		ld	a, e
		exx
		ld	e, a
		dec	hl
		ld	b, $ff
	.loop_down_test:
		; odd addresses
		ld	a, b
		ld	c, (hl)
		cp	c
		jr	nz, .test_failed
		ld	(hl), $0

		dec	hl
		dec	de

		; even addresses
		ld	a, (hl)
		and	$f
		cp	$f
		jr	nz, .test_failed_even
		ld	(hl), $0

		dec	hl
		dec	de

		ld	a, d
		or	e
		jr	nz, .loop_down_test

		xor	a
		DSUB_RETURN

	.test_failed_even:
		ld	c, a
		ld	a, b
		and	$f
		ld	b, a

	.test_failed:
		xor	a
		inc	a
		DSUB_RETURN

; When a memory address doesn't output anything on a read request it will
; usually result in the target register being filled with the opcode for
; the ld.  Its not 100% and will sometimes results in the register filled
; with $ff or other garbage.  So we we loop $64 times trying to catch
; 2 different opcodes being placed into 'a' in a row.
; params:
;  hl = memory location to test
; returns:
;  Z = 0 (error), 1 = (pass)
;  a = 0 (pass), 1 = (fail)
palette_output_even_test_dsub:
		exx

		WATCHDOG

		ld	d, h
		ld	e, l

		ld	b, $64
	.loop_next:
		ld	a, (hl)
		and	$f
		cp	$e		; ld a, (hl) opcode ($7e & $f)
		jr	nz, .loop_pass

		ld	a, (de)
		and	$f
		cp	$a		; ld a, (de) opcode ($1a & $f
		jr	z, .test_failed

	.loop_pass:
		djnz	.loop_next

		xor	a
		DSUB_RETURN

	.test_failed:
		xor	a
		inc	a
		DSUB_RETURN


; params:
;  hl = memory location to test
;   c = mask
; returns:
;  Z = 0 (error), 1 = (pass)
;  a = 0 (pass), 1 = (fail)
;  b = expected data
;  c = actual data
;  hl = address
palette_write_test_dsub:
		exx

		WATCHDOG

		ld	d, c
		; read/save a byte from ram, write !byte back to the location,
		; re-read the location and error if it still the original byte
		ld	a, (hl)
		and	d
		ld	b, a
		xor	$ff
		ld	(hl), a
		nop
		nop
		nop
		nop
		ld	a, (hl)
		and	d
		cp	b
		jr	z, .test_failed

		xor	a
		DSUB_RETURN

	.test_failed:
		ld	c, a
		ld	a, b
		xor	$ff
		and	d
		ld	b, a
		xor	a
		inc	a
		DSUB_RETURN

	section data

d_screen_xys_list:
	XY_STRING SCREEN_START_X, SCREEN_START_Y, "PALETTE RAM TEST"
	XY_STRING SCREEN_START_X, SCREEN_B1_Y, "B1 - PAUSE"
	XY_STRING_LIST_END
