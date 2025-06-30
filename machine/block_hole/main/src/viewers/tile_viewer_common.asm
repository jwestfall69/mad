	include "cpu/konami2/include/common.inc"

	global tvc_draw_tile_cb
	global tvc_init

	section code

; Palette Layout
;  xBBB BBGG GGGR RRRR
; params:
;  y = start palette address
tvc_init:

		clr	r_tvc_bank_num
		clr	REG_TILE_BANK_SLOTS_A

		; bank to palette ram
		setln	#(SETLN_WATCHDOG_POLL|SETLN_SELECT_RAM_PALETTE)


		ldx	#d_palette_data
		ldb	#PALETTE_SIZE

	.loop_next_color:
		lda	,x+
		sta	,y+
		decb
		bne	.loop_next_color

		setln	#(SETLN_WATCHDOG_POLL|SETLN_SELECT_RAM_WORK)
		rts

; params:
;  d = tile (word)
; 0000 BBTT TTTT TTTT
;  x = already at location in tile ram
; PPP? SSTT TTTT TTTT
; P = palette num
; S = bank slot?
; T = tile num
tvc_draw_tile_cb:
		exg	b, a
		RSUB	print_byte

		; top 4 bits will select the bank number for bank slot 1
		tfr	b, a
		aslb
		aslb
		andb	#$30
		cmpb	r_tvc_bank_num
		beq	.skip_set_bank_num

		stb	REG_TILE_BANK_SLOTS_A
		stb	r_tvc_bank_num

	.skip_set_bank_num:
		anda	#$3
		ora	#(TVC_PALETTE_NUM<<5 | TVC_BANK_SLOT_NUM<<2)
		sta	-$2000, x
		rts

	section data

d_palette_data:
	dc.w	$0000, $6d39, $3e34, $fe00, $5864, $8064, $e519, $d126
	dc.w	$ffff, $8271, $0e78, $aa39, $f725, $0e5e, $9532, $e277

	section bss

r_tvc_bank_num:		dcb.b 1
