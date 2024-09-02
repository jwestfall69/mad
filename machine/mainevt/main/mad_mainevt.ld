MEMORY {
	RAM: org=0x4000, len=0x1e00
	ROM: org=0xc000, len=0x4000
}

SECTIONS {
	/* force our reset_handler function to be at 0xc05a */
	.reset 0xc000: {
		FILL8(0x12);
		RESERVE(0x5a);
		*(reset)
	} > ROM
	.code 0xc05d: {
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
}
