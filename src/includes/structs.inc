
.struct FarPtr
	ptr .addr
	bank .byte
.endstruct
.macro farPtr label
	.word label
	.byte ^label
.endmac

.struct OAM2TileCopy
	src .faraddr
	destHigh .byte
	lenHigh .byte
	padding .res 3
.endstruct
.macro oam2TileCopy src, dest, len
	.faraddr src
	.byte >dest
	.byte >len
	.byte 0,0,0 ; TODO: check padding
.endmac

.struct TileCopyStruct
	src .faraddr
	destHigh .byte
	lenHigh .byte
.endstruct
.macro tileCopyStruct src, dest, len
	.faraddr src
	.byte >dest
	.byte >len
.endmac

.struct TilemapCopyStruct
	src .faraddr
	dest .addr
	len .word
.endstruct
.macro tilemapCopyStruct src, dest, len
	.faraddr src
	.addr dest
	.word len
.endmac

.struct BGParams
	BGMODE .byte
	CGWSEL .byte
	CGADSUB .byte
	COLDATA .byte
	unk_unused .word
	BLENDMAIN .byte
	BLENDSUB .byte
.endstruct

.struct MenuFeature
	minX .byte
	maxX .byte
	minY .byte
	maxY .byte
.endstruct
.macro menuFeature minX, maxX, minY, maxY
	.byte minX
	.byte maxX
	.byte minY
	.byte maxY
.endmac

.struct PaletteCopyStruct
	attr0 .faraddr
	attr1 .byte
	attr2 .word
.endstruct
.macro paletteCopyStruct ptr, byte, word
	.faraddr ptr
	.byte byte
	.word word
.endmac

.struct CopyStruct
	len .word
	src .faraddr
	dest .faraddr
.endstruct
.macro copyStruct src, dest, len
	.word len
	.faraddr src
	.faraddr dest
.endmac

.struct PaddedFarPtr
	ptr .faraddr
	padding .byte
.endstruct
.macro paddedFarPtr ptr
	.faraddr ptr
	.byte 0 ; TODO: check padding value
.endmac

.struct OBJ
	xPos .byte
	yPos .byte
	tile .byte
	attr .byte
.endstruct

.struct Sprite
	attr0 .byte
	attr1 .byte
	attr2 .byte
	unkIndex .byte
	unkCounter .byte
	attr5 .byte
	attr6 .byte
	attr7 .byte
	xPos .word
	yPos .byte
	attrB .byte
	unkPtr .addr
	size .byte
	attrF .byte
.endstruct

.struct CoordPair
	xCoord .word
	yCoord .word
.endstruct
