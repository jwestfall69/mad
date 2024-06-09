	global MAD_ROM_CRC32_ADDRESS
	global MAD_ROM_MIRROR_ADDRESS

	section footer

; both filled in by rom-inject-crc-mirror
MAD_ROM_MIRROR_ADDRESS:
		blk	1

MAD_ROM_CRC32_ADDRESS:
		blk	4
