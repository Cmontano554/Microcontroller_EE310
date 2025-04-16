#include <xc.h>
#include <stdio.h>
#include <stdlib.h>

#define _XTAL_FREQ 4000000
#define FCY     _XTAL_FREQ/4

int code = 0x21; // The secret code
int input = 0x00;
int count = 0x00;
const char seg_code[] __at(0x200) = {0x3F, 0x06, 0x5B, 0x4F};
int x = 0x00;
int y = 0x00;
void check(void);


void __interrupt(irq(IRQ_INT0),base(0x4008)) INT0_ISR(void) {
    if (PIR1bits.INT0IF == 1) {
       
       
                
        for (int i = 0; i < 2; i++) { 
             PORTBbits.RB4 = 1;
            __delay_ms(200);
            PORTBbits.RB4 = 0;
            __delay_ms(500);
            PORTBbits.RB4 = 1;
            __delay_ms(100);
            PORTBbits.RB4 = 0;
            __delay_ms(600);
            
        
        }
       
    }
    PIR1bits.INT0IF = 0;
}

void check(void) {
    
    // Indicate PIC is on
    PORTBbits.RB7 = 1;
    count = 0x00;
    
    while ( x < 1){
        if (PORTBbits.RB1 == 0){
            count = count + 1;
            __delay_ms(2000);
            if (count >= 4) {
            count = 0;
            }
        }
        if (PORTBbits.RB5== 0) {
            x = x + 1;
            input = input + (count*16);
            count = 0xFF;
            
        }
        PORTD = seg_code[count];
        
                
    }
        __delay_ms(1000);
        count = 0x00;
        while ( y < 1){
        if (PORTBbits.RB2 == 0){
            count = count + 1;
            __delay_ms(2000);
            if (count >= 4) {
            count = 0;
            }
        }
        if (PORTBbits.RB5 == 0) {
            y = y + 1;
            input = input + count;
            count = 0xFF;
            
        }
        PORTD = seg_code[count];
    }
    if (input == code) {
        PORTBbits.RB3 = 1;
        __delay_ms(5000);
        PORTBbits.RB3 = 0;
    }
    
    if (input != code) {
        PORTBbits.RB4 = 1;
        __delay_ms(2000);
        PORTBbits.RB4 = 0;
    }
}