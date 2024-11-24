;==== FRIENDLY HEADER BY alexmush ====;
; Game Title, encoded in JIS X 0201
; Must be 21 or less characters long
; (This script pads the string to 21 bytes automatically)
!HEADER_GAMETITLE = "                     "

; Map mode - Indicates how ROM space is mapped to SNES CPU address space
; 0 - LoROM
; 1 - HiROM
; 2 - LoROM + S-DD1 = Mappable ("Super MMC")
; 3 - LoROM + SA-1  = Mappable ("Emulates Super MMC")
; 5 - ExHiROM
; 6 - ExLoROM (homebrew only)
!HEADER_MAPMODE = 0
; ROM Speed - Indicates access times for ROM in banks $80-$FF
; 0 - 2.68 MHz
; 1 - 3.58 MHz
!HEADER_ROMSPEED = 1

; Cartridge type - Indicates what hardware is present on the cart
; No coprocessor - only specify CARTTYPE (leave COPTYPE at 0):
; CARTTYPE:
; |_Value_|_ROM_|_RAM_|_Battery_|
; |___0___|__X__|_____|_________|
; |___1___|__X__|__X__|_________|
; |___2___|__X__|__X__|____X____|
;
; Yes coprocessor - specify both CARTTYPE and COPTYPE:
; CARTTYPE:
; |_Value_|_ROM_|_RAM_|_Battery_|
; |___3___|__X__|_____|_________|
; |___4___|__X__|__X__|_________|
; |___5___|__X__|__X__|____X____|
; |___6___|__X__|_____|____X____|
;
; COPTYPE:
; |_Value_|_Coprocessor_|_Notes
; |___0___|_DSP_________|_Types: DSP1, DSP1A, DSP1B, DSP2, DSP3, DSP4
; |___1___|_GSU_________|_aka SuperFX, Revisions: MarioChip1, GSU1, GSU2, GSU2-SP1
; |___2___|_OBC1________|
; |___3___|_SA-1________|
; |___4___|_S-DD1_______|
; |___5___|_S-RTC_______|
; |__14___|_Other_______|_Super Gameboy / Satellaview
; |__15___|_Custom______|_Specified with Cartridge Type Sub-Number
;
; |_If COPTYPE = 15 (Custom), then EXTCOPTYPE indicates the exact coprocessor:
; |_Value_|_Coprocessor_|
; |___0___|_SPC7110_____|
; |___1___|_ST010/ST011_|
; |___2___|_ST018_______|
; |_*3/16_|_CX4_________|
; * Conflicting information from snesdev wiki and fullsnes respectively.
!HEADER_CARTTYPE = 0
!HEADER_COPTYPE = 0
!HEADER_EXTCOPTYPE = 0

; ROM size
; Just write the ROM size in kibibytes here
; (This script automatically calculates the value in the header)
!HEADER_ROMSIZE = 32

; RAM size
; Just write the SRAM size in kibibytes here
; (This script automatically calculates the value in the header)
; Write 0 if there is no SRAM
; If you are using a GSU (SuperFX) chip, then put this value into
; Expansion RAM Size
!HEADER_SRAMSIZE = 0
!HEADER_EXRAMSIZE = 0

; Destination Code
; |_D.C._|_Destination_(Language)____|_Region_|_Last Letter of 4-letter Game Code
; |_$00__|_Japan_____________________|_NTSC___|_J
; |_$01__|_North_America_(US/Canada)_|_NTSC___|_E
; |_$02__|_All_of_Europe_____________|_PAL____|_P
; |_$03__|_Scandinavia_______________|_PAL____|_W
; |_$04__|_Finland___________________|_PAL____|
; |_$05__|_Denmark___________________|_PAL____|
; |_$06__|_Europe_(French_only)______|_SECAM__|_F
; |_$07__|_Dutch_____________________|_PAL____|_H
; |_$08__|_Spanish___________________|_PAL____|_S
; |_$09__|_German____________________|_PAL____|_D
; |_$0A__|_Italian___________________|_PAL____|_I
; |_$0B__|_Chinese___________________|_PAL____|_C
; |_$0C__|_Indonesian________________|_PAL____|
; |_$0D__|_Korean____________________|_NTSC___|_K
; |_$0E__|_Common____________________|________|_A
; |_$0F__|_Canada____________________|_NTSC___|_N
; |_$10__|_Brazil____________________|_PAL-M__|_B
; |_$11__|_Australia_________________|_PAL____|_U
; |_$12__|                           |        |_X
; |_$13__| Other variation           |        |_Y
; |_$14__|___________________________|________|_Z
; For generic homebrews, just pick $00 (for NTSC), $01 (for NTSC), $02 (for PAL)
; or $0E and you should be in the clear.
!HEADER_DESTINATIONCODE = $0E

