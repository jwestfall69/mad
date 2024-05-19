# tmnt
## NOTES

### watchdog / error addresses
Address $0a0011 must be written to periodically or the board will reset itself. However if its written to to fast the watchdog won't register the ping and the board will reset.  ie just adding a watchdog write in the normal STALL macro doesn't work

```
	.loop:
		move.b	d0, $a0011
		bra		.loop
```
This will end up causing a watchdog trigger, instead a delay must be added in the loop.  Unclear how much of a delay is needed, the current value was picked at random.

```
	.loop:
		move.b	d0, $a0011
		move.l	#$1fff, d0
		DSUB	delay
		bra		.loop
```

While it might have been possible to use error address with the non-delay version, its not going to be viable having to add that delay code in.  Its going to cause the cpu address lines to bounce around to much when we do the stall for error addresses.

### MAD eproms
27c010/27c1001

### Palette RAM
Palette ram is 8 bits only (lower byte).  Its supports word read/write, with the upper byte being ignored.

### Tile RAM
Tile ram is 8 bits only (lower byte).  Its only supports byte read/write from/to it.  Word reads/writes do nothing.
