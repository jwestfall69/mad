; OKI MSM6295 ADPCM
	include "global/include/oki/msm6295.inc"
	include "cpu/z80/include/common.inc"

	global msm6295_not_playing_test
	global msm6295_play_test

	section code

; we haven't told the msm6295 to play anything
; so sound channels should be inactive
; params:
;  hl = msm6285 register
msm6295_not_playing_test:
		ld	a, (hl)
		and	a, $f			; lower 4 bits are the channels
		jr	nz, .test_failed

		xor	a
		ret

	.test_failed:
		xor	a
		inc	a
		ret

; tell the msm6295 to play something and
; verify it says its playing
; params:
;   a = sound/phase #
;  hl = msm6295 register
msm6295_play_test:

		or	MSM6295_PHRASE_SEL
		ld	(hl), a
		ld	bc, $64
		RSUB	delay

		ld	a, MSM6295_CHANNEL4 << 4
		ld	(hl), a
		ld	bc, $64
		RSUB	delay

		ld	a, (hl)
		and	a, $f

		; tell the msm to stop playing the test sound
		push	af
		ld	a, MSM6295_CHANNEL4 << 3
		ld	(hl), a
		pop	af

		cp	a, MSM6295_CHANNEL4
		jr	nz, .test_failed

		xor	a
		ret

	.test_failed:
		xor	a
		inc	a
		ret
