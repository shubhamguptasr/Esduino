//*****************************************************************************
//CoE 2DP4 Final Projec
//By Shubham Gupta 04/01/2016
//*****************************************************************************

#include <hidef.h> /* common defines and macros */
#include "derivative.h" /* derivative information */
#include "SCI.h"

#define initSYNR 0x01 // Defines the SYNR variable, and assigns it a value of 0x01, as shown in the calculations.
#define VCOFRQ 0x40
#define initREFDIV 0x00
#define REFFRQ 0x80

char string[20];
unsigned short val;

//function prototypes
void setClk(void); //function initiation for setting up bus speed
void delayby01ms(int k);//function initiation for setting up delay and sampling frequency
void ADC_output(void);////function initiation for outputting data

void OutCRLF(void){
 SCI_OutChar(CR);
 SCI_OutChar(LF);
 PTJ ^= 0x20; // toggle LED D2
}


void main(void) {
// Refer to Chapter 14 in S12G Reference Manual for ADC subsystem details
// Setup and Enable ADC Channel to 5

//-----------------------ADC Settings (Channel 5)-----------------------

 ATDCTL0 = 0x05; //selects channel 5
 ATDCTL1 = 0x2F; // set for 10-bit resolution
 ATDCTL3 = 0x90; // right justified, two sample per sequence
 ATDCTL4 = 0x02; // prescaler = 2; ATD clock = 6.25MHz / (2 * (2 + 1)) == 1.04MHz
 ATDCTL5 = 0x25; // continuous conversion on channel 5

//-----------------Desired Bus Clock Settings (16 Mhz)----------------------
 
 setClk(); //Enables the PLL clock, and sets the bus clock to 16 Mhz
 
 // Configure PAD0-PAD7 Pins
 ATDDIEN = 0x000F; // Configure PT1AD3-PT1AD0 (A3 to A0 on the Esduino) as digital inputs (as opposed to analog inputs)
 PER1AD = 0x0F; // Enable internal pull up resistors to avoid indeterminate state when not connected
 DDR1AD = 0x00; // Set upper 4 bits to outputs (D6, D4, A5, A4 on Esduino) and lower 4 bits to inputs (A3-A0 on Esduino)

// Setup LED and SCI
 DDRJ |= 0x01; // PortJ bit 0 is output to LED D2 on DIG13
 SCI_Init(9600);
 for(;;) {
 ADC_output();
 }
//For loop to verify Clock  
  // for(;;){      
 //  PTJ=0x01;
 //  delayby01ms(1000);
  // PTJ=0x00;
  // delayby01ms(1000); 
//}
}

void setClk(void)
{    
    CPMUSYNR=initSYNR+VCOFRQ; //Set PLL multiplier (0x41 = 0100 0001)
    CPMUREFDIV = initREFDIV+REFFRQ; //Set PLL divider (0x80 = 1000 0000)
    CPMUPOSTDIV=0x00; // Set Post Divider
    CPMUOSC = 0xC0; // Enable external oscillator
    while (CPMUFLG_LOCK == 0) {} // wait for it
    CPMUPLL = CPMUCLKS; // Engage PLL to system.
}

//Delay Function

void delayby01ms(int k){//delays by 100 micro seconds, or a tenth of a milisecond for more accuracy
 int i;
 TSCR1 = 0x90; /* enable timer and fast timer flag clear */
 TSCR2 = 0x00; /* disable timer interrupt, set prescaler to 1*/
 TIOS |= 0x01; /* enable OC0 */ 
 TC0 = TCNT + 16000; //16000 was used to be more precise due to the 2.08ms
 for(i = 0; i < k; i++) {
 while(!(TFLG1_C0F));
 TC0 += 16000;
 }
 TIOS &= ~0x01; /* disable OC0 */ 
}

void ADC_output(void){
 PTJ ^= 0x01; // toggle LED
 val=ATDDR0;

// SCI_OutString("ADC Values:");
 SCI_OutUDec(val);//SCI output value 
 SCI_OutChar(CR); //new line
 delayby01ms(2); //This was done to achieve a 480 Hz sampling frequency
}                 //
