;---------------------
; Title: Heating Control System
;---------------------
; Program Details:
; The purpose of this assignment is to create a heating and cooling system that
; that allows the user to define a desired temperature. 

; Inputs: MeasuredTempInput, RefTempInput
; Outputs: PortD
; Date: March, 8th
; File Dependencies / Libraries: None 
; Compiler: xc8, 2.4
; Author: Cole Montano
; Versions:
; V1.0: March, 8th. First Version
     

;---------------------
; Initialization - make sure the path is correct
;---------------------
;#include ".\MyConfigFile.inc"

#include <xc.inc>

;----------------
; PROGRAM INPUTS
;----------------
;The DEFINE directive is used to create macros or symbolic names for values.
;It is more flexible and can be used to define complex expressions or sequences of instructions.
;It is processed by the preprocessor before the assembly begins.

#define  measuredTempInput 	-10 ; this is the input value
#define  refTempInput 		10 ; this is the input value

;---------------------
; Definitions
;---------------------
#define SWITCH    LATD,2  
#define LED0      PORTD,0
#define LED1	  PORTD,1
    
 
;---------------------
; Program Constants
;---------------------
; The EQU (Equals) directive is used to assign a constant value to a symbolic name or label.
; It is simpler and is typically used for straightforward assignments.
;It directly substitutes the defined value into the code during the assembly process.
    
contReg	equ	0x22
refTemp	equ	0x20
measuredTemp equ 0x21
;---------------
; Main Code
;---------------
    PSECT absdata,abs,ovrld	
    ORG	    0x00
    GOTO    _start
_start:    
    ORG	    0x20
    MOVLW   0x00
    MOVWF   STATUS
   
    MOVLW   0xF8
    MOVWF   TRISD,0; Establihes port D0-D2 as outputs
    
    
    
    MOVLW   refTempInput
    MOVWF   refTemp,0
    MOVLW   measuredTempInput
    MOVWF   measuredTemp,0 
    MOVLW   0xF0
    CPFSGT  measuredTemp,0
    BRA	    _comp
    BRA	    _elim
; Hex to Decimal Conversion and Storage
;-----------------------
; Eliminate negative numbers
_elim:    
    NEGF    measuredTemp,0
    MOVLW   refTempInput
    ADDLW   1
    
;Compare for heating, WREG=refTemp
    
_comp:    
    CPFSLT  measuredTemp,0; If measured is less than ref skips to heating implementation
    BRA	    _coolcheck; If measured >= Ref skips to another check
    BRA	    _heating
    
_coolcheck: 
    CPFSGT  measuredTemp,0; Wreg = refTemp, is measured is greater than ref, skips to cooling implementation
    BRA	    _equalcheck
    BRA     _cooling
    
_equalcheck:
    CPFSEQ  measuredTemp,0; Wreg = refTemp, if they are equal goes to equal value implementaion
    BRA	    _start
    BRA	    _equal
    
_heating:
    MOVLW   0x02
    MOVWF   PORTD,0
    MOVLW   0x01
    MOVWF   contReg,0
    BRA	    _end
_cooling:
   MOVLW    0x04
   MOVWF   PORTD,0
   MOVLW    0x02
   MOVWF    contReg,0
   BRA	    _end
   
_equal:
    MOVLW   0x00
    MOVWF   contReg,0
    MOVWF   PORTD,0
    BRA	    _end

_end:
END
