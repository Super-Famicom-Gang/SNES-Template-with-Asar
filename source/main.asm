incsrc "init.asm"

%codebank(0)

NAT_COP_Routine:
NAT_BRK_Routine:
EMU_COP_Routine:

NAT_NMI_Routine:
EMU_NMI_Routine:
	JML	.fastROM		;
	%codebank($80)		;	Move to FastROM
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

%codebank(0)
NAT_IRQ_Routine:
EMU_IRQ_Routine:
	RTI

EMU_RESET:
Start:
	%InitSNES()
	.loop:
		WAI			;	Loop forever
		BRA .loop	;__
