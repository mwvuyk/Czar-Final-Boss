
ClusterHandler:

STZ hydra.last_cluster
PHX
LDY.b #!cl_size

ClusterStart:
DEY
BMI .End
LDA !cl_n,y
BEQ ClusterStart
CMP hydra.last_cluster
BEQ .GoFast

STA hydra.last_cluster

ASL
TAX
LDA ClusterTable,x
STA hydra.cluster_r1
LDA ClusterTable+1,x
STA hydra.cluster_r2

.GoFast

JMP (hydra.cluster_r1)

.End:
PLX
RTS

ClusterTable:
dw $0000
dw RingFlame
dw GravityProjectile
dw RingFlameAlt
dw DetailYellow
dw DetailYellowAlt

ClusterOAM:
db $00,$04,$08,$0C,$10,$14,$18,$1C,$30,$34,$38,$3C,$40,$44,$48,$4C,$50,$58,$5C,$60,$64,$68,$6C,$70,$74,$78,$7C,$80,$84,$88,$8C,$90,$94,$98,$9C,$A0,$A4,$A8,$AC,$B0,$B4,$B8,$BC,$C0,$C4,$C8,$CC,$D0,$D4,$D8,$DC

DetailTiles:
db $A2,$A4,$A6

DetailYellowAlt:
TYX
LDA $9D
BNE .Lock
DEC !cl_u,x
BPL .Lock
STZ !cl_u,x
INC !cl_v,x

INC !cl_y,x
LDA !cl_v,x
CMP #$02
BEQ +
INC !cl_y,x
+

LDA !cl_v,x
CMP #$03
BNE ++
STZ !cl_n,x
BRA .Return
++
LDA #!FrameLength
SEC : SBC hydra.lolspeed
STA !cl_u,x


.Lock
LDY !cl_v,x
LDA DetailTiles,y
STA $00

LDY.w ClusterOAM,x

STA $01
LDA !cl_y,x
SEC : SBC $1C
STA $6201,y

LDA !cl_x,x
SEC : SBC $1A
STA $6200,y

LDA $00
STA $6202,y
LDA #$82
STA $6203,y

TYA : LSR : LSR : TAY
LDA #$03
STA $6420,y

.Return
TXY
JMP ClusterStart

DetailYellow:

TYX
LDA $9D
BNE .Lock
DEC !cl_u,x
BPL .Lock
STZ !cl_u,x
INC !cl_v,x

DEC !cl_x,x
LDA !cl_v,x
CMP #$02
BEQ +
DEC !cl_x,x
+

LDA !cl_v,x
CMP #$03
BNE ++
STZ !cl_n,x
BRA .Return
++
LDA #!FrameLength
SEC : SBC hydra.lolspeed
STA !cl_u,x


.Lock
LDY !cl_v,x
LDA DetailTiles,y
STA $00

LDY.w ClusterOAM,x

STA $01
LDA !cl_y,x
SEC : SBC $1C
STA $6201,y

LDA !cl_x,x
SEC : SBC $1A
STA $6200,y

LDA $00
STA $6202,y
LDA #$02
STA $6203,y

TYA : LSR : LSR : TAY
LDA #$02
STA $6420,y

.Return
TXY
JMP ClusterStart

GravityProjectile:
LDA $9D
BNE +
JSR ClusterAccumFrac
LDA !cl_t1,y
INC
STA !cl_t1,y
+

LDA !cl_xh,y
BNE .Return
LDA !cl_yh,y
BEQ +
CMP #$FF
BNE .Return
LDA !cl_y,y
CMP #$F0
BCC .Return
+

JSR ClusterInteract

JSR FireGFX

LDA !cl_v,y
INC : INC
CMP #$70
BEQ +
STA !cl_v,y
+

.Return
JMP ClusterStart

RingFlameAlt:
LDA $9D
BNE +

JSR ClusterAccumFrac
LDA $14
AND #$01
BEQ +
LDA !cl_t1,y
INC
STA !cl_t1,y
+
BRA SkiphereRingFlame
RingFlame:

LDA $9D
BNE +

JSR ClusterAccumFrac
LDA !cl_t1,y
INC
STA !cl_t1,y
+
SkiphereRingFlame:
;LDA !cl_xh,y
;BMI Offscreen

;LDA !cl_x,y
;CLC : ADC !cl_u,y
;STA !cl_x,y

;LDA !cl_y,y
;CLC : ADC !cl_v,y
;STA !cl_y,y



LDA !cl_xh,y
BNE .Return
LDA !cl_yh,y
BEQ +
CMP #$FF
BNE .Return
LDA !cl_y,y
CMP #$F0
BCC .Return
+




JSR ClusterInteract
JSR FireGFX

.Return
JMP ClusterStart



Offscreen:
LDA #$00
STA !cl_n,y
JMP ClusterStart




ClusterInteract:
!YInteractSmOrDu = $18 ; How many pixels to interact with small or ducking Mario, vertically.
!YInteractSmNorDu = $28 ; How many pixels to interact with powerup Mario (not ducking), vertically.

LDA hydra.diesig
BEQ +
RTS
+

LDA $94				; \ Sprite <-> Mario collision routine starts here.
SEC                             ;  | X collision = #$18 pixels. (#$0C left, #$0C right.)
SBC !cl_x,y                     ;  |
CLC                             ;  |
ADC #$08			;  |
CMP #$10			;  |
BCS Immobile			; /
LDA #!YInteractSmOrDu           ; Y collision routine starting here.
LDX $73
BNE StoreToNill
LDX $19
BEQ StoreToNill
LDA #!YInteractSmNorDu

StoreToNill:
STA $00
STZ $01

LDA !cl_y,y
STA $02
LDA !cl_yh,y
STA $03

REP #$20
LDA $96
SEC
SBC $02
CLC
ADC #$0018
CMP $00
SEP #$20
BCS Immobile

phx : phy
JSL $00F5B7			; Hurt Mario if sprite is interacting.
ply : plx
Immobile:                       ; OAM routine starts here.
RTS

ClusterAccumFrac:
JSR DoAccumFrac
PHY
TYA
CLC : ADC #!cl_size
TAY
JSR DoAccumFrac
PLY
RTS

DoAccumFrac:
LDA !cl_u,y
BEQ ++
ASL #4
CLC : ADC !cl_1,y
STA !cl_1,y
PHP
LDX #$00
LDA !cl_u,y
LSR #4
CMP #$08
BCC +
ORA #$F0
DEX
+
PLP
ADC !cl_x,y
STA !cl_x,y
TXA
ADC !cl_xh,y
STA !cl_xh,y
++
RTS

DatFireball:
db $A8,$AA,$AC,$AE
db $A8,$AA,$AC,$AE
db $60,$62,$64,$66

PropFireball:
db $3A,$3A,$3A,$3A
db $FA,$FA,$FA,$FA
db $3A,$3A,$3A,$3A

FireGFX:
LDA hydra.diesig
BEQ +
CMP #$10
BCC +++
LDA #$00
STA !cl_n,y
BRA ++++
+++
AND #$0F
LSR : LSR
CLC : ADC #$07
BRA ++
+
LDA !cl_t1,y   
AND #$0F    
LSR
++
TAX
LDA DatFireball,x
STA $00
LDA PropFireball,x
LDX !cl_u,y
BMI +
EOR #$40
+
STA $01
LDA !cl_y,y
SEC : SBC $1C
CMP #$F0
BCC +
LDX !cl_yh,y
BMI +
++++
PLA : PLA
JMP ClusterStart
+

LDX.w ClusterOAM,y
STA $6201,x

LDA !cl_x,y
SEC : SBC $1A
STA $6200,x

LDA $00
STA $6202,x
LDA $01
STA $6203,x

TXA : LSR : LSR : TAX
LDA #$02
STA $6420,x
RTS