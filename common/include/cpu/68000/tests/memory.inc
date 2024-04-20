	macro MEMORY_ADDRESS_ENTRY
		dc.l \1
	endm

	macro MEMORY_ADDRESS_LIST_END
		dc.l $1
	endm
