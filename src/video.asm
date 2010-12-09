; NESMine game
;   VRAM tile palette source
;
; Author: Serguey G Basalaev
; Copyright (C) 2009  Serguey G Basalaev <sbasalaev@gmail.com>
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

; Here we define some symbols for better visual representation
; of tiles
;
; Symbol      High bit     Low bit
; ----------------------------------
;   #           0            0
;   X           1            0
;   o           0            1
;   .           1            1
;
; In tile palette there first comes a sequence of high bits
; for the tile and then the sequence of low ones

* = 0

; TILE $00
; Empty tile (0 mines)
;
; XXXXXXXX
; XooooooX
; XooooooX
; XooooooX
; XooooooX
; XooooooX
; XooooooX
; XXXXXXXX
.byt $FF, $81, $81, $81, $81, $81, $81, $FF
.byt $00, $7E, $7E, $7E, $7E, $7E, $7E, $00

; TILE $01
; 1 mine
;
; XXXXXXXX
; XooooooX
; Xoo##ooX
; Xooo#ooX
; Xooo#ooX
; Xooo#ooX
; Xoo###oX
; XXXXXXXX
.byt $FF, $81, $81, $81, $81, $81, $81, $FF
.byt $00, $7E, $66, $76, $76, $76, $62, $00

; TILE $02
; 2 mines
;
; XXXXXXXX
; XooooooX
; Xo####oX
; Xoooo#oX
; Xo####oX
; Xo#ooooX
; Xo####oX
; XXXXXXXX
.byt $FF, $81, $81, $81, $81, $81, $81, $FF
.byt $00, $7E, $42, $7A, $42, $5E, $42, $00

; TILE $03
; 3 mines
;
; XXXXXXXX
; XooooooX
; Xo####oX
; Xoooo#oX
; Xo####oX
; Xoooo#oX
; Xo####oX
; XXXXXXXX
.byt $FF, $81, $81, $81, $81, $81, $81, $FF
.byt $00, $7E, $42, $7A, $42, $7A, $42, $00

; TILE $04
; 4 mines
;
; XXXXXXXX
; XooooooX
; Xo#oo#oX
; Xo#oo#oX
; Xo####oX
; Xoooo#oX
; Xoooo#oX
; XXXXXXXX
.byt $FF, $81, $81, $81, $81, $81, $81, $FF
.byt $00, $7E, $5A, $5A, $42, $7A, $7A, $00

; TILE $05
; 5 mines
;
; XXXXXXXX
; XooooooX
; Xo####oX
; Xo#ooooX
; Xo####oX
; Xoooo#oX
; Xo####oX
; XXXXXXXX
.byt $FF, $81, $81, $81, $81, $81, $81, $FF
.byt $00, $7E, $42, $5E, $42, $7A, $42, $00

; TILE $06
; 6 mines
;
; XXXXXXXX
; XooooooX
; Xo####oX
; Xo#ooooX
; Xo####oX
; Xo#oo#oX
; Xo####oX
; XXXXXXXX
.byt $FF, $81, $81, $81, $81, $81, $81, $FF
.byt $00, $7E, $42, $5E, $42, $5A, $42, $00

; TILE $07
; 7 mines
;
; XXXXXXXX
; XooooooX
; Xo####oX
; Xo#oo#oX
; Xoooo#oX
; Xoooo#oX
; Xoooo#oX
; XXXXXXXX
.byt $FF, $81, $81, $81, $81, $81, $81, $FF
.byt $00, $7E, $42, $5A, $7A, $7A, $7A, $00

; TILE $08
; 8 mines
;
; XXXXXXXX
; XooooooX
; Xo####oX
; Xo#oo#oX
; Xo####oX
; Xo#oo#oX
; Xo####oX
; XXXXXXXX
.byt $FF, $81, $81, $81, $81, $81, $81, $FF
.byt $00, $7E, $42, $5A, $42, $5A, $42, $00

