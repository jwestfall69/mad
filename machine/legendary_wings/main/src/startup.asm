    section code

startup:
        im   1
        jp   $0071
        xor  a
        set  5,a
        ld   ($F80E),a
        ld   a,$FF
        ld   ($F80C),a
        ld   hl,$0069
        ld   de,$F300
        ld   bc,$0004
        ldir
        
        ld   de,$F700
        ld   bc,$0004
        ldir

        ld   c,$00
        ld   b,$10
    .loop3:
        ld   de,$C000
        ld   hl,$3000
    .loop1:
        ld   a,c
        ld   (de),a
        inc  de
        dec  hl
        ld   a,h
        or   l
        jr   nz, .loop1

    ld   de,$C000
        ld   hl,$3000
    .loop2:
        ld   a,(de)
        cp   c
        inc  de
        dec  hl
        ld   a,h
        or   l
        jr   nz, .loop2

        ld   a,c
        add  a,$11
        ld   c,a
        djnz .loop3

        xor  a
        ld   ($F802),a
        ld   ($F800),a
        ld   ($F803),a
        ld   ($F801),a
        ld   ($F804),a
        ld   a,$3F
        ld   ($F805),a
