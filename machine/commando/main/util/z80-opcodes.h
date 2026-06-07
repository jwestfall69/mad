// The arrays below were built from
// http://www.breakintoprogram.co.uk/programming/assembly-language/z80/z80-opcodes
// with a few missing instructions added


int8_t z80_oparg_size_main[256] = {
   0, // 00            nop
   2, // 01 ll hh      ld	bc, hhll
   0, // 02            ld	(bc), a
   0, // 03            inc	bc
   0, // 04            inc	b
   0, // 05            dec	b
   1, // 06 nn         ld	b, nn
   0, // 07            rlca
   0, // 08            ex	af, af’
   0, // 09            add	hl, bc
   0, // 0a            ld	a, (bc)
   0, // 0b            dec	bc
   0, // 0c            inc	c
   0, // 0d            dec	c
   1, // 0e nn         ld	c, nn
   0, // 0f            ca
   1, // 10 nn         djnz	nn
   2, // 11 ll hh      ld	de, hhll
   0, // 12            ld	(de), a
   0, // 13            inc	de
   0, // 14            inc	d
   0, // 15            dec	d
   1, // 16 nn         ld	d, nn
   0, // 17            rla
   1, // 18 nn         jr	nn
   0, // 19            add	hl, de
   0, // 1a            ld	a, (de)
   0, // 1b            dec	de
   0, // 1c            inc	e
   0, // 1d            dec	e
   1, // 1e nn         ld	e, nn
   0, // 1f            rra
   1, // 20 nn         jr	nz, nn
   2, // 21 ll hh      ld	hl, hhll
   2, // 22 ll hh      ld	(hhll), hl
   0, // 23            inc	hl
   0, // 24            inc	h
   0, // 25            dec	h
   1, // 26 nn         ld	h, nn
   0, // 27            daa
   1, // 28 nn         jr	z, nn
   0, // 29            add	hl, hl
   2, // 2a ll hh      ld	hl, (hhll)
   0, // 2b            dec	hl
   0, // 2c            inc	l
   0, // 2d            dec	l
   1, // 2e nn         ld	l, nn
   0, // 2f            cpl
   1, // 30 nn         jr	nc, nn
   2, // 31 ll hh      ld	sp, hhll
   2, // 32 ll hh      ld	(hhll), a
   0, // 33            inc	sp
   0, // 34            inc	(hl)
   0, // 35            dec	(hl)
   1, // 36 nn         ld	(hl), nn
   0, // 37            scf
   1, // 38 nn         jr	c, nn
   0, // 39            add	hl, sp
   2, // 3a ll hh      ld	a, (hhll)
   0, // 3b            dec	sp
   0, // 3c            inc	a
   0, // 3d            dec	a
   1, // 3e nn         ld	a, nn
   0, // 3f            ccf
   0, // 40            ld	b, b
   0, // 41            ld	b, c
   0, // 42            ld	b, d
   0, // 43            ld	b, e
   0, // 44            ld	b, h
   0, // 45            ld	b, l
   0, // 46            ld	b, (hl)
   0, // 47            ld	b, a
   0, // 48            ld	c, b
   0, // 49            ld	c, c
   0, // 4a            ld	c, d
   0, // 4b            ld	c, e
   0, // 4c            ld	c, h
   0, // 4d            ld	c, l
   0, // 4e            ld	c, (hl)
   0, // 4f            ld	c, a
   0, // 50            ld	d, b
   0, // 51            ld	d, c
   0, // 52            ld	d, d
   0, // 53            ld	d, e
   0, // 54            ld	d, h
   0, // 55            ld	d, l
   0, // 56            ld	d, (hl)
   0, // 57            ld	d, a
   0, // 58            ld	e, b
   0, // 59            ld	e, c
   0, // 5a            ld	e, d
   0, // 5b            ld	e, e
   0, // 5c            ld	e, h
   0, // 5d            ld	e, l
   0, // 5e            ld	e, (hl)
   0, // 5f            ld	e, a
   0, // 60            ld	h, b
   0, // 61            ld	h, c
   0, // 62            ld	h, d
   0, // 63            ld	h, e
   0, // 64            ld	h, h
   0, // 65            ld	h, l
   0, // 66            ld	h, (hl)
   0, // 67            ld	h, a
   0, // 68            ld	l, b
   0, // 69            ld	l, c
   0, // 6a            ld	l, d
   0, // 6b            ld	l, e
   0, // 6c            ld	l, h
   0, // 6d            ld	l, l
   0, // 6e            ld	l, (hl)
   0, // 6f            ld	l, a
   0, // 70            ld	(hl), b
   0, // 71            ld	(hl), c
   0, // 72            ld	(hl), d
   0, // 73            ld	(hl), e
   0, // 74            ld	(hl), h
   0, // 75            ld	(hl), l
   0, // 76            halt
   0, // 77            ld	(hl), a
   0, // 78            ld	a, b
   0, // 79            ld	a, c
   0, // 7a            ld	a, d
   0, // 7b            ld	a, e
   0, // 7c            ld	a, h
   0, // 7d            ld	a, l
   0, // 7e            ld	a, (hl)
   0, // 7f            ld	a, a
   0, // 80            add	a, b
   0, // 81            add	a, c
   0, // 82            add	a, d
   0, // 83            add	a, e
   0, // 84            add	a, h
   0, // 85            add	a, l
   0, // 86            add	a, (hl)
   0, // 87            add	a, a
   0, // 88            adc	a, b
   0, // 89            adc	a, c
   0, // 8a            adc	a, d
   0, // 8b            adc	a, e
   0, // 8c            adc	a, h
   0, // 8d            adc	a, l
   0, // 8e            adc	a, (hl)
   0, // 8f            adc	a, a
   0, // 90            sub	a, b
   0, // 91            sub	a, c
   0, // 92            sub	a, d
   0, // 93            sub	a, e
   0, // 94            sub	a, h
   0, // 95            sub	a, l
   0, // 96            sub	a, (hl)
   0, // 97            sub	a, a
   0, // 98            sbc	a, b
   0, // 99            sbc	a, c
   0, // 9a            sbc	a, d
   0, // 9b            sbc	a, e
   0, // 9c            sbc	a, h
   0, // 9d            sbc	a, l
   0, // 9e            sbc	a, (hl)
   0, // 9f            sbc	a, a
   0, // a0            and	b
   0, // a1            and	c
   0, // a2            and	d
   0, // a3            and	e
   0, // a4            and	h
   0, // a5            and	l
   0, // a6            and	(hl)
   0, // a7            and	a
   0, // a8            xor	b
   0, // a9            xor	c
   0, // aa            xor	d
   0, // ab            xor	e
   0, // ac            xor	h
   0, // ad            xor	l
   0, // ae            xor	(hl)
   0, // af            xor	a
   0, // b0            or	b
   0, // b1            or	c
   0, // b2            or	d
   0, // b3            or	e
   0, // b4            or	h
   0, // b5            or	l
   0, // b6            or	(hl)
   0, // b7            or	a
   0, // b8            cp	b
   0, // b9            cp	c
   0, // ba            cp	d
   0, // bb            cp	e
   0, // bc            cp	h
   0, // bd            cp	l
   0, // be            cp	(hl)
   0, // bf            cp	a
   0, // c0            ret	nz
   0, // c1            pop	bc
   2, // c2 ll hh      jp	nz, hhll
   2, // c3 ll hh      jp	hhll
   2, // c4 ll hh      call	nz, hhll
   0, // c5            push	bc
   1, // c6 nn         add	a, nn
   0, // c7            rst	00
   0, // c8            ret	z
   0, // c9            ret
   2, // ca ll hh      jp	z, hhll
   0, // cb            cb	opcodes
   2, // cc ll hh      call	z, hhll
   2, // cd ll hh      call	hhll
   1, // ce nn         adc	a, nn
   0, // cf            rst	08
   0, // d0            ret	nc
   0, // d1            pop	de
   2, // d2 ll hh      jp	nc, hhll
   1, // d3 nn         out	(nn), a
   2, // d4 ll hh      call	nc, hhll
   0, // d5            push	de
   1, // d6 nn         sub	a, nn
   0, // d7            rst	10
   0, // d8            ret	c
   0, // d9            exx
   2, // da ll hh      jp	c, hhll
   1, // db nn         in	a, (nn)
   2, // dc ll hh      call	c, hhll
   0, // dd            dd	opcodes
   1, // de nn         sbc	a, nn
   0, // df            rst	18
   0, // e0            ret	po
   0, // e1            pop	hl
   2, // e2 ll hh      jp	po, hhll
   0, // e3            ex	(sp), hl
   2, // e4 ll hh      call	po, hhll
   0, // e5            push	hl
   1, // e6 nn         and	nn
   0, // e7            rst	20
   0, // e8            ret	pe
   0, // e9            jp	(hl)
   2, // ea ll hh      jp	pe, hhll
   0, // eb            ex	de, hl
   2, // ec ll hh      call	p, hhll
   0, // ed            ed	opcodes
   1, // ee nn         xor	nn
   0, // ef            rst	28
   0, // f0            ret	p
   0, // f1            pop	af
   2, // f2 ll hh      jp	p, hhll
   0, // f3            di
   2, // f4 ll hh      call	p, hhll
   0, // f5            push	af
   1, // f6 nn         or	nn
   0, // f7            rst	30
   0, // f8            ret	m
   0, // f9            ld	sp, hl
   2, // fa ll hh      jp	m, hhll
   0, // fb            ei
   2, // fc ll hh      call	m, hhll
   0, // fd            fd	opcodes
   1, // fe nn         cp	nn
   0, // ff            rst	38
};

