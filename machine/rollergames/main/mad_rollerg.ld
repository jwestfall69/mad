MEMORY {
	RAM: org=0x2000, len=0x1b00
	ROM: org=0xc000, len=0x4000
}

SECTIONS {
	.code 0xc000: {
		*(code)
	} > ROM
	.rodata: {
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
