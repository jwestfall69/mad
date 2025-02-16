# tmnt
## NOTES

### watchdog
Address $0a0011 must be written to periodically or the board will reset itself.
However if its written to to fast the watchdog won't register the ping and the
board will reset.  ie just adding a watchdog write in the normal STALL macro
doesn't work

```
	.loop:
		move.b	d0, $a0011
		bra		.loop
```
This will end up causing a watchdog trigger, instead a delay must be added in
the loop.  Unclear how much of a delay is needed, the current value was picked
at random.

```
	.loop:
		move.b	d0, $a0011
		move.l	#$1fff, d0
		DSUB	delay
		bra		.loop
```

### MAD eproms
27c010/27c1001

### Palette RAM
Palette ram is 8 bits only (lower byte).  Its supports word read/write, with the
upper byte being ignored.

Palette ram is 2x ram chips.  F22, and F23.  Memory address are interleaved
between the chips such that

```
$80000 = F22
$80002 = F23
$80004 = F22
$80006 = F23
etc
```

### Sprite RAM
Sprite ram is at G8.  Only correctly works with byte reads/writes.  Attempts to
read/write as a word will cause the upper byte to get read/written to both the
upper and lower bytes.

### Tile RAM
Tile ram is 16 bits, but only correctly works with byte reads/writes.  Attempts
to read/write as a word will cause the upper byte to get read/written to both
the upper and lower bytes.

It also appears that:

```
$100000 is mirrored at $101000
$102000 is mirrored at $103000
$104000 is mirrored at $105000
```

Writing anything from $106800 to 1068ff will cause screen rendering/updating to stop.

Tile ram is 2x ram chips.  G27 is upper, G28 is lower.
