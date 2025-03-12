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
; V1.2: March, 10th. Final Version
     

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

#define  measuredTempInput 	14; this is the input value
#define  refTempInput 		14; this is the input value
; Note these values are assumed to be within specified range
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
num	equ	0x59
h	equ	0x58
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
    GOTO    _convert
_continue: 
    MOVLW   refTempInput
    MOVWF   refTemp,0
    MOVLW   measuredTempInput
    MOVWF   measuredTemp,0
    MOVLW   0xF0
    CPFSGT  measuredTemp,0
    BRA	    _comp
    BRA	    _elim
; Eliminate negative numbers
_elim:    
    NEGF    measuredTemp,0
    MOVLW   0x01
    ADDWF   refTemp
 
    
;Compare for heating, WREG=refTemp
    
_comp: 
    MOVFF   refTemp,WREG
    CPFSLT  0x21,0; If measured is less than ref skips to heating implementation
    GOTO    _coolcheck
    GOTO    _heating
    
_coolcheck: 
    CPFSGT  0x21,0; Wreg = refTemp, if measured is greater than ref, skips to cooling implementation
    BRA	    _equal
    BRA     _cooling
    
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
    
_convert:
    CLRF    h
    MOVLW   refTempInput
    MOVWF   num,0
    MOVLW   0x64
    CPFSGT  num,0; Checks if value is greater than 100d
    GOTO    _next
    GOTO    _hundreds
_hundreds:
    MOVLW   0x64
    CPFSLT  num,0; Checks if value is less than 100d
    GOTO    _hun
    CLRF    h
    GOTO    _next
_hun:
    MOVLW   0x64
    SUBWF   num
    MOVLW   0x01
    ADDWF   h
    GOTO    _hundreds
_next:  
    MOVLW   0x0A
    CPFSLT  num,0; Checks if value is less than 10d
    GOTO    _tens
    GOTO    _next2   
_tens:
    MOVLW   0x0A
    SUBWF   num
    MOVLW   0x01
    ADDWF   h
    GOTO    _next  
_next2:
    MOVFF   h,0x61; Places amount of loops into tens register
    MOVFF   num,0x60; Places remainder is ones register
    GOTO    _meas
_meas:
    CLRF    h
    MOVLW   measuredTempInput
    MOVWF   0x40
    MOVLW   0xF0
    CPFSGT  0x40,0; Ensures decimal is displayed corectly even if negative
    GOTO    _here
    NEGF    0x40
    MOVFF   0x40,WREG
    MOVWF   num,0
    GOTO    _after
_here:
    MOVLW   measuredTempInput; Only happens if number is posiitve
    MOVWF   num,0
_after:; Code reaches here always, steps before based on sign of value
    MOVLW   0x64
    CPFSGT  num,0; Checks if value is greater than 100d
    GOTO    _nextm1
    GOTO    _hundredsm
_hundredsm:
    MOVLW   0x64
    CPFSLT  num,0; Checks if value is less than 100d
    GOTO    _hunm
    CLRF    h
    GOTO    _nextm1
_hunm:
    MOVLW   0x64
    SUBWF   num
    MOVLW   0x01
    ADDWF   h
    GOTO    _hundredsm
_nextm1:   
    MOVLW   0x0A
    CPFSLT  num,0; Ensures value is less than 10d
    GOTO    _tensm
    GOTO    _nextm2  
_tensm:
    MOVLW   0x0A
    SUBWF   num
    MOVLW   0x01
    ADDWF   h
    GOTO    _nextm1  
_nextm2:
    MOVFF   h,0x71; Places amout of tens loops into tens register
    MOVFF   num,0x70; places remainder into ones register
    GOTO    _continue
   
_end:
END