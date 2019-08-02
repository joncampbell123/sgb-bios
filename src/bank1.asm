.include "includes.inc"

.segment "CODE1"
.org $018000


	baseinc $018000, $01D9FE


.proc DetermineSelectedMenuFeature
.i8
.a8
    STZ SelectedMenuFeature
    LDY #0

@loop:
    LDA MenuCursorXPos
    CMP [SrcFarPtr], Y
    BCC :+
    INY
    LDA MenuCursorXPos
    CMP [SrcFarPtr], Y
    BCS :+
    INY
    LDA MenuCursorYPos
    CMP [SrcFarPtr], Y
    BCC :+
    INY
    LDA MenuCursorYPos
    CMP [SrcFarPtr], Y
    BCS :+
    RTL
:
    INC SelectedMenuFeature
    LDA SelectedMenuFeature
    ASL
    ASL
    TAY
    DEX
    BNE @loop

    LDA #$FF
    STA SelectedMenuFeature
    RTL
.endproc


	baseinc $01DA35, $01E452


.export MultBy0x140Table
MultBy0x140Table:
    .word $0000, $0140, $0280, $03C0, $0500, $0640, $0780, $08C0
    .word $0A00, $0B40, $0C80, $0DC0, $0F00, $1040, $1180, $12C0
    .word $1400, $1540, $1680, $17C0, $1900, $1900, $1900, $1900
    .word $1900, $1900, $1900, $1900, $1900, $1900, $1900, $1900


GBNintendoLogo:
    .byte $CE, $ED, $66, $66, $CC, $0D, $00, $0B, $03, $73, $00, $83, $00, $0C, $00, $0D
    .byte $00, $08, $11, $1F, $88, $89, $00, $0E, $DC, $CC, $6E, $E6, $DD, $DD, $D9, $99
    .byte $BB, $BB, $67, $63, $6E, $0E, $EC, $CC, $DD, $DC, $99, $9F, $BB, $B9, $33, $3E


    baseinc $01E4C2, $028000
