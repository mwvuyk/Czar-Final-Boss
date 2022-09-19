


!size1 = $0440
!size2 = $0040

DoAnimations:
    LDA hydra.animation
    BNE +
    RTS
    +

    LDA hydra.anim_timer
    BEQ +
    DEC hydra.anim_timer
    RTS

    +
    PHX
    PHY
    

    LDA hydra.anim_frame
    ASL
    TAY

    LDA hydra.animation
    TAX
    LDA animbankptrs,x
    STA hydra.dmabank
    
    TXA
    ASL
    TAX


    LDA hydra.diry
    ASL : CLC : ADC hydra.dirx
    ASL : STA $00
    ASL : ASL : CLC : ADC $00
    ;this is dumb
    REP #$20
    AND #$00FF
    CLC : ADC #flipn            
    STA $02

    LDA foptrs,x
    STA $00
    LDA animptrs,x
    CLC : ADC ($00),y
    STA hydra.dmasrc

    LDA bodyptrs,x
    CLC : ADC bodyoffset,y
    JSR SetBodyOffsets
    SEP #$20
    LDA hydra.dirx
    BEQ +
    LDA hydra.hoffx
    SEC : SBC #$10
    STA hydra.hoffx;why is this needed
    +

    LDA #$01
    STA hydra.dmado
    JSR DoFramalCode
    PLY
    PLX

RTS


SetBodyOffsets:
    STA $00
    LDY #$08
    -
    LDA ($00),y
    EOR ($02),y
    STA hydra.hoffx,y
    DEY : DEY
    BPL -
    RTS

flipn:
db $00,$00,$00,$00,$00
db $00,$00,$00,$00,$00

flipx:
db $FF,$FF,$FF,$FF,$FF
db $00,$00,$00,$00,$00

flipy:
db $00,$00,$00,$00,$00
db $FF,$FF,$FF,$FF,$FF

flipb:
db $FF,$FF,$FF,$FF,$FF
db $FF,$FF,$FF,$FF,$FF

animbankptrs:
db $00
db #idle>>16
db #idle2>>16
db #hdown>>16
db #hup>>16
db #fcharge>>16
db #fidle>>16
db #fend>>16
db #hurt>>16
db #death>>16
db #tail>>16
db #chase>>16
db #hup>>16 ;rise
db #hdown>>16 ;halt

animptrs:
dw $0000
dw #idle
dw #idle2
dw #hdown
dw #hup
dw #fcharge
dw #fidle
dw #fend
dw #hurt
dw #death
dw #tail
dw #chase
dw #hup ;rise
dw #hdown ;halt

foptrs:
dw $0000
dw #frameoffset
dw #frameoffset
dw #frameoffsethdown
dw #frameoffsethup
dw #frameoffset
dw #frameoffset
dw #frameoffset
dw #frameoffset
dw #frameoffset
dw #frameoffset
dw #frameoffset
dw #frameoffsetrise
dw #frameoffsethalt

frameoffset:
!i #= 0
while !i < 14
    dw (!size1+!size2)*!i
    !i #= !i+1
endif

frameoffsethup:
!i #= 0
while !i < 4 ;0123
    dw (!size1+!size2)*!i
    !i #= !i+1
endif
dw (!size1+!size2)*!i : dw (!size1+!size2)*!i : dw (!size1+!size2)*!i ;555
!i #= !i+1
while !i < 14 ;6etc
    dw (!size1+!size2)*!i
    !i #= !i+1
endif

frameoffsethdown:
dw (!size1+!size2)*0 : dw (!size1+!size2)*1 : dw (!size1+!size2)*2 : dw (!size1+!size2)*3 : dw (!size1+!size2)*4 : dw (!size1+!size2)*4
dw (!size1+!size2)*5 : dw (!size1+!size2)*6 : dw (!size1+!size2)*7 : dw (!size1+!size2)*8 : dw (!size1+!size2)*8 : dw (!size1+!size2)*8
dw (!size1+!size2)*8 : dw (!size1+!size2)*8 : dw (!size1+!size2)*13 : dw (!size1+!size2)*14 : dw (!size1+!size2)*15 : dw (!size1+!size2)*16

