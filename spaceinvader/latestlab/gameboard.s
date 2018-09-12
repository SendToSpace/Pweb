		AREA gameboard, CODE, READWRITE
		extern read_character
		extern output_character
		extern read_string
		extern output_string	
		extern spawn_player
		extern move_right
		extern move_left
		extern en_move_right
		extern en_move_left	
		extern en_move_down		
		extern player_setup
		extern shoot
		extern bullet_up
		extern enemy_move
		extern level
		extern game_instruction
		extern game_feature	
		extern press_s_to_start	
		extern check_level_clear	
		EXPORT board
		EXPORT FIQ_Handler
		EXPORT Initial_board
		EXPORT led_score		
		extern rng	
		extern print_scores
		extern en_shot	
		extern RPG_WHITE	
		extern RPG_PURPLE
		extern RPG_RED
		extern RPG_GREEN
		extern Display_life
		extern lives
		extern Display_score
		extern atoi
		extern itoa
		extern MOTHERLEFT
		extern MOTHERRIGHT
		extern mothermoving		
Timmer = "Game Over, Press Q to Exit, and Press LOAD to restart",0x00
boarder = 0x0D,0X0a,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x00
;clear = 0x1B,0x5B,0x32,0x4A,0x00
	ALIGN
clear = 0x0C,0x00
Initial_board =\
0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x0D,\
0x0A,0x7C,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x7C,0x0D,\
0x0A,0x7C,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x4F,0x4F,0x4F,0x4F,0x4F,0x4F,0x4F,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x7C,0x0D,\
0x0A,0x7C,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x4D,0x4D,0x4D,0x4D,0x4D,0x4D,0x4D,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x7C,0x0D,\
0x0A,0x7C,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x4D,0x4D,0x4D,0x4D,0x4D,0x4D,0x4D,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x7C,0x0D,\
0x0A,0x7C,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x57,0x57,0x57,0x57,0x57,0x57,0x57,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x7C,0x0D,\
0x0A,0x7C,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x57,0x57,0x57,0x57,0x57,0x57,0x57,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x7C,0x0D,\
0x0A,0x7C,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x7C,0x0D,\
0x0A,0x7C,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x7C,0x0D,\
0x0A,0x7C,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x7C,0x0D,\
0x0A,0x7C,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x7C,0x0D,\
0x0A,0x7C,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x7C,0x0D,\
0x0A,0x7C,0x20,0x20,0x20,0x53,0x53,0x53,0x20,0x20,0x20,0x53,0x53,0x53,0x20,0x20,0x20,0x53,0x53,0x53,0x20,0x20,0x20,0x7C,0x0D,\
0x0A,0x7C,0x20,0x20,0x20,0x73,0x20,0x73,0x20,0x20,0x20,0x73,0x20,0x73,0x20,0x20,0x20,0x73,0x20,0x73,0x20,0x20,0x20,0x7C,0x0D,\
0x0A,0x7C,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x7C,0x0D,\
0x00

;keep track of timmer0 cycle
timer0_cycle_count = 0x00
	ALIGN
;Every 2 cycle from the timmer0, this change to a 1
move_enable	= 0x00;
	ALIGN

led_score = "0000",0x00;
	ALIGN
led_digt = 0	
	ALIGN
selet_digt = 0	
	ALIGN
board
		;set Life to 4
		
		mov r0,#4
		bl Display_life
		;
		;set rpg to white
		
		BL RPG_WHITE
		
		;set rpg to white
		
		ldr r2,=game_instruction
		bl output_string
		ldr r2,=game_feature
		bl output_string
		ldr r2,=press_s_to_start
		bl output_string
		bl read_character
		cmp r0,#0x73
		bne board
		bl player_setup;
		
		bl interrupt_init
		
testloop
	

	b testloop

