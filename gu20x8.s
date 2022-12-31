	;; gu20x8.s
	;; Library of routines for controlling the Noritake GU20x8 VFD
	;;
	;; Routines that use registers have an additional _BASIC calling 
	;; point which populates the registers with the POKEd values from 
	;; ARGA, ARGX, and ARGY locations.
	
	;; VIA locations
	DDRB  = $A012
	ORB   = $A010
	ACR   = $A01B
	SHIFT = $A01A
	
	;; Memory used for the RAM buffer and other functions
	BLUEBUFF = $0700
	REDBUFF  = $0720
	COLOR    = $0734
	MASK     = $0735
	MASKINV  = $0736
	
	;; Locations for the Accumulator, X and Y registers for BASIC interfacing
	ARGA     = $0737
	ARGX     = $0738
	ARGY     = $0739

	;; APPLE 1 DEBUG ROUTINES - REMOVE (eventually)
	PRBYTE = $FFDC


	;; Init routine - call this first to set up the hardware
	;; Automatically clears the buffer and then updates the display
	;; Sets the plot color to blue
GINIT:	
	LDA #$0F
	STA DDRB		; VIA DATA DIR
	STA ORB			; ENABLE DISPLAY
	LDA #$18
	STA ACR			; VIA SHIFT REG.
	JSR GBUSY
	LDA #$01		; Set plot color to blue
	STA COLOR

	;; Clears the buffer to black
GCLEAR:	
	LDA #$00
	LDX #$13		
GCLEAR1:
	STA BLUEBUFF,X
	STA REDBUFF,X
	DEX
	BPL GCLEAR1		; Loop until done
	RTS
	
	;; Paint routine updates the display with the contents of the RAM buffer
GPAINT:	
	LDX #$13		; BLUE DATA
GPAINT1:
	LDA BLUEBUFF,X
	STX SHIFT		; ADDRESS
	JSR GDELAY
	STA SHIFT		; DATA
	JSR GDELAY
	JSR GWR			; WRITE TO GU20X8
	JSR GDELAY		; Extra delay sometines needed?
	JSR GDELAY		; Extra delay sometines needed?
	JSR GDELAY		; Extra delay sometines needed?
	TXA
	CLC
	ADC #$20		; Add our offset to get to the red buffer
	TAY
	LDA BLUEBUFF,Y
	STY SHIFT
	JSR GDELAY
	STA SHIFT
	JSR GDELAY
	JSR GWR
	DEX
	BPL GPAINT1
	RTS
	
	;; Shift out delay routine
GDELAY:	
	PHX
GDELAY1:
	LDX #$A0		; Count down until the 
	DEX				; shift register has 
	BPL GDELAY1		; shifted out our bits
	PLX				; $A0 works as a reliable delay
	RTS

	;; WRITE/READ Toggle
GWR:
	PHA
	LDA #$0D		; Set the RESET bit to 0
	STA ORB			; Output it
	LDA #$0F
	STA ORB
	JSR GBUSY		; Wait for display to finish before we return
	PLA
	RTS

	;; Waits until the busy bit of the display is 0
GBUSY:	
	PHA
GBUSY1:
	LDA ORB
	AND #%00010000	; Test for display busy bit set
	BNE GBUSY1
	PLA
	RTS

	;; Plot a single pixel to the display
	;; Uses the current color set in the COLOR zero page location
	;; $00 = black, $01 = blue, $02 = red, $03 = white
	;; Use X and Y registers to define the coordinate of the pixel to plot 
GPLOT:	
	LDA #$01		; Turn the Y coord into a bit mask
GPLOT1:	
	DEY
	BMI GPLOT2		; Branch when the result of decrementing Y is negative
	ASL				; Shift the mask 1 bit until we get to the Y column
	JMP GPLOT1		; Repeat
GPLOT2:
	STA MASK		; Save the normal mask to RAM
	EOR #$FF		; Invert the mask
	STA MASKINV		; Store the inverted mask
GPLOTH:
	LDA BLUEBUFF,X	; Get the whole byte for the column we need (also entry point for HLINE)
	AND MASKINV		; Use the mask to clear the Y pixel
	STA BLUEBUFF,X	; Save it back
	LDA COLOR		; Load the plot color
	BEQ GPLOT3		; If the color is BLACK then go to where we clear the red bit
	AND #$01		; Test if colour is blue or white
	BEQ GPLOT3		; Branch if it's not blue or white
	LDA BLUEBUFF,X	; Grab that blue column again
	ORA MASK		; Use the mask to set the blue bit
	STA BLUEBUFF,X	; Save it again
GPLOT3:
	LDA REDBUFF,X	; Now we get to the red bits
	AND MASKINV		; Clear the red bit first
	STA REDBUFF,X	; Save it back
	LDA COLOR		; Grab the color again
	BEQ GPLOT4		; Color is black so branch to the end
	AND #$02		; Test if color is red or white
	BEQ GPLOT4		; If zero then its black to branch to end
	LDA REDBUFF,X	; Get the red column
	ORA MASK		; Use the mask to set the red bit
	STA REDBUFF,X	; Save if back
GPLOT4:
	RTS				; We're done plotting this pixel
