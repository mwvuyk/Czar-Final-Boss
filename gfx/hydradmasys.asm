
incsrc "../../PIXI V1.31/sprites/hydra/hdefs.asm"

!dest1 = $E800
!dest2 = $EB00
!size1 = $0440
!size2 = $0040

nmi:
LDA.w hydra.cl_init
CMP #$F7
BNE ++
LDA.w hydra.dmado
BNE +
++
RTL
+

STZ.w hydra.dmado
PHP
REP #$20			; 16-bit A
SEP #$10			; 8-bit XY
LDY #$80			;
STY $2115			; increment after reading the high byte of the VRAM data write ($2119)
LDA #!dest1		    ;
STA $2116			; VRAM address
LDA #$1801			;
STA $4320			; 2 regs write once, $2118
LDA.w hydra.dmasrc		;
STA $4322			; set the lower two bytes of the source address
LDY.w hydra.dmabank		;
STY $4324			;
LDA #!size1		; number of bytes to transfer
STA $4325			;
LDY #$04			; DMA channel 2 (TSB $420B messes stuff up...I wonder why?)
STY $420B			;

LDA #!dest2		;
STA $2116			; VRAM address
LDA #!size2		; number of bytes to transfer
STA $4325			;
LDY #$04			; DMA channel 2 (TSB $420B messes stuff up...I wonder why?)
STY $420B			;
PLP				;

RTL

init:
;HDMA settings
LDA #$02 ;window 1 affects layer 1
STA $41
STA $2123
LDA #$01
STA $212E
RTL