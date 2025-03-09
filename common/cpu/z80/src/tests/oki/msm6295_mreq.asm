; OKI MSM6295 ADPCM
	include "cpu/z80/include/dsub.inc"
	include "cpu/z80/include/macros.inc"

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

; Information about the start/stop addresses of sound
; samples are stored in array of data at the start of
; the ADPCM rom space.  The array consists up to 128 of
; the following struct;
; struct phrase {
;   uint8_t start_addr[3];
;   uint8_t end_addr[3];
;   uint8_t pad[2]; // 0 filled
; }
; The msm6295 doesn't allow the use of phrase 0, so
; this allows for 127 different adpcm sounds.
;
; When wanting to play a sound you need to send 2 bytes
; to the msm6295 register address.
;  byte 1 = MSM6295_PHRASE_SEL_BIT | phrase #
;  delay
;  byte 2 = channel bit << 4 | volume reduction value
;
MSM6295_PHRASE_SEL	equ $80
MSM6295_CHANNEL1	equ $1
MSM6295_CHANNEL2	equ $2
MSM6295_CHANNEL3	equ $4
MSM6295_CHANNEL4	equ $8

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