GPLOT_BASIC:
	LDX ARGX
	LDY ARGY
	JMP GPLOT
		
	;; Get the color of a pixel at location defined by registers X Y
	;; Returns the color in A
GCOLOR:
	LDA #$01		; Get a bit mask from the Y coord
GCOLOR1:
	DEY
	BMI GCOLOR2		; Branch if decrementing Y is negative
	ASL				; Shift mask for until we get to Y coord
	JMP GCOLOR1		; Repeat until we get there
GCOLOR2:
	STA MASK		; Save this mask into RAM
	LDY #$00		; We'll keep track of the color in Y by starting with black
	LDA BLUEBUFF,X	; Get the blue column for the X coord
	AND MASK		; Test the blue bit
	BEQ GCOLOR3		; If zero then color isn't blue or white, so go check for red
	LDY #$01		; Set Y to blue, until we know if its also red, i.e. white
GCOLOR3:
	LDA REDBUFF,X	; Now get the red column
	AND MASK		; Check for the red bit set
	BEQ GCOLOR5		; No red so return
	TYA				; Grab the color from Y
	ORA #%000000010	; Set the red bit in the color
	RTS
GCOLOR5:
	TYA				; Move the blue (or black) pixel to A
	RTS				; Return with color in A
GCOLOR_BASIC:
	LDX ARGX
	LDY ARGY
	JSR GCOLOR
	STA ARGA
	RTS

	;; Fill the display with the current plot color
GFILL:
	LDA #$00		; First clear the blue and red buffers to black
	LDX #$13
GFILL1:
	STA BLUEBUFF,X
	STA REDBUFF,X
	DEX
	BPL GFILL1
	LDA COLOR		; Now we'll get the current color
	BEQ GFILL5		; Color is black so we can return now
	AND #$01		; Test for blue or white bit
	BEQ GFILL3		; Not blue or white, so go test for red
	LDA #$FF		; Our fill byte
	LDX #$13		; Buffer length
GFILL2:
	STA BLUEBUFF,X	; Fill the buffer
	DEX
	BPL GFILL2		; Loop until done
GFILL3:	
	LDA COLOR		; Test for red or white
	AND #$02
	BEQ GFILL5		; Not red or white so return
	LDA #$FF		; The red fill byte
	LDX #$13		; Buffer length
GFILL4:
	STA REDBUFF,X	; Fill the buffer
	DEX
	BPL GFILL4		; Loop until done
GFILL5:
	RTS

	;; Draw a vertical line in the current plot color
	;; Starting coordinates passin the X and Y registers
	;; Length of the line in the accumulator
	;; Line is drawn downwards only
GVLINE:
	PHY				; Save the Y coord for later
	TAY				; Move the length to Y
	LDA #$01		; Start building a mask for the line
GVLINE1:
	DEY				; Step through the length
	BEQ GVLINE2		; End once we've completed the line
	ASL				; Move the mask by 1 step
	ORA #$01		; Add the next bit of the mask
	JMP GVLINE1		; Go around again
GVLINE2:
	PLY				; Get that Y coord again
GVLINE3:
	DEY				; Count down to position the mask at the Y coord
	BMI GVLINE4		; Once done go and plot it
	ASL				; Shift the mask 1 bit
	JMP GVLINE3		; Go around agin
GVLINE4:
	JMP GPLOT2		; Jump into the mask saving step of GPLOT to draw a full line
GVLINE_BASIC:
	LDA ARGA
	LDX ARGX
	LDY ARGY
	JMP GVLINE

	;; Draw a horizontal line in the current plot color
	;; Starting coordinated passed in the X and Y registers
	;; Length of the line in the accumulator
	;; Line is drawn from left to right only
GHLINE:
	PHA				; Save the length for later
	LDA #$01		; Build a mask for plotting a single color
GHLINE1:
	DEY				; Move the mask to the Y coord of the line
	BMI GHLINE2		; done
	ASL				; Move the mask down 1 bit
	JMP GHLINE1		; Repeat until we get there
GHLINE2:
	STA MASK		; Store the mask
	EOR #$FF		; Invert the mask for plotting in black
	STA MASKINV		; Save that too
	PLY				; Get that length from before
GHLINE3:
	BEQ GHLINE4		; If length gets to zero we're done
	JSR GPLOTH		; Use the second half of the plot function to plot each point in the line
	INX				; Move to the next pixel to the right
	DEY				; Count down 1 pixel in the length
	JMP GHLINE3		; Keep goind
GHLINE4:
	RTS
GHLINE_BASIC:
	LDA ARGA
	LDX ARGX
	LDY ARGY
	JMP GHLINE


	;; Change the brightness of the screen
	;; Pass the value in the X register
	;; From $00 (dimmest) to $03 (brightest)
GBRITE:
	LDA #$0E		; Set command mode bit
	STA ORB
	LDA #$3F		; Address to the Gu20x8 brightness value
	STA SHIFT		; Shift that out
	JSR GDELAY
	STX SHIFT		; Shift out the value
	JSR GDELAY
	LDA #$0C		; Toggle the W/R line
	STA ORB
	LDA #$0E
	STA ORB
	JSR GBUSY
	LDA #$0F		; Disable command and return to data mode
	STA ORB
	RTS
GBRITE_BASIC:
	LDX ARGX
	JMP GBRITE