; TILE $09
; closed cell
;
; .......X
; .oooooo#
; .oooooo#
; .oooooo#
; .oooooo#
; .oooooo#
; .oooooo#
; X#######
.byt $FF, $80, $80, $80, $80, $80, $80, $80
.byt $FE, $FE, $FE, $FE, $FE, $FE, $FE, $00

; TILE $0A
; flagged cell
;
; .......X
; .oooooo#
; .oXXXoo#
; .oXXXXo#
; .oXXXoo#
; .oXoooo#
; .oXoooo#
; X#######
.byt $FF, $80, $B8, $BC, $B8, $A0, $A0, $80
.byt $FE, $FE, $C6, $C2, $C6, $DE, $DE, $00

; TILE $0B
; mine
;
; .......X
; .oooooo#
; .ooXXoo#
; .oXXXXo#
; .oXXXXo#
; .ooXXoo#
; .oooooo#
; X#######
.byt $FF, $80, $98, $BC, $BC, $98, $80, $80
.byt $FE, $FE, $E6, $C2, $C2, $E6, $FE, $00

; TILE $0C
; wrong flag
;
; .......X
; .XoooXo#
; .oXoXoo#
; .ooXooo#
; .oXoXoo#
; .XoooXo#
; .oooooo#
; X#######
.byt $FF, $C4, $A8, $90, $A8, $C4, $80, $80
.byt $FE, $BA, $D6, $EE, $D6, $BA, $FE, $00

;not used tiles $0D..$0F
.dsb ($10-$0D)*16, 0

; TILE $10
; cursor #1
;
; XXX##XXX
; X######X
; X######X
; ########
; ########
; X######X
; X######X
; XXX##XXX
.byt $E7, $81, $81, $00, $00, $81, $81, $E7
.byt $00, $00, $00, $00, $00, $00, $00, $00

; TILE $11
; cursor #2
;
; ooo##ooo
; o######o
; o######o
; ########
; ########
; o######o
; o######o
; ooo##ooo
.byt $00, $00, $00, $00, $00, $00, $00, $00
.byt $E7, $81, $81, $00, $00, $81, $81, $E7

; TILE $12
; cursor #3
;
; ...##...
; .######.
; .######.
; ########
; ########
; .######.
; .######.
; ...##...
.byt $E7, $81, $81, $00, $00, $81, $81, $E7
.byt $E7, $81, $81, $00, $00, $81, $81, $E7

; TILE $13
; cursor #4
;
; ooo##ooo
; o######o
; o######o
; ########
; ########
; o######o
; o######o
; ooo##ooo
.byt $00, $00, $00, $00, $00, $00, $00, $00
.byt $E7, $81, $81, $00, $00, $81, $81, $E7

; TILE $14
; bang up
;
; ########
; ########
; #.....##
; ........
; .######.
; ########
; ########
; ########
.byt $00, $00, $7E, $FF, $81, $00, $00, $00
.byt $00, $00, $7E, $FF, $81, $00, $00, $00

; TILE $15
; bang down
;
; ########
; ########
; ########
; .######.
; ........
; #......#
; ########
; ########
.byt $00, $00, $81, $FF, $7E, $00, $00, $00
.byt $00, $00, $81, $FF, $7E, $00, $00, $00

; TILE $16
; bang left
;
; ###..###
; ##..####
; ##..####
; ##..####
; ##..####
; ##..####
; ##..####
; ###..###
.byt $18, $30, $30, $30, $30, $30, $30, $18
.byt $18, $30, $30, $30, $30, $30, $30, $18

; TILE $17
; bang right
;
; ###..###
; ####..##
; ####..##
; ####..##
; ####..##
; ####..##
; ####..##
; ###..###
.byt $18, $0C, $0C, $0C, $0C, $0C, $0C, $18
.byt $18, $0C, $0C, $0C, $0C, $0C, $0C, $18

;not used tiles $18..$1F
.dsb ($20-$18)*16, 0

; TILE $20
; space symbol (empty)
;
; ########
; ########
; ########
; ########
; ########
; ########
; ########
; ########
.byt $00, $00, $00, $00, $00, $00, $00, $00
.byt $00, $00, $00, $00, $00, $00, $00, $00

