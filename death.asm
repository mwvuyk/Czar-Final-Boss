PreDeath:
    LDA #$01
    STA $73FB
    INC hydra.diesig
    LDA hydra.anim_frame
    CMP #$03
    BNE +
    LDA #$03
    STA hydra.fightstate
    DEC hydra.hp
    STZ hydra.generic_state
    LDA #$05
    STA hydra.generic_timer 
    LDA #$FF
    STA $7DFB
    +
    RTS

DeathRoutine:
    LDA hydra.animation;hold frame 7 of hurt
    CMP !ANIM_hurt
    BNE +
    LDA hydra.anim_frame
    CMP #$07
    BNE +
    LDA #$01
    STA hydra.anim_timer
    + 
    
    LDA hydra.generic_state
    JSL $0086DF

    dw WaitForHurtSeven
    dw Crumble3
    dw Crumble3
    dw Crumble2
    dw Crumble2
    dw Crumble1
    dw Crumble1
    dw Crumble4
    dw Crumble4
    dw Boom3
    dw Boom2
    dw Boom1
    dw Boom4
    dw WindowFadeout
    dw Noneasddsadsa
!crumbletime = $08
!boomtime = $05



Noneasddsadsa:
DEC hydra.generic_timer
LDA hydra.generic_timer
BNE +
LDA #$18
STA $6100
LDA #$08
STA $73C6

+
RTS

macro boom(x)
Boom<x>:
    DEC hydra.generic_timer
    BNE +
    LDA #!boomtime
    STA hydra.generic_timer
    INC hydra.crumble<x>
    LDA hydra.crumble<x>
    CMP #$06
    BNE +
    LDA #$09
    STA $7DFC
    RTS
    +
    CMP #$0B
    BNE +
    DEC hydra.segments
    INC hydra.generic_state
    +
    RTS

endmacro

%boom(1)
%boom(2)
%boom(3)

Boom4:
    DEC hydra.generic_timer
    BNE +
    LDA #!crumbletime
    STA hydra.generic_timer
    STZ hydra.anim_timer
    LDA hydra.anim_frame
    CMP #$05
    BNE +
    LDA #$1E
    STZ hydra.misc1
    STA hydra.misc2
    INC hydra.generic_state
    LDA #$18
    STA $7DFC
    +
RTS

macro crumble(x)
Crumble<x>:

    DEC hydra.generic_timer
    BNE +
    LDA #!crumbletime
    STA hydra.generic_timer
    INC hydra.crumble<x>
    INC hydra.generic_state        
    +
    RTS
endmacro

%crumble(1)
%crumble(2)
%crumble(3)

    Crumble4:
    DEC hydra.generic_timer
    BNE +
    LDA #!crumbletime
    STA hydra.generic_timer
    STZ hydra.anim_timer
    INC hydra.generic_state
    +
    RTS

    
WaitForHurtSeven:
    LDA hydra.animation ;hold frame 7 of hurt
    CMP !ANIM_hurt
    BNE +
    LDA hydra.anim_frame
    CMP #$07
    BNE +
    INC hydra.anim_timer
    INC hydra.generic_state
    %setanim(!ANIM_death)
    + 
RTS

!frames 		= $1E			; The number of frames in the fade-in.


WindowFadeout:
LDA !RAM_SpriteXLo,x
STA $0A
LDA !RAM_SpriteYLo,x
STA $0C
LDA !RAM_SpriteXHi,x
STA $0B
LDA !RAM_SpriteYHi,x
STA $0D
DEC hydra.generic_timer
LDA hydra.generic_timer
BNE +
LDA #$03
STA hydra.generic_timer
+
RTS

