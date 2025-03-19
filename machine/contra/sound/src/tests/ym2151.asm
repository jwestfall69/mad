	include "cpu/6809/include/macros.inc"
	include "cpu/6809/include/psub.inc"

	include "error_codes.inc"
	include "machine.inc"

	global ym2151_tests

	section code

ym2151_tests:
		ldx	#REG_YM2151_DATA
		PSUB	memory_output_test
		beq	.test_passed_output
		lda	#EC_YM2151_OUTPUT
		jmp	error_address

	.test_passed_output:
		ldx	#REG_YM2151_DATA
		jsr	ym2151_busy_bit_test
		beq	.test_passed_busy_bit
		lda	#EC_YM2151_BUSY_BIT
		jmp	error_address

	.test_passed_busy_bit:
		rts
