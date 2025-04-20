	global MAD_ROM_CRC32_ADDRESS
	global MAD_ROM_MIRROR_ADDRESS

	section footer


		; these get filled in by rom-inject-crc-mirror
MAD_ROM_MIRROR_ADDRESS:
		dc.b 	$00			; bios mirror, $00 is running copy, $01 1st copy, $02 2nd, $03 3rd

MAD_ROM_CRC32_ADDRESS:
		dc.b 	$00,$00,$00,$00		; bios crc32 value calculated from bios_start to $c07ffb