int8_t z80_oparg_size_cb[256] = {
   0, // cb 00         rlc	b
   0, // cb 01         rlc	c
   0, // cb 02         rlc	d
   0, // cb 03         rlc	e
   0, // cb 04         rlc	h
   0, // cb 05         rlc	l
   0, // cb 06         rlc	(hl)
   0, // cb 07         rlc	a
   0, // cb 08         rrc	b
   0, // cb 09         rrc	c
   0, // cb 0a         rrc	d
   0, // cb 0b         rrc	e
  -1, // cb 0c         invalid
  -1, // cb 0d         invalid
   0, // cb 0e         rrc	(hl)
   0, // cb 0f         rrc	a
   0, // cb 10         rl	b
   0, // cb 11         rl	c
   0, // cb 12         rl	d
   0, // cb 13         rl	e
   0, // cb 14         rl	h
   0, // cb 15         rl	l
   0, // cb 16         rl	(hl)
   0, // cb 17         rl	a
   0, // cb 18         rr	b
   0, // cb 19         rr	c
   0, // cb 1a         rr	d
   0, // cb 1b         rr	e
   0, // cb 1c         rr	h
   0, // cb 1d         rr	l
   0, // cb 1e         rr	(hl)
   0, // cb 1f         rr	a
   0, // cb 20         sla	b
   0, // cb 21         sla	c
   0, // cb 22         sla	d
   0, // cb 23         sla	e
   0, // cb 24         sla	h
   0, // cb 25         sla	l
   0, // cb 26         sla	(hl)
   0, // cb 27         sla	a
   0, // cb 28         sra	b
   0, // cb 29         sra	c
   0, // cb 2a         sra	d
   0, // cb 2b         sra	e
   0, // cb 2c         sra	h
   0, // cb 2d         sra	l
   0, // cb 2e         sra	(hl)
   0, // cb 2f         sra	a
   0, // cb 30         sls	b
   0, // cb 31         sls	c
   0, // cb 32         sls	d
   0, // cb 33         sls	e
   0, // cb 34         sls	h
   0, // cb 35         sls	l
   0, // cb 36         sls	(hl)
   0, // cb 37         sls	a
   0, // cb 38         srl	b
   0, // cb 39         srl	c
   0, // cb 3a         srl	d
   0, // cb 3b         srl	e
   0, // cb 3c         srl	h
   0, // cb 3d         srl	l
   0, // cb 3e         srl	(hl)
   0, // cb 3f         srl	a
   0, // cb 40         bit	0, b
   0, // cb 41         bit	0, c
   0, // cb 42         bit	0, d
   0, // cb 43         bit	0, e
   0, // cb 44         bit	0, h
   0, // cb 45         bit	0, l
   0, // cb 46         bit	0, (hl)
   0, // cb 47         bit	0, a
   0, // cb 48         bit	1, b
   0, // cb 49         bit	1, c
   0, // cb 4a         bit	1, d
   0, // cb 4b         bit	1, e
   0, // cb 4c         bit	1, h
   0, // cb 4d         bit	1, l
   0, // cb 4e         bit	1, (hl)
   0, // cb 4f         bit	1, a
   0, // cb 50         bit	2, b
   0, // cb 51         bit	2, c
   0, // cb 52         bit	2, d
   0, // cb 53         bit	2, e
   0, // cb 54         bit	2, h
   0, // cb 55         bit	2, l
   0, // cb 56         bit	2, (hl)
   0, // cb 57         bit	2, a
   0, // cb 58         bit	3, b
   0, // cb 59         bit	3, c
   0, // cb 5a         bit	3, d
   0, // cb 5b         bit	3, e
   0, // cb 5c         bit	3, h
   0, // cb 5d         bit	3, l
   0, // cb 5e         bit	3, (hl)
   0, // cb 5f         bit	3, a
   0, // cb 60         bit	4, b
   0, // cb 61         bit	4, c
   0, // cb 62         bit	4, d
   0, // cb 63         bit	4, e
   0, // cb 64         bit	4, h
   0, // cb 65         bit	4, l
   0, // cb 66         bit	4, (hl)
   0, // cb 67         bit	4, a
   0, // cb 68         bit	5, b
   0, // cb 69         bit	5, c
   0, // cb 6a         bit	5, d
   0, // cb 6b         bit	5, 
   0, // cb 6c         bit	5, h
   0, // cb 6d         bit	5, l
   0, // cb 6e         bit	5, (hl)
   0, // cb 6f         bit	5, a
   0, // cb 70         bit	6, b
   0, // cb 71         bit	6, c
   0, // cb 72         bit	6, d
   0, // cb 73         bit	6, e
   0, // cb 74         bit	6, h
   0, // cb 75         bit	6, l
   0, // cb 76         bit	6, (hl)
   0, // cb 77         bit	6, a
   0, // cb 78         bit	7, b
   0, // cb 79         bit	7, c
   0, // cb 7a         bit	7, d
   0, // cb 7b         bit	7, e
   0, // cb 7c         bit	7, h
   0, // cb 7d         bit	7, l
   0, // cb 7e         bit	7, (hl)
   0, // cb 7f         bit	7, a
   0, // cb 80         res	0, b
   0, // cb 81         res	0, c
   0, // cb 82         res	0, d
   0, // cb 83         res	0, e
   0, // cb 84         res	0, h
   0, // cb 85         res	0, l
   0, // cb 86         res	0, (hl)
   0, // cb 87         res	0, a
   0, // cb 88         res	1, b
   0, // cb 89         res	1, c
   0, // cb 8a         res	1, d
   0, // cb 8b         res	1, e
   0, // cb 8c         res	1, h
   0, // cb 8d         res	1, l
   0, // cb 8e         res	1, (hl)
   0, // cb 8f         res	1, a
   0, // cb 90         res	2, b
   0, // cb 91         res	2, c
   0, // cb 92         res	2, d
   0, // cb 93         res	2, e
   0, // cb 94         res	2, h
   0, // cb 95         res	2, l
   0, // cb 96         res	2, (hl)
   0, // cb 97         res	2, a
   0, // cb 98         res	3, b
   0, // cb 99         res	3, c
   0, // cb 9a         res	3, d
   0, // cb 9b         res	3, e
   0, // cb 9c         res	3, h
   0, // cb 9d         res	3, l
   0, // cb 9e         res	3, (hl)
   0, // cb 9f         res	3, a
   0, // cb a0         res	4, b
   0, // cb a1         res	4, c
   0, // cb a2         res	4, d
   0, // cb a3         res	4, 
   0, // cb a4         res	4, h
   0, // cb a5         res	4, l
   0, // cb a6         res	4, (hl)
   0, // cb a7         res	4, a
   0, // cb a8         res	5, b
   0, // cb a9         res	5, c
   0, // cb aa         res	5, d
   0, // cb ab         res	5, e
   0, // cb ac         res	5, h
   0, // cb ad         res	5, l
   0, // cb ae         res	5, (hl)
   0, // cb af         res	5, a
   0, // cb b0         res	6, b
   0, // cb b1         res	6, c
   0, // cb b2         res	6, d
   0, // cb b3         res	6, e
   0, // cb b4         res	6, h
   0, // cb b5         res	6, l
   0, // cb b6         res	6, (hl)
   0, // cb b7         res	6, a
   0, // cb b8         res	7, b
   0, // cb b9         res	7, c
   0, // cb ba         res	7, d
   0, // cb bb         res	7, e
   0, // cb bc         res	7, h
   0, // cb bd         res	7, l
   0, // cb be         res	7, (hl)
   0, // cb bf         res	7, a
   0, // cb c0         set	0, b
   0, // cb c1         set	0, c
   0, // cb c2         set	0, d
   0, // cb c3         set	0, e
   0, // cb c4         set	0, h
   0, // cb c5         set	0, l
   0, // cb c6         set	0, (hl)
   0, // cb c7         set	0, a
   0, // cb c8         set	1, b
   0, // cb c9         set	1, c
   0, // cb ca         set	1, d
   0, // cb cb         set	1, e
   0, // cb cc         set	1, h
   0, // cb cd         set	1, l
   0, // cb ce         set	1, (hl)
   0, // cb cf         set	1, a
   0, // cb d0         set	2, b
   0, // cb d1         set	2, c
   0, // cb d2         set	2, d
   0, // cb d3         set	2, e
   0, // cb d4         set	2, h
   0, // cb d5         set	2, l
   0, // cb d6         set	2, (hl)
   0, // cb d7         set	2, a
   0, // cb d8         set	3, b
   0, // cb d9         set	3, c
   0, // cb da         set	3, d
   0, // cb db         set	3, e
   0, // cb dc         set	3, h
   0, // cb dd         set	3, l
   0, // cb de         set	3, (hl)
   0, // cb df         set	3, a
   0, // cb e0         set	4, b
   0, // cb e1         set	4, c
   0, // cb e2         set	4, d
   0, // cb e3         set	4, e
   0, // cb e4         set	4, h
   0, // cb e5         set	4, l
   0, // cb e6         set	4, (hl)
   0, // cb e7         set	4, a
   0, // cb e8         set	5, b
   0, // cb e9         set	5, c
   0, // cb ea         set	5, d
   0, // cb eb         set	5, e
   0, // cb ec         set	5, h
   0, // cb ed         set	5, l
   0, // cb ee         set	5, (hl)
   0, // cb ef         set	5, a
   0, // cb f0         set	6, b
   0, // cb f1         set	6, c
   0, // cb f2         set	6, d
   0, // cb f3         set	6, e
   0, // cb f4         set	6, h
   0, // cb f5         set	6, l
   0, // cb f6         set	6, (hl)
   0, // cb f7         set	6, a
   0, // cb f8         set	7, b
   0, // cb f9         set	7, c
   0, // cb fa         set	7, d
   0, // cb fb         set	7, e
   0, // cb fc         set	7, h
   0, // cb fd         set	7, l
   0, // cb fe         set	7, (hl)
   0, // cb ff         set	7, a
};

