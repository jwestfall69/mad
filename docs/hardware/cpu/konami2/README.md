# Konami-2 CPU
This CPU was used on a handful of konami arcade boards.  Its based on the 6809
CPU with scrambled opcodes, some extra instructions and a few missing ones.

Information below is based on MAME and from testing on hardware.

# EXG/TFR quirks
There are a couple quirks with the CPU around the EXG/TFR instructions.

#1 There is no way to TFR/EXG a 16bit register to the `D` register.

| Instruction | Result |
|:------------|:-------|
| `EXG D,Y`     | `Y` gets filled with `D`<br>`A` = unchanged<br>`B` = lower byte of `Y` |
| `TFR D,Y`     | `Y` gets filled with `D` |
| `TFR Y,D`     | `A` = unchanged<br>`B` = lower byte of `Y` |

#2 `DP` seems to be part of a 16bit register, where `DP` is the high byte and
the lower byte seems hidden.

If you do a EXG/TFR with `DP` with another 16bit register the CPU does a full 16bit EXG/TFR. 

For example: `EXG DP, X`

`DP` ends up in the high byte of `X` and the hidden byte ends up in the lower
byte of `X`.  Likewise the high byte of the `X` ends up in `DP`, and the low byte of `X` in the hidden byte.

If you do an `EXG A, DP`, `A` will get swapped with the hidden byte of the `DP` register.

However pushing and pulling `DP` on the stack is only 1 byte.

## CPU Revisions / Part Numbers
There are 3 known CPU Revisions / Part Numbers:

| CPU Part # | CPU Package | Games (I own) |
|:-----------|:------------|:------|
| 052001 | PGA | ajax, crimfght |
| 052526 | PGA | blockhl |
| 053248 | QFP | rollerg, vendetta |

## Extra Instructions over 6809 CPU
The below table outlines the extra instructions.  Revision 052001 can't run them
all as noted in the Test Results column of the table.

`#imm` = direct value<br>
`$mem` = a memory address via either direct page, indexed or extended<br>
`label` = jump point

