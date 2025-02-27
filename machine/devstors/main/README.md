# devstors
## NOTES (need to verify, readme stolen from mainevt)

### watchdog
Address $1f8c must be written to periodically or the board will reset itself.
However if its written to to fast the watchdog won't register the ping and the
board will reset.  ie just adding a watchdog write in the normal STALL macro
doesn't work

### MAD eproms
27c512 @ K11

### Palette RAM
Palette ram C11 (even addresses) and C14 (odd addresses)

Note: the schematics says the even address ship is C12, but silk screen says
C11.

### Tile1 RAM
Tile1 ram is I17

### Tile2 RAM
Tile2 ram is H17

### Sprite RAM
Sprite ram is I5

### Work RAM
Work ram is J9

### Error Addresses
6309 CPU @ K13.  Address lines that are 95% high are 1, 50/50 pulsing are 0.
