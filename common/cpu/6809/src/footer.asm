	global MAD_ROM_CRC16_ADDRESS
	global MAD_ROM_MIRROR_ADDRESS

	section footer

		; these get filled in by rom-inject-crc-mirror
MAD_ROM_MIRROR_ADDRESS:
		dc.b 	$00

MAD_ROM_CRC16_ADDRESS:
		dc.b 	$00, $00