; Mask ROM Version
; Store the version number of the mask ROM released to the market as a product.
; The number begins with 0 at production and increases with each revised version.
!HEADER_ROMVERSION = $00

; Maker Code
; A 2-digit ASCII code. Back in the day, it was assigned by Nintendo to developers.
; Ignored by emulators; for ROM hackers and homebrewers, just insert whatever.
!HEADER_MAKERCODE = "00"

; Game Code
; A 4-letter (or 2-letter and padded with 2 spaces at the end) ASCII code.
; Back in the day, it was assigned by Nintendo for each game and stated here
; as well as on the game cartridge and its box. If the code was 4 letters long,
; then the last letter indicated the region as stated in the REGION table above.
; Ignored by emulators; for ROM hackers and homebrewers, just insert whatever.
; Note: if the code is "Z**J", then it's a BS-X flash cartridge.
!HEADER_GAMECODE = "NULL"

; Special Version
; This is only used under special circumstances, such as for a promotional event.
; Under normal circumstances, this should be 0.
!HEADER_SPECIALVERSION = 0

;=== Interrupt vectors ===;
; == Native mode ==
	; Software interrupts
	!NAT_COP = NAT_COP_Routine		; The one triggered by the COP instruction
	!NAT_BRK = NAT_BRK_Routine		; The one triggered by the BRK instruction

	; Non-maskable interrupt, called when vertical refresh (vblank) begins
	!NAT_NMI = NAT_NMI_Routine

	; Interrupt request, can be set to be called at a certain spot in the
	; horizontal refresh cycle
	!NAT_IRQ = NAT_IRQ_Routine 

; == Emulation mode ==
	; Software interrupt triggered by the COP instruction
	!EMU_COP = EMU_COP_Routine

	; Non-maskable interrupt, called when vertical refresh (vblank) begins
	!EMU_NMI = EMU_NMI_Routine

	; Reset vector, execution begins via this vector
	!EMU_RES = EMU_RESET

	; Interrupt request, can be set to be called at a certain spot in the
	; horizontal refresh cycle;
	; also the software interrupt triggered by the BRK instruction
	!EMU_IRQBRK = EMU_IRQ_Routine

;=== Actually setting the header ===;

; Get the mapping mode first
if !HEADER_COPTYPE == 1		; SuperFX
	sfxrom
	!LOROM = 1
elseif !HEADER_MAPMODE == 0	; LoROM
	lorom
	!LOROM = 1
	!EXROM = 0
elseif !HEADER_MAPMODE == 1	; HiROM
	hirom
	!LOROM = 0
	!EXROM = 0
elseif !HEADER_MAPMODE == 2	; LoROM + S-DD1
	if !HEADER_COPTYPE != 4	; S-DD1
		warn "You have set Mapping Mode 2 (LoROM + S-DD1) but you have not set the Co-Processor Type to 4 (S-DD1)"
	endif
	sa1rom
	!LOROM = 1	; may be incorrect
	!EXROM = 0
elseif !HEADER_MAPMODE == 3	; LoROM + SA-1
	if !HEADER_COPTYPE != 3	; SA-1
		warn "You have set Mapping Mode 3 (LoROM + SA-1) but you have not set the Co-Processor Type to 3 (SA-1)"
	endif
	sa1rom
	!LOROM = 1	; may be incorrect
	!EXROM = 0
