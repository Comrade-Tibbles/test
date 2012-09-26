// Name: Steven Stanaway
// EECE 337 - Fall 2012
// hw1

// Constants for supplied functions
RCC_BASE                        EQU     0x40023800
RCC_AHBENR_OFF                  EQU     0x1C
RCC_AHBENR_GPIOAEN              EQU     0x01
RCC_AHBENR_GPIOBEN              EQU     0x02
RCC_AHBENR_GPIOCEN              EQU     0x04

GPIO_PORTA_BASE                 EQU     0x40020000
GPIO_PORTB_BASE                 EQU     0x40020400
GPIO_PORTC_BASE                 EQU     0x40020800

GPIO_PIN_0                      EQU     0X01
GPIO_PIN_1                      EQU     0X02
GPIO_PIN_2                      EQU     0X04
GPIO_PIN_3                      EQU     0X08
GPIO_PIN_4                      EQU     0X10
GPIO_PIN_5                      EQU     0X20
GPIO_PIN_6                      EQU     0X40
GPIO_PIN_7                      EQU     0x80
GPIO_PIN_8                      EQU     0x100
GPIO_PIN_9                      EQU     0x200
GPIO_PIN_10                     EQU     0x400
GPIO_PIN_11                     EQU     0x800
GPIO_PIN_12                     EQU     0x1000
GPIO_PIN_13                     EQU     0x2000
GPIO_PIN_14                     EQU     0x4000
GPIO_PIN_15                     EQU     0x8000

GPIO_MODER_OFF                  EQU     0x00
GPIO_OTYPER_OFF                 EQU     0x04
GPIO_OSPEEDR_OFF                EQU     0x08
GPIO_PUPDR_OFF                  EQU     0x0C
GPIO_ODR_OFF                    EQU     0x14
GPIO_IDR_OFF                    EQU     0x10

GPIO_MODER_OUT_PORT6AND7        EQU 0X5000
GPIO_OSPEEDR_2MHZ_PORT6AND7     EQU 0X5000
GPIO_MODER_OUT_PORT5            EQU 0X00000400

GPIO_MODER_OUT_PORT11           EQU 0X00400000

GPIO_MODER_OUT_PORT12           EQU 0X01000000
GPIO_OSPEEDR_2MHZ_PORT12        EQU 0X01000000

GPIO_OTYPER_PP                  EQU 0X00
GPIO_PUPDR_NOPULL               EQU 0X00

DELAY_HIGH                      EQU     0x0006  //0x0006
DELAY_LOW                       EQU     0x0000


        NAME hw1
        
        PUBLIC  main_assembly
        
        SECTION .text : CODE (2)
        THUMB
        
        PUBLIC  config_gpio
        
        SECTION .text : CODE (2)
        THUMB
               
        PUBLIC  delay
        
        SECTION .text : CODE (2)
        THUMB


// Start of Assembly Language Code - Called from C main()
main_assembly:
        BL      config_gpio       // Initialize GPIO pins
        
        
main_loop
        
GRN_L:

        LDR     R0, =GPIO_PORTB_BASE
        LDR     R1, =GPIO_ODR_OFF
        
        MOV R5, #5
          
GRN: 
        // Turn Green Light On
        LDR     R2, =GPIO_PIN_7
        LDR     R3, [R0, R1]
        ORR     R2, R3, R2
        STR     R2, [R0, R1]
        BL      delay
        
        // Turn Green Light Off
	LDR	R2, =GPIO_PIN_7
        LDR     R3, [R0, R1]
        BIC     R2, R3, R2
	STR	R2, [R0, R1]
        BL      delay
        
          SUB R5,R5,#1
          CMP R5, #0
          BLE BLU_L
          B GRN
        
        
BLU_L:    
        LDR     R0, =GPIO_PORTB_BASE
        LDR     R1, =GPIO_ODR_OFF
        
        MOV R5, #5
          
BLU: 
        // Turn Blue Light On
        LDR     R2, =GPIO_PIN_6
        LDR     R3, [R0, R1]
        ORR     R2, R3, R2
        STR     R2, [R0, R1]
        
        BL      delay
        
        // Turn Blue Light Off
	LDR	R2, =GPIO_PIN_6
        LDR     R3, [R0, R1]
        BIC     R2, R3, R2
	STR	R2, [R0, R1]
          
        BL      delay
          SUB R5,R5,#1
          CMP R5, #0
          BLE GRN_L
          B BLU

                     
        B       main_loop                         // infinite loop
        
        
        
        BX      lr				    // return - should never get here....







