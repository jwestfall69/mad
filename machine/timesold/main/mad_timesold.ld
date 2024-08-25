MEMORY {
	ROM: org=0x000000, len=0x8000
	/* 
	   RAM actually starts at 0x040000, but the MCU
	   seems to use some of it to communicate with
	   the main cpu (ie: dsw2)
	*/
	RAM: org=0x040100, len=0xf00
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
