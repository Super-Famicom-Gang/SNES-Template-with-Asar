incsrc "init.asm"
; RAM allocation can happen anywhere
; Generic cc65-style tmp vars
%allocateRAM(0, tmp1, 1, tmp2, 1, tmp3, 1, tmp4, 1)
%allocateRAM(0, ptr1, 2, ptr2, 2, ptr3, 2, ptr4, 2)


; init.asm pushes PC, so to start coding in the bank 0, pull pc
%codebank(0)

NAT_COP_Routine:
NAT_BRK_Routine:
EMU_COP_Routine:

NAT_NMI_Routine:
EMU_NMI_Routine:; init.asm pushes PC, so to start coding in the first bank, pull 
	JSL	.fastROM		;
	org $800000|pc()	;	Move to FastROM
	.fastROM:			;__
	PHA	;
	PHX	;	Save regs
	PHY	;
	PHP	;__
; TODO: add NMI routine with stdlib:
;	- DMA queue
;	- Controller reading at the end
;	- Space for other routines

	PLP	;
	PLY	;	Get regs
	PLX	;
	PLA	;__
	RTI

NAT_IRQ_Routine:
EMU_IRQ_Routine:
	RTI

EMU_RESET:
Start:
	%InitSNES()
	.loop:
		WAI			;	Loop forever
		BRA .loop	;__