frameoffsetrise:
!i #= 9
while !i > 0 
    !i #= !i-1
    dw (!size1+!size2)*!i
endif

frameoffsethalt:
dw (!size1+!size2)*13 : dw (!size1+!size2)*14
dw (!size1+!size2)*8 : dw (!size1+!size2)*7 : dw (!size1+!size2)*6 : dw (!size1+!size2)*5

bodyptrs:
dw $0000
dw #idleoffsets
dw #idleoffsets
dw #hdownoffsets
dw #hupoffsets
dw #fchargeoffsets
dw #fidleoffsets
dw #hdownoffsets
dw #hurtoffsets
dw #deathoffsets
dw #tailoffsets
dw #chaseoffsets
dw #riseoffsets
dw #haltoffsets

!size3 = $000A
bodyoffset:
!j = 0
while !j < 18
    dw (!size3)*!j
    !j #= !j+1
endif

initoffsets: ;x above y
    db 0, -4, 9, 4, 0
    db 0, 31, 54, 81, 0

;so its
;head x, seg1x, seg2x, seg3x, tailx
;head y, sex1y,seg2y,seg3y, taily

;initoffsets: ;x above y
;>>ANIMATION: idle
idleoffsets:
    ;frame 1:
        db 0, -4, 9, 5, 0
        db 0, 31, 55, 82, 0

    ;frame 2:
        db 0, -3, 9, 4, 0
        db 0, 31, 54, 82, 0

    ;frame 3:
        db 0, -3, 10, 4, 0
        db 0, 32, 54, 83, 0

    ;frame 4:
        db 0, -4, 10, 5, 0
        db 0, 32, 55, 83, 0
fidleoffsets:
    ;frame 1:
        db 0, -4, 9, 5, 0
        db 0, 31, 55, 82, 0

    ;frame 2:
        db 0, -3, 9, 4, 0
        db 1, 31, 54, 82, 0

    ;frame 3:
        db 0, -3, 10, 4, 0
        db 1, 32, 54, 83, 0

    ;frame 4:
        db 0, -4, 10, 5, 0
        db 0, 32, 55, 83, 0
hdownoffsets:
    ;>>ANIMATION: head down
    ;should play directly after the 4th frame of the idle animation
    ;if it plays after an animation that's NOT the idle one, it should start from frame 7
    ;frame 1:
        db 0, -4, 9, 5, 0
        db 0, 31, 55, 82, 0

    ;frame 2:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 82, 0

    ;frame 3:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

    ;frame 4:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

    ;frame 5:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

    ;frame 6:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

    ;frame 7:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

    ;frame 8:
        db 0, -4, 7, 5, 0
        db 0, 30, 54, 80, 0

    ;frame 9:
        db 0, -5, -4, 6, 0 
        db 0, 28, 54, 76, 0

    ;frame 10:
    ;segments 1 and 3 are y-flipped in this frame
        db 0, -5, -9, 6, 0 
        db 0, 28, 52, 74, 0
    ;>>ANIMATION: chase start
    ;segments 1 and 3 are y-flipped in all frames of this animation
    ;starts immediately after the last frame of the previous animation
    ;frame 1:
        db 0, -5, -9, 6, 0 
        db 0, 28, 52, 74, 0

    ;frame 2:
        db 0, -5, -9, 8, 0 
        db 0, 28, 52, 73, 0

    ;frame 3:
        db 0, -5, -7, 12, 0 
        db 0, 28, 51, 71, 0

    ;frame 4:
        db 0, -5, -3, 14, 0 
        db 0, 28, 50, 73, 0

    ;frame 5:
    ;use the graphics from the "chase" section of the .bin file from here on, starting, fittingly, from frame 5
        db 0, -3, -1, 15, 0 
        db 1, 27, 51, 74, 0

    ;frame 6:
        db 2, 1, 0, 13, 0 
        db -1, 26, 52, 75, 0

    ;frame 7:
        db 6, 3, -2, 9, 0 
        db -2, 27, 53, 76, 0

    ;frame 8:
        db 8, 4, -6, 7, 0 
        db -1, 28, 54, 75, 0

