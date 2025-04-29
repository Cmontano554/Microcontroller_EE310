/* 
 * ------------------------------
 * Title: Code Locked Box
 * ------------------------------
 * Purpose: To implement interrupts, C coding, conditional statement,s and 
 * hardware including photo resistor, relays, driver circuits, motors, and
 * buzzer to simulate a code-locked box.  
 * Dependencies: Functions Header, Initialization Heade,r and Configuration Header
 * Outputs: RD0-RD7 For Seven Segment
 *          RB3 For Motor
 *          RB4 For All buzzer functions
 *          RB7 For LED to Show PIC is on
 * 
 * Inputs:  RBO Interrupt Input 
 *          RB5 Confirm Input
 *          RB1-RB2 For Photo-resistor inputs
 * 
 * Compiler: MPLAB X IDE v6.20; XC8, V3.0
 * Author: Cole Montano
 *
 * Versions:
 *          V1.0 Created Header Files
 *          V1.1 First Attempt of Photo-resistor
 *          V1.2 Code Works With LEDs Instead of Buzzer and Motor for Testing
 *               Sensitivity of photo-resistor may be hardware issue
 *          V2.0 Completed Hardware, fixed issue of common grounding, linked 
 *               Interrupt and incorrect code to the buzzer
 */


#include <stdio.h>
#include <stdlib.h>
#include <xc.h>
#include "Config.h"
#include "Initialize.h"
#include "functions.h"

#define _XRAL_FREQ 400000
#define FCY     _XTAL_FREQ/4


void initialize(void);

void main (void) {
    
    initialize();
    check();
    return;
}
