.include "includes.inc"

.segment "CODE0"
.org $008000


	baseinc $008000, $008100


.proc Native_mode_NMI
	JMP [NMIFarPtr]
.endproc

.proc Native_mode_ABORT
	STP
.endproc

.proc EntryPoint
	SEI
	setaxy8
	LDA #0
	STA PPUNMI
	CLC
	XCE
	setxy16
	LDX #StackBottom
	TXS
	setxy8
	LDA #1
	PHA
	PLB
	LDA #0
	PHA
	PHA
	PLD
	JMP PerformInit
.endproc

	RTI

.proc PerformInit
	LDA #FORCEBLANK
	STA PPUBRIGHT
	LDA #0
	STA NMITIMEN
	STZ HDMAEN
	LDA #1
	STA f:ICD2CTL
	LDA GamePalettePresent
	STA byte_7E1712
	setxy16

	LDX #0
:
	STZ z:0, X
	INX
	CPX #$800
	BNE :-
	LDX #$F00
:
	STZ z:0, X
	INX
	CPX #$1700
	BNE :-

	LDX #StackBottom
	TXS
	setxy8
	CLD
	JSR ResetIO
	LDA #<Native_mode_IRQ
	STA NMIFarPtr
	LDA #>Native_mode_IRQ
	STA NMIFarPtr+1

	; TODO
.endproc


ResetIO = $0082B1
	baseinc $008166, $00B50A
	
	
Native_mode_IRQ:
	PHA
	PHX
	PHY
	PHB
	PHP
	setaxy8
	LDA #1
	PHA
	PLB
	LDA #INC_DATAHI
	STA PPUCTRL
	seta16
	LDA #$7000
	STA PPUADDR
	
	; TODO
	
	
	baseinc $00B522, $00FFC0


.segment "HEADER"
	; No extended header here, instead are some jumps
.org $00FFC0

snes_header:
	.byte "Super GAMEBOY        "
	.byte $20   ; LoROM mapping, 200ns access time
	.byte $E3   ; Extra hardware
	.byte 8     ; ROM size
	.byte 0     ; RAM size
	.byte 0     ; Destination code (Japan)
	.byte 1     ; Publisher
	.byte rom_version
	.res 2      ; Checksum complement
	.res 2      ; Checksum
	
	.word $F4F4
	.word $F4F4
	.word $F4F4 ; Native mode COP
	.word $F4F4 ; Native mode BRK
	.addr Native_mode_ABORT
	.addr Native_mode_NMI
	.addr EntryPoint ; Native mode RESET
	.addr Native_mode_IRQ
	
	.word $F4F4
	.word $F4F4
	.word $F4F4 ; Emulation mode COP
	.word $F4F4
	.addr Native_mode_ABORT
	.addr Native_mode_NMI
	.addr EntryPoint ; Emulation mode RESET
	.addr Native_mode_IRQ

