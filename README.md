# Gu20x8 6502 Routines



## Memory Locations

### BLUEBUFF `$700` - `$713` (`1792` - `1811`)

20 byte RAM buffer of blue pixel data.


### REDBUFF `$720` (`1824`)

20 byte RAM buffer of RED pixel data.


### COLOR `$734` (`1844`)

Stores the current drawing colour used by the routines:

- `$00` Black
- `$01` Blue
- `$02` Red
- `$03` White


### ARGA `$737` (`1847`)

Location for passing parameters in the Accumulator, useful for CALLing from BASIC programs. The result of `GCOLOR` is stored there on return.


### ARGX `$738` (`1848`)

Location for passing parameters in the X register, useful for CALLing from BASIC programs.


### ARGY `$739` (`1849`)

Location for passing parameters in the Y register, useful for CALLing from BASIC programs.

---

## Routines

### GINIT

Initialises port B on the 6522 VIA, before setting the plot colour to blue (`$01`) and clearing the buffer to black.

**From assembly:** `$300`
**From BASIC:** `768`


### GCLEAR

Clears the RAM buffer to black, but does not clear the display. Do this by then calling `GPAINT`.

**From assembly:** `$315`
**From BASIC:** `789`


### GPAINT

This routine "paints" the contents of the RAM buffer to the display.

**From assembly:** `$323`
**From BASIC:** `803`


### GPLOT

Plot a single pixel to the display using the current colour set in the COLOR memory location. 

Use X and Y registers to define the coordinates of the pixel to plot. 

**From assembly:** `$37D`
**From BASIC:** `965`


### GCOLOR

Get the colour of a pixel at location defined by registers X and Y.

Returns the colour in the Accumulator.

**From assembly:** `$3CE`
**From BASIC:** `974`


### GFILL

Fill the display with the current plot colour.

**From assembly:** `$401`
**From BASIC:** `1025`


### GVLINE

Draw a vertical line in the current plot colour.

Starting coordinates passed the X and Y registers, length of the line in the accumulator.

Line is drawn downwards only.

**From assembly:** `$433`
**From BASIC:** `1099`


### GHLINE

Draw a horizontal line in the current plot colour.

Starting coordinated passed in the X and Y registers, length of the line in the accumulator.

Line is drawn from left to right only.

**From assembly:** `$457`
**From BASIC:** `1141`


### GBRITE

Change the brightness of the screen.

Pass the value in the X register from $00 (dimmest) to $03 (brightest).

**From assembly:** `$481`
**From BASIC:** `1191`