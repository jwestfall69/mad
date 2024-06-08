	global MAD_ROM_CRC32_ADDRESS

	section footer

MAD_ROM_MIRROR_ADDRESS:
		blk	1

MAD_ROM_CRC32_ADDRESS:
		blk	4	; rom-inject-crc-mirror
