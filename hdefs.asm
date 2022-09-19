includeonce

!topleft = $0000
!topleftl = !topleft&$ff
!toplefth = !topleft>>8

pushpc
org $000000
struct hydra $79F8 ;6de5

    .dirx:              skip 1
    .diry:              skip 1

    .fightstate:        skip 1
    .rotation:          skip 1
    .rotation_hi:       skip 1
    .comm_timer:        skip 1
    .hp:                skip 1
    .segments:          skip 1
    .canbehit:          skip 1
    .spinplatform:      skip 1
    
    .animation:         skip 1
    .anim_timer:        skip 1
    .anim_frame:        skip 1

    
    .last_cluster:      skip 1
    .cluster_slot:      skip 1
    .cluster_r1:        skip 1
    .cluster_r2:        skip 1
    .cl_init:           skip 1
    
    .generic_state:     skip 1
    .generic_timer:     skip 1
    .misc1:             skip 1
    .misc2:             skip 1
    
    .hoffx:             skip 1
    .seg1x:             skip 1
    .seg2x:             skip 1
    .seg3x:             skip 1
    .seg4x:             skip 1
    
    .hoffy:             skip 1
    .seg1y:             skip 1
    .seg2y:             skip 1
    .seg3y:             skip 1
    .seg4y:             skip 1
    
    .dmado:             skip 1
    .dmabank:           skip 1
    .dmasrc:            skip 2

	.moveamt:			skip 2
	.movetimer:			skip 1
	.specialflip:		skip 1  
	.misc3:				skip 1
	.misc4:				skip 1
	.lolspeed			skip 1
	.diesig				skip 1
	.crumble1			skip 1
	.crumble2			skip 1
	.crumble3			skip 1
	.crumble4			skip 1
    .end:
    
endstruct
pullpc
 
;SCUFFED ENUM
!ANIM_stop		=  #$00
!ANIM_idle		=  #$01
!ANIM_idle2		=  #$02
!ANIM_hdown		=  #$03
!ANIM_hup		=  #$04
!ANIM_fcharge	=  #$05
!ANIM_fidle		=  #$06
!ANIM_fend		=  #$07
!ANIM_hurt		=  #$08
!ANIM_death		=  #$09
!ANIM_tail		=  #$0A
!ANIM_chase		=  #$0B
!ANIM_rise		=  #$0C
!ANIM_halt		=  #$0D

!cl_size = 50
!cl_start = $64A0
!cl_start2 = $6F4A
!cl_start3 = $6DF5

!cl_n = !cl_start+(!cl_size*0) ;number
!cl_x = !cl_start+(!cl_size*1) ;xpos
!cl_y = !cl_start+(!cl_size*2) ;ypos
!cl_u = !cl_start+(!cl_size*3) ;xspd
!cl_v = !cl_start+(!cl_size*4) ;yspd
!cl_a = !cl_start+(!cl_size*5) ;accum
!cl_b = !cl_start+(!cl_size*6)
!cl_1 = !cl_start+(!cl_size*7);INTERNAL
!cl_2 = !cl_start+(!cl_size*8)

!cl_xh = !cl_start2             ;x hi
!cl_yh = !cl_start2+!cl_size    ;y hi

!cl_t1 = !cl_start3				;timer1
!cl_t2 = !cl_start3+!cl_size	;timer2

macro incloop(ram, until)
    LDA <ram>
    INC
    CMP <until>
    BNE 2
    LDA #$00
    STA <ram>
endmacro

macro setanim(anim)
	LDA #$00
	STA hydra.anim_timer
	STA hydra.anim_frame
	LDA <anim>
	STA hydra.animation
	LDA #$04
	STA hydra.specialflip
;LDA #$00
;STA hydra.anim_frame ;DEBUG
endmacro

macro stopanim()
STZ hydra.animation
;STZ hydra.anim_frame ;DEBUG
endmacro

macro setoffsets(table, num, start)
REP #$30
!a #= 0
while !a < <num>*2
LDA <table>+!a
STA hydra.hoffx+!a+<start>
!a #= !a+2
endif

SEP #$30
endmacro

macro CheckSegment()
    CPX hydra.segments
    BEQ SegmentOver
endmacro

macro clusterfinish()
LDA hydra.cluster_slot
INC
CMP #!cl_size
BNE 2
LDA #$00
STA hydra.cluster_slot
STA !cl_1,y
STA !cl_2,y
STA !cl_t1,y
STA !cl_t2,y
endmacro

!ClRingFlame = $01
!ClGP = $02
!ClRingFlameAlt = $03
!ClParticle = $04
!ClParticleAlt = $05


			!RAM_FrameCounter	= $13
			!RAM_FrameCounterB	= $14
			!RAM_ScreenBndryXLo	= $1A
			!RAM_ScreenBndryYLo	= $1C
			!RAM_MarioDirection	= $76
			!RAM_MarioSpeedX	= $7B
			!RAM_MarioSpeedY	= $7D
			!RAM_MarioXPos		= $94
			!RAM_MarioXPosHi	= $95
			!RAM_MarioYPos		= $96
			!RAM_SpritesLocked	= $9D
			!RAM_SpriteNum		= !9E
			!RAM_SpriteSpeedY	= !AA
			!RAM_SpriteSpeedX	= !B6
			!RAM_SpriteState	= !C2
			!RAM_SpriteYLo		= !D8
			!RAM_SpriteXLo		= !E4
			!OAM_DispX		= $0300|!Base2
			!OAM_DispY		= $0301|!Base2
			!OAM_Tile		= $0302|!Base2
			!OAM_Prop		= $0303|!Base2
			!OAM_Tile2DispX		= $0304|!Base2
			!OAM_Tile2DispY		= $0305|!Base2
			!OAM_Tile2		= $0306|!Base2
			!OAM_Tile2Prop		= $0307|!Base2
			!OAM_TileSize		= $0460|!Base2
			!RAM_RandomByte1	= $148D|!Base2
			!RAM_RandomByte2	= $148E|!Base2
			!RAM_KickImgTimer	= $149A|!Base2
			!RAM_SpriteYHi		= !14D4
			!RAM_SpriteXHi		= !14E0
			!RAM_Reznor1Dead	= $1520|!Base2
			!RAM_Reznor2Dead	= $1521|!Base2
			!RAM_Reznor3Dead	= $1522|!Base2
			!RAM_Reznor4Dead	= $1523|!Base2
			!RAM_DisableInter	= !154C
			!RAM_SpriteDir		= !157C
			!RAM_SprObjStatus	= !1588
			!RAM_OffscreenHorz	= !15A0
			!RAM_SprOAMIndex	= !15EA
			!RAM_SpritePal		= !15F6
			!RAM_Tweaker1662	= !1662
			!RAM_ExSpriteNum	= $170B|!Base2
			!RAM_ExSpriteYLo	= $1715|!Base2
			!RAM_ExSpriteXLo	= $171F|!Base2
			!RAM_ExSpriteYHi	= $1729|!Base2
			!RAM_ExSpriteXHi	= $1733|!Base2
			!RAM_ExSprSpeedY	= $173D|!Base2
			!RAM_ExSprSpeedX	= $1747|!Base2
			!RAM_OffscreenVert	= !186C
			!RAM_OnYoshi		= $187A|!Base2

			!RAM_ExtraBits 		= !7FAB10
			!RAM_NewSpriteNum	= !7FAB9E