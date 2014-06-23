/*
 * octoblocks.asm
 *
 *  Created: 02/06/2014 05:55:28 p.m.
 *   Author: Lefo
 */
 


 ; ******************************************************
; BASIC .ASM template file for AVR config3modulosatemega328 gusano
; ******************************************************

//.include "m88def.inc"
.INCLUDE "m328def.inc"
.cseg
;****************************************************
;**************vectores de interecion****************
;****************************************************

.org $00
rjmp inicio

;-----para timer1----------
.org 0x000E
rjmp Timer2_COMPA

.org 0x0010
rjmp Timer2_COMPB

.org 0x0012
rjmp TIM2_OVF

;----para timer0-----------

.org 0x001C
rjmp Timer0_COMPA

.org 0x001E
rjmp Timer0_COMPB

.org 0x0020
rjmp TIM0_OVF



;----------------------------------------------------------------------------------------------------





;--------progrma principal---------------------------------

inicio:

	ldi		R18,LOW(RAMEND)
	out		SPL,R18
	ldi		R18,HIGH(RAMEND)
	out		SPH,R18





ldi r16, $ff       ;puertos B como salidas
out ddrb, r16
out ddrd, r16	   ;puertos D como salidas oc2 A,
  

;-----configuramos timer1-----servo1 y servo2-------------------------

	   LDI R16,(1<<COM1A1|0 <<COM1A0|1<<COM1B1|0<<COM1B0|1<<WGM11|0<<WGM10)
       STS TCCR1A,R16    ; configuramos timer1 modo14 pwm no invertido,top = icr1
       LDI R16,(1<<WGM13|1 <<WGM12|0<<CS12|0<<CS11|1<<CS10)
       STS TCCR1B,R16

 

       LDI R16,HIGH(20000)
       STS ICR1H,R16
       LDI R16,LOW(20000)          ;ICR1 ES EL TOPE = 20ms
       STS ICR1L,R16


;-----configuramos timer2-----servo3 y servo4-------------------------

	
		;Configuramos Periodo de la PWM en TIMER 2, top= max
		;modo 3, preescalador =64, frec = 61Hz, clk =1MH
   	   LDI R16,(1<<COM2A1|0 <<COM2A0|1<<COM2B1|0<<COM2B0|1<<WGM21|1<<WGM20)
       STS TCCR2A,R16    ; 
       LDI R16,(0<<WGM22|1<<CS22|0<<CS21|0<<CS20)
       STS TCCR2B,R16
		;habilitamos interreupciones timer2Compa, Timer2CompB y Timer2OVF
		lds  r16, TIMSK2
		ori r16,(1<<TOIE2) | (1<<OCIE2A) | (1<<OCIE2B)
		sts TIMSK2, r16


;-----configuramos timer0-----servo5 y servo6-------------------------

		;Configuramos Periodo de la PWM en TIMER 0, top= max
		;modo 3, preescalador =64, frec = 61Hz, clk =1MHZ
   	   LDI R16,(1<<COM0A1|0 <<COM0A0|1<<COM0B1|0<<COM0B0|1<<WGM01|1<<WGM00)
       OUT TCCR0A,R16    ; 
       LDI R16,(0<<WGM02|0<<CS02|1<<CS01|1<<CS00)
       OUT TCCR0B,R16
		;habilitamos interreupciones timer2Compa, Timer2CompB y Timer2OVF
		lds  r16, TIMSK0
		ori r16,(1<<TOIE0) | (1<<OCIE0A) | (1<<OCIE0B)
		sts TIMSK0, r16

;-------------fin configuracion de timers-------------------------------------------
	 
	 
	   sei





	



;---------------------------------------------------------------------------
;...........instante0: 0,0,0,0,0,0.............................................
;---------------------------------------------------------------------------
	;----------------------------------------------------
	;------POSICIONES SERVO1 Y SERVO2-TIMER1-------------

		   ;DUTYC. EN OCR1A-PB1 SERVO1  
	   LDI R16,HIGH(1360)
       STS OCR1AH,R16
       LDI R16,LOW(1360)   
       STS OCR1AL,R16
	
		;;DUTYC. EN OCR1B-PB1 SERVO2 
	   LDI R16,HIGH(1480)
       STS OCR1BH,R16
       LDI R16,LOW(1480)   
       STS OCR1BL,R16



	;---------------------------------------------------
	;------POSICIONES SERVO3 Y SERVO4-TIMER2------------

		;DUTYC. EN PB3-SERVO3 0 grados, 

		LDI R16,21
       	STS OCR2A,R16

		;DUTYC. EN PD3-SERVO4 0 grados, 
	
	   	LDI R16,21
       	STS OCR2B,R16


	;---------------------------------------------------------
	;------POSICIONES SERVO5 Y SERVO6-TIMER0---------------

		;DUTYC. EN PD6-SERVO5, 0 grados, 

		LDI R16,23
       	OUT OCR0A,R16

		;DUTYC. EN PD5-SERVO6, 0 grados, 
	
	   	LDI R16,23
       	OUT OCR0B,R16

	  
	  rcall retardo100
	  rcall retardo100
	
	 
	  

 



 lazo:

;----------------------------------------------------------------------------------
;...........instante1: +45,-45,-45,+45,0,0...s1,s2,s3,s4,s5..........................................................
;----------------------------------------------------------------------------------
	;---------------------------------------------------------
	;---------POSICIONES SERVO1 Y SERVO2-TIMER1---------------

	

		; DUTYC. EN OCR1A-PB1 SERVO1  
	   LDI R16,HIGH(1764)
       STS OCR1AH,R16
       LDI R16,LOW(1764)   
       STS OCR1AL,R16

	   	;DUTYC. EN OCR1B-PB1 SERVO2 
	   LDI R16,HIGH(1894)
       STS OCR1BH,R16
       LDI R16,LOW(1894)   
       STS OCR1BL,R16



	;---------------------------------------------------
	;------POSICIONES SERVO3 Y SERVO4-TIMER2------------

		;DUTYC. EN PB3-SERVO3 -45 grados, 

		LDI R16,14
       	STS OCR2A,R16

		;DUTYC. EN PD3-SERVO4 +45 grados, 
	
	   	LDI R16,14
       	STS OCR2B,R16


	;---------------------------------------------------------
	;------POSICIONES SERVO5 Y SERVO6-TIMER0---------------

		;DUTYC. EN PD6-SERVO5, 0 grados, 

		LDI R16,23
       	OUT OCR0A,R16

		;DUTYC. EN PD5-SERVO6, 0 grados, 
	
	   	LDI R16,23
       	OUT OCR0B,R16

	  rcall retardo100
	  rcall retardo100
	
	


	  
	 
	  


;------------------------------------------------------------------------------
;...........instante2: 0,0,-45,+45,-45,+45........................................................
;------------------------------------------------------------------------------
	;---------------------------------------------------------
	;---------POSICIONES SERVO1 Y SERVO2-TIMER1---------------

	 ;DUTYC. EN OCR1A-PB1 SERVO1  
	   LDI R16,HIGH(1360)
       STS OCR1AH,R16
       LDI R16,LOW(1360)   
       STS OCR1AL,R16
	
		;;DUTYC. EN OCR1B-PB1 SERVO2 
	   LDI R16,HIGH(1480)
       STS OCR1BH,R16
       LDI R16,LOW(1480)   
       STS OCR1BL,R16


	;---------------------------------------------------------
	;---------POSICIONES SERVO3 Y SERVO4-TIMER2---------------

	;DUTYC. EN PB3-SERVO3 -45 grados, 

		LDI R16,14
       	STS OCR2A,R16

		;DUTYC. EN PD3-SERVO4 +45 grados, 
	
	   	LDI R16,14
       	STS OCR2B,R16


	;---------------------------------------------------------
	;------POSICIONES SERVO5 Y SERVO6-TIMER0---------------

	;DUTYC. OCR0A - -SERVO5 

	 	LDI R17,13
      	OUT OCR0A,R17 // ojo, se utiliza out para los regictros OCR0A/B

	;DUTYC. OCR0B - -SERVO6    	
      	LDI R17,16
       	OUT OCR0B,R17 ; ojo, se utiliza out para los regictros OCR0A/B


	  rcall retardo100
	  rcall retardo100
	 


	  
	  