; TILE $21
; symbol !
;
; ###..###
; ###..###
; ###..###
; ###..###
; ###..###
; ########
; ###..###
; ########
.byt $18, $18, $18, $18, $18, $00, $18, $00
.byt $18, $18, $18, $18, $18, $00, $18, $00

; TILE $22
; symbol "
;
; #..#..##
; #..#..##
; #..#..##
; ########
; ########
; ########
; ########
; ########
.byt $6C, $6C, $6C, $00, $00, $00, $00, $00
.byt $6C, $6C, $6C, $00, $00, $00, $00, $00

; TILE $23
; symbol #
;
; #..#..##
; #..#..##
; .......#
; #..#..##
; .......#
; #..#..##
; #..#..##
; ########
.byt $6C, $6C, $FE, $6C, $FE, $6C, $6C, $00
.byt $6C, $6C, $FE, $6C, $FE, $6C, $6C, $00

; TILE $24
; symbol $
;
; ###..###
; ##.....#
; #..#####
; ##....##
; #####..#
; #.....##
; ###..###
; ########
.byt $18, $3E, $60, $3C, $06, $7C, $18, $00
.byt $18, $3E, $60, $3C, $06, $7C, $18, $00

; TILE $25
; symbol %
;
; #..##..#
; #..##..#
; ####..##
; ###..###
; ##..####
; #..##..#
; #..##..#
; ########
.byt $66, $66, $0C, $18, $30, $66, $66, $00
.byt $66, $66, $0C, $18, $30, $66, $66, $00

; TILE $26
; symbol &
;
; ##..####
; #.##.###
; #..#.###
; ##..####
; #.#..#.#
; #.##..##
; ##..#..#
; ########
.byt $30, $48, $68, $30, $5A, $4C, $36, $00
.byt $30, $48, $68, $30, $5A, $4C, $36, $00

; TILE $27
; symbol '
;
; ###..###
; ###..###
; ###..###
; ########
; ########
; ########
; ########
; ########
.byt $18, $18, $18, $00, $00, $00, $00, $00
.byt $18, $18, $18, $00, $00, $00, $00, $00

; TILE $28
; symbol (
;
; ###..###
; ##..####
; ##..####
; ##..####
; ##..####
; ##..####
; ###..###
; ########
.byt $18, $30, $30, $30, $30, $30, $18, $00
.byt $18, $30, $30, $30, $30, $30, $18, $00

; TILE $29
; symbol )
;
; ##..####
; ###..###
; ###..###
; ###..###
; ###..###
; ###..###
; ##..####
; ########
.byt $30, $18, $18, $18, $18, $18, $30, $00
.byt $30, $18, $18, $18, $18, $18, $30, $00

; TILE $2A
; symbol *
;
; ########
; ###..###
; ..#..#..
; #......#
; ..#..#..
; ###..###
; ########
; ########
.byt $00, $18, $DB, $7E, $DB, $18, $00, $00
.byt $00, $18, $DB, $7E, $DB, $18, $00, $00

; TILE $2B
; symbol +
;
; ########
; ###..###
; ###..###
; #......#
; ###..###
; ###..###
; ########
; ########
.byt $00, $18, $18, $7E, $18, $18, $00, $00
.byt $00, $18, $18, $7E, $18, $18, $00, $00

; TILE $2C
; symbol ,
;
; ########
; ########
; ########
; ########
; ########
; ###..###
; ###..###
; ##..####
.byt $00, $00, $00, $00, $00, $18, $18, $30
.byt $00, $00, $00, $00, $00, $18, $18, $30

; TILE $2D
; symbol -
;
; ########
; ########
; ########
; #......#
; ########
; ########
; ########
; ########
.byt $00, $00, $00, $7E, $00, $00, $00, $00
.byt $00, $00, $00, $7E, $00, $00, $00, $00

; TILE $2E
; symbol '
;
; ########
; ########
; ########
; ########
; ########
; ###..###
; ###..###
; ########
.byt $00, $00, $00, $00, $00, $18, $18, $00
.byt $00, $00, $00, $00, $00, $18, $18, $00

