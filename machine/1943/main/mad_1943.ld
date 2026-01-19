MEMORY {
	ROM: org=0x0000, len=0x8000
	RAM: org=0xe000, len=0x1000
}

SECTIONS {
	.vectors 0x0: {
		*(vectors)
	} > ROM
	.code 0x80: {
		*(code)
	} > ROM
	.rodata: {
		*(data)
	} > ROM
	 .error_addresses 0x6000: {
		*(error_addresses)
	} > ROM
	.footer 0x7ffb: {
		*(footer)
	} > ROM
	.bss (NOLOAD): {
		*(bss)
	} > RAM
}
