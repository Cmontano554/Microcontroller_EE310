;---------------------
; Title: Seven Segment Counter
;---------------------
; Program Details:
; The purpose of this program is to implement a seven segment
; with the ability to count up, count down and reset using
; SPST buttons 
    
    
; Inputs: PORTB,0 and PORTB,1
; Outputs: PORTD, 0-7

    
; Date: March 25, 2025
; File Dependencies / Libraries: It is required to include the 
;   AssemblyConfig.inc in the Header Folder
; Compiler: xc8, 2.4
; Author: Cole Montano
; Versions:
;       V1.3: Updated Delay Configuration to avoid
;		accidenttle "floating" changes
		
; Useful links: 
;       Datasheet: https://ww1.microchip.com/downloads/en/DeviceDoc/PIC18(L)F26-27-45-46-47-55-56-57K42-Data-Sheet-40001919G.pdf 

    
    #include <xc.inc>
    #include "./myConfigFile.inc"
    PSECT absdata,abs,ovrld 
    ORG	0x00
    RCALL _setupPortD
    RCALL _setupPortB
    DIGIT   equ	0x1E; Used to ensure tablepointer is looking at correct spot
    
    ORG 0x20 ; Initiliazes table pointer value and clear DIGIT
    CLRF    TBLPTRL
    MOVLW   0x3F
    MOVWF   PORTD,0
    MOVLW   0x0
    MOVWF   TBLPTRU
    MOVLW   0x0A
    MOVWF   TBLPTRH
    MOVLW   0x00
    MOVWF   TBLPTRL
    CLRF    DIGIT
  
 _CHECK: ; Checks if one of the buttons is pressed, both are pressed and neither are pressed
    CALL    _DELAY
    BTFSS   PORTB,0
    GOTO    _DOUBLE
    BTFSS   PORTB,1
    GOTO    _DOUBLE
    GOTO    _CHECK
    
_DOUBLE: ; Makes sure if both buttons are pressed it clear the display 
    BTFSC   PORTB,0
    GOTO    _UPC
    BTFSC   PORTB,1
    GOTO    _DOWNC
    CLRF    DIGIT
    GOTO    _DISPLAY
_UPC:
    MOVLW   0x02 ; Must move two addresses to properly display digits
    ADDWF   DIGIT
    MOVLW   0x1E
    CPFSGT  DIGIT
    GOTO    _DISPLAY
    CLRF    DIGIT
    GOTO    _DISPLAY
_DOWNC: 
    MOVLW   0x02; Must move two addresses to properly display digits
    SUBWF   DIGIT
    MOVLW   0xFE
    CPFSEQ  DIGIT
    GOTO    _DISPLAY
    MOVLW   0x1E
    MOVWF   DIGIT
    GOTO    _DISPLAY
    
 
_DISPLAY:
    MOVFF   DIGIT, TBLPTRL ; Increases the table pointer to look at the required value 
    TBLRD* ; Reads from seven segment table
    MOVFF   TABLAT, PORTD
    CALL    _DELAY ; Calls to the delay loop 
    GOTO    _CHECK ; Goes back to start to continue the loops
 
_DELAY:
    MOVLW   0xFF
    MOVWF   0x10
    MOVLW   0xFF
    MOVWF   0x11
    MOVLW   0x02
    MOVWF   0x12
_loop:
    DECF        0x10
    BNZ         _loop
    MOVLW       0xFF 
    MOVWF       0x10
    DECF        0x11 
    BNZ        _loop
    MOVLW	0xFF
    MOVWF	0x10
    MOVLW	0xFF
    MOVWF	0x11
    DECF	0x12
    BNZ		_loop
    RETURN
    
    
    
    
    
_setupPortD:
    BANKSEL	PORTD ;
    CLRF	PORTD ;Init PORTA
    BANKSEL	LATD ;Data Latch
    CLRF	LATD ;
    BANKSEL	ANSELD ;
    CLRF	ANSELD ;digital I/O
    BANKSEL	TRISD ;
    MOVLW	0x00 ;Set RD[7:1] as inputs
    MOVWF	TRISD ;and set RD0 as ouput
    RETURN

    _setupPortB:
    BANKSEL	PORTB ;
    CLRF	PORTB ;Init PORTA
    BANKSEL	LATB ;Data Latch
    CLRF	LATB ;
    BANKSEL	ANSELB ;
    CLRF	ANSELB ;digital I/O
    BANKSEL	TRISB ;
    MOVLW	0x03 ; Sets RB0 and RB1 as inputs
    MOVWF	TRISB ;
    RETURN    
  
    
ORG 0x00A00; Organized away from main code
    SEVENSEG_TABLE:
    RETLW 0x3F   ; 0
    RETLW 0x06   ; 1
    RETLW 0x5B   ; 2
    RETLW 0x4F   ; 3
    RETLW 0x66   ; 4
    RETLW 0x6D   ; 5
    RETLW 0x7D   ; 6
    RETLW 0x07   ; 7
    RETLW 0x7F   ; 8
    RETLW 0x6F   ; 9
    RETLW 0x77   ; A
    RETLW 0x7C   ; B
    RETLW 0x39   ; C
    RETLW 0x5E   ; D
    RETLW 0x79   ; E
    RETLW 0x71   ; F

    
END