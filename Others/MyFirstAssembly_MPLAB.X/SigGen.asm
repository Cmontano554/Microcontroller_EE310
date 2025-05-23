;---------------------
; Title: Waveform Generator with Delay
;---------------------
; Program Details:
; The purpose of this program is to demonstrate how to call a delay function. 

; Inputs: Inner_loop ,Outer_loop 
; Outputs: PORTD
; Date: Feb 24, 2024
; File Dependencies / Libraries: None 
; Compiler: xc8, 2.4
; Author: Farid Farahmand
; Versions:
;       V1.3: Changes the loop size
; Useful links: 
;       Datasheet: https://ww1.microchip.com/downloads/en/DeviceDoc/PIC18(L)F26-27-45-46-47-55-56-57K42-Data-Sheet-40001919G.pdf 
;       PIC18F Instruction Sets: https://onlinelibrary.wiley.com/doi/pdf/10.1002/9781119448457.app4 
;       List of Instrcutions: http://143.110.227.210/faridfarahmand/sonoma/courses/es310/resources/20140217124422790.pdf 


;---------------------
; Initialization - make sure the path is correct
;---------------------
#include ".\MyConfigFile.inc"
;#include "C:\Users\student\Documents\myMPLABXProjects\ProjectFirstAssemblyMPLAB\FirstAssemblyMPLAB.X\AssemblyConfig.inc"

#include <xc.inc>

;---------------------
; Program Inputs
;---------------------
Inner_loop  equ 5 // in decimal
Outer_loop  equ 5
 
;---------------------
; Program Constants
;---------------------
REG10   equ     10h   // in HEX
REG11   equ     11h
REG01   equ     1h
REG02	equ	2h
;---------------------
; Definitions
;---------------------
#define SWITCH    LATD,2  
#define LED0      PORTD,0
#define LED1	  PORTD,1

;---------------------
; Main Program
;---------------------
    PSECT absdata,abs,ovrld        ; Do not change
    
    ORG          0                ;Reset vector
    GOTO        _start1

    ORG          0020H           ; Begin assembly at 0020H

_start1:
    MOVLW	0x00
    MOVWF       TRISD,0
    MOVLW	0xFE
    MOVWF       REG01,0
    MOVLW	0xFD
    MOVWF	REG02,0

_onoff:
    MOVFF       REG01,PORTD
    MOVFF	REG02,PORTD
    MOVLW       Inner_loop
    MOVWF       REG10,0
    MOVLW       Outer_loop
    MOVWF       REG11,0

_loop1:
    DECF        REG10,1,0
    BNZ         _loop1
_loop2:
    DECF        REG11,1,0 // outer loop
    BNZ        _loop2
    
    COMF        REG01,1,0 // Negate the register 
    COMF	REG02,1,0
    BRA         _onoff
END