MEMORY {
	RAM: org=0x0400, len=0x1c00
	ROM: org=0xe000, len=0x2000
}

SECTIONS {
	/* force our reset_handler function to be at 0xc05a */
	.reset 0xe000: {
		FILL8(0x12);
		RESERVE(0x5a);
		*(reset)
	} > ROM
	.code 0xe05e: {
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
