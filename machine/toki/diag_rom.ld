MEMORY {
	ROM: org=0x000000, len=0x8000
	RAM: org=0x060000, len=0xd800
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
	.footer 0x7ffb: {
		*(footer)
	} > ROM
	.bss (NOLOAD): {
		*(bss)
	} > RAM
}
