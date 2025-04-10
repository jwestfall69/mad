## Part Numbers
The part number printed on the CPU for the given game.  Maybe this will git some
insight into the different CPU revisions and what extra opcodes they support.

| Game | CPU Part # | CPU Package | CPU Manufacture Date |
|:-----|:-----------|:------------|:---------------------|
| ajax | 052001 | PGA | 42nd week of 1987 |
| crimfght | 052001 | PGA |6th week of 1988 |
| rollerg | 053248 | QFP | 19th week of 1990 |
| vendetta | 053248 | QFP | 21st week of 1991 |

## Extra Instructions over 6809 CPU

#imm = direct value<br>
$mem = a memory address via either direct page, indexed or extended<br>
*label* = jump point

| Instruction | Opcode | Description | Notes |
|:------------|:------:|:------------|:------|
| absa | 0xCC | abs(a) | crimfght = Works<br>rollerg = Works<br>vendetta = Works |
| absb | 0xCD | abs(b) | crimfght = Works<br>rollerg = Works<br>vendetta = Works |
| absd | 0xCE | abs(d) | crimfght = Works<br>rollerg = Works<br>vendetta = Works |
| asldi #imm | 0xBE | asl D register, (#imm & 0xF) times | crimfght = CPU Crash<br>rollerg = Works<br>vendetta = Works |
| aslw $mem | 0xA6 | asl word stored at $mem one time | crimfght = Works<br>vendetta = Works |
| aslwa $mem | 0xBF | asl word stored at $mem, (A register & 0xF) times | crimfght = CPU Crash<br>rollerg = Works<br>vendetta = Works |
| asrdi #imm | 0xBC | asr D register, (#imm & 0xF) times | crimfght = CPU Crash<br>rollerg = Works<br>vendetta = Works |
| asrw $mem | 0xA5 | asr word stored at $mem one time | crimfght = Works<br>rollerg = Works<br>vendetta = Works |
| asrwa $mem | 0xBD | asr word stored at $mem, (A register & 0xF) times | crimfght = CPU Crash<br>rollerg = Works<br>vendetta = Works |
| bmove | 0xB6 | `while(u != 0) { , x = , y; x += 1; y +=1 ;u -=1; }` | crimfght = Works<br>rollerg = Works<br>vendetta = Works |
| bset | 0xCF | `while(u != 0) { sta , x; x += 1; u -= 1 }` | crimfght = CPU Crash<br>rollerg = Works<br>vendetta = Works |
| bsetw | 0xD0 |`while(u != 0) { std , x; x += 2; u -= 1 }` | crimfght = CPU Crash<br>rollerg = Works<br>vendetta = Works |
| clrd | 0xC2 | Sets D register to 0x0000 | crimfght = CPU Crash<br>rollerg = Works<br>vendetta = Works |
| clrw $mem | 0xC3 | Set the word stored at $mem to 0x0000 | crimfght = CPU Crash<br>rollerg = Works<br>vendetta = Works |
| dbjnz *label* | 0xAD | decb, if non-zero jump to *label* | crimfght = Works<br>rollerg = Works<br>vendetta = Works |
| decd | 0xC8 | Reduce the D register by 1 | crimfght = CPU Crash<br>rollerg = Works<br>vendetta = Works |
| decw $mem | 0xC9 | Reduce the word stored at $mem by one | crimfght = CPU Crash<br>rollerg = Works<br>vendetta = Works |
| divxb | 0xB5 | X = X / B; B = remainder | crimfght = Works<br>rollerg = Works<br>vendetta = Works |
| dxjnz *label* | 0xAD | decx, if non-zero jump to *label* | crimfght = Works<br>rollerg = Works<br>vendetta = Works |
| incd | 0xC6 | Increase D register by 1 | crimfght = Bad result (`s` goes up by one)<br>rollerg = Works<br>vendetta = Works |
| incw $mem | 0xC7 | Increase the word value stored at $mem by one | crimfght = CPU Crash<br>rollerg = Works<br>vendetta = Works |
| lsldi #imm | 0xBE | lsl D register, (#imm & 0xF) times | crimfght = Bad result (random junk in registers)<br>rollerg = Works<br>vendetta = Works |
| lslw $mem | 0xA6 | lsl word stored at $mem one time| crimfght = Works<br>rollerg = Works<br>vendetta = Works |
| lslwa $mem | 0xBF | lsl word stored at $mem, (A register & 0xF) times | crimfght = CPU Crash<br>rollerg = Works<br>vendetta = Works |
| lsrdi #imm | 0xB8 | lsr D register, (#imm & 0xF) times | crimfght = CPU Crash<br>rollerg = Works<br>vendetta = Works |
| lsrw $mem | 0xA3 | lsr word stored at $mem one time | crimfght = Works<br>rollerg = Works<br>vendetta = Works |
| lsrwa $mem | 0xB9 | lsr word stored at $mem, (A register & 0xF) times | crimfght = CPU Crash<br>rollerg = Works<br>vendetta = Works |
| move | 0xB7 | `, x = , y; x += 1; y +=1 ;u -=1;` | crimfght = Works<br>rollerg = Works<br>vendetta = Works |
| mulxy | 0xB4 | X = high byte of X * Y; Y = low byte of X * Y | crimfght = Works<br>rollerg = Works<br>vendetta = Works |
| negd | 0xC4 | `D = 0 - D` | crimfght = Bad result (`s` goes down by 2)<br>rollerg = Works<br>vendetta = Works |
| negw $mem | 0xC5 | `value stored at $mem = 0 - value stored at $mem` | crimfght = Bad result (no registers change) <br>rollerg = Works<br>vendetta = Works |
| roldi #imm | 0xC0 | rol D register, (#imm & 0xF) times | crimfght = CPU Crash<br>rollerg = Works<br>vendetta = Works |
| rolw $mem | 0xA7 | rol word stored at $mem one time | crimfght = Works<br>rollerg = Works<br>vendetta = Works |
| rolwa $mem | 0xC1 | rol word stored at $mem, (A register & 0xF) times | crimfght = CPU Crash<br>rollerg = Works<br>vendetta = Works |
| rordi #imm | 0xBA | ror D register, (#imm & 0xF) times | crimfght = CPU Crash<br>rollerg = Works<br>vendetta = Works |
| rorw $mem | 0xA4 | ror word stored at $mem one time | crimfght = Works<br>rollerg = Works<br>vendetta = Works |
| rorwa $mem | 0xBB | ror word stored at $mem, (A register & 0xF) times | crimfght = CPU Crash<br>rollerg = Works<br>vendetta = Works |
| setln #imm | 0x38 | Sets some banking related values in the CPU | crimfght = Works<br>rollerg = Works<br>vendetta = Works |
| setln $mem | 0x39 | Sets some banking related values in the CPU | crimfght = Works<br>rollerg = Works<br>vendetta = Works |
| tstd | 0xCA | set CPU flags based on contents of D register | crimfght = Bad result (`u` goes down by 6)<br>rollerg = Works<br>vendetta = Works |
| tstw $mem | 0xCB | set CPU flags based on the contents of the word stored at $mem | crimfght = CPU Crash<br>rollerg = Works<br>vendetta = Works |

## Missing Instructions from 6809
| Instruction | Description |
|:------------|:------------|
| cwai #imm | clear condition code bits and wait for interrupt |
| swi | software interrupt |
| swi2 | software interrupt |
| swi3 | software interrupt |
| sync | halt execution and wait for interrupt |
