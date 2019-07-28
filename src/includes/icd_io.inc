ICD2CURROW    = $6000
; 76543210
; ||||| ++- Current buffer number the ICD2 is writing to
; +++++---- Current GB LCD LY, divided by 8 ($11 = VBlank)

ICD2ROWSEL    = $6001
; 76543210
;       ++- Selected CHR buf number

ICD2PACKAVAIL = $6002
; 76543210
;        +- 16-byte packet available at ICD2PACKDATA

ICD2CTL       = $6003
; 76543210
; | ||  ++- Clock speed
; | ||      0: 5MHz, 1: 4MHz, 2: 3MHz, 3: 2.3MHz
; | ++----- Number of controllers
; |         0: 1, 1: 2, 2: ?, 3: 4
; +-------- 0: Reset CPU

ICD2P1        = $6004
ICD2P2        = $6005
ICD2P3        = $6006
ICD2P4        = $6007
; 76543210
; SsBADULR
; 0: Pressed, 1: Released

ICD2VER       = $600F
; $21 SGB1v?
; $61 SGB1v?
; $?? SGB2

ICD2PACKDATA  = $7000
; 16-byte buffer containing a command packet
; Reading $7000 resets ICD2PACKAVAIL bit 0

ICD2CHR       = $7800
; Read 320 times (via DMA) to get a CHR row

