		AREA player, CODE, READWRITE
		extern read_character
		extern output_character
		extern read_string
		extern output_string
		extern RPG_WHITE		
		EXPORT spawn_player
		EXPORT move_right
		EXPORT player_setup
		EXPORT move_left
		EXPORT current_position
		EXPORT player1		
player1 = 0x7C,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x41,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x7C,0x20,0x20,0x00

	ALIGN

current_position = 0xB;
	ALIGN
;the aircraft started at middle position 10
	;GBLA    current_position
;current_position   SETA    11
	

	
;r3 is global variable for player position, dont change it
;set the starting position as 10 in the middle
player_setup
	STMFD   SP!,{lr};
	ldr r3,=current_position;
	LDMFD   SP!, {lr}
    BX      lr

; ***************************
; spawn_player
; ARGS  : NONE
; RETURN: NONE
; ***************************
;SPAWN THE aircraft AT THE MIDDLE.
spawn_player
	STMFD   SP!,{lr};
	ldr r2 ,= player1;
	bl output_string
	LDMFD   SP!, {lr}
    BX      lr
	
	
; ***************************
; move_right
; ARGS  : NONE
; RETURN: NONE
;
; ***************************
;move the aircraft 1 unit to the right
move_right
	STMFD   SP!,{r4,r5,r3,lr};
	ldr r4,=current_position
	ldrb r3,[r4]
	cmp r3,#21;
	beq no_right_move;
	ldr r4,= player1;
	mov r5,#0x20;
	strb r5,[r4,r3];
	mov r5,#0x41;
	add r3,#1;
	strb r5,[r4,r3];
	ldr r5, =current_position
	str r3,[r5]
no_right_move	

	LDMFD   SP!, {r4,r5,r3,lr}
    BX      lr



; ***************************
; move_left
; ARGS  : NONE
; RETURN: NONE
;
; ***************************
;move the aircraft 1 unit to the left
move_left
	STMFD   SP!,{r4,r5,r3,lr};
	ldr r4,=current_position
	ldrb r3,[r4]
	cmp r3,#1;
	beq no_left_move;
	ldr r4,= player1;
	mov r5,#0x20;
	strb r5,[r4,r3];
	mov r5,#0x41;
	sub r3,#1;
	strb r5,[r4,r3];
no_left_move	
	ldr r5, =current_position
	str r3,[r5]
	LDMFD   SP!, {r4,r5,r3,lr}
    BX      lr


	END