hupoffsets:
    ;>>ANIMATION: head up (diving)
    ;if it plays after an animation that's NOT the idle one, it should start from frame 7
    ;frame 1:
        db 0, -4, 9, 5, 0
        db 0, 31, 55, 82, 0

    ;frame 2:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 82, 0

    ;frame 3:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

    ;frame 4:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

    ;frame 5:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

    ;frame 6:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

    ;frame 7:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

    ;frame 8:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

    ;frame 9:
        db 0, 1, 11, 8, 0
        db 0, 31, 54, 81, 0

    ;frame 10:
        db 0, 15, 19, 12, 0
        db 0, 31, 54, 81, 0

    ;frame 11:
        db 0, 17, 21, 14, 0
        db 0, 31, 54, 81, 0

    ;frame 12:
        db 0, 17, 21, 14, 0
        db 0, 31, 54, 81, 0

fchargeoffsets:
    ;>>ANIMATION: charging flame (it's the same for both when the fireballs from the attack spread out from his mouth or gather in it)
    ;frame 1:
        db 0, -4, 9, 5, 0
        db 0, 31, 55, 82, 0

    ;frame 2:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 82, 0

    ;frame 3:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

    ;frame 4:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

    ;frame 5:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

    ;frame 6:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

    ;frame 7:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

    ;frame 8:
        db 0, -3, 10, 5, 0
        db 0, 32, 53, 80, 0

    ;frame 9:
        db 0, -6, 7, 2, 0
        db 0, 29, 54, 83, 0

    ;frame 10:
        db 0, -5, 8, 3, 0
        db 0, 30, 54, 82, 0

    ;frame 11:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

    ;the following coordinates are for the yellow stuff that comes out of the fins starting from frame 9

    ;frame 1
        db 0, -11 ;first value is the top one, the second value is the bottom one
        db 0, 35 ;idk if this format is even supposed to be used for this as well but lol

    ;frame 2
        db 0, -11
        db -2, 37

    ;frame 3
        db 0, 0
        db -3, 38
snakeoffset:
    ;>>TAIL SETUP
    ;all it does is rise up from the lava and into mario in a straight line, so there's no difference in the placement of the segments since there's no real animation going on here
    ; also uhhh I think his tail will be a separate sprite for the stabbing attack? there's no head here since his head will be in the lava on the other side of the screen :derpyoshi:
    ;so his tail is at the top, where he head would be in the other animation instructions, aka the 1st x and y values
        db 0, 0, 0, 0		
        db 0, 24, 44, 69
    ;all segments are x-flipped
    ;segment 2 is y-flipped


hurtoffsets:
    ;>>ANIMATION: hurt
    ;frame 1:
        db 0, -4, 9, 5, 0
        db 0, 31, 55, 82, 0

    ;frame 2:
        db 0, -1, 13, 9, 0
        db 0, 32, 52, 74, 0

    ;frame 3:
        db 0, 2, 16, 12, 0
        db 5, 35, 56, 77, 0

    ;frame 4:
    ;segment 1 is y-flipped in this frame
        db 0, -8, -14, -7, 0
        db 0, 32, 58, 82, 0

    ;after frame 4, his body segments stay in the same general place -- since they have to shake around to make snake sans' pain convincing -- and only his head changes graphics
        db 0, -8, -14, -7, 0
        db 0, 32, 58, 82, 0
    ;the next frames are for the transition back into idling
    ;after frame 4, his body segments stay in the same general place -- since they have to shake around to make snake sans' pain convincing -- and only his head changes graphics
        db 0, -8, -14, -7, 0
        db 0, 32, 58, 82, 0
    ;the next frames are for the transition back into idling
    ;after frame 4, his body segments stay in the same general place -- since they have to shake around to make snake sans' pain convincing -- and only his head changes graphics
        db 0, -8, -14, -7, 0
        db 0, 32, 58, 82, 0
    ;frame 6:
        db 0, 2, -2, 0, 0
        db 0, 28, 49, 75, 0

    ;frame 7:
        db 0, -3, 1, 0, 0
        db 0, 33, 54, 80, 0

    ;frame 8:
        db 0, -1, 12, 7, 0
        db 0, 34, 56, 84, 03

    ;frame 9:
        db 0, -1, 12, 7, 0
        db 0, 34, 56, 84, 0

    ;frame 10:
        db 0, -4, 9, 5, 0
        db 0, 31, 55, 82, 0

    ;frame 11:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 82, 0

    ;frame 12:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

    ;frame 13:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

deathoffsets:
        db 0, -8, -14, -7, 0
        db 0, 32, 58, 82, 0
                db 0, -8, -14, -7, 0
        db 0, 32, 58, 82, 0
                db 0, -8, -14, -7, 0
        db 0, 32, 58, 82, 0
                db 0, -8, -14, -7, 0
        db 0, 32, 58, 82, 0
                db 0, -8, -14, -7, 0
        db 0, 32, 58, 82, 0
                db 0, -8, -14, -7, 0
        db 0, 32, 58, 82, 0
                db 0, -8, -14, -7, 0
        db 0, 32, 58, 82, 0
                db 0, -8, -14, -7, 0
        db 0, 32, 58, 82, 0
                db 0, -8, -14, -7, 0
        db 0, 32, 58, 82, 0
                db 0, -8, -14, -7, 0
        db 0, 32, 58, 82, 0
tailoffsets:
    db -24, -4, 9, 4, -0
    db -94, -71, -48, -21, -0

chaseoffsets:
    ;>>ANIMATION: chasing
    ;segments 1 and 3 are y-flipped in all frames of this animation
    ;starts immediately after the last frame of the previous animation and loops on and on for as long as the attack lasts
    ;frame 1:
        db 9, 2, -8, 6, 0 
        db 0, 29, 53, 74, 0

    ;frame 2:
        db 6, -2, -9, 8, 0 
        db 2, 30, 52, 73, 0

    ;frame 3:
        db 2, -4, -7, 12, 0 
        db 3, 29, 51, 71, 0

    ;frame 4:
        db 1, -5, -3, 14, 0 
        db 2, 28, 50, 73, 0

    ;frame 5:
        db 0, -3, -1, 15, 0 
        db 1, 27, 51, 74, 0

    ;frame 6:
        db 2, 1, 0, 13, 0 
        db -1, 26, 52, 75, 0

    ;frame 7:
        db 6, 3, -2, 9, 0 
        db -2, 27, 53, 76, 0

    ;frame 8:
        db 8, 4, -6, 7, 0 
        db -1, 28, 54, 75, 0

riseoffsets:
    ;frame 12:
        db 0, 17, 21, 14, 0
        db 0, 31, 54, 81, 0
    ;frame 11:
        db 0, 17, 21, 14, 0
        db 0, 31, 54, 81, 0
    ;frame 10:
        db 0, 15, 19, 12, 0
        db 0, 31, 54, 81, 0
    ;frame 9:
        db 0, 1, 11, 8, 0
        db 0, 31, 54, 81, 0
    ;frame 8:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0
    ;frame 7:
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

haltoffsets:
        ;>>ANIMATION: chase end
    ;starts immediately after the last loop of the chasing animation
    ;frame 1:
    ;head graphics are the same as in frame 1 of the chasing animation
    ;(because these first two frames are just repeats of the first two frames of that animation)
    ;segments 1 and 3 are y-flipped in this frame
        db 9, 2, -8, 6, 0 
        db 0, 29, 53, 74, 0

    ;frame 2:
    ;head graphics are the same as in frame 2 of the chasing animation
    ;segments 1 and 3 are y-flipped in this frame
        db 6, -2, -9, 8, 0 
        db 2, 30, 52, 73, 0

    ;frame 3:
    ;head graphics are the same as in frame 9 of "head down"
    ;(these frames are just "head down" playing backwards starting from frame 9 and stopping at frame 6 lol)
        db 0, -5, -4, 6, 0 
        db 0, 28, 54, 76, 0

    ;frame 4:
    ;head graphics are the same as in frame 8 of "head down"
        db 0, -4, 7, 5, 0
        db 0, 30, 54, 80, 0

    ;frame 5:
    ;head graphics are the same as in frame 7 of "head down"
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0

    ;frame 6:
    ;head graphics are the same as in frame 6 of "head down"
        db 0, -4, 9, 4, 0
        db 0, 31, 54, 81, 0






