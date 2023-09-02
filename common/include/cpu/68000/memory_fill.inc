	; struct MEMORY_FILL_ENTRY {
	;  long start_address;
	;  word size;
	;  word fill_data;
	; }
	macro MEMORY_FILL_ENTRY
		dc.l \1		; start address
		dc.w \2, \3	; size, value
	endm

	macro MEMORY_FILL_ENTRY_LIST_END
		dc.l $0
	endm
