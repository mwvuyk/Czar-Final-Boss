!FrameLength = $07

DoFramalCode:
    LDA hydra.animation
    JSL $0086DF
    dw $0000
    dw .idle
    dw .idle2
    dw .hdown
    dw .hup
    dw .fcharge
    dw .fidle
    dw .fend
    dw .hurt
    dw .death
    dw .tail
    dw .chase
    dw .rise
    dw .halt

.idle
    LDA #!FrameLength
    STA hydra.anim_timer
    INC hydra.anim_frame
    LDA hydra.anim_frame
    CMP #$04
    BNE +
    STZ hydra.anim_frame
    +
RTS
.idle2
    LDA #!FrameLength
    STA hydra.anim_timer
    INC hydra.anim_frame
    LDA hydra.anim_frame
    CMP #$0A
    BNE +
    STZ hydra.anim_frame
    +
    CMP #$04
    BNE +
    LDA #!FrameLength*4
    STA hydra.anim_timer
    +
RTS
.hdown

    LDA #!FrameLength
    STA hydra.anim_timer
    INC hydra.anim_frame
    LDA hydra.anim_frame
    CMP #$12
    BNE +
    %setanim(!ANIM_chase)
    LDA #$01
    STA hydra.specialflip
    +
    CMP #$09
    BNE +
    LDA #$01
    STA hydra.specialflip
    STZ hydra.canbehit
    +
RTS
.hup
    LDA #!FrameLength
    STA hydra.anim_timer
    INC hydra.anim_frame
    LDA hydra.anim_frame
    CMP #$0B
    BNE +
    STZ hydra.canbehit
    %stopanim()
    +
RTS
.fcharge
    LDA #!FrameLength
    SEC : SBC hydra.lolspeed
    STA hydra.anim_timer
    INC hydra.anim_frame
    LDA hydra.anim_frame
    CMP #$0B
    BNE +
    %setanim(!ANIM_fidle)
    RTS
    +
    CMP #$09
    BNE +
    JSR SpawnParticles
    +
    CMP #$03
    BNE +
    LDA #$10    ;sound
    STA $7DF9
    +
RTS
.fidle
    LDA #!FrameLength
    STA hydra.anim_timer
    INC hydra.anim_frame
    LDA hydra.anim_frame
    CMP #$04
    BNE +
    STZ hydra.anim_frame
    +
RTS
.fend
    LDA #!FrameLength
    SEC : SBC hydra.lolspeed
    STA hydra.anim_timer
    INC hydra.anim_frame
    LDA hydra.anim_frame
    CMP #$04
    BNE +
    %setanim(!ANIM_idle)
    +
RTS
.hurt
    LDA.b #!inity&$ff
    STA !RAM_SpriteYLo,x
    LDA.b #!inity>>8
    STA !RAM_SpriteYHi,x
    LDA #!FrameLength
    STA hydra.anim_timer
    INC hydra.anim_frame
    LDA hydra.anim_frame
    CMP #$0C
    BNE +
    %setanim(!ANIM_hdown)
    LDA #$06
    STA hydra.anim_frame
    RTS
    +
    CMP #$07
    BNE +
    LDA #!FrameLength*3
    STA hydra.anim_timer
    RTS
    +
    CMP #$03
    BNE +
    LDA #$05
    STA hydra.specialflip
    RTS
    +
    CMP #$09
    BNE +
    LDA #$04
    STA hydra.specialflip
    RTS
    +
    CMP #$01
    BNE +
    LDA #$25
    STA $7DF9
    RTS
    +
RTS
.death
    LDA #$05
    STA hydra.specialflip
    LDA #$FF
    STA hydra.anim_timer
    INC hydra.anim_frame
RTS
.tail
    %stopanim()
RTS

.chase
    LDA #!FrameLength
    STA hydra.anim_timer
    INC hydra.anim_frame
    LDA hydra.anim_frame
    CMP #$08
    BNE +
    STZ hydra.anim_frame
    RTS
    +
    CMP #$01
    BNE +
    LDA #$25
    STA $7DF9
    RTS
    +
RTS

.rise
    LDA #!FrameLength
    STA hydra.anim_timer
    LDA hydra.anim_frame
    BNE +
    LDA #!FrameLength*2
    STA hydra.anim_timer
    +
    INC hydra.anim_frame
    LDA hydra.anim_frame
    CMP #$08
    BNE +
    %setanim(!ANIM_idle)
    +
RTS

.halt
    LDA #!FrameLength
    STA hydra.anim_timer
    INC hydra.anim_frame
    LDA hydra.anim_frame
    CMP #$06
    BNE +
    %setanim(!ANIM_idle)
    +
    CMP #$01
    BEQ +
    CMP #$02
    BEQ +
    BRA ++
    +
    LDA #$01
    STA hydra.specialflip
    RTS
    ++
    LDA #$04
    STA hydra.specialflip
RTS

SpawnParticles:
    LDX $75E9
    LDY hydra.cluster_slot
    LDA #!ClParticle
    STA !cl_n,y
    
    LDA #$00
    STA !cl_xh,y
    STA !cl_yh,y
    STA !cl_v,y
    LDA !RAM_SpriteXLo,x
    STA !cl_x,y
    LDA !RAM_SpriteYLo,x
    STA !cl_y,y
    LDA #$07
    SEC : SBC hydra.lolspeed
    STA !cl_u,y

    %clusterfinish()

    LDX $75E9
    LDY hydra.cluster_slot
    LDA #!ClParticleAlt
    STA !cl_n,y
    
    LDA #$00
    STA !cl_xh,y
    STA !cl_yh,y
    STA !cl_v,y
    LDA !RAM_SpriteXLo,x
    SEC : SBC #11
    STA !cl_x,y
    LDA !RAM_SpriteYLo,x
    CLC : ADC #35
    STA !cl_y,y
    LDA #$07
    SEC : SBC hydra.lolspeed
    STA !cl_u,y
   
    %clusterfinish()
    RTS