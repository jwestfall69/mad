## Extra Instructions over 6809 CPU

#imm = direct value<br>
$mem = a memory address via either direct page, indexed or extended<br>
*label* = jump point

| Instruction | Opcode | Description | Notes |
|:------------|:------:|:------------|:------|
| absa | 0xCC | abs(a) | Untested |
| absb | 0xCD | abs(b) | Untested |
| absd | 0xCE | abs(d) | Untested |
| asld #imm | 0xBE | asl D register, (#imm & 0xF) times | crimfght = CPU Crash<br>vendetta = Works |
| asld $mem | 0xBF | asl word stored at $mem, (A register & 0xF) times | crimfght = CPU Crash<br>vendetta = Works |
| aslw $mem | 0xA6 | asl word stored at $mem one time | Untested |
| asrd #imm | 0xBC | asr D register, (#imm & 0xF) times | crimfght = CPU Crash<br>vendetta = Works |
| asrd $mem | 0xBD | asr word stored at $mem, (A register & 0xF) times | crimfght = CPU Crash<br>vendetta = Works |
| asrw $mem | 0xA5 | asr word stored at $mem one time | Untested |
| bmove | 0xB6 | `while(u != 0) { [, x] = [, y]; x += 1; y +=1 ;u -=1; }` | Untested |
| bset | 0xCF | `while(u != 0) { sta [, x]; x += 1; u -= 1 }` | Untested |
| bsetw | 0xD0 |`while(u != 0) { std [, x]; x += 2; u -= 1 }` | Untested|
| clrd | 0xC2 | Sets D register to 0x0000 | Untested |
| clrw $mem | 0xC3 | Set the word stored at $mem to 0x0000 | Untested |
| decbjnz *label* | 0xAD | decb, if non-zero jump to *label* | crimfght = Works<br>vendetta = Works |
| decd | 0xC8 | Reduce the D register by 1 | crimfght = CPU Crash<br>vendetta = Works |
| decw $mem | 0xC9 | Reduce the word stored at $mem by one | Untested |
| decxjnz *label* | 0xAD | decx, if non-zero jump to *label* | crimfght = Works<br>vendetta = Works |
| divxb | 0xB5 | X = X / B; B = remainder | Untested |
| incd | 0xC6 | Increase D register by 1 | Untested |
| incw $mem | 0xC7 | Increase the word value stored at $mem by one | Untested |
| lsld #imm | 0xBE | lsl D register, (#imm & 0xF) times | Untested |
| lsld $mem | 0xBF | lsl word stored at $mem, (A register & 0xF) times | Untested |
| lslw $mem | 0xA6 | lsl word stored at $mem one time| Untested |
| lsrd #imm | 0xB8 | lsr D register, (#imm & 0xF) times | Untested |
| lsrd $mem | 0xB9 | lsr word stored at $mem, (A register & 0xF) times | Untested |
| lsrw $mem | 0xA3 | lsr word stored at $mem one time | Untested |
| move | 0xB7 | `[, x] = [, y]; x += 1; y +=1 ;u -=1;` | Untested |
| mulxy | 0xB4 | X = high byte of X * Y; Y = low byte of X * Y | Untested |
| negd | 0xC4 | `D = 0 - D` | Untested |
| negw $mem | 0xC5 | `value stored at $mem = 0 - value stored at $mem` | Untested |
| rold #imm | 0xC0 | rol D register, (#imm & 0xF) times | Untested |
| rold $mem | 0xC1 | rol word stored at $mem, (A register & 0xF) times | Untested |
| rolw $mem | 0xA7 | rol word stored at $mem one time | Untested |
| rord #imm | 0xBA | ror D register, (#imm & 0xF) times | Untested |
| rord $mem | 0xBB | ror word stored at $mem, (A register & 0xF) times | Untested |
| rorw $mem | 0xA4 | ror word stored at $mem one time | Untested |
| setline #imm | 0x38 | Sets some banking related values in the CPU | crimfght = Works<br>vendetta = Works |
| setline $mem | 0x39 | Sets some banking related values in the CPU | Untested |
| tstd | 0xCA | set CPU flags based on contents of D register | Untested |
| tstw $mem | 0xCB | set CPU flags based on the contents of the word stored at $mem | Untested |
