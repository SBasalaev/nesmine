; NESMine game
;   Code source file
;
; Author: Sergey Basalaev
; Copyright (C) 2009, 2014, Sergey Basalaev <sbasalaev@gmail.com>
;
; Redistribution and use in source and binary forms, with or without
; modification, are permitted provided that the following conditions
; are met:
; 1. Redistributions of source code must retain the above copyright
;    notice, this list of conditions and the following disclaimer.
; 2. Redistributions in binary form must reproduce the above copyright
;    notice, this list of conditions and the following disclaimer in the
;    documentation and/or other materials provided with the distribution.
; 3. The name of the author may not be used to endorse or promote products
;    derived from this software without specific prior written permission.
;
; THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
; IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
; OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
; IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
; INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
; NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
; DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
; THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
; (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
; THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

; ***** MACRO DEFINITIONS *****
#define NULL  0

;loads high byte of address in X and low one in Y
#define LOAD_ADDR(addr)      ldx #>(addr) : ldy #<(addr)

; ***** CONSTANT DEFINITIONS *****

;VRAM addresses
PAGE1_SYM   = $2000
PAGE1_ATTR  = $23C0
PAGE2_SYM   = $2800
PAGE2_ATTR  = $2BC0
PAL_BG      = $3F00
PAL_SPRITE  = $3F10

;tiles
TILE_OPEN   = $00       ;add number of mines to display it
TILE_CLOSED = $09       ;closed cell
TILE_FLAG   = $0A       ;cell with flag
TILE_MINE   = $0B       ;cell with mine
TILE_WRONG  = $0C       ;cell with wrong flag
TILE_CURSOR = $10       ;four tiles for cursor sprite
TILE_BANGUP = $14       ;top part of bang
TILE_BANGDN = $15       ;bottom part of bang
TILE_BANGLT = $16       ;left part of bang
TILE_BANGRT = $17       ;right part of bang

;sprite addresses
SPR_CURSOR  = $00
SPR_BANGUP  = $04
SPR_BANGDN  = $08
SPR_BANGLT  = $0C
SPR_BANGRT  = $10

;sprite offsets
SPR_X      = $03
SPR_Y      = $00
SPR_TILE   = $01
SPR_OPTS   = $02

;cell bits
CELL_MINE   = $01       ;mine in this cell
CELL_FLAG   = $02       ;this cell is flagged
CELL_OPEN   = $04       ;this cell is opened

; ***** VARIABLES *****

TMP         = $20;-$2F  ;16 temp variables, to avoid conflicts
                        ; should be only used by procedures which
                        ; do not call other procedures

TIMER       = $30;$31   ;increases at every VBlank

RND_JUNK    = $32       ;trailing bits of random seed
RND         = $33       ;pseudorandom seed

BTN_A       = $47       ;button states
BTN_B       = $46
BTN_SELECT  = $45
BTN_START   = $44
BTN_UP      = $43
BTN_DOWN    = $42
BTN_LEFT    = $41
BTN_RIGHT   = $40
BTN_OFFSET  = BTN_RIGHT-1

FIELD_W     = $50       ;field width
FIELD_H     = $51       ;field height
FIELD_XOFS  = $52       ;offset from the left margin
FIELD_MINES = $53       ;count of mines

CURSOR_X    = $54       ;column in which cursor is
CURSOR_Y    = $55       ;line on which cursor is

CURSOR_MODE = $56       ;cursor mode
                        ; 0 - hidden (space symbol)
                        ; 1 - shown (blinking brackets)

GAME_STATE  = $57       ;game state
                        ; =0 - game goes normal
                        ; >0 - player wins
                        ; <0 - player meets mine
                        
TO_OPEN     = $58;$59   ;amount of cells to open before winning
BANG_SPRITES= $60;-$6F  ;sprite data for the bang

FIELD_ADDR  = $200      ;field start address ($200-$3FF)

;video ports
VRAM_OPTS   = $2000     ;VRAM overall options
VRAM_SHOW   = $2001     ;VRAM visibility options
VRAM_STATE  = $2002     ;PPU state
SPRITE_ADDR = $2003     ;port to set sprite memory address
SPRITE_IO   = $2004     ;port to r/w sprite data
SCROLLING   = $2005     ;scrolling control
VRAM_ADDR   = $2006     ;port to set VRAM address
VRAM_IO     = $2007     ;port to r/w VRAM data

;joypad ports
JOYPAD1     = $4016
JOYPAD2     = $4017

; ***** CODE STARTS HERE *****
* = $C000

cursed:
	jmp cursed
reset:
	;initializing
	cld
	sei
	ldx #$FF            ;init stack
	txs
	lda #%10000000      ;enable VBlank
	sta VRAM_OPTS
	jsr sync
	LOAD_ADDR(PAGE1_ATTR)
	jsr setvramaddr
	lda #0
	ldx #$40
reset_clearattr:
	sta VRAM_IO
	dex
	bne reset_clearattr
	sta SCROLLING
	sta SCROLLING
	jsr sync
	lda #" "
	ldx #0
reset_clearsprites:
	sta SPRITE_IO
	dex
	bne reset_clearsprites
	;setting sprite palette
	jsr sync
	LOAD_ADDR(PAL_SPRITE)
	jsr setvramaddr
	LOAD_ADDR(spritepal)
	jsr print
	;setting cursor options
	lda #SPR_CURSOR+SPR_OPTS
	sta SPRITE_ADDR
	lda #0
	sta SPRITE_IO
	
; ***** STARTUP SCREEN *****
	
start:
	jsr lights_off
	jsr sprites_off
	jsr clear
	;drawing title
	jsr sync
	ldx #0
	ldy #11
	jsr setvrambyxy
	LOAD_ADDR(str_nesmine)
	jsr print
	LOAD_ADDR(str_empty)
	jsr print
	LOAD_ADDR(str_pstart)
	jsr print
	jsr lights_on
	;waiting for start button
	;this actually helps to randomize
start_wait:
	lda BTN_START
	beq start_wait
	jsr randomize

; ***** GAME MENU *****
	;to choose difficulty and show records
	;TODO game menu
	
	;field settings, now only hardcoded
	lda #10
	sta FIELD_MINES
	lda #16
	sta FIELD_H
	lda #16
	sta FIELD_W
	lsr
	eor #$ff
	adc #17             ; set to (16 - FIELD_W / 2)
	sta FIELD_XOFS      ; to center field on the screen


; ***** MINE FIELD *****

field:
	jsr lights_off
	;clearing mine field
	LOAD_ADDR(FIELD_ADDR)
	stx TMP+1
	sty TMP
	lda #0
	tay
field_clear1:
	sta (TMP), y
	iny
	bne field_clear1
	inc TMP+1
field_clear2:
	sta (TMP), y
	iny
	bne field_clear2
	;generating mines
	lda FIELD_MINES
	sta TMP+2
field_genmines:
field_genx:             ;generating x-coordinate
	jsr random
	lda RND
	and #$1F
	cmp FIELD_W
	bpl field_genx
	tax
field_geny:             ;generating y-coordinate
	jsr random
	lda RND
	and #$0F
	cmp FIELD_H
	bpl field_geny
	tay
	jsr celladdr        ;calculating address
	ldy #0              ;testing if already mine
	lda (TMP), y
	bne field_genmines
	lda #CELL_MINE      ;and finally placing explosive
	sta (TMP), y
	dec TMP+2
	bne field_genmines
	;drawing field
	jsr clear
	jsr sync
	LOAD_ADDR(PAGE1_SYM)
	jsr setvramaddr
	LOAD_ADDR(str_empty)
	jsr print
	LOAD_ADDR(str_nesmine)
	jsr print
	clc
	ldy FIELD_H
	sty TMP+2
field_drawline:         ;drawing a single line of the field
	jsr sync
	lda TMP+2
	adc #3
	tay
	ldx FIELD_XOFS
	jsr setvrambyxy
	lda #TILE_CLOSED
	ldx FIELD_W
field_drawcell:         ;drawing a single cell of the field
	sta VRAM_IO
	dex
	bne field_drawcell
	dec TMP+2
	bne field_drawline
	jsr lights_on
	lda #0
	sta CURSOR_X
	sta CURSOR_Y
	jsr movecursor

; ***** GAME LOOP *****

gameinit:
	;initializing game
	ldx #0
	stx GAME_STATE
	dex
	stx TO_OPEN+1       ;TO_OPEN = 0 - FIELD_MINES
	ldy FIELD_MINES
gameinit_decbymines:
	dex
	dey
	bne gameinit_decbymines
	stx TO_OPEN
	ldy FIELD_H
	clc
gameinit_calc_toopen:   ;TO_OPEN += FIELD_W * FIELD_H
	lda FIELD_W
	adc TO_OPEN
	sta TO_OPEN
	lda TO_OPEN+1
	adc #0
	sta TO_OPEN+1
	dey
	bne gameinit_calc_toopen
	lda #1
	sta CURSOR_MODE
	jsr sprites_on

gameloop:
	ldx #0
	ldy #4
	jsr pause
	;testing GAME_STATE
	lda GAME_STATE
	bpl gameloop_testwin
	jmp gamelost
gameloop_testwin:
	beq gameloop_a
	jmp gamewon
	;processing A button
gameloop_a:
	lda BTN_A
	beq gameloop_b
	jsr opencell
	;processing B button
gameloop_b:
	lda BTN_B
	beq gameloop_up
	jsr triggerflag
	;processing UP button
gameloop_up:
	lda BTN_UP
	beq gameloop_down
	ldy CURSOR_Y
	bne gameloop_up2
	ldy FIELD_H
gameloop_up2:
	dey
	sty CURSOR_Y
	jsr movecursor
	;processing DOWN button
gameloop_down:
	lda BTN_DOWN
	beq gameloop_left
	ldy CURSOR_Y
	iny
	tya
	cmp FIELD_H
	bne gameloop_down2
	ldy #0
gameloop_down2:
	sty CURSOR_Y
	jsr movecursor
	;processing LEFT button
gameloop_left:
	lda BTN_LEFT
	beq gameloop_right
	ldx CURSOR_X
	bne gameloop_left2
	ldx FIELD_W
gameloop_left2:
	dex
	stx CURSOR_X
	jsr movecursor
	;processing RIGHT button
gameloop_right:
	lda BTN_RIGHT
	beq gameloop_end
	ldx CURSOR_X
	inx
	txa
	cmp FIELD_W
	bne gameloop_right2
	ldx #0
gameloop_right2:
	stx CURSOR_X
	jsr movecursor
gameloop_end:
	jmp gameloop
	
; ***** GAME IS LOST *****
	
gamelost:
	;print regretful message
	jsr sync
	ldx #0
	ldy #21
	jsr setvrambyxy
	LOAD_ADDR(str_lost)
	jsr print
	LOAD_ADDR(str_pstart)
	jsr print
	jsr enddraw
	;draw bangs
	jsr drawbang
gamelost_wait:
	lda BTN_START
	beq gamelost_wait
	jmp start
	
; ***** GAME IS WON *****
	
gamewon:
	jsr sync
	ldx #0
	ldy #21
	jsr setvrambyxy
	LOAD_ADDR(str_won)
	jsr print
	LOAD_ADDR(str_pstart)
	jsr print
	jsr enddraw
gamewon_wait:
	lda BTN_START
	beq gamewon_wait
	jmp start
	
; ***** VBLANK INTERRUPT *****

nmi:
	;increasing timer
	inc TIMER
	bne nmi_timeskip
	inc TIMER+1         ;increasing high byte on overflow
nmi_timeskip:
	;saving joypad buttons
	ldx #$01
	stx JOYPAD1
	dex
	stx JOYPAD1
	ldx #8
nmi_btnload:
	lda JOYPAD1
	and #1
	sta BTN_OFFSET, x
	dex
	bne nmi_btnload
	;cursor animation
	lda CURSOR_MODE
	bne nmi_animcursor
	rti
nmi_animcursor:
	ldx #SPR_CURSOR+SPR_TILE
	stx SPRITE_ADDR
	lda TIMER
	clc
	lsr
	lsr
	lsr
	lsr
	and #3
	ora #$10
	sta SPRITE_IO
	rti

; ***** SUBROUTINES *****

;setvramaddr SUBROUTINE
;  sets VRAM I/O address
;Arguments:
;  X - high byte of address
;  Y - low byte of address
setvramaddr:
	stx VRAM_ADDR
	sty VRAM_ADDR
	rts

;setvrambyxy SUBROUTINE
;  sets VRAM I/O address on the cell with given coordinates
;Arguments:
;  X - x-coordinate of tile (0..32)
;  Y - y-coordinate of tile (0..24)
setvrambyxy:
	tya
	lsr
	lsr
	lsr
	clc
	adc #$20
	sta TMP+1
	tya
	asl
	asl
	asl
	asl
	asl
	sta TMP
	txa
	clc
	adc TMP
	tay
	ldx TMP+1
	jsr setvramaddr
	rts

;enddraw SUBROUTINE
;  should be called after drawing operations because for
;  some weird reason setting VRAM address scrolls screen
enddraw:
	ldx #0
	stx VRAM_ADDR
	stx VRAM_ADDR
	rts

;sync SUBROUTINE
;  waits for VBlank and then returns
sync:
	lda VRAM_STATE
	bpl sync
sync_2:
	lda VRAM_STATE
	bmi sync_2
	rts

;pause SUBROUTINE
;  syncs many times
;Arguments:
;  Y - time of pause
;  X - time of pause, small amount
pause:
	jsr sync
	dex
	bne pause
	dey
	bne pause
	rts

;print SUBROUTINE
;  prints data in VRAM
;  VRAM address should already be set
;  data is a null-terminated sequence of bytes
;  routine writes at most 256 bytes
;Arguments:
;  X - high byte of data address
;  Y - low byte of data address
print:
	stx TMP+1
	sty TMP
	ldy #0
print_loop:
	lda (TMP), y
	beq print_end
	sta VRAM_IO
	iny
	bne print_loop
print_end:
	rts

;lights_on SUBROUTINE
;  lightens display
lights_on:
	;Eins. Hier kommt die Sonne
	ldy #$5
	ldx #$0
	jsr pause
	LOAD_ADDR(PAL_BG)
	jsr setvramaddr
	LOAD_ADDR(bgpal_night)
	jsr print
	jsr enddraw
	;Zwei. Hier kommt die Sonne
	ldy #$5
	ldx #$0
	jsr pause
	LOAD_ADDR(PAL_BG)
	jsr setvramaddr
	LOAD_ADDR(bgpal_twilight)
	jsr print
	jsr enddraw
	;Drei. Sie ist der hellste Stern von allen
	ldy #$5
	ldx #$0
	jsr pause
	LOAD_ADDR(PAL_BG)
	jsr setvramaddr
	LOAD_ADDR(bgpal_day)
	jsr print
	jsr enddraw
	;Vier. Hier kommt die Sonne
	rts
	
;lights_off SUBROUTINE
;  darkens display
lights_off:
	;Eins. Hier kommt die Sonne
	ldy #5
	ldx #0
	jsr pause
	LOAD_ADDR(PAL_BG)
	jsr setvramaddr
	LOAD_ADDR(bgpal_twilight)
	jsr print
	jsr enddraw
	;Zwei. Hier kommt die Sonne
	ldy #5
	ldx #0
	jsr pause
	LOAD_ADDR(PAL_BG)
	jsr setvramaddr
	LOAD_ADDR(bgpal_night)
	jsr print
	jsr enddraw
	;Drei. Sie ist der hellste Stern von allen
	ldy #5
	ldx #0
	jsr pause
	LOAD_ADDR(PAL_BG)
	jsr setvramaddr
	LOAD_ADDR(bgpal_darkness)
	jsr print
	jsr enddraw
	;Vier. Und wird nie vom Himmel fallen
	rts
	
;sprites_on SUBROUTINE
;  shows sprites
sprites_on:
	lda #%00011110      ;show all
	sta VRAM_SHOW
	rts
	
;sprites_off SUBROUTINE
;   hides sprites
sprites_off:
	lda #%00001110      ;show all except sprites
	sta VRAM_SHOW
	rts

;randomize SUBROUTINE
;  initializes pseudorandom seed
randomize:
	lda TIMER
	sta RND
	lda TIMER+1
	sta RND_JUNK
	rts

;random SUBROUTINE
;  generates the next pseudorandom number
;  next seed is calculated by formula
;    RANDOM = RANDOM*13 + 41
;  RND is high byte of RANDOM
;  It can be erroneous but who cares?
;  And I feel like I should have done it simpler
random:
	;RND = RND * 13
	lda RND
	asl
	asl
	sta TMP
	asl
	clc
	adc TMP
	clc
	adc RND
	sta RND
	;RND += (RND_JUNK * 13) >> 8
	lda RND_JUNK
	lsr
	lsr
	lsr
	lsr
	lsr
	sta TMP
	lsr
	clc
	adc TMP
	adc RND
	sta RND
	;RND_JUNK = RND_JUNK * 13 + 41
	lda RND_JUNK
	asl
	asl
	sta TMP
	asl
	clc
	adc TMP
	clc
	adc RND_JUNK
	clc
	adc #41
	sta RND_JUNK
	;add carry to RND
	lda #0
	adc RND
	sta RND
	rts
	
;clear SUBROUTINE
;  clears screen
;  writes $3C0 spaces to the VRAM page 1
;  it syncs after each $C0 symbols written because
;  as strange as it can sound when VBlank comes
;  VRAM I/O address becomes random
;  
clear:
	LOAD_ADDR(PAGE1_SYM)
	stx TMP+1
	sty TMP
	ldy #5
clear_loop1:
	jsr sync
	lda TMP+1
	sta VRAM_ADDR
	lda TMP
	sta VRAM_ADDR
	lda #" "
	ldx #$C0
clear_loop2:
	sta VRAM_IO
	dex
	bne clear_loop2
	lda TMP
	clc
	adc #$C0
	sta TMP
	bcc clear_nocarry
	inc TMP+1
clear_nocarry:
	dey
	bne clear_loop1
	rts
	
;celladdr SUBROUTINE
;  gets cell address by it's coordinates
;  result is stored in TMP,TMP+1
;Arguments:
;  X - x coordinate, in tiles
;  Y - y coordinate, in tiles
celladdr:
	tya
	lsr
	lsr
	lsr
	clc
	adc #>(FIELD_ADDR)
	sta TMP+1
	tya
	asl
	asl
	asl
	asl
	asl
	sta TMP
	txa
	clc
	adc TMP
	sta TMP
	rts

;movecursor SUBROUTINE
;  moves cursor to it's current position
;  position is specified by CURSOR_X and CURSOR_Y
movecursor:
	lda CURSOR_X        ;setting x coordinate
	clc
	adc FIELD_XOFS
	asl
	asl
	asl
	ldx #SPR_CURSOR+SPR_X
	stx SPRITE_ADDR
	sta SPRITE_IO
	lda CURSOR_Y        ;setting y coordinate
	clc
	adc #4
	asl
	asl
	asl
	tax
	dex
	ldy #SPR_CURSOR+SPR_Y
	sty SPRITE_ADDR
	stx SPRITE_IO
	rts
	
;triggerflag SUBROUTINE
;  triggers flag at cell under cursor
triggerflag:
	ldx CURSOR_X
	ldy CURSOR_Y
	jsr celladdr
	ldy #0
	lda (TMP), y        ;testing if cell is opened
	tax
	and #CELL_OPEN      
	beq triggerflag_trigger
	rts
triggerflag_trigger:    ;closed - testing if flagged
	clc
	txa
	and #CELL_FLAG
	bne triggerflag_remove
triggerflag_add:
	txa
	ora #CELL_FLAG
	sta (TMP), y
	lda #TILE_FLAG
	bcc triggerflag_draw
triggerflag_remove:
	txa
	and #($FF-CELL_FLAG)
	sta (TMP), y
	lda #TILE_CLOSED
triggerflag_draw:
	pha
	jsr sync
	lda CURSOR_X
	adc FIELD_XOFS
	tax
	lda CURSOR_Y
	adc #4
	tay
	jsr setvrambyxy
	pla
	sta VRAM_IO
	jsr enddraw
	rts
	
;opencell SUBROUTINE
;  opens cell under cursor
opencell:
	ldx CURSOR_X
	ldy CURSOR_Y
	jsr celladdr
	ldy #0
	lda (TMP), y        ;testing if cell is flagged or opened
	tax
	and #(CELL_FLAG | CELL_OPEN)
	beq opencell_testmine
	rts
opencell_testmine:      ;test if mine is in the cell
	txa
	and #CELL_MINE
	beq opencell_teststack
	dec GAME_STATE
	jsr sync
	lda CURSOR_X
	adc FIELD_XOFS
	tax
	lda CURSOR_Y
	adc #4
	tay
	jsr setvrambyxy
	lda #TILE_MINE
	sta VRAM_IO
	jsr enddraw
	rts
opencell_teststack:     ;testing stack to not cause overflow
	tsx
	bmi opencell_mark
	rts
opencell_mark:
	;marking cell as opened
	lda #CELL_OPEN
	sta (TMP), y
	;decreasing amount of cells to open
	clc
	lda TO_OPEN
	adc #$FF
	sta TO_OPEN
	bcs opencell_testz
	dec TO_OPEN+1
	bcc opencell_calc
opencell_testz:
	bne opencell_calc
	lda TO_OPEN+1
	bne opencell_calc
	inc GAME_STATE
opencell_calc:
	;calculating mines in cells around
	ldx #0              ;x will store amount of mines
	lda TMP
	clc
	adc #($FF-32)       ;moving to the upper-left cell (to do only positive offsets)
	sta TMP
	bcs opencell_calc_topleft
	dec TMP+1
opencell_calc_topleft:
	lda CURSOR_Y
	beq opencell_calc_left
	lda CURSOR_X
	beq opencell_calc_top
	ldy #0
	lda (TMP), y
	and #CELL_MINE
	beq opencell_calc_top
	inx
opencell_calc_top:
	ldy #1
	lda (TMP), y
	and #CELL_MINE
	beq opencell_calc_topright
	inx
opencell_calc_topright:
	ldy CURSOR_X
	iny
	tya
	cmp FIELD_W
	beq opencell_calc_left
	ldy #2
	lda (TMP), y
	and #CELL_MINE
	beq opencell_calc_left
	inx
opencell_calc_left:
	lda CURSOR_X
	beq opencell_calc_right
	ldy #32
	lda (TMP), y
	and #CELL_MINE
	beq opencell_calc_right
	inx
opencell_calc_right:
	ldy CURSOR_X
	iny
	tya
	cmp FIELD_W
	beq opencell_calc_bottomleft
	ldy #34
	lda (TMP), y
	and #CELL_MINE
	beq opencell_calc_bottomleft
	inx
opencell_calc_bottomleft:
	ldy CURSOR_Y
	iny
	tya
	cmp FIELD_H
	beq opencell_calc_end
	ldy CURSOR_X
	beq opencell_calc_bottom
	ldy #64
	lda (TMP), y
	and #CELL_MINE
	beq opencell_calc_bottom
	inx
opencell_calc_bottom:
	ldy #65
	lda (TMP), y
	and #CELL_MINE
	beq opencell_calc_bottomright
	inx
opencell_calc_bottomright:
	ldy CURSOR_X
	iny
	tya
	cmp FIELD_W
	beq opencell_calc_end
	ldy #66
	lda (TMP), y
	and #CELL_MINE
	beq opencell_calc_end
	inx
opencell_calc_end:
	;drawing cell
	txa
	pha
	jsr sync
	clc
	lda CURSOR_X
	adc FIELD_XOFS
	tax
	lda CURSOR_Y
	adc #4
	tay
	jsr setvrambyxy
	pla
	sta TMP+5
	sta VRAM_IO
	jsr enddraw
	lda TMP+5
	beq opencell_recursion
	rts
opencell_recursion:
	;open nearby cells on zero of mines
opencell_touch_topleft:
	lda CURSOR_Y
	beq opencell_touch_left
	lda CURSOR_X
	beq opencell_touch_top
	dec CURSOR_X
	dec CURSOR_Y
	jsr opencell
	inc CURSOR_X
	inc CURSOR_Y
opencell_touch_top:
	dec CURSOR_Y
	jsr opencell
	inc CURSOR_Y
opencell_touch_topright:
	ldy CURSOR_X
	iny
	tya
	cmp FIELD_W
	beq opencell_touch_left
	dec CURSOR_Y
	inc CURSOR_X
	jsr opencell
	dec CURSOR_X
	inc CURSOR_Y
opencell_touch_left:
	lda CURSOR_X
	beq opencell_touch_right
	dec CURSOR_X
	jsr opencell
	inc CURSOR_X
opencell_touch_right:
	ldy CURSOR_X
	iny
	tya
	cmp FIELD_W
	beq opencell_touch_bottomleft
	inc CURSOR_X
	jsr opencell
	dec CURSOR_X
opencell_touch_bottomleft:
	ldy CURSOR_Y
	iny
	tya
	cmp FIELD_H
	beq opencell_end
	ldy CURSOR_X
	beq opencell_touch_bottom
	inc CURSOR_Y
	dec CURSOR_X
	jsr opencell
	inc CURSOR_X
	dec CURSOR_Y
opencell_touch_bottom:
	inc CURSOR_Y
	jsr opencell
	dec CURSOR_Y
opencell_touch_bottomright:
	ldy CURSOR_X
	iny
	tya
	cmp FIELD_W
	beq opencell_end
	inc CURSOR_X
	inc CURSOR_Y
	jsr opencell
	dec CURSOR_X
	dec CURSOR_Y
opencell_end:
	rts

;drawbang SUBROUTINE
; draws bang at cursor position
drawbang:
	;calculating coordinates
	clc
	lda CURSOR_X
	adc FIELD_XOFS
	asl
	asl
	asl
	tax
	clc
	lda CURSOR_Y
	adc #4
	asl
	asl
	asl
	tay
	dey
	;initializing sprite data
	stx BANG_SPRITES+$0+SPR_X
	stx BANG_SPRITES+$4+SPR_X
	stx BANG_SPRITES+$8+SPR_X
	stx BANG_SPRITES+$C+SPR_X
	sty BANG_SPRITES+$0+SPR_Y
	sty BANG_SPRITES+$4+SPR_Y
	sty BANG_SPRITES+$8+SPR_Y
	sty BANG_SPRITES+$C+SPR_Y
	lda #TILE_BANGUP
	sta BANG_SPRITES+$0+SPR_TILE
	lda #TILE_BANGDN
	sta BANG_SPRITES+$4+SPR_TILE
	lda #TILE_BANGLT
	sta BANG_SPRITES+$8+SPR_TILE
	lda #TILE_BANGRT
	sta BANG_SPRITES+$C+SPR_TILE
	lda #0
	sta BANG_SPRITES+$0+SPR_OPTS
	sta BANG_SPRITES+$4+SPR_OPTS
	sta BANG_SPRITES+$8+SPR_OPTS
	sta BANG_SPRITES+$C+SPR_OPTS
	;drawing bang cycle
	lda #16
	sta TMP+5
drawbang_animation:
	dec BANG_SPRITES
	inc BANG_SPRITES+4
	dec BANG_SPRITES+11
	inc BANG_SPRITES+15
	jsr sync
	jsr drawbang_writesprites
	jsr enddraw
	dec TMP+5
	bne drawbang_animation
	;erasing bang
	lda #" "
	sta BANG_SPRITES+1
	sta BANG_SPRITES+5
	sta BANG_SPRITES+9
	sta BANG_SPRITES+13
	jsr drawbang_writesprites
	jsr enddraw
	rts
	;subroutine to write sprite data
drawbang_writesprites:
	lda #4
	sta SPRITE_ADDR
	lda #<(BANG_SPRITES)
	sta TMP
	lda #>(BANG_SPRITES)
	sta TMP+1
	ldy #0
	ldx #16
drawbang_cycle:	
	lda (TMP), y
	sta SPRITE_IO
	iny
	dex
	bne drawbang_cycle
	jsr enddraw
	rts

; ***** PROGRAM DATA *****

;background palettes
bgpal_darkness:
	.byt $3F, $3F, $3F, $3F, NULL

bgpal_night:
	.byt $3F, $3F, $3F, $2D, NULL
	
bgpal_twilight:
	.byt $3F, $3F, $2D, $10, NULL

bgpal_day:
	.byt $3F, $2D, $10, $30, NULL

;sprite palette
spritepal:
	.byt $3F, $2C, $24, $28, NULL
	
;string data
str_nesmine:
	.asc "         N E S M I N E          ", NULL
	
str_pstart:
	.asc "          PRESS START           ", NULL
	
str_empty:
	.asc "                                ", NULL

str_level1:
	.asc "BEGINNER", NULL
str_level2:
	.asc "ADVANCED", NULL
str_level3:
	.asc "EXPERT", NULL
	
str_won:
	.asc "       CONGRATULATIONS!!!       ", NULL
str_lost:
	.asc "      HOW UNFORTUNATELY...      ", NULL

; ***** PROGRAM ENTRY POINTS *****

#if $fffa-* < 0
#echo *** Error: Code occupies too much space
#else
	.dsb $fffa-*, 0     ;aligning
	.word nmi           ;entry point for VBlank interrupt  (NMI)
	.word reset         ;entry point for program start     (RESET)
	.word cursed        ;entry point for masking interrupt (IRQ)
#endif