int8_t z80_oparg_size_dd[256] = {
  -1, // dd 00         invalid
  -1, // dd 01         invalid
  -1, // dd 02         invalid
  -1, // dd 03         invalid
  -1, // dd 04         invalid
  -1, // dd 05         invalid
  -1, // dd 06         invalid
  -1, // dd 07         invalid
  -1, // dd 08         invalid
   0, // dd 09         add	ix, bc
  -1, // dd 0a         invalid
  -1, // dd 0b         invalid
  -1, // dd 0c         invalid
  -1, // dd 0d         invalid
  -1, // dd 0e         invalid
  -1, // dd 0f         invalid
  -1, // dd 10         invalid
  -1, // dd 11         invalid
  -1, // dd 12         invalid
  -1, // dd 13         invalid
  -1, // dd 14         invalid
  -1, // dd 15         invalid
  -1, // dd 16         invalid
  -1, // dd 17         invalid
  -1, // dd 18         invalid
   0, // dd 19         add	ix, de
  -1, // dd 1a         invalid
  -1, // dd 1b         invalid
  -1, // dd 1c         invalid
  -1, // dd 1d         invalid
  -1, // dd 1e         invalid
  -1, // dd 1f         invalid
  -1, // dd 20         invalid
   2, // dd 21 ll hh   ld	ix, hhll
   2, // dd 22 ll hh   ld	(hhll), ix
   0, // dd 23         inc	ix
   0, // dd 24         inc	ixh
   0, // dd 25         dec	ixh
   1, // dd 26 nn      ld	ixh, nn
  -1, // dd 27         invalid
  -1, // dd 28         invalid
   0, // dd 29         add	ix, ix
   2, // dd 2a ll hh   ld	ix, (hhll)
   0, // dd 2b         dec	ix
   0, // dd 2c         inc	ixl
   0, // dd 2d         dec	ixl
   1, // dd 2e nn      ld	ixl, nn
  -1, // dd 2f         invalid
  -1, // dd 30         invalid
  -1, // dd 31         invalid
  -1, // dd 32         invalid
  -1, // dd 33         invalid
   1, // dd 34 nn      inc	(ix+nn)
   1, // dd 35 nn      dec	(ix+nn)
   2, // dd 36 nn xx   ld	(ix+nn), 	xx
  -1, // dd 37         invalid
  -1, // dd 38         invalid
   0, // dd 39         add	ix, sp
  -1, // dd 3a         invalid
  -1, // dd 3b         invalid
  -1, // dd 3c         invalid
  -1, // dd 3d         invalid
  -1, // dd 3e         invalid
  -1, // dd 3f         invalid
  -1, // dd 40         invalid
  -1, // dd 41         invalid
  -1, // dd 42         invalid
  -1, // dd 43         invalid
   0, // dd 44         ld	b, ixh
   0, // dd 45         ld	b, ixl
   1, // dd 46 nn      ld	b, (ix+nn)
  -1, // dd 47         invalid
  -1, // dd 48         invalid
  -1, // dd 49         invalid
  -1, // dd 4a         invalid
  -1, // dd 4b         invalid
   0, // dd 4c         ld	c, ixh
   0, // dd 4d         ld	c, ixl
   1, // dd 4e nn      ld	c, (ix+nn)
  -1, // dd 4f         invalid
  -1, // dd 50         invalid
  -1, // dd 51         invalid
  -1, // dd 52         invalid
  -1, // dd 53         invalid
   0, // dd 54         ld	d, ixh
   0, // dd 55         ld	d, ixl
   1, // dd 56 nn      ld	d, (ix+nn)
  -1, // dd 57         invalid
  -1, // dd 58         invalid
  -1, // dd 59         invalid
  -1, // dd 5a         invalid
  -1, // dd 5b         invalid
   0, // dd 5c         ld	e, ixh
   0, // dd 5d         ld	e, ixl
   1, // dd 5e nn      ld	e, (ix+nn)
  -1, // dd 5f         invalid
   0, // dd 60         ld	ixh, b
   0, // dd 61         ld	ixh, c
   0, // dd 62         ld	ixh, d
   0, // dd 63         ld	ixh, e
   0, // dd 64         ld	ixh, ixh
   0, // dd 65         ld	ixh, ixl
   1, // dd 66 nn      ld	h, (ix+nn)
   0, // dd 67         ld	ixh, a
   0, // dd 68         ld	ixl, b
   0, // dd 69         ld	ixl, c
   0, // dd 6a         ld	ixl, d
   0, // dd 6b         ld	ixl, e
   0, // dd 6c         ld	ixl, ixh
   0, // dd 6d         ld	ixl, ixl
   1, // dd 6e nn      ld	l, (ix+nn)
   0, // dd 6f         ld	ixl, a
   1, // dd 70 nn      ld	(ix+nn), b
   1, // dd 71 nn      ld	(ix+nn), c
   1, // dd 72 nn      ld	(ix+nn), d
   1, // dd 73 nn      ld	(ix+nn), e
   1, // dd 74 nn      ld	(ix+nn), h
   1, // dd 75 nn      ld	(ix+nn), l
  -1, // dd 76         invalid
   1, // dd 77 nn      ld	(ix+nn), a
  -1, // dd 78         invalid
  -1, // dd 79         invalid
  -1, // dd 7a         invalid
  -1, // dd 7b         invalid
   0, // dd 7c         ld	a, ixh
   0, // dd 7d         ld	a, ixl
   1, // dd 7e nn      ld	a, (ix+nn)
  -1, // dd 7f         invalid
  -1, // dd 80         invalid
  -1, // dd 81         invalid
  -1, // dd 82         invalid
  -1, // dd 83         invalid
   0, // dd 84         add	a, ixh
   0, // dd 85         add	a, ixl
   1, // dd 86 nn      add	a, (ix+nn)
  -1, // dd 87         invalid
  -1, // dd 88         invalid
  -1, // dd 89         invalid
  -1, // dd 8a         invalid
  -1, // dd 8b         invalid
   0, // dd 8c         adc	a, ixh
   0, // dd 8d         adc	a, ixl
   1, // dd 8e nn      adc	a, (ix+nn)
  -1, // dd 8f         invalid
  -1, // dd 90         invalid
  -1, // dd 91         invalid
  -1, // dd 92         invalid
  -1, // dd 93         invalid
   0, // dd 94         sub	a, ixh
   0, // dd 95         sub	a, ixl
   1, // dd 96 nn      sub	a, (ix+nn)
  -1, // dd 97         invalid
  -1, // dd 98         invalid
  -1, // dd 99         invalid
  -1, // dd 9a         invalid
  -1, // dd 9b         invalid
   0, // dd 9c         sbc	a, ixh
   0, // dd 9d         sbc	a, ixl
   1, // dd 9e nn      sbc	a, (ix+nn)
  -1, // dd 9f         invalid
  -1, // dd a0         invalid
  -1, // dd a1         invalid
  -1, // dd a2         invalid
  -1, // dd a3         invalid
   0, // dd a4         and	ixh
   0, // dd a5         and	ixl
   1, // dd a6 nn      and	(ix+nn)
  -1, // dd a7         invalid
  -1, // dd a8         invalid
  -1, // dd a9         invalid
  -1, // dd aa         invalid
  -1, // dd ab         invalid
   0, // dd ac         xor	ixh
   0, // dd ad         xor	ixl
   1, // dd ae nn      xor	(ix+nn)
  -1, // dd af         invalid
  -1, // dd b0         invalid
  -1, // dd b1         invalid
  -1, // dd b2         invalid
  -1, // dd b3         invalid
   0, // dd b4         or	ixh
   0, // dd b5         or	ixl
   1, // dd b6 nn      or	(ix+nn)
  -1, // dd b7         invalid
  -1, // dd b8         invalid
  -1, // dd b9         invalid
  -1, // dd ba         invalid
  -1, // dd bb         invalid
   0, // dd bc         cp	ixh
   0, // dd bd         cp	ixl
   1, // dd be nn      cp	(ix+nn)
  -1, // dd bf         invalid
  -1, // dd c0         invalid
  -1, // dd c1         invalid
  -1, // dd c2         invalid
  -1, // dd c3         invalid
  -1, // dd c4         invalid
  -1, // dd c5         invalid
  -1, // dd c6         invalid
  -1, // dd c7         invalid
  -1, // dd c8         invalid
  -1, // dd c9         invalid
  -1, // dd ca         invalid
   2, // dd cb nn xx   zzz	(ix+nn)	bit_operations
  -1, // dd cc         invalid
  -1, // dd cd         invalid
  -1, // dd ce         invalid
  -1, // dd cf         invalid
  -1, // dd d0         invalid
  -1, // dd d1         invalid
  -1, // dd d2         invalid
  -1, // dd d3         invalid
  -1, // dd d4         invalid
  -1, // dd d5         invalid
  -1, // dd d6         invalid
  -1, // dd d7         invalid
  -1, // dd d8         invalid
  -1, // dd d9         invalid
  -1, // dd da         invalid
  -1, // dd db         invalid
  -1, // dd dc         invalid
  -1, // dd dd         invalid
  -1, // dd de         invalid
  -1, // dd df         invalid
  -1, // dd e0         invalid
   0, // dd e1         pop	ix
  -1, // dd e2         invalid
   0, // dd e3         ex	(sp), ix
  -1, // dd e4         invalid
   0, // dd e5         push	ix
  -1, // dd e6         invalid
  -1, // dd e7         invalid
  -1, // dd e8         invalid
   0, // dd e9         jp	(ix)
  -1, // dd ea         invalid
  -1, // dd eb         invalid
  -1, // dd ec         invalid
  -1, // dd ed         invalid
  -1, // dd ee         invalid
  -1, // dd ef         invalid
  -1, // dd f0         invalid
  -1, // dd f1         invalid
  -1, // dd f2         invalid
  -1, // dd f3         invalid
  -1, // dd f4         invalid
  -1, // dd f5         invalid
  -1, // dd f6         invalid
  -1, // dd f7         invalid
  -1, // dd f8         invalid
  -1, // dd f9         invalid
  -1, // dd fa         invalid
  -1, // dd fb         invalid
  -1, // dd fc         invalid
  -1, // dd fd         invalid
  -1, // dd fe         invalid
  -1, // dd ff         invalid
};

int8_t z80_oparg_size_ed[256] = {
  -1, // ed 00         invalid
  -1, // ed 01         invalid
  -1, // ed 02         invalid
  -1, // ed 03         invalid
  -1, // ed 04         invalid
  -1, // ed 05         invalid
  -1, // ed 06         invalid
  -1, // ed 07         invalid
  -1, // ed 08         invalid
  -1, // ed 09         invalid
  -1, // ed 0a         invalid
  -1, // ed 0b         invalid
  -1, // ed 0c         invalid
  -1, // ed 0d         invalid
  -1, // ed 0e         invalid
  -1, // ed 0f         invalid
  -1, // ed 10         invalid
  -1, // ed 11         invalid
  -1, // ed 12         invalid
  -1, // ed 13         invalid
  -1, // ed 14         invalid
  -1, // ed 15         invalid
  -1, // ed 16         invalid
  -1, // ed 17         invalid
  -1, // ed 18         invalid
  -1, // ed 19         invalid
  -1, // ed 1a         invalid
  -1, // ed 1b         invalid
  -1, // ed 1c         invalid
  -1, // ed 1d         invalid
  -1, // ed 1e         invalid
  -1, // ed 1f         invalid
  -1, // ed 20         invalid
  -1, // ed 21         invalid
  -1, // ed 22         invalid
  -1, // ed 23         invalid
  -1, // ed 24         invalid
  -1, // ed 25         invalid
  -1, // ed 26         invalid
  -1, // ed 27         invalid
  -1, // ed 28         invalid
  -1, // ed 29         invalid
  -1, // ed 2a         invalid
  -1, // ed 2b         invalid
  -1, // ed 2c         invalid
  -1, // ed 2d         invalid
  -1, // ed 2e         invalid
  -1, // ed 2f         invalid
  -1, // ed 30         invalid
  -1, // ed 31         invalid
  -1, // ed 32         invalid
  -1, // ed 33         invalid
  -1, // ed 34         invalid
  -1, // ed 35         invalid
  -1, // ed 36         invalid
  -1, // ed 37         invalid
  -1, // ed 38         invalid
  -1, // ed 39         invalid
  -1, // ed 3a         invalid
  -1, // ed 3b         invalid
  -1, // ed 3c         invalid
  -1, // ed 3d         invalid
  -1, // ed 3e         invalid
  -1, // ed 3f         invalid
   0, // ed 40         in	b, (c)
   0, // ed 41         out	(c), b
   0, // ed 42         sbc	hl, bc
   2, // ed 43 ll hh   ld	(hhll), bc
   0, // ed 44         neg
   0, // ed 45         retn
   0, // ed 46         im	0
   0, // ed 47         ld	i, a
   0, // ed 48         in	c, (c)
   0, // ed 49         out	(c), c
   0, // ed 4a         adc	hl, bc
   2, // ed 4b ll hh   ld	bc, (hhll)
  -1, // ed 4c         invalid
   0, // ed 4d         reti
  -1, // ed 4e         invalid
   0, // ed 4f         ld	r, a
   0, // ed 50         in	d, (c)
   0, // ed 51         out	(c), d
   0, // ed 52         sbc	hl, de
   2, // ed 53 ll hh   ld	(hhll), de
  -1, // ed 54         invalid
  -1, // ed 55         invalid
   0, // ed 56         im	1
   0, // ed 57         ld	a, i
   0, // ed 58         in	e, (c)
   0, // ed 59         out	(c), e
   0, // ed 5a         adc	hl, de
   2, // ed 5b ll hh   ld	de, (hhll)
  -1, // ed 5c         invalid
  -1, // ed 5d         invalid
   0, // ed 5e         im	2
   0, // ed 5f         ld	a, r
   0, // ed 60         in	h, (c)
   0, // ed 61         out	(c), h
   0, // ed 62         sbc	hl, hl
   2, // ed 63 ll hh   ld	(hhll), hl
  -1, // ed 64         invalid
  -1, // ed 65         invalid
  -1, // ed 66         invalid
   0, // ed 67         rrd
   0, // ed 68         in	l, (c)
   0, // ed 69         out	(c), l
   0, // ed 6a         adc	hl, hl
   2, // ed 6b ll hh   ld	hl, (hhll)
  -1, // ed 6c         invalid
  -1, // ed 6d         invalid
  -1, // ed 6e         invalid
   0, // ed 6f         rld
   0, // ed 70         in	f, (c)
   0, // ed 71         out	(c), f
   0, // ed 72         sbc	hl, sp
   2, // ed 73 ll hh   ld	(hhll), sp
  -1, // ed 74         invalid
  -1, // ed 75         invalid
  -1, // ed 76         invalid
  -1, // ed 77         invalid
   0, // ed 78         in	a, (c)
   0, // ed 79         out	(c), a
   0, // ed 7a         adc	hl, sp
   2, // ed 7b ll hh   ld	sp, (hhll)
  -1, // ed 7c         invalid
  -1, // ed 7d         invalid
  -1, // ed 7e         invalid
  -1, // ed 7f         invalid
  -1, // ed 80         invalid
  -1, // ed 81         invalid
  -1, // ed 82         invalid
  -1, // ed 83         invalid
  -1, // ed 84         invalid
  -1, // ed 85         invalid
  -1, // ed 86         invalid
  -1, // ed 87         invalid
  -1, // ed 88         invalid
  -1, // ed 89         invalid
  -1, // ed 8a         invalid
  -1, // ed 8b         invalid
  -1, // ed 8c         invalid
  -1, // ed 8d         invalid
  -1, // ed 8e         invalid
  -1, // ed 8f         invalid
  -1, // ed 90         invalid
  -1, // ed 91         invalid
  -1, // ed 92         invalid
  -1, // ed 93         invalid
  -1, // ed 94         invalid
  -1, // ed 95         invalid
  -1, // ed 96         invalid
  -1, // ed 97         invalid
  -1, // ed 98         invalid
  -1, // ed 99         invalid
  -1, // ed 9a         invalid
  -1, // ed 9b         invalid
  -1, // ed 9c         invalid
  -1, // ed 9d         invalid
  -1, // ed 9e         invalid
  -1, // ed 9f         invalid
   0, // ed a0         ldi
   0, // ed a1         cpi
   0, // ed a2         ini
   0, // ed a3         oti
  -1, // ed a4         invalid
  -1, // ed a5         invalid
  -1, // ed a6         invalid
  -1, // ed a7         invalid
   0, // ed a8         ldd
   0, // ed a9         cpd
   0, // ed aa         ind
   0, // ed ab         otd
  -1, // ed ac         invalid
  -1, // ed ad         invalid
  -1, // ed ae         invalid
  -1, // ed af         invalid
   0, // ed b0         ldir
   0, // ed b1         cpir
   0, // ed b2         inir
   0, // ed b3         otir
  -1, // ed b4         invalid
  -1, // ed b5         invalid
  -1, // ed b6         invalid
  -1, // ed b7         invalid
   0, // ed b8         lddr
   0, // ed b9         cpdr
   0, // ed ba         indr
   0, // ed bb         otdr
  -1, // ed bc         invalid
  -1, // ed bd         invalid
  -1, // ed be         invalid
  -1, // ed bf         invalid
  -1, // ed c0         invalid
  -1, // ed c1         invalid
  -1, // ed c2         invalid
  -1, // ed c3         invalid
  -1, // ed c4         invalid
  -1, // ed c5         invalid
  -1, // ed c6         invalid
  -1, // ed c7         invalid
  -1, // ed c8         invalid
  -1, // ed c9         invalid
  -1, // ed ca         invalid
  -1, // ed cb         invalid
  -1, // ed cc         invalid
  -1, // ed cd         invalid
  -1, // ed ce         invalid
  -1, // ed cf         invalid
  -1, // ed d0         invalid
  -1, // ed d1         invalid
  -1, // ed d2         invalid
  -1, // ed d3         invalid
  -1, // ed d4         invalid
  -1, // ed d5         invalid
  -1, // ed d6         invalid
  -1, // ed d7         invalid
  -1, // ed d8         invalid
  -1, // ed d9         invalid
  -1, // ed da         invalid
  -1, // ed db         invalid
  -1, // ed dc         invalid
  -1, // ed dd         invalid
  -1, // ed de         invalid
  -1, // ed df         invalid
  -1, // ed e0         invalid
  -1, // ed e1         invalid
  -1, // ed e2         invalid
  -1, // ed e3         invalid
  -1, // ed e4         invalid
  -1, // ed e5         invalid
  -1, // ed e6         invalid
  -1, // ed e7         invalid
  -1, // ed e8         invalid
  -1, // ed e9         invalid
  -1, // ed ea         invalid
  -1, // ed eb         invalid
  -1, // ed ec         invalid
  -1, // ed ed         invalid
  -1, // ed ee         invalid
  -1, // ed ef         invalid
  -1, // ed f0         invalid
  -1, // ed f1         invalid
  -1, // ed f2         invalid
  -1, // ed f3         invalid
  -1, // ed f4         invalid
  -1, // ed f5         invalid
  -1, // ed f6         invalid
  -1, // ed f7         invalid
  -1, // ed f8         invalid
  -1, // ed f9         invalid
  -1, // ed fa         invalid
  -1, // ed fb         invalid
  -1, // ed fc         invalid
  -1, // ed fd         invalid
  -1, // ed fe         invalid
  -1, // ed ff         invalid
};

