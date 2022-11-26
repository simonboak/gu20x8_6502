A	;; teAstcard.s
	;; Displays a test pattern using all the routines
	;; from the gu20x8.s library

	* = $300



START:	JSR GINIT
	JSR GCLEAR

	;; Set the brightness to zero
	LDX #$00
	JSR GBRITE

	JSR GPAINT
	JSR DELAY

	;; 1 GFILL with white
	LDA #$03
	STA COLOR
	JSR GFILL

	JSR GPAINT
	JSR DELAY

	;; 2 Horizontal blue line
	LDA #$01
	STA COLOR
	LDX #$01
	LDY #$00
	LDA #$12
	JSR GHLINE

	JSR GPAINT
	JSR DELAY

	;; 3 Horizontal red line
	LDA #02
	STA COLOR
	LDX #$02
	LDY #$01
	LDA #$10
	JSR GHLINE

	JSR GPAINT
	JSR DELAY

	;; 4 Horizontal white line
	LDA #$03
	STA COLOR
	LDX #$03
	LDY #$02
	LDA #$0E
	JSR GHLINE

	JSR GPAINT
	JSR DELAY

	;; 5 Horizontal black line
	LDA #$00
	STA COLOR
	LDX #$04
	LDY #$03
	LDA #$0C
	JSR GHLINE

	JSR GPAINT
	JSR DELAY

	;; 6 Vertical blue line
	LDA #$01
	STA COLOR
	LDX #$00
	LDY #$03
	LDA #$05
	JSR GVLINE

	JSR GPAINT
	JSR DELAY

	;; 7 Vertical red line
	LDA #$02
	STA COLOR
	LDX #$01
	LDY #$04
	LDA #$04
	JSR GVLINE

	JSR GPAINT
	JSR DELAY

	;; 8 Vertical white line
	LDA #$03
	STA COLOR
	LDX #$02
	LDY #$05
	LDA #$03
	JSR GVLINE

	JSR GPAINT
	JSR DELAY

	;; 9 Vertical black line
	LDA #$00
	STA COLOR
	LDX #$03
	LDY #$06
	LDA #$02
	JSR GVLINE

	JSR GPAINT
	JSR DELAY

	;; 10 Blue pixel
	LDA #$01
	STA COLOR
	LDX #$0A
	LDY #$05
	JSR GPLOT

	JSR GPAINT
	JSR DELAY

	;; 11 Red pixel
	LDA #$02
	STA COLOR
	LDX #$0B
	LDY #$05
	JSR GPLOT

	JSR GPAINT
	JSR DELAY

	;; 12 White pixel
	LDA #$03
	STA COLOR
	LDX #$0C
	LDY #$05
	JSR GPLOT

	JSR GPAINT
	JSR DELAY

	;; 13 Black pixel
	LDA #$00
	STA COLOR
	LDX #$0D
	LDY #$05
	JSR GPLOT

	JSR GPAINT
	JSR DELAY

	;; 14 Get blue color and plot
	LDX #$05
	LDY #$00
	JSR GCOLOR
	STA COLOR
	LDX #$0D
	LDY #$07
	JSR GPLOT
	
	JSR GPAINT
	JSR GDELAY
	
	;; 15 Get red color and plot
	LDX #$06
	LDY #$01
	JSR GCOLOR
	STA COLOR
	LDX #$0E
	LDY #$07
	JSR GPLOT
	
	JSR GPAINT
	JSR GDELAY
	
	;; 16 Get white color and plot
	LDX #$07
	LDY #$02
	JSR GCOLOR
	STA COLOR
	LDX #$0F
	LDY #$07
	JSR GPLOT
	
	JSR GPAINT
	JSR GDELAY
	
	;; 17 Get black color and plot
	LDX #$08
	LDY #$03
	JSR GCOLOR
	STA COLOR
	LDX #$10
	LDY #$07
	JSR GPLOT
	
	JSR GPAINT
	JSR GDELAY
	
	;; End the test
	RTS
	

DELAY:	LDX #$FF
DELAY1:	DEX
	BNE DELAY1
	LDX #$FF
DELAY2:	DEX
	BNE DELAY2
	RTS
	



	/*
	LDA #$01                ; blue  test bot
        STA COLOR                                                                                        
        LDX #$07                                                                                         
        LDY #$07                                                                                         
        JSR GPLOT 
	
	LDA #$01
	STA COLOR
	LDX #$0
	LDY #$0
	LDA #$1
	JSR GVLINE

	LDA #$02
	STA COLOR
	LDX #$01
	LDY #$01
	LDA #$02
	JSR GVLINE

	LDA #$03
	STA COLOR
	LDX #$02
	LDY #$02
	LDA #$03
	JSR GVLINE

	JSR GPAINT


	LDX #$04
	LDY #$05
	LDA #$09
	JSR GHLINE

	LDA #$02
	STA COLOR
	LDX #$05
	LDY #$06
	LDA #$02
	JSR GHLINE

	LDA #$01
	STA COLOR
	LDX #$06
	LDY #$07
	LDA #$01
	JSR GHLINE

	JSR GPAINT

	;; Color grabbing test
	LDX #$00
	LDY #$00
	JSR GCOLOR
	STA COLOR 		; Should return blue
	JSR $FFDC
	LDX #$0A
	LDY #$00
	JSR GPLOT

	LDA #$20
	JSR $FFEF
	
	LDX #$01
	LDY #$01
	JSR GCOLOR
	STA COLOR		; Should return red
	JSR $FFDC
	LDX #$0A
	LDY #$01
	JSR GPLOT

	LDA #$20
	JSR $FFEF

	LDX #$02
	LDY #$02
	JSR GCOLOR
	STA COLOR		; Should return white
	JSR $FFDC
	LDX #$0A
	LDY #$02
	JSR GPLOT

	LDA #$20
	JSR $FFEF

	LDX #$00
	LDY #$06
	JSR GCOLOR
	STA COLOR		; Should return black
	JSR $FFDC
	LDX #$00
	LDY #$00
	JSR GPLOT

	JSR GPAINT
	
	LDX #$00		; Dim the screen to the lowest setting
	JSR GBRITE		; Might perseve its lifespan..?
	
	
	RTS
*/
	/*
START1:	LDA #$01
	STA COLOR
	JSR GFILL
	JSR GPAINT
	JSR GDELAY
	LDA #$02
	STA COLOR
	JSR GFILL
	JSR GPAINT
	JSR GDELAY
	LDA #$03
	STA COLOR
	JSR GFILL
	JSR GPAINT
	JSR GDELAY
	JMP START1
	RTS
*/	
	
/*
        ;; PLOT TESTING
	
PTEST:	JSR GCLEAR
        LDA #$01                ; blue                                                                       
        STA COLOR
        LDX #$00
        LDY #$07
        JSR GPLOT
        LDA #$02                ; red                                                                        
        STA COLOR
        LDX #$01
        LDY #$07
        JSR GPLOT
        LDA #$03                ; white                                                                      
        STA COLOR
        LDX #$02
        LDY #$07
        JSR GPLOT
        JSR GPAINT
        LDA #$00                ; black                                                                     
        STA COLOR
        LDX #$00                ; paint black over the blue?                                                
        LDY #$07
        JSR GPLOT
        JSR GPAINT
        RTS
*/

#include "../gu20x8.s"
	
