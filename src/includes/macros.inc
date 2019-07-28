.macro baseinc begin_addr, end_addr
	.local begin_ofs, end_ofs, len
	
	.if !(begin_addr & $8000)
		.error "baseinc start address must be in ROM"
	.endif	
	
	.if !(end_addr & $8000)
		.error "baseinc end address must be in ROM"
	.endif	
	
	; We'll treat the ROM mirror identically to the actual ROM
	begin_ofs = (^begin_addr & $7F) * $8000 + (begin_addr & $7FFF)
	end_ofs   =   (^end_addr & $7F) * $8000 +   (end_addr & $7FFF)
	len = end_ofs - begin_ofs

	.incbin .concat(BIOS_NAME,".sfc"), begin_ofs, len
.endmac
