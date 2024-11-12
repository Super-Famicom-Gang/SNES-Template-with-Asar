incsrc "header.asm"

org $8000

NAT_COP_Routine:
NAT_BRK_Routine:
EMU_COP_Routine:

NAT_NMI_Routine:
EMU_NMI_Routine:

NAT_IRQ_Routine:
EMU_IRQ_Routine:

EMU_RESET:
    NOP