// Supplied Functions - Do not modify....
config_gpio:
        // Enable RCC GPIO Clock
        LDR     R0, =RCC_BASE               // load base address for RCC
        LDR     R1, =RCC_AHBENR_OFF         // load offset for AHBENR
        LDR     R2, =RCC_AHBENR_GPIOBEN     // load value for GPIO Port B enable
        
        LDR     R3, [R0, R1]                // Read current AHBENR value
        ORR     R2, R2, R3                  // Modify AHBENR value to enable B
        STR	R2, [R0, R1]                // Write new AHBENR value to register

        // Set Port B Mode
        //GPIO_Mode_OUT
        LDR     R2, =GPIO_MODER_OUT_PORT6AND7
        LDR     R0, =GPIO_PORTB_BASE
        LDR     R1, =GPIO_MODER_OFF
        
        LDR     R4, [R0, R1]
        ORR     R4, R2, R4        
        STR	R4, [R0]
                        
        // Set Port Speed
        //GPIO_Speed_2MHz
        LDR     R2, =GPIO_OSPEEDR_2MHZ_PORT6AND7
        LDR     R0, =GPIO_PORTB_BASE
        LDR     R1, =GPIO_OSPEEDR_OFF
        
        LDR     R4, [R0, R1]
        ORR     R4, R2, R4
        STR	R4, [R0, R1]
                
        // Set Port Output Type
        //GPIO_OType_PP
        LDR     R2, =GPIO_OTYPER_PP
        LDR     R0, =GPIO_PORTB_BASE
        LDR     R1, =GPIO_OTYPER_OFF
        
        LDR     R4, [R0, R1]
        ORR     R4, R2, R4
        STR	R4, [R0, R1]
                
        // Set Port Pull-up/ Pull-down resistor
        //GPIO_PuPd_NOPULL
        LDR     R2, =GPIO_PUPDR_NOPULL
        LDR     R0, =GPIO_PORTB_BASE
        LDR     R1, =GPIO_PUPDR_OFF
        
        LDR     R4, [R0, R1]
        ORR     R4, R2, R4
        STR	R4, [R0, R1] 
       
        
            
        // Set Port A Mode - Left as reset values, input, slow mode
        
        // Enable RCC GPIO Clock
        LDR     R0, =RCC_BASE               // load base address for RCC
        LDR     R1, =RCC_AHBENR_OFF         // load offset for AHBENR
        LDR     R2, =RCC_AHBENR_GPIOAEN     // load value for GPIO Port A enable
        
        LDR     R3, [R0, R1]                // Read current AHBENR value
        ORR     R2, R2, R3                  // Modify AHBENR value to enable A
        STR	R2, [R0, R1]                // Write new AHBENR value to register

     // Set Port A.11, A.12 to output
     // Leave A.1 as input for pushbutton
        //GPIO_Mode_OUT
        LDR     R2, =(GPIO_MODER_OUT_PORT5 | GPIO_MODER_OUT_PORT11 | GPIO_MODER_OUT_PORT12)
        LDR     R0, =GPIO_PORTA_BASE
        LDR     R1, =GPIO_MODER_OFF
        
        LDR     R4, [R0, R1]
        ORR     R4, R2, R4        
        STR	R4, [R0]                               
        // Set Port Speed
        //GPIO_Speed_400kHz by default....
        
        
 //  Enable Port C as output       
       
        // Enable RCC GPIO Clock
        LDR     R0, =RCC_BASE               // load base address for RCC
        LDR     R1, =RCC_AHBENR_OFF         // load offset for AHBENR
        LDR     R2, =RCC_AHBENR_GPIOCEN     // load value for GPIO Port C enable
        
        LDR     R3, [R0, R1]                // Read current AHBENR value
        ORR     R2, R2, R3                  // Modify AHBENR value to enable C
        STR	R2, [R0, R1]                // Write new AHBENR value to register

        // Set Port C Mode
        //GPIO_Mode_OUT
        LDR     R2, =GPIO_MODER_OUT_PORT12
        LDR     R0, =GPIO_PORTC_BASE
        LDR     R1, =GPIO_MODER_OFF
        
        LDR     R4, [R0, R1]
        ORR     R4, R2, R4        
        STR	R4, [R0]
                        
        // Set Port Speed
        //GPIO_Speed_2MHz
        LDR     R2, =GPIO_OSPEEDR_2MHZ_PORT12
        LDR     R0, =GPIO_PORTC_BASE
        LDR     R1, =GPIO_OSPEEDR_OFF
        
        LDR     R4, [R0, R1]
        ORR     R4, R2, R4
        STR	R4, [R0, R1]
                
        // Set Port Output Type
        //GPIO_OType_PP
        LDR     R2, =GPIO_OTYPER_PP
        LDR     R0, =GPIO_PORTC_BASE
        LDR     R1, =GPIO_OTYPER_OFF
        
        LDR     R4, [R0, R1]
        ORR     R4, R2, R4
        STR	R4, [R0, R1]
                
        // Set Port Pull-up/ Pull-down resistor
        //GPIO_PuPd_NOPULL
        LDR     R2, =GPIO_PUPDR_NOPULL
        LDR     R0, =GPIO_PORTC_BASE
        LDR     R1, =GPIO_PUPDR_OFF
        
        LDR     R4, [R0, R1]
        ORR     R4, R2, R4
        STR	R4, [R0, R1] 
       
        
        BX      lr				    // return



// Very Crude delay function
delay:
        MOV     R9, #DELAY_LOW
        MOV    R9, #DELAY_HIGH
        
delay_loop
        SUBS    R9, R9, #1
        CMP     R9, #0
        BNE     delay_loop
        BX      lr				    // return

        
        END
        
