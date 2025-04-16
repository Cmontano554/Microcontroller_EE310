#include <xc.h>  //Required 

void initialize(void){
    //setup PORTB
    PORTB = 0; 
    ANSELB = 0; 
    LATB = 0;
    TRISB = 0b01100111;
    
    
    //setup PORTD
    PORTD = 0; 
    ANSELD = 0; 
    LATD = 0; 
    TRISD = 0b00000000;
    
    //setup PORTA
    PORTA = 0; 
    ANSELA = 0; 
    LATA = 0; 
    TRISA = 0b00000000;

    //Enable interrupt priority bit in INTCON0 register
    INTCON0bits.IPEN = 1;
  
    //Enables high priority interrupts
    INTCON0bits.GIEH = 1;
    
    //Enables low priority interrupts
    INTCON0bits.GIEL = 1;
    
    //INterrupt on rising edge  of INT0 pin
    INTCON0bits.INT0EDG = 0;
    
    //Sets the interrupt high priority (IP) for INT0 - INT0IP
    IPR1bits.INT0IP = 1;
    
    //Enable the interrupt (IE) for INT0
    PIE1bits.INT0IE = 1;
    
    //Clears interrupt flag for INT0
    PIR1bits.INT0IF = 0;
    PIR5bits.INT1IF = 0;  // Clear Interrupt 1
    
    
    IVTBASEU = 0x00;
    IVTBASEH = 0x40;
    IVTBASEL = 0x08;
                         // Enable low priority interrupts using bits in INTCON0
   
    // Change IVTBASE by doing the following
    
    WPUB=0b00100001; // weak pull-ups are enabled for port B
    return;
}