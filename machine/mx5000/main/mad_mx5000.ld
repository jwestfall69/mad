MEMORY {
	RAM: org=0x3000, len=0x1000
	ROM: org=0xc000, len=0x4000
}

SECTIONS {
	.header 0xc000: {
		*(header)
	} > ROM
	.code 0xc001: {
		*(code)
	} > ROM
	.rodata: {
		*(data)
	} > ROM
	.error_addresses 0xf000: {
		*(error_addresses)
	} > ROM
	.footer 0xffed: {
		*(footer)
	} > ROM
	.vectors 0xfff2: {
		*(vectors)
	} > ROM
	.bss (NOLOAD): {
		*(bss)
	} > RAM
}
