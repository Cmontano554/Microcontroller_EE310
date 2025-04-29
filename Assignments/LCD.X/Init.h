#ifndef INIT_H
#define INIT_H
#include "Config.h"
#include "Functions.h"
#include <xc.h>

void LCD_Init(void);
void MSdelay(unsigned int );
void LCD_Command(char );
void ADC_Init(void);
void INTERRUPT_Initialize(void);



#define RS LATDbits.LATD0                   /* PORTD 0 pin is used for Register Select */
#define EN LATDbits.LATD1                   /* PORTD 1 pin is used for Enable */
#define ldata LATB                 /* PORTB is used for transmitting data to LCD */

#define LCD_Port TRISB              
#define LCD_Control TRISD
#define EMERGENCY_FLAG IOCCFbits.IOCCF2
#define LED PORTDbits.RD3

void INTERRUPT_Initialize(void) {
TRISCbits.TRISC2 = 1;  // RC1 as input
ANSELCbits.ANSELC2 = 0; // Digital input
IOCCNbits.IOCCN2 = 0;  // No Negative edge
IOCCPbits.IOCCP2 = 1;  //  positive edge 

//IPR0bits.IOCIP = 1;
IOCCFbits.IOCCF2 = 0;  // Clear interrupt flag
PIR0bits.IOCIF = 0; // Clear flag
PIE0bits.IOCIE = 1;  // Enable IOC interrupts
INTCON0bits.GIEL = 1;
INTCON0bits.GIEH = 1;    // Enable global interrupt
INTCON0bits.IPEN = 1; // Enable Priority


}

void ADC_Init(void)
{
       //Setup ADC
    ADCON0bits.FM = 1;  //right justify
    ADCON0bits.CS = 1; //ADCRC Clock
    
    TRISAbits.TRISA0 = 1; //Set RA0 to input
    ANSELAbits.ANSELA0 = 1; //Set RA0 to analog
    // Added 
    ADPCH = 0x00; //Set RA0 as Analog channel in ADC ADPCH
    ADCLK = 0x00; //set ADC CLOCK Selection register to zero
    
    ADRESH = 0x00; // Clear ADC Result registers
    ADRESL = 0x00; 
    
    ADPREL = 0x00; // set precharge select to 0 in register ADPERL & ADPERH
    ADPREH = 0x00; 
    
    ADACQL = 0x00;  // set acquisition low and high byte to zero 
    ADACQH = 0x00;    
    
    ADCON0bits.ON = 1; //Turn ADC On 
}
void LCD_Init(void){
    MSdelay(15);                /* 15ms,16x2 LCD Power on delay */   
    LCD_Port = 0x00;       /* Set PORTB as output PORT for LCD data(D0-D7) pins */
    LCD_Control = 0x00;    /* Set PORTD as output PORT LCD Control(RS,EN) Pins */
    LCD_Command(0x01);     /* clear display screen */
    LCD_Command(0x38);     /* uses 2 line and initialize 5*7 matrix of LCD */
    LCD_Command(0x0c);     /* display on cursor off */
    LCD_Command(0x06);     /* increment cursor (shift cursor to right) */
   
}

#endif