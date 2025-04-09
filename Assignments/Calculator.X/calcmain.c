/* 
 * -------------------------------------------------
 * Title: LED Display Binary Calculator
 * -------------------------------------------------
 * Purpose: To implement a calculator using a 4x4 matrix keypad to display a binary value on 
 * LEDS using a PIC18F47K42 microcontroller using the C coding language. The calculator performs the four basic arithmetic operations:
 * addition, subtraction, multiplication, and division.
 *
 * Outputs: PORTD [0:7], controls the output LEDS
 *          PORTB [0:3], controls the columns of the KEYPAD
 * Inputs:  PORTB [4:7], takes input from KEYPAD rows
 * Dependency: Configuration header
 * Compiler: MPLAB X IDE v6.20; XC8, V3.0
 * Author: Cole Montano
 * Versions: 1.0 Created on 4/5/2025 - Wrote Functions and Main Code Body
 *           1.1 Created on 4/6/2025 - Corrected Issue with Double Inputs, Created Reset at All Stages
 *           1.2 Created on 4/8/2025 - Finished Header and Reset Function
 */

#include <xc.h>
#include "calcH.h"
#include <stdio.h> 
#include <stdlib.h> 
#include <math.h> 

/*
 * 
 */
#define _XTAL_FREQ 4000000 // Fosc  frequency for _delay()  library


int x_reg __at(0x01); // first number
int y_reg __at(0x03); //second number
int op_reg __at(0x05);//(+,-,*,/))
signed char display_reg __at(0x07); //solution


unsigned char button;
int a;
int b;
int c;
int d;
 
//Call Functions
void initialize();
void check_keypad();
void setupB();
void setupD();
void op();
void solve();



void main (void) {
    while (1) { //Infinite loop
        start:
        initialize();
        check_keypad();
        if (d == 1) goto start;
        x_reg = x_reg + (button*10); //Tens place
        __delay_ms(500);
        check_keypad();
        if (d == 1) goto start;
        x_reg = x_reg + button; // Ones place
        PORTDbits.RD0 = 1; //First led turns on
        op();
        if (d == 1) goto start;
        check_keypad();
        if (d == 1) goto start;
        y_reg = y_reg + (button*10);
        __delay_ms(500);
        check_keypad();
        if (d == 1) goto start;
        y_reg = y_reg + button;
        PORTDbits.RD0 = 0;
        PORTDbits.RD1 = 1;
        solve();
        if (d == 1) goto start;
        PORTDbits.RD1 = 0;
        PORTD = display_reg;
        __delay_ms(5000); //10 Second delay to view result      
    }
    return;
}


void initialize() {
    x_reg = 0;
    y_reg = 0;
    button = 0;
    op_reg = 0;
    display_reg = 0;
    setupB();
    setupD();
    a = 0;
    b = 0;
    c = 0;
    d = 0;
    button = 0;
   
    
}


void setupB() {
    PORTB = 0x00;
    TRISB = 0b11110000; //RB0-RB3 are output and RB4-RB7 are inputs
    LATB = 0x00;
    ANSELB = 0x00;           
}

void setupD() {
    PORTD = 0x00;
    TRISD = 0x00; // All of D is an output
    LATD = 0x00;
    ANSELD = 0x00;       
}



void check_keypad() {
    a = 0;
    button = 0;
    while (a<1) {
        PORTBbits.RB0 = 1;
        if (PORTBbits.RB4 == 1) button = 1, a = a+1, __delay_ms(1);
        else if (PORTBbits.RB5 == 1) button = 4, a = a+1, __delay_ms(1);
        else if (PORTBbits.RB6 == 1) button = 7, a = a+1, __delay_ms(1);
        else if (PORTBbits.RB7 == 1) d = d + 1, a = a + 1, __delay_ms(1);
        PORTBbits.RB0 = 0;
        
        PORTBbits.RB1 = 1;
        if (PORTBbits.RB4 == 1) button = 2, a = a+1, __delay_ms(1);
        else if (PORTBbits.RB5 == 1) button = 5, a = a+1, __delay_ms(1);
        else if (PORTBbits.RB6 == 1) button = 8, a = a+1, __delay_ms(1);
        else if (PORTBbits.RB7 == 1) button = 0, a = a+1, __delay_ms(1);
        PORTBbits.RB1 = 0;
        
        PORTBbits.RB2 = 1;
        if (PORTBbits.RB4 == 1) button = 3, a = a+1, __delay_ms(1);
        else if (PORTBbits.RB5 == 1) button = 6, a = a+1, __delay_ms(1);
        else if (PORTBbits.RB6 == 1) button = 9, a = a+1, __delay_ms(1);
        PORTBbits.RB2 = 0;
        
    }
}

void op() {
    b = 0;
    
    while (b<1) {
        PORTBbits.RB3 = 1;
        if (PORTBbits.RB4 == 1) op_reg = 1, b = b+1; //Addition 
        else if (PORTBbits.RB5 == 1) op_reg = 2, b = b+1; //Subtraction
        else if (PORTBbits.RB6 == 1) op_reg = 3, b = b+1; // Multiplication
        else if (PORTBbits.RB7 == 1)  op_reg = 4, b = b+1; //Division
        PORTBbits.RB3 = 0;
        
        PORTBbits.RB0 = 1;
        if (PORTBbits.RB7 == 1) d = d+ 1, b = b +1;
        PORTBbits.RB0 = 0;
    }
            
}

void solve() {
    c = 0;
    while (c<1) {
        PORTBbits.RB2 = 1;
        if (PORTBbits.RB7 == 1) c = c+1; 
        PORTBbits.RB2 = 0;
        
        PORTBbits.RB0 = 1;
        if (PORTBbits.RB7 == 1) d = d + 1, c = c +1;
        PORTBbits.RB0 = 0;
    }
    if (op_reg == 1) display_reg = (x_reg + y_reg);
    else if (op_reg == 2) display_reg = (x_reg - y_reg);
    else if (op_reg == 3) display_reg = (x_reg * y_reg);
    else if (op_reg == 4) display_reg = (x_reg/y_reg);
    
}
