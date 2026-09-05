MEMORY {
	RAM: org=0x3a00, len=0x0600
	ROM: org=0xc000, len=0x4000
}

SECTIONS {
	.header 0xc000: {
		*(header)
	} > ROM
	.code 0xc001: {
		*(code)
	} > ROM
	.rodata 0xe000: {
		*(data)
	} > ROM
	.error_addresses 0xf000: {
		*(error_addresses)
	} > ROM
	.footer 0xffef: {
		*(footer)
	} > ROM
	.vectors 0xfff2: {
		*(vectors)
	} > ROM
	.bss (NOLOAD): {
		*(bss)
	} > RAM
}