elseif !HEADER_MAPMODE == 5	; ExHiROM
	exhirom
	!LOROM = 0
	!EXROM = 1
elseif !HEADER_MAPMODE == 6	; ExLoROM
	exlorom
	!LOROM = 1
	!EXROM = 1
endif

macro __header_setDefault(macro, default)
	if not(defined("<macro>")) : !HEADER_<macro> = <default> : endif
endmacro

macro __header_padString(addr)
	padbyte $20 : assert pc() <= <addr> : pad <addr>
endmacro

macro __header_padWithZeros(addr)
	padbyte $00 : assert pc() <= <addr> : pad <addr>
endmacro

macro __header_putRAMSize(param)
	if <param> != 0 : db $00 : else : db ceil(log2(<param>)) : endif
endmacro

org $00FFB0
; $B0-B1 : Maker Code
assert pc() == $00FFB0 : %__header_setDefault(MAKERCODE, "00") : db "!HEADER_MAKERCODE" : %__header_padString($00FFB2)
; $B2-B5 : Game Code
assert pc() == $00FFB2 : %__header_setDefault(GAMECODE, "NULL") : db "!HEADER_GAMECODE" : %__header_padString($00FFB6)
; $B6-BC : Fixed Value
assert pc() == $00FFB6 : %__header_padWithZeros($00FFBD)
; $BD    : Expansion RAM Size
assert pc() == $00FFBD : %__header_setDefault(EXRAMSIZE, 0) : %__header_putRAMSize(!HEADER_EXRAMSIZE)
; $BE    : Special Version
assert pc() == $00FFBE : %__header_setDefault(SPECIALVERSION, 0) : db !HEADER_SPECIALVERSION
; $BF    : Cartridge Type Sub-Number
assert pc() == $00FFBF : %__header_setDefault(EXTCOPTYPE, 0) : db !HEADER_EXTCOPTYPE
; $C0-D4 : Game Title
assert pc() == $00FFC0 : db "!HEADER_GAMETITLE" : %__header_padString($00FFD5)
; $D5    : Map Mode
assert pc() == $00FFD5 : db $20|(!HEADER_ROMSPEED<<4)|!HEADER_MAPMODE
; $D6    : Cartridge Type
%__header_setDefault(COPTYPE, 0) : assert !HEADER_COPTYPE <= $0F : assert !HEADER_CARTTYPE <= $0F
assert pc() == $00FFD6 : db (!HEADER_COPTYPE<<4)|!HEADER_CARTTYPE
; $D7    : ROM Size
%__header_setDefault(ROMSIZE, 0) : assert !HEADER_ROMSIZE > 0
assert pc() == $00FFD7 : db ceil(log2(!HEADER_ROMSIZE))
; $D8    : RAM Size
assert pc() == $00FFD8 : %__header_setDefault(SRAMSIZE, 0) : %__header_putRAMSize(!HEADER_SRAMSIZE)
; $D9    : Destination Code
assert pc() == $00FFD9 : %__header_setDefault(DESTINATIONCODE, $0E) : db !HEADER_DESTINATIONCODE
; $DA    : Fixed Value
assert pc() == $00FFDA : db $33
; $DB    : Mask ROM Version
assert pc() == $00FFDB : %__header_setDefault(ROMVERSION, 0) : db !HEADER_ROMVERSION
; $DC-DD : Checksum Complement
assert pc() == $00FFDC : dw $FFFF
; $DE-DF : Checksum Complement
assert pc() == $00FFDE : dw $0000
; $E0-E3 : Unused
assert pc() == $00FFE0 : %__header_padWithZeros($00FFE4)
; $E4-EF : Native Interrupt Vectors
assert pc() == $00FFE4 : dw !NAT_COP, !NAT_BRK, $0000, !NAT_NMI,    $0000, !NAT_IRQ
; $F0-F3 : Unused
assert pc() == $00FFF0 : %__header_padWithZeros($00FFF4)
; $F4-FF : Emulation Interrupt Vectors
assert pc() == $00FFF4 : dw !EMU_COP,    $0000, $0000, !EMU_NMI, !EMU_RES, !EMU_IRQBRK