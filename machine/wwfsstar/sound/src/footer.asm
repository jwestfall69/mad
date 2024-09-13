	global MAD_ROM_CRC32_ADDRESS
	global MAD_ROM_MIRROR_ADDRESS

	section footer

; both filled in by rom-inject-crc-mirror
MAD_ROM_MIRROR_ADDRESS:
		dc.b 	$0

MAD_ROM_CRC32_ADDRESS:
		dc.b 	$0, $0, $0, $0