; TILE $2F
; symbol /
;
; #####..#
; #####..#
; ####..##
; ###..###
; ##..####
; #..#####
; #..#####
; ########
.byt $06, $06, $0C, $18, $30, $60, $60, $00
.byt $06, $06, $0C, $18, $30, $60, $60, $00

; TILE $30
; symbol 0
;
; #.....##
; ..###..#
; ..#.#..#
; ..#.#..#
; ..#.#..#
; ..###..#
; #.....##
; ########
.byt $7C, $C6, $D6, $D6, $D6, $C6, $7C, $00
.byt $7C, $C6, $D6, $D6, $D6, $C6, $7C, $00

; TILE $31
; symbol 1
;
; ###..###
; ##...###
; ###..###
; ###..###
; ###..###
; ###..###
; #......#
; ########
.byt $18, $38, $18, $18, $18, $18, $7E, $00
.byt $18, $38, $18, $18, $18, $18, $7E, $00

; TILE $32
; symbol 2
;
; #.....##
; ..###..#
; #####..#
; ###...##
; #...####
; ..######
; .......#
; ########
.byt $7C, $C6, $06, $1C, $70, $C0, $FE, $00
.byt $7C, $C6, $06, $1C, $70, $C0, $FE, $00

; TILE $33
; symbol 3
;
; #.....##
; ..###..#
; #####..#
; ###...##
; #####..#
; ..###..#
; #.....##
; ########
.byt $7C, $C6, $06, $1C, $06, $C6, $7C, $00
.byt $7C, $C6, $06, $1C, $06, $C6, $7C, $00

; TILE $34
; symbol 4
;
; ###...##
; ##....##
; #..#..##
; ..##..##
; ..##..##
; .......#
; ####..##
; ########
.byt $1C, $3C, $6C, $CC, $CC, $FE, $0C, $00
.byt $1C, $3C, $6C, $CC, $CC, $FE, $0C, $00

; TILE $35
; symbol 5
;
; .......#
; ..######
; ......##
; #####..#
; #####..#
; ..###..#
; #.....##
; ########
.byt $FE, $C0, $FC, $06, $06, $C6, $7C, $00
.byt $FE, $C0, $FC, $06, $06, $C6, $7C, $00

; TILE $36
; symbol 6
;
; #.....##
; ..###..#
; ..######
; ......##
; ..###..#
; ..###..#
; #.....##
; ########
.byt $7C, $C6, $C0, $FC, $C6, $C6, $7C, $00
.byt $7C, $C6, $C0, $FC, $C6, $C6, $7C, $00

; TILE $37
; symbol 7
;
; .......#
; #####..#
; ####..##
; ###..###
; ##..####
; ##..####
; ##..####
; ########
.byt $FE, $06, $0C, $18, $30, $30, $30, $00
.byt $FE, $06, $0C, $18, $30, $30, $30, $00

; TILE $38
; symbol 8
;
; #.....##
; ..###..#
; ..###..#
; #.....##
; ..###..#
; ..###..#
; #.....##
; ########
.byt $7C, $C6, $C6, $7C, $C6, $C6, $7C, $00
.byt $7C, $C6, $C6, $7C, $C6, $C6, $7C, $00

; TILE $39
; symbol 9
;
; #.....##
; ..###..#
; ..###..#
; #......#
; #####..#
; ..###..#
; #.....##
; ########
.byt $7C, $C6, $C6, $7E, $06, $C6, $7C, $00
.byt $7C, $C6, $C6, $7E, $06, $C6, $7C, $00

;not used tiles $3A..$40
.dsb ($41-$3A)*16

; TILE $41
; symbol A
;
; #.....##
; ..###..#
; ..###..#
; .......#
; ..###..#
; ..###..#
; ..###..#
; ########
.byt $7C, $C6, $C6, $FE, $C6, $C6, $C6, $00
.byt $7C, $C6, $C6, $FE, $C6, $C6, $C6, $00