interrupt_init       
		STMFD SP!, {r0-r1, lr}   ; Save registers 
		
		; Push button setup		 
		LDR r0, =0xE002C000
		LDR r1, [r0]
		ORR r1, r1, #0x20000000
		BIC r1, r1, #0x10000000
		STR r1, [r0]  ; PINSEL0 bits 29:28 = 10


		; UART0 setup
		LDR r0, =0xE000C004  ; U0IER
		LDR r1, [r0]
		ORR r1, r1, #1 	; Enable Receive Data Available Interrupt(RDA) Bit 0
		STR r1, [r0]
		
		; Classify sources as IRQ or FIQ
		LDR r0, =0xFFFFF000
		LDR r1, [r0, #0xC]
		ORR r1, r1, #0x8000 ; External Interrupt 1
		STR r1, [r0, #0xC]
		ORR r1, r1, #0x40 	; UART0 Interrupt
		ORR r1, r1, #0x30   ; TIMER 0 and 1
		STR r1, [r0, #0xC]

		; Enable Interrupts
		LDR r0, =0xFFFFF000
		LDR r1, [r0, #0x10] 
		ORR r1, r1, #0x8000 ; External Interrupt 1
		STR r1, [r0, #0x10]
		ORR r1, r1, #0x40	; UART0 Interrupt
		ORR r1, r1, #0x30    ; TIMER 0 and 1
		STR r1, [r0, #0x10]
		
		LDR r4, =0xE0004014 	; T0MCR - Timer0MatchControlRegister
		LDR r5, [r4]
		ORR r5, r5, #0x18 		; Interrupt and Reset for MR1 and MR0
		STR r5, [r4]

		LDR r4, =0xE0008014	; T1MCR - Timer0MatchControlRegister
		LDR r5, [r4]
		ORR r5, r5, #0x28 		; Interrupt and stop for MR1
		STR r5, [r4]
		
		; Set match register
		LDR r4, =0xE000401C 	; Match Register 1
		LDR r5, =0x000F0000	; Set time to match time ;0x002, 0x000F
		STR r5, [r4]
		
		;	Set match register
		LDR r4, =0xE000801C	; Match Register 1 for timmer 1
		LDR r5, =0x71000000		; Set time to match time:0x21000000	;0x41000000;71
		STR r5, [r4]
	
		; Enable Timer0
		LDR r4, =0xE0004004	    ; T0TCR - Timer0ControlRegister
		LDR r5, [r4]
		ORR r5, r5, #1
		STR r5, [r4]
		
		; Enable Timer1
		LDR r4, =0xE0008004	    ; T1TCR - Timer0ControlRegister
		LDR r5, [r4]
		ORR r5, r5, #1
		STR r5, [r4]
		
		; External Interrupt 1 setup for edge sensitive
		LDR r0, =0xE01FC148
		LDR r1, [r0]
		ORR r1, r1, #2  ; EINT1 = Edge Sensitive
		STR r1, [r0]

		; Enable FIQ's, Disable IRQ's
		MRS r0, CPSR
		BIC r0, r0, #0x40
		ORR r0, r0, #0x80
		MSR CPSR_c, r0

		LDMFD SP!, {r0-r1, lr} ; Restore registers
		BX lr             	   ; Return





FIQ_Handler
	STMFD SP!, {r0-r2,r4-r12, lr}   ; Save registers 
	;cathing TIMER 1
	LDR r0, =0xE0008000  
	LDR r1, [r0]
	cmp r1, #0x00000002
	BEQ T1
	
Timer0Int ; Check for Timer 0 Interrupt
	LDR r0, =0xE0004000  	; T0InterruptRegister
	LDR r1, [r0]
	TST r1, #2 	;  1 if pending interrupt due to Match Register 1
	BEQ UART0
	
	
	
	
	ldr r2,=mothermoving
	ldrb r3,[r2]
	cmp r3,#1
	bleq MOTHERLEFT
	CMP R3,#0
	BLEQ MOTHERRIGHT


	
;STROBING THE SCORE
	ldr r2,=led_score
	ldr r3,=led_digt
	ldrb r4,[r3];r4 contain digit of score
	ldrb r5,[r2,r4]; r5 contain the score values
	cmp r5,#0x00
	subne r5,#48
	moveq r4,#0x00
	ldrbeq r5,[r2,r4];load first digt of score
	subeq r5,#48
;update digit
	cmp r4,#0x04
	addne r4,#1
	moveq r4,0x00
	strb r4,[r3];update digit

	mov r1,r5
	
	LDR R2,=selet_digt
	ldr r3,[r2]
	mov r0,r3
	add r3,#1
	cmp r3,#4
	moveq r3,#0
	strb r3,[r2]
    bl Display_score
;STROBING THE SCORE

	;check level clear
	bl check_level_clear
;@@@@@@@@@@@@printing the player and board,and level@@@@@@@@@@@@@@@@	

	
	ldr r2,=clear;
	bl output_string
	;ldr r2,=boarder;
	;bl output_string;
	ldr r2,= Initial_board;
	bl output_string;
	bl spawn_player;
	ldr r2,=boarder;
	bl output_string;
	ldr r2,=level
	bl output_string
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@


	
;$$$$$$$$$$$$$flag to enable move$$$$$$$$$$$$$$$$$$$$$$	
	
	ldr r2,= timer0_cycle_count;
	ldrb r4,[r2]
	cmp r4,#6; set speed of enable move flag:4or2
	beq set_move
	add r4,#1;
	strb r4,[r2];
;$$$$$$$$$$flag to enable move$$$$$$$$$$$$$$$$4	

	;bullet up;
	bl bullet_up
	bl en_shot
	bl print_scores
;move enemy if the enable flag is set
	;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	;skip move if move_enalbe is 0;
	ldr r2,= move_enable ; enable is set to 1 every other cycle
	ldrb r4,[r2];
	cmp r4,#0
	beq skip_move
	ldr r2,=move_enable
	mov r4,#0;     ;reset enable everytime a move is call
	strb r4,[r2];
	bl enemy_move


;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@	

;display lives
	ldr r2,=lives
	ldrb r0,[r2]
	bl Display_life
	
	;timmer0 code above
skip_move
	B Timer0Int_Exit

	;Timer1 game over
	
T1 
;display lives
	ldr r2,=lives
	ldrb r0,[r2]
	bl Display_life
	ldr r2,=clear
	bl output_string
	ldr r2,=Timmer
	BL RPG_PURPLE
	bl output_string
	;disable timer0
	LDR r4, =0xE0004004	    ; T0TCR - Timer0ControlRegister
	mov r5, #0   
	STR r5, [r4]
	bl read_character
	cmp r0, #0x71;press q quit
	beq Timer1Int_Exit
	b T1

UART0	; Check for UART0 interrupt
	LDR r0, =0xE000C008  ; UART0 Interrupt Identification Register(U0IIR)
	LDR r1, [r0]
	TST r1, #1	; Bit 0 / 0 = pending, 1 = no pending interrupts
	BNE EINT1
	
	STMFD SP!,  {r0-r2,r4-r12, lr}
;Uart0 interrupt code below
	bl read_character; character store in r0

	
shooting  
		cmp r0 ,#0x20
		bleq shoot

 ;$$$$$$$$$$4player move$$$$$$$$$$$$$$$$$$$44 
player_move	
	;moving left and right
	cmp r0,#0x64;   set d to move right
	bleq move_right;
	cmp r0,#0x61; set a to move left
	bleq move_left;
 ;$$$$$$$$$$4player move$$$$$$$$$$$$$$$$$$$44 
	
	
	
;Uart0 interrupt code above;	

	LDMFD SP!,  {r0-r2,r4-r12, lr}
	B FIQ_Exit


EINT1			; Check for EINT1 interrupt
		LDR r0, =0xE01FC140
		LDR r1, [r0]
		TST r1, #2
		BEQ FIQ_Exit
		
		STMFD SP!,  {r0-r2,r4-r12, lr}  ; Save registers 
			
		; Push button EINT1 Handling Code
		
		LDR r4, =0xE0008004	    ; T0TCR - Timer0ControlRegister
		mov r5, #0   
		STR r5, [r4]
stoploop
		bl read_character
		cmp r0,0x73
		beq resume
		b stoploop
		; My code
		
	
resume				
		; End My code
		LDR r4, =0xE0008004	    ; T0TCR - Timer0ControlRegister
		mov r5, #1   
		STR r5, [r4]
		LDMFD SP!,  {r0-r2,r4-r12, lr}   ; Restore registers
		
		ORR r1, r1, #2		; Clear Interrupt
		STR r1, [r0]
		
		

	

Timer0Int_Exit
	
	
	
	; Clear Interrupt
	LDR r0, =0xE0004000 	; get T0InterruptRegister
	LDR r1, [r0]			; by writing 1 to bit 1
	ORR r1, #2              ; Clear interrupt for MR1
	STR r1, [r0]            ; by writing to bit 1
	
	BEQ FIQ_Exit
	
Timer1Int_Exit
	LDR r0, =0xE0008000 	; get T1InterruptRegister
	LDR r1, [r0]			; by writing 1 to bit 1
	ORR r1, #4              ; Clear interrupt for MR2
	STR r1, [r0]       
	



FIQ_Exit
		ldr r1,=lives
		ldrb r2,[r1]
		cmp r2,#0
		beq T1
		LDMFD SP!,  {r0-r2,r4-r12, lr}
		SUBS pc, lr, #4


;set player to move,reset cycles of move
set_move
	STMFD SP!, {r2,r4,lr} 
	ldr r2,= move_enable;
	mov r4,#0x01;
	strb r4,[r2];
	ldr r2,= timer0_cycle_count;
	mov r4,#-1;
	strb r4,[r2];
	LDMFD SP!,  {r2,r4,lr}
	BX lr
	END
