optimize dp always
optimize address mirrors

!debug = $00

!oam_i = $0300|!addr
!oam_x = !oam_i
!oam_y = !oam_i+1
!oam_t = !oam_i+2
!oam_p = !oam_i+3

!inity = !topleft+$0060


!inithp = $03 ;should be 03

!dir = !1510
!necklength = !151C
!wiggle = !1504

incsrc prot.asm ;MUST BE FIRST
incsrc hdefs.asm

incsrc animations.asm 
incsrc framalcode.asm
incsrc clusters.asm
incsrc attacks.asm
incsrc drawroutines.asm
incsrc death.asm
;initoffsets: ;x above y
;    db 0, -4, 9, 4, 0
;    db 0, 31, 54, 81, 0




print "INIT ",pc
PHB : PHK : PLB

rep #$20
STZ $7411
LDY #$7E
LDA #$0000
-
STA hydra.dirx,y
DEY : DEY
BPL -

SEP #$20

    LDA #$08                ;oam order bullshit
    STA !RAM_SpriteXLo,x

    %setoffsets(initoffsets, 5, 0)
    PLB
RTL

print "MAIN ",pc
PHB : PHK : PLB


LDA hydra.cl_init
CMP #$F7
BEQ +
JSR CleanRAM

;INIT

    LDA #!inithp
    STA hydra.hp
    LDA #$03
    STA hydra.segments
    LDA #$F7
    STA hydra.cl_init
    LDA #$05
    STA hydra.comm_timer
    LDA #$04
    STA hydra.specialflip
    %setanim(!ANIM_idle)
+

JSR SpriteCode
PLB
RTL

Debug:

LDA #$01
STA $19
;LDA $16
;AND #$01
;BEQ +
;    LDA #$04
;    STA hydra.specialflip
;INC hydra.animation
;STZ hydra.anim_frame
;STZ hydra.anim_timer
;+
;LDA $16
;AND #$02
;BEQ +
;    LDA #$04
;    STA hydra.specialflip
;DEC hydra.animation
;STZ hydra.anim_frame
;STZ hydra.anim_timer
;+

LDA $16;move on state
AND #$20
BEQ +
LDA #$02
STA hydra.fightstate
LDA #$80
STA hydra.comm_timer
%setanim(!ANIM_hdown)
+
RTS

SpriteCode:


    LDA $9D
    BEQ +
    
    JSR Graphics
    JSR ClusterHandler
    LDA $1E
    STA $22
    RTS
+

    JSR StateMachine
    JSL $01801A ; y speed
    JSL $018022 ; x speed

    LDA hydra.animation
    CMP !ANIM_death
    BEQ +
    JSR ClusterHandler
    +

    if !debug
    JSR Debug
    endif
    
    JSR DoAnimations

    LDA hydra.hp
    BEQ +
    JSR DoHit     
    +

    JSR Graphics
    
RTS

StateMachine:
            LDA hydra.fightstate
            JSL $0086DF
            dw Intro
            dw StateRaiseBall
            dw HitCleanUpAtk
            dw PostAtkPhase
            dw CleanBefore



Intro:
    LDA !RAM_SpriteYHi,x ;Rise.
    XBA
    LDA !RAM_SpriteYLo,x
    REP #$20
    DEC : DEC
    CMP #!inity
    SEP #$20
    BNE +
    
    PHA
    LDA #$01
    STA hydra.fightstate
    PLA
    
    +
    STA !RAM_SpriteYLo,x
    XBA
    STA !RAM_SpriteYHi,x
    
    LDA hydra.comm_timer
    LDA #$01
    STA hydra.animation
    RTS
    +
    DEC hydra.comm_timer
    RTS

StateRaiseBall:
    LDA hydra.hp
    CMP #$03
    BNE +
    PHX
    JSR PhaseOneRaise
    PLX
    RTS
    +
    CMP #$02
    BNE +
    PHX
    JSR PhaseTwoRaise
    PLX
    RTS
    +
    PHX
    JSR PhaseThreeRaise
    PLX
    RTS

HitCleanUpAtk:
    lda hydra.hp
    cmp #$01
    BEQ ++
    LDA #$01
    STA hydra.spinplatform
    INC hydra.diesig
    LDA hydra.animation
    CMP !ANIM_hdown
    BNE +
    LDA #$03
    STA hydra.fightstate
    DEC hydra.hp
    STZ hydra.generic_state
    STZ hydra.generic_timer
    LDA #$20
    STA hydra.movetimer
+
RTS
++  
    JSR PreDeath
    RTS

