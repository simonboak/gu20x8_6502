	;; testcard.s
	;; Displays a test pattern using all the routines
	;; from the gu20x8.s library

	* = $300

	CURSOR_X = $FF
	CURSOR_Y = $FE
	COLOR_AT_CURSOR = $FD

	ECHO = $FFEF
	

PAINT:	JSR GINIT		; Init the display and fill with black
	JSR GCLEAR
	LDX #$00
	JSR GBRITE
	LDA #$00
	STA COLOR_AT_CURSOR
	STA COLOR
	JSR GFILL
	LDA #$03		; Set white to be the starting color
	STA COLOR
	LDA #$06		; Set the cursor starting point to top left
	STA CURSOR_X
	STA CURSOR_Y
	JSR SHOW_CURSOR
	JSR EVENT_LOOP		; Read the keyboard for the next even
	RTS

SHOW_CURSOR:
	LDA COLOR		; Save the current plot color
	PHA
	LDX CURSOR_X		; Get the color of the current point
	LDY CURSOR_Y
	JSR GCOLOR
	STA COLOR_AT_CURSOR
	EOR #%00000011		; Invert the color value
	STA COLOR		; Use this for the cursor color
	LDX CURSOR_X
	LDY CURSOR_Y
	JSR GPLOT		; Draw it
	JSR GPAINT
	PLA			; Now return the original color for painting
	STA COLOR
	RTS

HIDE_CURSOR:
	LDA COLOR		; Save the current plot color
	PHA
	LDA COLOR_AT_CURSOR	; Now get back the color under the cursor point
	STA COLOR
	LDX CURSOR_X
	LDY CURSOR_Y
	JSR GPLOT
	JSR GPAINT
	PLA			; Restore the original plot color
	STA COLOR
	RTS
	
EVENT_LOOP:
	LDA $D011		; Read the keyboard and dispatch to the appropriate command
	BPL EVENT_LOOP
	LDA $D010
	ORA #$80
TESTW:	CMP #$D7		; W
	BNE TESTA
	JMP CURSOR_UP
TESTA:	CMP #$C1 		; A
	BNE TESTS
	JMP CURSOR_LEFT
TESTS:	CMP #$D3		; S
	BNE TESTD
	JMP CURSOR_DOWN
TESTD:	CMP #$C4		; D
	BNE TESTSPC
	JMP CURSOR_RIGHT
TESTSPC:CMP #$A0		; [space]
	BNE TEST0
	JMP DRAW
TEST0:	CMP #$B0		; 0
	BNE TEST1
	JMP SET_BLACK
TEST1:	CMP #$B1		; 1
	BNE TEST2
	JMP SET_BLUE
TEST2:	CMP #$B2		; 2
	BNE TEST3
	JMP SET_RED
TEST3:	CMP #$B3		; 3
	BNE TESTQ
	JMP SET_WHITE
TESTQ:	CMP #$D1		; Q
	BNE TESTN
	RTS			; Quit
TESTN:	CMP #$CE		; N
	BNE TESTESC
	JMP NEW
TESTESC:CMP #$9B		; [esc]
	BNE EVENT_LOOP
	JMP ESCAPE


NEW:
	LDA COLOR
	PHA
	LDA #$00
	STA COLOR
	JSR GFILL
	PLA
	STA COLOR
	JSR SHOW_CURSOR
	JMP EVENT_LOOP

ESCAPE:
	JSR HIDE_CURSOR
	JMP EVENT_LOOP


SET_BLACK:
	LDA #$00
	STA COLOR
	JMP EVENT_LOOP

SET_BLUE:
	LDA #$01
	STA COLOR
	JMP EVENT_LOOP

SET_RED:
	LDA #$02
	STA COLOR
	JMP EVENT_LOOP

SET_WHITE:
	LDA #$03
	STA COLOR
	JMP EVENT_LOOP

DRAW:	
	LDX CURSOR_X
	LDY CURSOR_Y
	JSR GPLOT
	JSR GPAINT
	LDA COLOR
	STA COLOR_AT_CURSOR
	JMP EVENT_LOOP

	
CURSOR_LEFT: .(
	LDX CURSOR_X		; Get the current X value
	BEQ END			; If it's already at 0 then stop
	JSR HIDE_CURSOR
	LDX CURSOR_X		; Set the new X value to 1 less than current
	DEX
	STX CURSOR_X
	JSR SHOW_CURSOR		; Draw the cursor in the new location
END:	JMP EVENT_LOOP
	.)

CURSOR_RIGHT:	 .(
	LDX CURSOR_X		; Get the current X value
	CPX #$13		; Check that we're not already on the right edge
	BEQ END			; Stop if we are
	JSR HIDE_CURSOR
	LDX CURSOR_X		; Now increment the X value
	INX
	STX CURSOR_X
	JSR SHOW_CURSOR		; Draw the cursor in the new location
END:	JMP EVENT_LOOP
	.)

CURSOR_UP: .(
	LDY CURSOR_Y		; Get the current Y value
	BEQ END			; If it's already at 0 then stop
	JSR HIDE_CURSOR
	LDY CURSOR_Y		; Set the new Y value to 1 less than current
	DEY
	STY CURSOR_Y
	JSR SHOW_CURSOR		; Draw the cursor in the new location
END:	JMP EVENT_LOOP
	.)

CURSOR_DOWN:	 .(
	LDY CURSOR_Y		; Get the current Y value
	CPY #$07		; Check that we're not already on the bottom edge
	BEQ END			; Stop if we are
	JSR HIDE_CURSOR
	LDY CURSOR_Y		; Now increment the Y value
	INY
	STY CURSOR_Y
	JSR SHOW_CURSOR		; Draw the cursor in the new location
END:	JMP EVENT_LOOP
	.)






#include "../gu20x8.s"
	
