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
    jp  main

; ROM Header ---------------------------------------------------------------------
SECTION "rom header", ROM0[$0104]
    NINTENDO_LOGO   ; Required to run on actual hardware
    ROM_HEADER "Scroll         "    ; Cart name - Must be 15 bytes

; Includes go here. Make sure your code doesn't overwrite bytes $0000 - $014E

main:
    di                      ; Disable interrupts
    ld      SP, $FFFF       ; Initialize the stack

    ld      A, IEF_VBLANK
    ld      [rIE], A        ; Set VBlank interrupt flag
    ei                      ; Enable interrupts

    call    clear_oam

    ld      A, [rLCDC]      ; Fetch LCD config
    or      LCDCF_OBJON     ; Enable sprites
    or      LCDCF_OBJ8      ; Enable 8bit
    ld      [rLCDC], A      ; Save LCD config

.loop
    halt                    ; Wait for interrupt (VBlank)
    nop
    
    ld      A, B
    ld      [rSCY], A
    dec     A
    ld      B, A
    jp      .loop

clear_oam:
	ld		hl, _OAMRAM
	ld		bc, 40*4		; OAM is split into 40 chunks of 4 bytes
.clear_oam_loop
	ld		a, $0
	ld		[hli], a
	dec 	bc
	ld		a, b
	or		c
	jr		nz, .clear_oam_loop
	ret