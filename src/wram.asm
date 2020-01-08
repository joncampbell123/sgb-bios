.include "includes.inc"

; For `zp.sh` to work properly, ALL zero-page defintions must come first, and `.segment` directives must be on the first column
.zeropage
.org $000000

ICD2CTLTemp: ; .res 1
MouseMotionRadius: .res 1

.res 4

IndirectLongJumpIndexedPtr: .tag FarPtr

EightBitCounter: ; res 1
GBInput: .res 1

.res 7

APUTransferIndex: ; .res 1
PlayerInput: .res 2

.res 6

IndirectionPtr: .tag FarPtr

ScreenTransferPtr: .res 2
ScreenTransferIndex: .res 1

.res 4

IRQAck: .res 1

.res 1

AttractionModeWaitCounter: .res 1

.res 3

Some16BitCounter: .res 2
Some1BitCounter: .res 1
Some2BitCounter: .res 1
Some3BitCounter: .res 1

.res $33

MainOAMFarPtr: .tag FarPtr
SecondaryOAMFarPtr: .tag FarPtr
SecondaryOAMIndex: .res 1

.res 1

SpriteAttr: .res 1
SpriteSize: .res 1
SpriteYPos: .res 2
SpriteXPos: .res 2
SpriteTile: .res 1

.res $29

FramebufferFarPtr: .tag FarPtr

.res 1

APUTransferRemainingBytes: .res 2
APUTransferDest: .res 2

AttributeHCoord: .res 2
AttributeVCoord: .res 2

ATTR_BLKAttribute: .res 1
ATTR_BLKWidth: .res 1
ATTR_BLKHeight: .res 1

.res 1

AttributeFarPtr: .tag FarPtr

.res 5

DATA_SNDFarPtr: .tag FarPtr

.res 5

JUMPFarPtr: .tag FarPtr
NMIFarPtr: .tag FarPtr

.res 2

SrcFarPtr: .tag FarPtr
DestFarPtr: .tag FarPtr

.res 6

VRAMDMALen: .res 2
VRAMDMADest: .res 2
VRAMDMASrc: .tag FarPtr

.res 1

PaletteMakerSelectedColor: .res 2


.segment "BSS"
.org $000100

.res $0040

Player1HeldButtons: .res 2
Player1PressedButtons: .res 2

.res 4

Player2HeldButtons: .res 2
Player2PressedButtons: .res 2

.res $000C

P1GBInput: .res 1

.res 4

SpeedButtonSeqIndex: .res 1
SoundButtonSeqIndex: .res 1
ButtonSequenceSoundToggle: .res 1

.res $00B5

SomeMutex: .res 1 ; TODO: this seems to be a mutex, but what is its purpose?

RunGDMA4: .res 1

.res $0069

WhichFramebuffer: .res 1
.res 1
PtrToOtherFramebuffer: .res 2
PtrToFramebuffer: .res 2

.res 1

TmpFramebufPtrHigh: .res 1

.res 8

CurLYAndBufNum: .res 1
.res 1
CurLCDCHRRow: .res 1
.res 1
CurCHRRow: .res 2
.res 4

RemainingCHRRows: .res 1

.res $002F

DoCheckButtonSequences: .res 1 ; TODO: this is certainly something else

.res 32

CurClockSpeed: .res 1
CurNbControllers: .res 1

.res 5

MultiplayerControl: .res 1

.res $4E

SFXANum: .res 1
SFXBNum: .res 1
SFXAttrs: .res 1

.res $08C0

MapSNES_BToGB_A: .res 1

.res 23

PlayerRequestedClosing: .res 1

.res 2

MenuController: .res 1 ; 0 = P1, 1 = Mouse, 2 = P2
.res 1
MenuCursorXPos: .res 1
MenuCursorYPos: .res 1
PrevMenuCursorXPos: .res 1
PrevMenuCursorYPos: .res 1
SelectedMenuFeature: .res 1

.res $0023

AHeld: .res 1
BHeld: .res 1
MouseRightHoldCounter: .res 1
MouseLeftHoldCounter:  .res 1

.res $02B3

.res 1

TransmitOnlyStartSelect: .res 1

WhichActiveController: .res 1

.res 1

UpdateGamePalette: .res 1

.res 1

EnableOBJ_TRN: .res 1

DisabledMenuFeatures: .res 1

.res 1

AttractionModeActive: .res 1

DontUpdateScreen: .res 1

GamePalettePresent: .res 1

PCT_TRNSet: .res 1

.res 1

AttractionModeWaitFrames: .res 2

Multi5Present: .res 1

Player1Input: .res 2
Player2Input: .res 2
Player3Input: .res 2
Player4Input: .res 2
Player5Input: .res 2
IgnorePlayer1Input: .res 1
IgnorePlayer2Input: .res 1
IgnorePlayer3Input: .res 1
IgnorePlayer4Input: .res 1
IgnorePlayer5Input: .res 1

Multi5LeftPortStrobeless:  .res 1
Multi5LeftPortStrobed:     .res 1
Multi5RightPortStrobeless: .res 1
Multi5RightPortStrobed:    .res 1

.res 12

IsMouseConnected: .res 2
TargetMouseSensitivity: .res 2
CurrentMouseSensitivity: .res 2
VerticalMouseMovement: .res 2
HorizontalMouseMovement: .res 2
CurrentMouseButtons: .res 2
MouseButtonsChange: .res 2
PreviousMouseButtons: .res 2
MustChangeSensitivity: .res 2

.res $0BD

StackBottom: .res 1

MenuSprites:
.repeat 8
	.tag Sprite
.endrep

.res $692

byte_7E1712: .res 1


.segment "BSS7E"
.org $7E2000

.res $3000

Framebuffer_7E5000: .res $1800
Framebuffer_7E6800: .res $1800


.segment "BSS7F"
.org $7F0000

VRAMBuffer0: .res $1000
VRAMBuffer1: .res $1000
VRAMBuffer2: .res $1000
VRAMBuffer3: .res $1000
VRAMBuffer4: .res $1000
VRAMBuffer5: .res $1000
VRAMBuffer0Copy: .res $1000
VRAMBuffer1Copy: .res $1000
VRAMBuffer2Copy: .res $1000
VRAMBuffer3Copy: .res $1000
VRAMBuffer4Copy: .res $1000
VRAMBuffer5Copy: .res $1000

OAM2TileBuf0: .res $800
OAM2TileBuf1: .res $800
OAM2TileBuf2: .res $800
OAM2TileBuf3: .res $800
OAM2TileBuf4: .res $800
OAM2TileBuf5: .res $800
OAM2TileBuf6: .res $800
OAM2TileBuf7: .res $800