; TILE $42
; symbol B
;
; ......##
; ..###..#
; ..###..#
; ......##
; ..###..#
; ..###..#
; ......##
; ########
.byt $FC, $C6, $C6, $FC, $C6, $C6, $FC, $00
.byt $FC, $C6, $C6, $FC, $C6, $C6, $FC, $00

; TILE $43
; symbol C
;
; #.....##
; ..###..#
; ..######
; ..######
; ..######
; ..###..#
; #.....##
; ########
.byt $7C, $C6, $C0, $C0, $C0, $C6, $7C, $00
.byt $7C, $C6, $C0, $C0, $C0, $C6, $7C, $00

; TILE $44
; symbol D
;
; ......##
; ..###..#
; ..###..#
; ..###..#
; ..###..#
; ..###..#
; ......##
; ########
.byt $FC, $C6, $C6, $C6, $C6, $C6, $FC, $00
.byt $FC, $C6, $C6, $C6, $C6, $C6, $FC, $00

; TILE $45
; symbol E
;
; .......#
; ..######
; ..######
; ......##
; ..######
; ..######
; .......#
; ########
.byt $FE, $C0, $C0, $FC, $C0, $C0, $FE, $00
.byt $FE, $C0, $C0, $FC, $C0, $C0, $FE, $00

; TILE $46
; symbol F
;
; .......#
; ..######
; ..######
; ......##
; ..######
; ..######
; ..######
; ########
.byt $FE, $C0, $C0, $FC, $C0, $C0, $C0, $00
.byt $FE, $C0, $C0, $FC, $C0, $C0, $C0, $00

; TILE $47
; symbol G
;
; #.....##
; ..###..#
; ..######
; ..#....#
; ..###..#
; ..###..#
; #.....##
; ########
.byt $7C, $C6, $C0, $DE, $C6, $C6, $7C, $00
.byt $7C, $C6, $C0, $DE, $C6, $C6, $7C, $00

; TILE $48
; symbol H
;
; ..###..#
; ..###..#
; ..###..#
; .......#
; ..###..#
; ..###..#
; ..###..#
; ########
.byt $C6, $C6, $C6, $FE, $C6, $C6, $C6, $00
.byt $C6, $C6, $C6, $FE, $C6, $C6, $C6, $00

; TILE $49
; symbol I
;
; ##....##
; ###..###
; ###..###
; ###..###
; ###..###
; ###..###
; ##....##
; ########
.byt $3C, $18, $18, $18, $18, $18, $3C, $00
.byt $3C, $18, $18, $18, $18, $18, $3C, $00

; TILE $4A
; symbol J
;
; #####..#
; #####..#
; #####..#
; #####..#
; #####..#
; ..###..#
; #.....##
; ########
.byt $06, $06, $06, $06, $06, $C6, $7C, $00
.byt $06, $06, $06, $06, $06, $C6, $7C, $00

; TILE $4B
; symbol K
;
; ..###..#
; ..##..##
; ..#..###
; ....####
; ..#..###
; ..##..##
; ..###..#
; ########
.byt $C6, $CC, $D8, $F0, $D8, $CC, $C6, $00
.byt $C6, $CC, $D8, $F0, $D8, $CC, $C6, $00

; TILE $4C
; symbol L
;
; ..######
; ..######
; ..######
; ..######
; ..######
; ..######
; .......#
; ########
.byt $C0, $C0, $C0, $C0, $C0, $C0, $FE, $00
.byt $C0, $C0, $C0, $C0, $C0, $C0, $FE, $00

; TILE $4D
; symbol M
;
; ..###..#
; ...#...#
; ..#.#..#
; ..#.#..#
; ..###..#
; ..###..#
; ..###..#
; ########
.byt $C6, $EE, $D6, $D6, $C6, $C6, $C6, $00
.byt $C6, $EE, $D6, $D6, $C6, $C6, $C6, $00

; TILE $4E
; symbol N
;
; ..###..#
; ..###..#
; ...##..#
; ..#.#..#
; ..##...#
; ..###..#
; ..###..#
; ########
.byt $C6, $C6, $E6, $D6, $CE, $C6, $C6, $00
.byt $C6, $C6, $E6, $D6, $CE, $C6, $C6, $00

