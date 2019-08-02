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
.a8
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
	baseinc $008166, $00AC43


.proc UploadDefaultAPUProgram
.a8
	LDA #<DefaultAPUProgram
	STA FramebufferFarPtr
	LDA #>DefaultAPUProgram
	STA FramebufferFarPtr+1
	LDA #^DefaultAPUProgram
	STA FramebufferFarPtr+2
.endproc

.proc UploadAPUProgram
.a8
	JSR GetAPUBlockHeader
	JSR InitAPUUpload

@loop:
	JSR SendAPUProgramBlock
	JSR GetAPUBlockHeader
	seta16
	LDA APUTransferRemainingBytes
	seta8
	BEQ @done
	JSR APUTransferWaitAck
	BRA @loop

@done:
	JSR APUTransferWaitLastACK
	RTS
.endproc

.proc GetAPUBlockHeader
.a8
	LDA [FramebufferFarPtr]
	STA APUTransferRemainingBytes
	JSR IncFarPtr
	LDA [FramebufferFarPtr]
	STA APUTransferRemainingBytes+1
	JSR IncFarPtr
	LDA [FramebufferFarPtr]
	STA APUTransferDest
	JSR IncFarPtr
	LDA [FramebufferFarPtr]
	STA APUTransferDest+1
	JSR IncFarPtr
	RTS
.endproc

.proc IncFarPtr
.a8
	INC FramebufferFarPtr
	BNE @done
	INC FramebufferFarPtr+1
	BNE @done
	LDA #$80
	STA FramebufferFarPtr+1
	INC FramebufferFarPtr+2
@done:
	RTS
.endproc

.proc InitAPUUpload
.a8
	LDA APU0
	CMP #$AA
	BNE InitAPUUpload
	LDA APU1
	CMP #$BB
	BNE InitAPUUpload

	LDA APUTransferDest
	STA APU2
	LDA APUTransferDest+1
	STA APU3
	LDA #1
	STA APU1
	LDA #$CC
	STA APU0

@waitAPUReady:
	LDA APU0
	CMP #$CC
	BNE @waitAPUReady
	RTS
.endproc

.proc SendAPUProgramBlock
.a8
	setxy16
	LDY APUTransferRemainingBytes
	STZ APUTransferIndex

@sendByte:
	LDA [FramebufferFarPtr]
	STA APU1
	LDA APUTransferIndex
	STA APU0
	INC FramebufferFarPtr
	BNE :+
	INC FramebufferFarPtr+1
	BNE :+
	LDA #$80
	STA FramebufferFarPtr+1
	INC FramebufferFarPtr+2
:

	LDA APU0
	CMP APUTransferIndex
	BNE :-
	INC APUTransferIndex
	DEY
	BNE @sendByte
	setxy8
	RTS
.endproc

.proc APUTransferWaitAck
.a8
	LDA #2
	STA APU1
	LDA APUTransferDest
	STA APU2
	LDA APUTransferDest+1
	STA APU3
	INC APUTransferIndex
	BNE :+
	INC APUTransferIndex
:

	LDA APUTransferIndex
	STA APU0
:
	LDA APU0
	CMP APUTransferIndex
	BNE :-
	RTS
.endproc

.proc APUTransferWaitLastACK
.a8
	LDA #0
	STA APU1
	LDA APUTransferDest
	STA APU2
	LDA APUTransferDest+1
	STA APU3
	INC APUTransferIndex
	BNE :+
	INC APUTransferIndex
:

	LDA APUTransferIndex
	STA APU0
:
	LDA APU0
	CMP APUTransferIndex
	BNE :-
	RTS
.endproc


	baseinc $00AD33, $00B50A


.proc Native_mode_IRQ
.a8
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
.endproc


	baseinc $00B522, $00B9BE


.proc ReadCHRRows
.a8
	LDA f:ICD2CURROW
	STA CurLYAndBufNum
	LDA f:ICD2CURROW
	CMP CurLYAndBufNum
	BNE ReadCHRRows
	; Check if this "row" was VBlank
	CMP #$12 << 3
	BCS @done
	; Divide by 8
	LSR
	LSR
	LSR
	STA CurLCDCHRRow
	LDA CurLCDCHRRow
	SEC
	SBC CurCHRRow
	BEQ @done
	BPL @noWrap
	LDA #$12
	SEC
	SBC CurCHRRow
	CLC
	ADC CurLCDCHRRow
@noWrap:
	STA RemainingCHRRows
	CMP #4
	BCS @giveUp

