	include "cpu/z80/include/macros.inc"
	include "cpu/z80/include/dsub.inc"

	include "error_codes.inc"
	include "machine.inc"

	global msm6295_tests
	section code

msm6295_tests:

		ld	hl, REG_MSM6295
		RSUB	memory_output_test
		jr	z, .test_passed_output
		ld	a, EC_MSM6295_OUTPUT
		jp	error_address

	.test_passed_output:
		ld	hl, REG_MSM6295
		call	msm6295_not_playing_test
		jr	z, .test_passed_not_playing
		ld	a, EC_MSM6295_ALREADY_PLAYING
		jp	error_address

	.test_passed_not_playing:
		ld	hl, REG_MSM6295
		ld	a, $2			; sound number to try playing
		call	msm6295_play_test
		jr	z, .test_passed_play
		ld	a, EC_MSM6295_PLAY
		jp	error_address

	.test_passed_play:
		ret