; TILE $4F
; symbol O
;
; #.....##
; ..###..#
; ..###..#
; ..###..#
; ..###..#
; ..###..#
; #.....##
; ########
.byt $7C, $C6, $C6, $C6, $C6, $C6, $7C, $00
.byt $7C, $C6, $C6, $C6, $C6, $C6, $7C, $00

; TILE $50
; symbol P
;
; ......##
; ..###..#
; ..###..#
; ......##
; ..######
; ..######
; ..######
; ########
.byt $FC, $C6, $C6, $FC, $C0, $C0, $C0, $00
.byt $FC, $C6, $C6, $FC, $C0, $C0, $C0, $00

; TILE $51
; symbol Q
;
; #.....##
; ..###..#
; ..###..#
; ..###..#
; ..###..#
; ..###..#
; #.....##
; #####..#
.byt $7C, $C6, $C6, $C6, $C6, $C6, $7C, $06
.byt $7C, $C6, $C6, $C6, $C6, $C6, $7C, $06

; TILE $52
; symbol R
;
; ......##
; ..###..#
; ..###..#
; ......##
; ..#..###
; ..##..##
; ..###..#
; ########
.byt $FC, $C6, $C6, $FC, $D8, $CC, $C6, $00
.byt $FC, $C6, $C6, $FC, $D8, $CC, $C6, $00

; TILE $53
; symbol S
;
; #.....##
; ..###..#
; ..######
; #.....##
; #####..#
; ..###..#
; #.....##
; ########
.byt $7C, $C6, $C0, $7C, $06, $C6, $7C, $00
.byt $7C, $C6, $C0, $7C, $06, $C6, $7C, $00

; TILE $54
; symbol T
;
; #......#
; ###..###
; ###..###
; ###..###
; ###..###
; ###..###
; ###..###
; ########
.byt $7E, $18, $18, $18, $18, $18, $18, $00
.byt $7E, $18, $18, $18, $18, $18, $18, $00

; TILE $55
; symbol U
;
; ..###..#
; ..###..#
; ..###..#
; ..###..#
; ..###..#
; ..###..#
; #.....##
; ########
.byt $C6, $C6, $C6, $C6, $C6, $C6, $7C, $00
.byt $C6, $C6, $C6, $C6, $C6, $C6, $7C, $00

; TILE $56
; symbol V
;
; ..###..#
; ..###..#
; #..#..##
; #..#..##
; ##...###
; ##...###
; ###.####
; ########
.byt $C6, $C6, $6C, $6C, $38, $38, $10, $00
.byt $C6, $C6, $6C, $6C, $38, $38, $10, $00

; TILE $57
; symbol W
;
; ..###..#
; ..###..#
; ..###..#
; ..#.#..#
; ..#.#..#
; ..#.#..#
; #..#..##
; ########
.byt $C6, $C6, $C6, $D6, $D6, $D6, $6C, $00
.byt $C6, $C6, $C6, $D6, $D6, $D6, $6C, $00

; TILE $58
; symbol X
;
; ..###..#
; ..###..#
; #..#..##
; ##...###
; #..#..##
; ..###..#
; ..###..#
; ########
.byt $C6, $C6, $6C, $38, $6C, $C6, $C6, $00
.byt $C6, $C6, $6C, $38, $6C, $C6, $C6, $00

; TILE $59
; symbol Y
;
; #..##..#
; #..##..#
; #..##..#
; ##....##
; ###..###
; ###..###
; ###..###
; ########
.byt $66, $66, $66, $3C, $18, $18, $18, $00
.byt $66, $66, $66, $3C, $18, $18, $18, $00

; TILE $5A
; symbol Z
;
; .......#
; #####..#
; ####..##
; ##...###
; #..#####
; ..######
; .......#
; ########
.byt $FE, $06, $0C, $38, $60, $C0, $FE, $00
.byt $FE, $06, $0C, $38, $60, $C0, $FE, $00

;filling unused memory with zeros
#if $2000-* < 0
#echo *** Error: VRAM data occupies too much space 
#else
.dsb $2000-*, 0
#endif
