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


	baseinc $01DA35, $028000