int8_t z80_oparg_size_fd[256] = {
  -1, // fd 00         invalid
  -1, // fd 01         invalid
  -1, // fd 02         invalid
  -1, // fd 03         invalid
  -1, // fd 04         invalid
  -1, // fd 05         invalid
  -1, // fd 06         invalid
  -1, // fd 07         invalid
  -1, // fd 08         invalid
   0, // fd 09         add	iy, bc
  -1, // fd 0a         invalid
  -1, // fd 0b         invalid
  -1, // fd 0c         invalid
  -1, // fd 0d         invalid
  -1, // fd 0e         invalid
  -1, // fd 0f         invalid
  -1, // fd 10         invalid
  -1, // fd 11         invalid
  -1, // fd 12         invalid
  -1, // fd 13         invalid
  -1, // fd 14         invalid
  -1, // fd 15         invalid
  -1, // fd 16         invalid
  -1, // fd 17         invalid
  -1, // fd 18         invalid
   0, // fd 19         add	iy, de
  -1, // fd 1a         invalid
  -1, // fd 1b         invalid
  -1, // fd 1c         invalid
  -1, // fd 1d         invalid
  -1, // fd 1e         invalid
  -1, // fd 1f         invalid
  -1, // fd 20         invalid
   2, // fd 21 ll hh   ld	iy, hhll
   2, // fd 22 ll hh   ld	(hhll), iy
   0, // fd 23         inc	iy
   0, // fd 24         inc	iyh
   0, // fd 25         dec	iyh
   1, // fd 26 nn      ld	iyh, nn
  -1, // fd 27         invalid
  -1, // fd 28         invalid
   0, // fd 29         add	iy, iy
   2, // fd 2a ll hh   ld	iy, (hhll)
   0, // fd 2b         dec	iy
   0, // fd 2c         inc	iyl
   0, // fd 2d         dec	iyl
   1, // fd 2e nn      ld	iyl, nn
  -1, // fd 2f         invalid
  -1, // fd 30         invalid
  -1, // fd 31         invalid
  -1, // fd 32         invalid
  -1, // fd 33         invalid
   1, // fd 34 nn      inc	(iy+nn)
   1, // fd 35 nn      dec	(iy+nn)
   2, // fd 36 nn xx   ld	(iy+nn), 	xx
  -1, // fd 37         invalid
  -1, // fd 38         invalid
   0, // fd 39         add	iy, sp
  -1, // fd 3a         invalid
  -1, // fd 3b         invalid
  -1, // fd 3c         invalid
  -1, // fd 3d         invalid
  -1, // fd 3e         invalid
  -1, // fd 3f         invalid
  -1, // fd 40         invalid
  -1, // fd 41         invalid
  -1, // fd 42         invalid
  -1, // fd 43         invalid
   0, // fd 44         ld	b, iyh
   0, // fd 45         ld	b, iyl
   1, // fd 46 nn      ld	b, (iy+nn)
  -1, // fd 47         invalid
  -1, // fd 48         invalid
  -1, // fd 49         invalid
  -1, // fd 4a         invalid
  -1, // fd 4b         invalid
   0, // fd 4c         ld	c, iyh
   0, // fd 4d         ld	c, iyl
   1, // fd 4e nn      ld	c, (iy+nn)
  -1, // fd 4f         invalid
  -1, // fd 50         invalid
  -1, // fd 51         invalid
  -1, // fd 52         invalid
  -1, // fd 53         invalid
   0, // fd 54         ld	d, iyh
   0, // fd 55         ld	d, iyl
   1, // fd 56 nn      ld	d, (iy+nn)
  -1, // fd 57         invalid
  -1, // fd 58         invalid
  -1, // fd 59         invalid
  -1, // fd 5a         invalid
  -1, // fd 5b         invalid
   0, // fd 5c         ld	e, iyh
   0, // fd 5d         ld	e, iyl
   1, // fd 5e nn      ld	e, (iy+nn)
  -1, // fd 5f         invalid
   0, // fd 60         ld	iyh, b
   0, // fd 61         ld	iyh, c
   0, // fd 62         ld	iyh, d
   0, // fd 63         ld	iyh, e
   0, // fd 64         ld	iyh, iyh
   0, // fd 65         ld	iyh, iyl
   1, // fd 66 nn      ld	h, (iy+nn)
   0, // fd 67         ld	iyh, a
   0, // fd 68         ld	iyl, b
   0, // fd 69         ld	iyl, c
   0, // fd 6a         ld	iyl, d
   0, // fd 6b         ld	iyl, e
   0, // fd 6c         ld	iyl, iyh
   0, // fd 6d         ld	iyl, iyl
   1, // fd 6e nn      ld	l, (iy+nn)
   0, // fd 6f         ld	iyl, a
   1, // fd 70 nn      ld	(iy+nn), b
   1, // fd 71 nn      ld	(iy+nn), c
   1, // fd 72 nn      ld	(iy+nn), d
   1, // fd 73 nn      ld	(iy+nn), e
   1, // fd 74 nn      ld	(iy+nn), h
   1, // fd 75 nn      ld	(iy+nn), l
  -1, // fd 76         invalid
   1, // fd 77 nn      ld	(iy+nn), a
  -1, // fd 78         invalid
  -1, // fd 79         invalid
  -1, // fd 7a         invalid
  -1, // fd 7b         invalid
   0, // fd 7c         ld	a, iyh
   0, // fd 7d         ld	a, iyl
   1, // fd 7e nn      ld	a, (iy+nn)
  -1, // fd 7f         invalid
  -1, // fd 80         invalid
  -1, // fd 81         invalid
  -1, // fd 82         invalid
  -1, // fd 83         invalid
   0, // fd 84         add	a, iyh
   0, // fd 85         add	a, iyl
   1, // fd 86 nn      add	a, (iy+nn)
  -1, // fd 87         invalid
  -1, // fd 88         invalid
  -1, // fd 89         invalid
  -1, // fd 8a         invalid
  -1, // fd 8b         invalid
   0, // fd 8c         adc	a, iyh
   0, // fd 8d         adc	a, iyl
   1, // fd 8e nn      adc	a, (iy+nn)
  -1, // fd 8f         invalid
  -1, // fd 90         invalid
  -1, // fd 91         invalid
  -1, // fd 92         invalid
  -1, // fd 93         invalid
   0, // fd 94         sub	a, iyh
   0, // fd 95         sub	a, iyl
   1, // fd 96 nn      sub	a, (iy+nn)
  -1, // fd 97         invalid
  -1, // fd 98         invalid
  -1, // fd 99         invalid
  -1, // fd 9a         invalid
  -1, // fd 9b         invalid
   0, // fd 9c         sbc	a, iyh
   0, // fd 9d         sbc	a, iyl
   1, // fd 9e nn      sbc	a, (iy+nn)
  -1, // fd 9f         invalid
  -1, // fd a0         invalid
  -1, // fd a1         invalid
  -1, // fd a2         invalid
  -1, // fd a3         invalid
   0, // fd a4         and	iyh
   0, // fd a5         and	iyl
   1, // fd a6 nn      and	(iy+nn)
  -1, // fd a7         invalid
  -1, // fd a8         invalid
  -1, // fd a9         invalid
  -1, // fd aa         invalid
  -1, // fd ab         invalid
   0, // fd ac         xor	iyh
   0, // fd ad         xor	iyl
   1, // fd ae nn      xor	(iy+nn)
  -1, // fd af         invalid
  -1, // fd b0         invalid
  -1, // fd b1         invalid
  -1, // fd b2         invalid
  -1, // fd b3         invalid
   0, // fd b4         or	iyh
   0, // fd b5         or	iyl
   1, // fd b6 nn      or	(iy+nn)
  -1, // fd b7         invalid
  -1, // fd b8         invalid
  -1, // fd b9         invalid
  -1, // fd ba         invalid
  -1, // fd bb         invalid
   0, // fd bc         cp	iyh
   0, // fd bd         cp	iyl
   1, // fd be nn      cp	(iy+nn)
  -1, // fd bf         invalid
  -1, // fd c0         invalid
  -1, // fd c1         invalid
  -1, // fd c2         invalid
  -1, // fd c3         invalid
  -1, // fd c4         invalid
  -1, // fd c5         invalid
  -1, // fd c6         invalid
  -1, // fd c7         invalid
  -1, // fd c8         invalid
  -1, // fd c9         invalid
  -1, // fd ca         invalid
   2, // fd cb nn xx   zzz	(iy+nn)	bit_operations
  -1, // fd cc         invalid
  -1, // fd cd         invalid
  -1, // fd ce         invalid
  -1, // fd cf         invalid
  -1, // fd d0         invalid
  -1, // fd d1         invalid
  -1, // fd d2         invalid
  -1, // fd d3         invalid
  -1, // fd d4         invalid
  -1, // fd d5         invalid
  -1, // fd d6         invalid
  -1, // fd d7         invalid
  -1, // fd d8         invalid
  -1, // fd d9         invalid
  -1, // fd da         invalid
  -1, // fd db         invalid
  -1, // fd dc         invalid
  -1, // fd dd         invalid
  -1, // fd de         invalid
  -1, // fd df         invalid
  -1, // fd e0         invalid
   0, // fd e1         pop	iy
  -1, // fd e2         invalid
   0, // fd e3         ex	(sp), iy
  -1, // fd e4         invalid
   0, // fd e5         push	iy
  -1, // fd e6         invalid
  -1, // fd e7         invalid
  -1, // fd e8         invalid
   0, // fd e9         jp	(iy)
  -1, // fd ea         invalid
  -1, // fd eb         invalid
  -1, // fd ec         invalid
  -1, // fd ed         invalid
  -1, // fd ee         invalid
  -1, // fd ef         invalid
  -1, // fd f0         invalid
  -1, // fd f1         invalid
  -1, // fd f2         invalid
  -1, // fd f3         invalid
  -1, // fd f4         invalid
  -1, // fd f5         invalid
  -1, // fd f6         invalid
  -1, // fd f7         invalid
  -1, // fd f8         invalid
  -1, // fd f9         invalid
  -1, // fd fa         invalid
  -1, // fd fb         invalid
  -1, // fd fc         invalid
  -1, // fd fd         invalid
  -1, // fd fe         invalid
  -1, // fd ff         invalid
};

