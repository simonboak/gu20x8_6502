	;; tesstcard.s
	;; Displays a test pattern using all the routines from the gu20x8.s library
	;; Compare the end result with testcard.jpg to ensure correct functionality.
	;;
	;; Written for Apple 1 WAIT routine uses the keyboard PIA to WAIT for a
	;; keypress between each section of the test pattern.

	* = $300



TESTCARD:	
	JSR GINIT
	JSR GCLEAR

	;; Set the brightness to zero
	LDX #$00
	JSR GBRITE

	JSR GPAINT
	JSR WAIT

	;; 1 GFILL with white
	LDA #$03
	STA COLOR
	JSR GFILL

	JSR GPAINT
	JSR WAIT

	;; 2 Horizontal blue line
	LDA #$01
	STA COLOR
	LDX #$01
	LDY #$00
	LDA #$12
	JSR GHLINE

	JSR GPAINT
	JSR WAIT

	;; 3 Horizontal red line
	LDA #02
	STA COLOR
	LDX #$02
	LDY #$01
	LDA #$10
	JSR GHLINE

	JSR GPAINT
	JSR WAIT

	;; 4 Horizontal white line
	LDA #$03
	STA COLOR
	LDX #$03
	LDY #$02
	LDA #$0E
	JSR GHLINE

	JSR GPAINT
	JSR WAIT

	;; 5 Horizontal black line
	LDA #$00
	STA COLOR
	LDX #$04
	LDY #$03
	LDA #$0C
	JSR GHLINE

	JSR GPAINT
	JSR WAIT

	;; 6 Vertical blue line
	LDA #$01
	STA COLOR
	LDX #$00
	LDY #$03
	LDA #$05
	JSR GVLINE

	JSR GPAINT
	JSR WAIT

	;; 7 Vertical red line
	LDA #$02
	STA COLOR
	LDX #$01
	LDY #$04
	LDA #$04
	JSR GVLINE

	JSR GPAINT
	JSR WAIT

	;; 8 Vertical white line
	LDA #$03
	STA COLOR
	LDX #$02
	LDY #$05
	LDA #$03
	JSR GVLINE

	JSR GPAINT
	JSR WAIT

	;; 9 Vertical black line
	LDA #$00
	STA COLOR
	LDX #$03
	LDY #$06
	LDA #$02
	JSR GVLINE

	JSR GPAINT
	JSR WAIT

	;; 10 Blue pixel
	LDA #$01
	STA COLOR
	LDX #$0A
	LDY #$05
	JSR GPLOT

	JSR GPAINT
	JSR WAIT

	;; 11 Red pixel
	LDA #$02
	STA COLOR
	LDX #$0B
	LDY #$05
	JSR GPLOT

	JSR GPAINT
	JSR WAIT

	;; 12 White pixel
	LDA #$03
	STA COLOR
	LDX #$0C
	LDY #$05
	JSR GPLOT

	JSR GPAINT
	JSR WAIT

	;; 13 Black pixel
	LDA #$00
	STA COLOR
	LDX #$0D
	LDY #$05
	JSR GPLOT

	JSR GPAINT
	JSR WAIT

	;; 14 Get blue color and plot
	LDX #$05
	LDY #$00
	JSR GCOLOR
	STA COLOR
	LDX #$0D
	LDY #$07
	JSR GPLOT
	
	JSR GPAINT
	JSR WAIT
	
	;; 15 Get red color and plot
	LDX #$06
	LDY #$01
	JSR GCOLOR
	STA COLOR
	LDX #$0E
	LDY #$07
	JSR GPLOT
	
	JSR GPAINT
	JSR WAIT
	
	;; 16 Get white color and plot
	LDX #$07
	LDY #$02
	JSR GCOLOR
	STA COLOR
	LDX #$0F
	LDY #$07
	JSR GPLOT
	
	JSR GPAINT
	JSR WAIT
	
	;; 17 Get black color and plot
	LDX #$08
	LDY #$03
	JSR GCOLOR
	STA COLOR
	LDX #$10
	LDY #$07
	JSR GPLOT
	
	JSR GPAINT
	JSR WAIT
	
	
	;; 18 Clear the screen back to black
	JSR GCLEAR
	JSR GPAINT
	
	
	;; End the test
	RTS


WAIT:	
	LDA $D011
	BPL WAIT
	LDA $D010
	RTS


#include "../gu20x8.s"
	