@readRow:
	JSR ReadCHRRow
	INC CurCHRRow
	LDA CurCHRRow
	CMP #$12
	BCC @sameBuffer
	STZ CurCHRRow
	JSR ExchangeFramebufferPtrs
@sameBuffer:
	DEC RemainingCHRRows
	BNE @readRow

@done:
	RTS

@giveUp:
	LDA CurLCDCHRRow
	STA CurCHRRow
	RTS
.endproc

.proc ReadCHRRow
.a8
.i8
	LDA CurLYAndBufNum
	SEC
	SBC RemainingCHRRows
	AND #%11
	STA f:ICD2ROWSEL
	STZ WMADDH
	seta16
	LDA CurCHRRow
	ASL
	TAX
	LDA MultBy0x140Table,X
	CLC
	ADC PtrToOtherFramebuffer
	STA WMADDL ; And WMADDM
	LDA #<WMDATA << 8 | DMA_CONST
	STA DMAMODE + $40 ; Also DMAPPUREG
	LDA #ICD2CHR
	STA DMAADDR + $40 ; Also DMAADDRHI
	LDA #<$140 << 8 | ^ICD2CHR
	STA DMAADDRBANK + $40 ; Also DMALEN
	LDA #>$140
	STA DMALENHI + $40 ; Also a dummy write after
	seta8

	LDA SomeMutex
	BNE :+++++    ; -+
	LDY #1         ; |
	LDA PPUSTATUS2 ; |
	LDA GETXY      ; |
	LDA YCOORD     ; |
	CMP #$DF       ; |
	BCS :++     ; -+ |
	CMP #$DC     ; | |
	BCC :++++ ; -+ | |
	STY RunGDMA4;| | |
               ; | | |
:              ; | | |
	LDA IRQAck ; | | |
	BEQ :-     ; | | |
	STZ RunGDMA4;| | |
	RTS        ; | | |
               ; | | |
:            ; <-|-+ |
	BNE :++ ; -+ |   |
:            ; | |   |
	LDA IRQAck;| |   |
	BEQ :-   ; | |   |
:          ; <-+-+   |
	LDA #1 << 4    ; |
	STA COPYSTART  ; |
	RTS            ; |
                   ; |
:                ; <-+
	LDA #1 << 4
	STA COPYSTART
	RTS
.endproc

.proc ExchangeFramebufferPtrs
	LDA WhichFramebuffer
	EOR #1
	STA WhichFramebuffer
	BNE :+

	LDA #>Framebuffer_7E5000
	STA PtrToOtherFramebuffer+1
	LDA #>Framebuffer_7E6800
	STA PtrToFramebuffer+1
	RTS

:
	LDA #>Framebuffer_7E6800
	STA PtrToOtherFramebuffer+1
	LDA #>Framebuffer_7E5000
	STA PtrToFramebuffer+1
	RTS
.endproc


	baseinc $00BAA4, $00C573


.proc ProcessSOU_TRN
.a8
	LDA #$FF
	STA APU0
	JSR WaitFramebufferFilled
	LDA PtrToFramebuffer
	STA FramebufferFarPtr
	LDA PtrToFramebuffer+1
	STA FramebufferFarPtr+1
	LDA #$7E
	STA FramebufferFarPtr+2
	JSR UploadAPUProgram
	RTS
.endproc

.proc WaitFramebufferFilled
.a8
	SEI
	LDA #1
	STA SomeMutex
	LDA PtrToFramebuffer+1
	STA TmpFramebufPtrHigh

:
	JSR ReadCHRRows
	LDA PtrToFramebuffer+1
	CMP TmpFramebufPtrHigh
	BEQ :-

:
	JSR ReadCHRRows
	LDA PtrToFramebuffer+1
	CMP TmpFramebufPtrHigh
	BNE :-

	STZ SomeMutex
	LDA DoCheckButtonSequences
	BEQ :+
	LDA TIMEUP ; $4211
	CLI
:
	RTS
.endproc


	baseinc $00C5BC, $00FFC0


.segment "HEADER"
	; No extended header here, instead are some jumps
.org $00FFC0

snes_header:
	.byte "Super GAMEBOY        "
	.byte $20   ; LoROM mapping, 200ns access time
	.byte $E3   ; Extra hardware
	.byte 8	 ; ROM size
	.byte 0	 ; RAM size
	.byte 0	 ; Destination code (Japan)
	.byte 1	 ; Publisher
	.byte rom_version
	.res 2	  ; Checksum complement
	.res 2	  ; Checksum

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

