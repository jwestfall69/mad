	; struct MEMORY_FILL_ENTRY {
	;  long start_address;
	;  long size;
	;  word fill_data;
	; }
	macro MEMORY_FILL_ENTRY
		dc.l \1, \2		; start address, size
		dc.w \3			; value
	endm

	macro MEMORY_FILL_LIST_END
		dc.l $0
		dc.l $0
	endm
