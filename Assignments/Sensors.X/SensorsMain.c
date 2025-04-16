/* 
 * File:   SensorsMain.c
 * Author: Cole_Montano
 *
 * Created on April 14, 2025, 9:01 PM
 * Versions:
 *          1.0 Created Header Files
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
