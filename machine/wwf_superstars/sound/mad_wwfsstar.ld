MEMORY {
	ROM: org=0x0000, len=0x4000
	RAM: org=0x8000, len=0x800
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
	 .error_addresses 0x2000: {
		*(error_addresses)
	} > ROM
	.footer 0x3ffb: {
		*(footer)
	} > ROM
	.bss (NOLOAD): {
		*(bss)
	} > RAM
}