;------------------------------------------------------------------------------
;...........instante3: -45,+45,0,0,-45,+45.........................................................
;------------------------------------------------------------------------------
	;---------------------------------------------------------
	;---------POSICIONES SERVO1 Y SERVO2-TIMER1---------------

	;DUTYC. OCR1A - PB0-SERVO1 
	   LDI R16,HIGH(890)
       STS OCR1AH,R16
       LDI R16,LOW(890)    
       STS OCR1AL,R16

	;DUTYC. OCR1B - PB1-SERVO2 
	   LDI R16,HIGH(1065)
       STS OCR1BH,R16
       LDI R16,LOW(1065)   
       STS OCR1BL,R16

	;---------------------------------------------------------
	;---------POSICIONES SERVO3 Y SERVO4-TIMER2---------------


	;DUTYC. EN PB3-SERVO3 0 grados, 

		LDI R16,21
       	STS OCR2A,R16

		;DUTYC. EN PD3-SERVO4 0 grados, 
	
	   	LDI R16,21
       	STS OCR2B,R16


	;---------------------------------------------------------
	;------POSICIONES SERVO5 Y SERVO6-TIMER0---------------

	;DUTYC. OCR0A - -SERVO5 

	 	LDI R17,13
      	OUT OCR0A,R17 // ojo, se utiliza out para los regictros OCR0A/B

	;DUTYC. OCR0B - -SERVO6    	
      	LDI R17,16
       	OUT OCR0B,R17 ; ojo, se utiliza out para los regictros OCR0A/B


	  rcall retardo100
	  rcall retardo100
	  
	  



;----------------------------------------------------------------------------------
;...........instant4: 0,+30,-45,-45,+45,+45.............................................................
;----------------------------------------------------------------------------------
	;---------------------------------------------------------
	;---------POSICIONES SERVO1 Y SERVO2-TIMER1---------------

	
	 ;DUTYC. EN OCR1A-PB1 SERVO1  
	   LDI R16,HIGH(1360)
       STS OCR1AH,R16
       LDI R16,LOW(1360)   
       STS OCR1AL,R16
	
		;;DUTYC. EN OCR1B-PB1 SERVO2 
	   LDI R16,HIGH(1480)
       STS OCR1BH,R16
       LDI R16,LOW(1480)   
       STS OCR1BL,R16



	;---------------------------------------------------
	;------POSICIONES SERVO3 Y SERVO4-TIMER2------------

		;DUTYC. EN PB3-SERVO3 0 grados, 

		LDI R16,21
       	STS OCR2A,R16

		;DUTYC. EN PD3-SERVO4 0 grados, 
	
	   	LDI R16,21
       	STS OCR2B,R16


	;---------------------------------------------------------
	;------POSICIONES SERVO5 Y SERVO6-TIMER0---------------

		;DUTYC. EN PD6-SERVO5, 0 grados, 

		LDI R16,23
       	OUT OCR0A,R16

		;DUTYC. EN PD5-SERVO6, 0 grados, 
	
	   	LDI R16,23
       	OUT OCR0B,R16

	  
	  

	  rcall retardo100
	  rcall retardo100


	  
rjmp lazo	  
	  

;------------------fin programa principal--------------------




;------------------------------------------------------------
;--------sevicio de rutinas de INTERRUPCION------------------
;------------------------------------------------------------

Timer2_COMPA:
	push r16 
	in r16, SREG
	push r16 


	cbi portb, 3


	pop r16 
	out SREG, r16 
	pop r16 
	reti

Timer2_COMPB:
	push r16 
	in r16, SREG
	push r16 


	cbi portd, 3


	pop r16 
	out SREG, r16 
	pop r16 
	reti


TIM2_OVF:
	
	push r16 
	in r16, SREG
	push r16 

	sbi portb, 3
	sbi portd, 3

	pop r16 
	out SREG, r16 
	pop r16 
	reti

Timer0_COMPA:
	push r16 
	in r16, SREG
	push r16 


	cbi portd, 6


	pop r16 
	out SREG, r16 
	pop r16 
	reti

Timer0_COMPB:
	push r16 
	in r16, SREG
	push r16 


	cbi portd,5


	pop r16 
	out SREG, r16 
	pop r16 
	reti


TIM0_OVF:
	
	push r16 
	in r16, SREG
	push r16 

	sbi portd,5
	sbi portd,6

	pop r16 
	out SREG, r16 
	pop r16 
	reti

;------------------SUBRRUTINAS---------------------------------------	

;******************************************
;**************RETARDO 10ms****************
;******************************************
retardo:

push XH
push XL

ldi XH,high(2497)
ldi XL,low(2497)
Lazo_retardo:
sbiw XL,1
brne Lazo_retardo
pop XL
pop XH

ret



;******************************************
;**************RETARDO 100ms****************
;******************************************
retardo100:

push r16
ldi r16,10
lazo_retardo_100:
rcall retardo
 dec r16	
brne lazo_retardo_100
pop r16

ret


;******************************************
;**************RETARDO 1/2s****************
;******************************************
// ahora es menos de un segundo!
RETARDO2_500:

push r16

ldi r16,5
lazo_retardo_1000:
rcall retardo100
dec r16
brne lazo_retardo_1000
pop r16

ret
