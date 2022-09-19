
PrepSegment:
    LDA hydra.seg1x,x
    CLC : ADC $00
    STA $02
    
    LDA hydra.seg1y,x
    CLC : ADC $01
    STA $03

    STX $06
    LDA hydra.crumble1,x
    TAX
    LDA crumbletab,x
    LDX $06
    STA $06
RTS

DrawSegment:
    PHX
    LDX #$03
.head
    LDA hydra.dirx
    BNE +
    LDA $02
    CLC : ADC NXOFF,x
    BRA ++
    +
    LDA $02
    CLC : ADC NXOFFFlip,x
    ++
    STA !oam_x,y
    
    LDA hydra.diry
    BNE +
    LDA $03
    CLC : ADC NYOFF,x
    BRA ++
    +
    LDA $03
    CLC : ADC NYOFFFlip,x
    ++
    STA !oam_y,y

    LDA $04
    STA !oam_p,y
    LDA NTILE,x
    CLC : ADC $06
    STA !oam_t,y

    INY : INY : INY : INY
    DEX
    BPL .head
    PLX
RTS

DrawSegmentYFlip:
    PHX
    LDX #$03
.head
    LDA hydra.dirx
    BNE +
    LDA $02
    CLC : ADC NXOFF,x
    BRA ++
    +
    LDA $02
    CLC : ADC NXOFFFlip,x
    ++
    STA !oam_x,y
    
    LDA hydra.diry
    BEQ +
    LDA $03
    CLC : ADC NYOFF,x
    BRA ++
    +
    LDA $03
    CLC : ADC NYOFFFlip,x
    ++
    STA !oam_y,y

    LDA $05
    STA !oam_p,y
    LDA NTILE,x
    CLC : ADC $06
    STA !oam_t,y

    INY : INY : INY : INY
    DEX
    BPL .head
    PLX
RTS


DrawTail:
    PHX
    LDX #$03
.head
    LDA hydra.diry
    BEQ +++
    
    LDA hydra.dirx
    BNE +
    LDA $02
    CLC : ADC TXOFF,x
    BRA ++
    +
    LDA $02
    CLC : ADC TXOFFFlip,x
    ++
    STA !oam_x,y
    
    +++
    LDA hydra.dirx
    BNE +
    LDA $02
    CLC : ADC TXOFFYFlip,x
    BRA ++
    +
    LDA $02
    CLC : ADC TXOFFFlipXY,x
    ++
    STA !oam_x,y
    
    LDA hydra.diry
    BEQ +
    LDA $03
    CLC : ADC NYOFF,x
    BRA ++
    +
    LDA $03
    CLC : ADC NYOFFFlip,x
    ++
    STA !oam_y,y

    LDA $05
    STA !oam_p,y
    LDA TTILE,x
    STA !oam_t,y

    INY : INY : INY : INY
    DEX
    BPL .head
    PLX
RTS



DrawHead:
    LDX #$08
.head

    LDA hydra.dirx
    BNE +
    LDA $02
    CLC : ADC XOFF,x
    BRA ++
    +
    LDA $02
    CLC : ADC XOFFFlip,x
    ++
    STA !oam_x,y
    
    LDA hydra.diry
    BNE +
    LDA $03
    CLC : ADC YOFF,x
    BRA ++
    +
    LDA $03
    CLC : ADC YOFFFlip,x
    ++
    STA !oam_y,y

    LDA $04
    STA !oam_p,y
    LDA TILE,x
    STA !oam_t,y

    INY : INY : INY : INY
    DEX
    BPL .head
RTS

crumbletab:
db $00,$04,$08,$0C
db $40,$44,$48,$4C
db $80,$84,$88,$8C
db $C4,$00
;head
XOFF:
db $00, $10, $20
db $00, $10, $20
db $00, $10, $20

XOFFFlip:
db $20, $10, $00
db $20, $10, $00
db $20, $10, $00

YOFF:
db $00, $00, $00
db $10, $10, $10
db $20, $20, $20

YOFFFlip:
db $20, $20, $20
db $10, $10, $10
db $00, $00, $00

PROP:
db $22, $62
db $A2, $E2
;frame 1

TILE:
db $80, $82, $84
db $86, $88, $8A
db $8C, $8E, $A0



;neck
NXOFF:
db $00, $10
db $00, $10

NXOFFFlip:
db $10,$00
db $10,$00

NYOFF:
db $00, $00
db $10, $10

NYOFFFlip:
db $10, $10
db $00, $00

NPROP:
db $23, $63
db $A3, $E3



;tail
TXOFF:
db $F8, $08
db $00, $10

TXOFFYFlip:
db $00, $10
db $F8, $08

TXOFFFlip:
db $08, $F8
db $10, $00

TXOFFFlipXY:
db $10, $00
db $08, $F8

TTILE:
db $c8, $cA
db $cC, $cE

NTILE:
db $00, $02
db $20, $22