| Instruction | Opcode | Description | Test Results |
|:------------|:------:|:------------|:------|
| `absa` | 0xCC | abs(a) | 052001 = Works<br>052526 = Works<br>053248 = Works |
| `absb` | 0xCD | abs(b) | 052001 = Works<br>052526 = Works<br>053248 = Works |
| `absd` | 0xCE | abs(d) | 052001 = Works<br>052526 = Works<br>053248 = Works |
| `asldi #imm` | 0xBE | asl `D` register, (`#imm & 0xF`) times | 052001 = CPU Crash<br>052526 = Works<br>053248 = Works |
| `aslw $mem` | 0xA6 | asl word stored at `$mem` one time | 052001 = Works<br>052526 = Works<br>053248 = Works |
| `aslwa $mem` | 0xBF | asl word stored at `$mem`, (`A & 0xF`) times | 052001 = CPU Crash<br>052526 = Works<br>053248 = Works |
| `asrdi #imm` | 0xBC | asr `D` register, (`#imm & 0xF`) times | 052001 = CPU Crash<br>052526 = Works<br>053248 = Works |
| `asrw $mem` | 0xA5 | asr word stored at `$mem` one time | 052001 = Works<br>052526 = Works<br>053248 = Works |
| `asrwa $mem` | 0xBD | asr word stored at `$mem`, (`A & 0xF`) times | 052001 = CPU Crash<br>052526 = Works<br>053248 = Works |
| `bmove` | 0xB6 | `while(u != 0) { , x = , y; x += 1; y +=1 ;u -=1; }` | 052001 = Works<br>052526 = Works<br>053248 = Works |
| `bset` | 0xCF | `while(u != 0) { sta , x; x += 1; u -= 1 }` | 052001 = CPU Crash<br>052526 = Works<br>053248 = Works |
| `bsetw` | 0xD0 |`while(u != 0) { std , x; x += 2; u -= 1 }` | 052001 = CPU Crash<br>052526 = Works<br>053248 = Works |
| `clrd` | 0xC2 | Sets `D` register to 0x0000 | 052001 = CPU Crash<br>052526 = Works<br>053248 = Works |
| `clrw $mem` | 0xC3 | Set the word stored at `$mem` to 0x0000 | 052001 = CPU Crash<br>052526 = Works<br>053248 = Works |
| `dbjnz label` | 0xAD | `decb`, if non-zero jump to `label` | 052001 = Works<br>052526 = Works<br>053248 = Works |
| `decd` | 0xC8 | Reduce the `D` register by 1 | 052001 = CPU Crash<br>052526 = Works<br>053248 = Works |
| `decw $mem` | 0xC9 | Reduce the word stored at `$mem` by one | 052001 = CPU Crash<br>052526 = Works<br>053248 = Works |
| `divxb` | 0xB5 | `X = X / B; B = remainder` | 052001 = Works<br>052526 = Works<br>053248 = Works |
| `dxjnz label` | 0xAD | `decx`, if non-zero jump to `label` | 052001 = Works<br>052526 = Works<br>053248 = Works |
| `incd` | 0xC6 | Increase `D` register by 1 | 052001 = Bad result (`s` goes up by one)<br>052526 = Works<br>053248 = Works |
| `incw $mem` | 0xC7 | Increase the word value stored at `$mem` by one | 052001 = CPU Crash<br>052526 = Works<br>053248 = Works |
| `lsldi #imm` | 0xBE | lsl `D` register, (`#imm & 0xF`) times | 052001 = Bad result (random junk in registers)<br>052526 = Works<br>053248 = Works |
| `lslw $mem` | 0xA6 | lsl word stored at `$mem` one time| 052001 = Works<br>052526 = Works<br>053248 = Works |
| `lslwa $mem` | 0xBF | lsl word stored at `$mem`, (`A  & 0xF`) times | 052001 = CPU Crash<br>052526 = Works<br>053248 = Works |
| `lsrdi #imm` | 0xB8 | lsr `D` register, (`#imm & 0xF`) times | 052001 = CPU Crash<br>052526 = Works<br>053248 = Works |
| `lsrw $mem` | 0xA3 | lsr word stored at `$mem` one time | 052001 = Works<br>052526 = Works<br>053248 = Works |
| `lsrwa $mem` | 0xB9 | lsr word stored at `$mem`, (`A & 0xF`) times | 052001 = CPU Crash<br>052526 = Works<br>053248 = Works |
| `move` | 0xB7 | `, X = , Y; X += 1; Y +=1 ;U -=1;` | 052001 = Works<br>052526 = Works<br>053248 = Works |
| `mulxy` | 0xB4 | `X` = high byte of `X * Y`; `Y`= low byte of `X * Y` | 052001 = Works<br>052526 = Works<br>053248 = Works |
| `negd` | 0xC4 | `D = 0 - D` | 052001 = Bad result (`s` goes down by 2)<br>052526 = Works<br>053248 = Works |
| `negw $mem` | 0xC5 | `value stored at $mem = 0 - value stored at $mem` | 052001 = Bad result (no registers change) <br>052526 = Works<br>053248 = Works |
| `roldi #imm` | 0xC0 | rol `D` register, (`#imm & 0xF`) times | 052001 = CPU Crash<br>052526 = Works<br>053248 = Works |
| `rolw $mem` | 0xA7 | rol word stored at `$mem` one time | 052001 = Works<br>052526 = Works<br>053248 = Works |
| `rolwa $mem` | 0xC1 | rol word stored at `$mem`, (`A & 0xF`) times | 052001 = CPU Crash<br>052526 = Works<br>053248 = Works |
| `rordi #imm` | 0xBA | ror `D` register, (`#imm & 0xF`) times | 052001 = CPU Crash<br>052526 = Works<br>053248 = Works |
| `rorw $mem` | 0xA4 | ror word stored at `$mem` one time | 052001 = Works<br>052526 = Works<br>053248 = Works |
| `rorwa $mem` | 0xBB | ror word stored at `$mem`, (`A & 0xF`) times | 052001 = CPU Crash<br>052526 = Works<br>053248 = Works |
| `setln #imm` | 0x38 | Sets some banking related values in the CPU | 052001 = Works<br>052526 = Works<br>053248 = Works |
| `setln $mem` | 0x39 | Sets some banking related values in the CPU | 052001 = Works<br>052526 = Works<br>053248 = Works |
| `tstd` | 0xCA | set CPU flags based on contents of `D` register | 052001 = Bad result (`u` goes down by 6)<br>052526 = Works<br>053248 = Works |
| `tstw $mem` | 0xCB | set CPU flags based on the contents of the word stored at `$mem` | 052001 = CPU Crash<br>052526 = Works<br>053248 = Works |

## Missing Instructions from 6809
| Instruction | Description |
|:------------|:------------|
| `cwai #imm` | clear condition code bits and wait for interrupt |
| `swi` | software interrupt |
| `swi2` | software interrupt |
| `swi3` | software interrupt |
| `sync` | halt execution and wait for interrupt |