PostAtkPhase:
    LDA hydra.hp
    CMP #$03
    BNE +
    RTS
    +
    CMP #$02
    BNE +
    PHX
    LDA #$05
    STA hydra.misc4
    STZ hydra.misc3
    JSR PostPhaseOne
    PLX
    +
    CMP #$01
    BNE +
    PHX
    LDA #$0A
    STA hydra.misc4
    STZ hydra.misc3
    JSR PostPhaseOne
    PLX
    +
    CMP #$00
    BNE +
    PHX
    JSR DeathRoutine
    PLX
    +
RTS

CleanBefore:
DEC hydra.generic_timer
LDA hydra.generic_timer
BNE +
STZ hydra.spinplatform
LDA #$01
STA hydra.fightstate
STZ hydra.diesig
+
RTS

ResetState:
    STZ hydra.generic_timer
    STZ hydra.generic_state
RTS

















Graphics:
    %GetDrawInfo()

    PHX
    
;optimization   
    
    LDA hydra.diry : ASL
    ORA hydra.dirx : TAX
    LDA PROP,x
    STA $04
  
    LDA hydra.hoffx
    CLC : ADC $00
    STA $02
    
    LDA hydra.hoffy
    CLC : ADC $01
    STA $03
    
    JSR DrawHead
    
    LDA hydra.diry : ASL
    ORA hydra.dirx : TAX
    LDA NPROP,x
    STA $04    
    
    LDA hydra.diry : EOR #$01 : ASL
    ORA hydra.dirx : TAX
    LDA NPROP,x
    STA $05
    

    LDX #$00
    
    SegmentLoop:

macro segmentstuff(and)   
    %CheckSegment()
    JSR PrepSegment
    LDA hydra.specialflip
    AND #$<and>
    BNE ?succ
    JSR DrawSegment
    BRA ?succisdead
    ?succ
    JSR DrawSegmentYFlip
    ?succisdead
    INX
endmacro

    %segmentstuff(1)
    %segmentstuff(2)
    %segmentstuff(4)
    

    %CheckSegment()
    LDA hydra.seg4x
    CLC : ADC $00
    STA $02
    
    LDA hydra.seg4y
    CLC : ADC $01
    STA $03

    JSR DrawTail
    
    SegmentOver:
    PLX
    LDY #$02
    LDA #$29
    JSL $01B7B3|!BankB

RTS



DoHit:
    JSL $03B664 ;Mario Clipping

    LDA hydra.hoffx
    CLC : ADC #$08
    CLC
    BMI +
    ADC !E4,x
    STA $04
    LDA !14E0,x
    ADC #$00
    BRA ++
    +
    ADC !E4,x
    STA $04
    LDA !14E0,x
    ADC #$FF
    ++
    STA $0A
    
    LDA hydra.hoffy
    CLC : ADC #$10
    CLC
    BMI +
    ADC !D8,x
    STA $05
    LDA !14D4,x
    ADC #$00
    BRA ++
    +
    ADC !D8,x
    STA $05
    LDA !14D4,x
    ADC #$FF
    ++
    STA $0B    

    LDA #$20
    STA $06
    LDA #$18
    STA $07
    
    JSL $03B72B ;CheckForContact 
    BCS Hurt
    

    LDA #$18
    STA $06
    STA $07
    
    LDY hydra.segments
    DEY
-

    LDA hydra.seg1x,y
    CLC : ADC #$04
    CLC
    BMI +
    ADC !E4,x
    STA $04
    LDA !14E0,x
    ADC #$00
    BRA ++
    +
    ADC !E4,x
    STA $04
    LDA !14E0,x
    ADC #$FF
    ++
    STA $0A
    
    LDA hydra.seg1y,y
    CLC : ADC #$04
    CLC
    BMI +
    ADC !D8,x
    STA $05
    LDA !14D4,x
    ADC #$00
    BRA ++
    +
    ADC !D8,x
    STA $05
    LDA !14D4,x
    ADC #$FF
    ++
    STA $0B    
    
    JSL $03B72B
    BCS Hurt
    DEY
    BPL -
    
    BRA +
Hurt:
    JSL $00F5B7 
+
RTS


CleanRAM:
REP #$30
PHA
LDY #$01FE
LDA #$0000
-
STA !cl_start,y
DEY : DEY
BPL -

LDY #$0064
-
STA !cl_start2,y
DEY : DEY
BPL -

PLA
SEP #$30
RTS





wiggletable:
db -$03,-$03,-$03,-$03
db -$02,-$02,-$02
db -$01,-$01
db $00
db $01,$01
db $02,$02,$02
db $03,$03,$03,$03
db $02,$02,$02
db $01,$01
db $00
db -$01,-$01
db -$02,-$02,-$02
endwiggletable:
db -$03,-$03,-$03


