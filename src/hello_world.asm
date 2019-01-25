include "lib\\gbhw.inc"  ; Hardware & address info

; Interrupt Vectors --------------------------------------------------------------

; VBlank triggers every time the screen finishes drawing.
; VRAM is only available during vblank.
SECTION "Vblank", ROM0[$0040]
    reti

; LCD Interrupts
SECTION "LCDC", ROM0[$0048]
    reti

; Timer interrupt is triggered when the timer overflows.
SECTION "Timer", ROM0[$0050]
    reti

; Serial interrupt occurs when the GameBoy transfers a byte via the link cable.
SECTION "Serial", ROM0[$0058]
    reti

; Joypad interrupt occurs after a button has been pressed. Usually disabled.
SECTION "Joypad", ROM0[$0060]
    reti

; END Interrupt Vectors ----------------------------------------------------------

SECTION "ROM_entry_point", ROM0[$0100]
    nop
    jp      main

; ROM Header ---------------------------------------------------------------------
SECTION "rom header", ROM0[$0104]
    NINTENDO_LOGO   ; Required to run on actual hardware
    ROM_HEADER "Hello World    "    ; Cart name - Must be 15 bytes

; Includes go here. Make sure your code doesn't overwrite bytes $0000 - $014E
include "lib\\ibmpc1.inc"
include "lib\\memory.asm"


main:
    di                      ; Disable interrupts
    ld      SP, $FFFF       ; Initialize the stack
    call    lcd_stop

    ; Load ASCII charset into VRAM
    ld      HL, ascii_tiles ; Source address
    ld      DE, _VRAM       ; Destination address
    ld      BC, ascii_tiles_end - ascii_tiles ; Byte count
    call    mem_CopyMono

    call    clear_map

    ; Turn on the LCD
    ld      A, [rLCDC]
    or      LCDCF_ON
    ld      [rLCDC], A

    ; Draw text to the screen on the second row
    ld      HL, hello_world_text
    ld      DE, _SCRN0 + SCRN_VX_B
    ld      BC, 32
    call    mem_CopyVRAM

.loop
    halt
    nop

    jp      .loop

hello_world_text:
	DB	"    Hello, World    "

lcd_stop:
    ld      A, [rLCDC]      ; Load LCD config
    and     LCDCF_ON        ; Check if it's on
    ret     Z               ; Return if LCD is off
.wait4vblank
    ldh     A, [rLY]        ; Load the LCD's Y coord. LDH is faster than LD above $FF00
    cp      145             ; Are we past the bottom line yet?
    jr      NZ, .wait4vblank; If not, keep waiting
.stopLCD
    ld      A, [rLCDC]      ; Load LCD config again
    xor     LCDCF_ON        ; Toggle LCD off
    ld      [rLCDC], A      ; Save LCD config
    ret

; Clears _SCRN0
; Affects A, BC, HL, and NZ
clear_map:
    ld      HL, _SCRN0
    ld      BC, SCRN_VX_B * SCRN_VY_B
.clear_map_loop
    ld      A, " "
    ld      [HLI], a        ; Copy a blank space to HL and increment it
    dec     BC              ; Decrement BC
    ld      A, B
    or      C               ; If BC > 0, loop
    jr      NZ, .clear_map_loop
    ret

ascii_tiles:
    chr_IBMPC1 1, 8

ascii_tiles_end:
