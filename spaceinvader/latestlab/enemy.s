		AREA enemy, CODE, READWRITE
		extern Initial_board
		extern next_move		
		extern output_character	
		extern current_position
		extern rng
		extern score
		extern lives		
		EXPORT en_move_right
		EXPORT en_move_left	
		EXPORT en_move_down
		EXPORT en_amount
		EXPORT left_pos
		EXPORT right_pos
		EXPORT how_many_down_move_left
		EXPORT update_en_status
		EXPORT left_topmost	
		EXPORT left2_topmost
		EXPORT left3_topmost
		EXPORT left4_topmost
		EXPORT left5_topmost
		EXPORT left6_topmost
		EXPORT left7_topmost			
		EXPORT left_most_colum
		EXPORT en_shot	
			
how_many_down_move_left = 0x05; 
	ALIGN
		
left_topmost = 0x003B;(y,x);
	ALIGN
left2_topmost = 0x003C;(y,x)
	ALIGN
left3_topmost = 0x003D;(y,x)
	ALIGN
left4_topmost = 0x003E;(y,x)
	ALIGN
left5_topmost = 0x003F;(y,x)
	ALIGN
left6_topmost = 0x0040;(y,x)
	ALIGN
left7_topmost = 0x0041;right most
	ALIGN

left_num = 0x05;
left2_num = 0x05;
left3_num = 0x05;
left4_num = 0x05;
left5_num = 0x05;
left6_num = 0x05;
left7_num = 0x05;
	ALIGN
right_pos = 0x0041 ;41
	ALIGN
left_pos = 0x003B	;3b
	ALIGN
en_max_length = 0x04
	ALIGN
en_amount = 0x23;0x23
	ALIGN
left_most_colum = 7;
	ALIGN

en_bullets_pos = 0x0000
	ALIGN
en_shooted	= 0
	ALIGN
; ***************************
; Output char to UART0
; ARGS  : no
; RETURN: no
; ***************************	
;Move the enemy right, until it hit the wall
en_move_right
	STMFD SP!, {r4-r11,lr} 
	;check if the rightposition is against the wall
	ldr r6,=Initial_board ; load board
	ldr r5,= right_pos ; load right position
	ldrh r5,[r5]
  	add r5,#1
	ldrb r7,[r6,r5]
	;check if the next move is a wall
	cmp r7,#0x7C
	;update next_move
	ldreq r5,= next_move
	ldrbeq r4,[r5]
	addeq r4,#1
	strbeq r4,[r5]
	beq skip_en_right
	
	
	;set up the register
	ldr r5,= right_pos ; load right position
	ldr r8,=left_pos ; load left position
	ldrh r7,[r5] ; 
	mov r5,r7; let r5 keep track of the position left
	ldrh r7,[r8]
	mov r8,r7; let r8 keep track of the position right
	mov r10,#1; keep track of colum downs; TEMP SOLUTION
	
	;move the row
rightloop
	mov r7,r5;
	ldrb r4,[r6,r7]; load the right most register
	cmp r4, #0x5E;get rid of bullets
	moveq r4,#0x20
	cmp r4,#0x56
	moveq r4,#0x20
	add r7,#1;
	strb r4,[r6,r7];
	cmp r5,r8
	sub r5,#1
	beq fin
	b rightloop
fin 
	mov r7,r5;
	mov r4,#0x20
	add r7,#1;
	strb r4,[r6,r7];
	
	;set the next rows to move
rowloop	
	ldr r5,= right_pos
	ldr r8,=left_pos
	ldrh r7,[r5]
	mov r5,r7; let r5 keep track of the position right
	ldrh r7,[r8]
	mov r8,r7; let r8 keep track of the position left
	mov r9,#25
	mul r4,r10,r9
	add r5,r4;
	mul r4,r10,r9
	add r8,r4
	
	add r10,#1;TEMP SOLUTION
	cmp	r10,#6;temp solution
	
	beq fin2
	b rightloop

fin2
	;update left position and right position
	ldr r5,= right_pos
	ldrh r7,[r5]
	add r7,#1;
	strh r7,[r5];
	ldr r5,= left_pos
	ldrh r7,[r5]
	add r7,#1;
	strh r7,[r5];
	;update 7 enemy position
	ldr r5,=left_topmost
	ldrh r7,[r5]
	add r7,#1
	strh r7,[r5]
	ldr r5,=left2_topmost
	ldrh r7,[r5]
	add r7,#1
	strh r7,[r5]
	ldr r5,=left3_topmost
	ldrh r7,[r5]
	add r7,#1
	strh r7,[r5]
	ldr r5,=left4_topmost
	ldrh r7,[r5]
	add r7,#1
	strh r7,[r5]
	ldr r5,=left5_topmost
	ldrh r7,[r5]
	add r7,#1
	strh r7,[r5]
	ldr r5,=left6_topmost
	ldrh r7,[r5]
	add r7,#1
	strh r7,[r5]
	ldr r5,=left7_topmost
	ldrh r7,[r5]
	add r7,#1
	strh r7,[r5]
skip_en_right

	LDMFD SP!,  {r4-r11,lr}
	BX lr

; ***********Move_right****************



; ***************************
; Output char to UART0
; ARGS  : no
; RETURN: no
; ***************************	
;Move the enemy left, until it hit the wall
en_move_left
	STMFD SP!, {r4-r10,lr} 
	;check if the leftposition is against the wall
	ldr r6,=Initial_board ; load board
	ldr r5,= left_pos ; load left position
	ldrh r5,[r5]
	sub r5,#1
	ldrb r7,[r6,r5]
	cmp r7,#0x7C
	ldreq r5,= next_move
	ldrbeq r4,[r5]
	addeq r4,#1
	strbeq r4,[r5]
	beq skip_en_left
	
	;set up the register
	ldr r5,= left_pos ; load left position
	ldr r8,=right_pos ; load left position
	ldrh r7,[r5] ; 
	mov r5,r7; let r5 keep track of the position left
	ldrh r7,[r8]
	mov r8,r7; let r8 keep track of the position right
	
	mov r10,#1; keep track of colum downs; TEMP SOLUTION
	;move the row
leftloop
	mov r7,r5;
	ldrb r4,[r6,r7]; load the left most register
	cmp r4, #0x5E;get rid of bullets
	moveq r4,#0x20;get rid of bullets
	cmp r4,#0x56
	moveq r4,#0x20
	sub r7,#1;
	strb r4,[r6,r7];
	cmp r5,r8
	add r5,#1
	beq left_fin
	b leftloop
left_fin 
	mov r7,r5;
	mov r4,#0x20
	sub r7,#1;
	strb r4,[r6,r7];
	
	;set the next rows to move
rowloop2	
	ldr r5,=left_pos
	ldr r8,=right_pos
	ldrh r7,[r5]
	mov r5,r7; let r5 keep track of the position left
	ldrh r7,[r8]
	mov r8,r7; let r8 keep track of the position right
	mov r9,#25
	mul r4,r10,r9
	add r5,r4;
	mul r4,r10,r9
	add r8,r4
	
	add r10,#1;TEMP SOLUTION
	cmp	r10,#6;temp solution
	
	beq left_fin2
	b leftloop

left_fin2
	;update left and right position
	ldr r5,= left_pos
	ldrh r7,[r5]
	sub r7,#1;
	strh r7,[r5];
	ldr r5,= right_pos
	ldrh r7,[r5]
	sub r7,#1;
	strh r7,[r5];
	;update 7 enemy position
	ldr r5,=left_topmost
	ldrh r7,[r5]
	add r7,#-1
	strh r7,[r5]
	ldr r5,=left2_topmost
	ldrh r7,[r5]
	add r7,#-1
	strh r7,[r5]
	ldr r5,=left3_topmost
	ldrh r7,[r5]
	add r7,#-1
	strh r7,[r5]
	ldr r5,=left4_topmost
	ldrh r7,[r5]
	add r7,#-1
	strh r7,[r5]
	ldr r5,=left5_topmost
	ldrh r7,[r5]
	add r7,#-1
	strh r7,[r5]
	ldr r5,=left6_topmost
	ldrh r7,[r5]
	add r7,#-1
	strh r7,[r5]
	ldr r5,=left7_topmost
	ldrh r7,[r5]
	add r7,#-1
	strh r7,[r5]
skip_en_left
	LDMFD SP!,  {r4-r10,lr}
	BX lr

;*************Move_left*********88


;**********************
; Enemy Down
; ARGS  : no
; RETURN: no
;********************
en_move_down
	STMFD SP!,{lr}
	;every down is updating the cycle
	ldr r5,= next_move
	ldrb r4,[r5]
	add r4,#1
	strb r4,[r5]
	
	
	;check if there is more any down move left
	ldr r4,=how_many_down_move_left
	ldrb r5,[r4];
	cmp r5,#0;
	beq down_skip
	;initialize variables for position
	ldr r6,=Initial_board
	ldr r4,=right_pos
	ldrh r5,[r4];let r5 keep tract of right pos
	ldr r4,=left_pos
	ldrh r7,[r4]; let r7 keep track of left pos
	;moving one colum down from left
	ldr r4,=en_max_length
	ldrb r8,[r4]; r8 contain enemy max length
	mov r9,r8; r9 keep track enemy max length
	
	;moving left most unmove colums
mo_col	
	mov r8,r9; let r9 keep track of max lengh
	mov r4,#25
	mul r8,r4,r8;
	add r4,r7,r8
	ldrb r8,[r6,r4]
	add r4,#25
	strb r8,[r6,r4]
	sub r9 ,#1;
	cmp r9,#-1;
	bne mo_col
	;replace the top colom with space
re_s	
	mov r8,r9; let r9 keep track of max lengh
	mov r4,#25
	mul r8,r4,r8;
	add r4,r7,r8
	ldrb r8,[r6,r4]
	add r4,#25
	strb r8,[r6,r4]
	
	;go to next colum and do it again refresh the max length
	cmp r7,r5;
	add r7,#1;
	beq down_done
	ldr r4,=en_max_length
	ldrb r8,[r4]; r8 contain enemy max length
	mov r9,r8; r9 keep track enemy max length
	b mo_col

down_done
	;update the constant
	ldr r4,=right_pos
	ldrh r5,[r4]
	add r5,#25
	strh r5,[r4]
	ldr r4,=left_pos
	ldrh r5,[r4]
	add r5,#25
	strh r5,[r4]
	ldr r4,=how_many_down_move_left
	ldrb r5,[r4];
	sub r5,#1;
	strb r5,[r4];
	
	;update 7 enemy position
	ldr r5,=left_topmost
	ldrh r7,[r5]
	add r7,#25
	strh r7,[r5]
	ldr r5,=left2_topmost
	ldrh r7,[r5]
	add r7,#25
	strh r7,[r5]
	ldr r5,=left3_topmost
	ldrh r7,[r5]
	add r7,#25
	strh r7,[r5]
	ldr r5,=left4_topmost
	ldrh r7,[r5]
	add r7,#25
	strh r7,[r5]
	ldr r5,=left5_topmost
	ldrh r7,[r5]
	add r7,#25
	strh r7,[r5]
	ldr r5,=left6_topmost
	ldrh r7,[r5]
	add r7,#25
	strh r7,[r5]
	ldr r5,=left7_topmost
	ldrh r7,[r5]
	add r7,#25
	strh r7,[r5]
	
down_skip	
	LDMFD SP!,{lr}
	BX lr
;###########down done##############



;######################
;update the enemy status
; return none
; arg none
;######################
update_en_status
	STMFD SP!,{R4,R5,R7,R8,LR}
	;check from the 7 -all the way to 1 being the right most
	ldr r7,= left_most_colum
	ldrb r8,[r7];
	cmp r8,#6
	beq left2
	cmp r8,#5
	beq left3
	cmp r8,#4
	beq left4
	cmp r8,#3
	beq left5
	cmp r8,#2
	beq left6
	cmp r8,#1
	beq left7
	
	ldr r4,= left_topmost 
	ldrh r5,[r4];  ;r5 have left pos
	ldr r6,=Initial_board
	ldrb r5,[r6,r5]; r5 have the left char
	cmp r5,#0x20
 	ldreq r4,=left_pos
	ldreq r5,[r4];
	addeq r5,#1;
	strheq r5,[r4]; update left pos
	subeq r8,#1
	strbeq r8,[r7]
	LDMFD SP!,{R4,R5,R7,R8,LR}
	BX LR
	
left2
  	ldr r7,= left_most_colum
	ldrb r8,[r7];
	cmp r8,#5
	beq left3
	cmp r8,#4
	beq left4
	cmp r8,#3
	beq left5
	cmp r8,#2
	beq left6
	cmp r8,#1
	beq left7
	
	ldr r4,= left2_topmost 
	ldrh r5,[r4];  ;r5 have left pos
	ldr r6,=Initial_board
	ldrb r5,[r6,r5]; r5 have the left char
	cmp r5,#0x20
	ldreq r4,=left_pos
	ldreq r5,[r4];
	addeq r5,#1;
	strheq r5,[r4]; update left pos
	subeq r8,#1
	strbeq r8,[r7]
	

	LDMFD SP!,{R4,R5,R7,R8,LR}
	BX LR

	
left3
	ldr r7,= left_most_colum
	ldrb r8,[r7];
	cmp r8,#4
	beq left4
	cmp r8,#3
	beq left5
	cmp r8,#2
	beq left6
	cmp r8,#1
	beq left7
	
	ldr r4,= left3_topmost 
	ldrh r5,[r4];  ;r5 have left pos
	ldr r6,=Initial_board
	ldrb r5,[r6,r5]; r5 have the left char
	cmp r5,#0x20
	ldreq r4,=left_pos
	ldreq r5,[r4];
	addeq r5,#1;
	strheq r5,[r4]; update left pos
	
	subeq r8,#1
	strbeq r8,[r7]
	LDMFD SP!,{R4,R5,R7,R8,LR}
	BX LR
	
left4	
	ldr r7,= left_most_colum
	ldrb r8,[r7];
	cmp r8,#3
	beq left5
	cmp r8,#2
	beq left6
	cmp r8,#1
	beq left7
	
	ldr r4,= left4_topmost 
	ldrh r5,[r4];  ;r5 have left pos
	ldr r6,=Initial_board
	ldrb r5,[r6,r5]; r5 have the left char
	cmp r5,#0x20
	ldreq r4,=left_pos
	ldreq r5,[r4];
	addeq r5,#1;
	strheq r5,[r4]; update left pos
	
	subeq r8,#1
	strbeq r8,[r7]
	LDMFD SP!,{R4,R5,R7,R8,LR}
	BX LR
	
left5	
	ldr r7,= left_most_colum
	ldrb r8,[r7];
	cmp r8,#2
	beq left6
	cmp r8,#1
	beq left7
	
	ldr r4,= left5_topmost 
	ldrh r5,[r4];  ;r5 have left pos
	ldr r6,=Initial_board
	ldrb r5,[r6,r5]; r5 have the left char
	cmp r5,#0x20
	ldreq r4,=left_pos
	ldreq r5,[r4];
	addeq r5,#1;
	strheq r5,[r4]; update left pos
	
	subeq r8,#1
	strbeq r8,[r7]
	LDMFD SP!,{R4,R5,R7,R8,LR}
	BX LR
	
left6
	ldr r7,= left_most_colum
	ldrb r8,[r7];
	cmp r8,#1
	beq left7
	
	ldr r7,= left_most_colum
	ldrb r8,[r7];
	cmp r8,#3
	beq left5
	
	ldr r4,= left6_topmost 
	ldrh r5,[r4];  ;r5 have left pos
	ldr r6,=Initial_board
	ldrb r5,[r6,r5]; r5 have the left char
	cmp r5,#0x20
	ldreq r4,=left_pos
	ldreq r5,[r4];
	addeq r5,#1;
	strheq r5,[r4]; update left pos
	
		
	subeq r8,#1
	strbeq r8,[r7]
	LDMFD SP!,{R4,R5,R7,R8,LR}
	BX LR
	
left7	
	;last colum don't need to change
	
	LDMFD SP!,{R4,R5,R7,R8,LR}
	BX LR
;############update enemy status########END#############		
;en_sho
;return none
; arg none
en_shot
	;initial bullets position
	STMFD SP!,{r0-r9,LR}
	ldr r8,=en_shooted
	ldrb r9,[r8]
	cmp r9,#1
	beq shooting
	ldr r4,=left_topmost
	mov r0,#7;rng
	bl rng
	ldrh r5,[r4]
	add r5,r0; rng
	ldr r4,=en_bullets_pos
	strh r5,[r4]
	;updates flag
	mov r9,#1
	strb r9,[r8]
shooting
	ldr r4,=en_bullets_pos
	ldrh r5,[r4]
	add r5,#25;
	
	ldr r6,=Initial_board
	ldrb r7,[r6,r5]
	cmp r7,#0x53
	beq s_hit
	cmp r7,#0x73
	beq S_hit
	cmp r7,#0x5E
	beq bull_hit
	cmp r7,#0x20
	moveq r8,#0x56
	strbeq r8,[r6,r5];
	strh r5,[r4]   ;update enemy current position
	;get rid of bullets
	sub r5,#25
	ldrb r7,[r6,r5]
	cmp r7,#0x56
	moveq r7,#0x20
	strbeq r7,[r6,r5]
	
	
	
	
	ldr r7,=0x0179
	cmp r5,r7
	beq en_shot_hit0x79
	ldr r7,=0x017A
	cmp r5,r7
	beq en_shot_hit0x7A
	ldr r7,=0x017B
	cmp r5,r7
	beq en_shot_hit0x7B
	ldr r7,=0x017C
	cmp r5,r7
	beq en_shot_hit0x7C
	ldr r7,=0x017D
	cmp r5,r7
	beq en_shot_hit0x7D
	ldr r7,=0x017E
	cmp r5,r7
	beq en_shot_hit0x7E
	ldr r7,= 0x017F
	cmp r5,r7
	beq en_shot_hit0x7F
	ldr r7,=0x0180
	cmp r5,r7
	beq en_shot_hit0x80
	ldr r7,=0x0181
	cmp r5,r7
	beq en_shot_hit0x81
	ldr r7,= 0x0182
	cmp r5,r7
	beq en_shot_hit0x82
	ldr r7,=0x0183
	cmp r5,r7
	beq en_shot_hit0x83
	ldr r7,=0x0184
	cmp r5,r7
	beq en_shot_hit0x84
	ldr r7,=0x0185
	cmp r5,r7
	beq en_shot_hit0x85
	ldr r7,=0x0186
	cmp r5,r7
	beq en_shot_hit0x86
	ldr r7,=0x0187
	cmp r5,r7
	beq en_shot_hit0x87
	ldr r7,=0x0188
	cmp r5,r7
	beq en_shot_hit0x88
	ldr r7,= 0x0189
	cmp r5,r7
	beq en_shot_hit0x89
	ldr r7,=0x018A
	cmp r5,r7
	beq en_shot_hit0x8A
	ldr r7,=0x018B
	cmp r5,r7
	beq en_shot_hit0x8B
	ldr r7,=0x018C
	cmp r5,r7
	beq en_shot_hit0x8C

	
	

	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;________________________________________-	
en_shot_hit0x79
	ldr r4,=current_position
	ldrb r5,[r4]
	cmp r5,#0x01
	ldreq r2,=lives
	ldrbeq r1,[r2]
	subeq r1,#1
	strbeq r1,[r2]
;-------------------------update bullets enable
	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]

	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;__________________________________________	
en_shot_hit0x7A
	ldr r4,=current_position
	ldrb r5,[r4]
	cmp r5,#0x02
	ldreq r2,=lives
	ldrbeq r1,[r2]
	subeq r1,#1
	strbeq r1,[r2]
;-------------------------update bullets enable
	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]


	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;_______________________________________	
en_shot_hit0x7B
	ldr r4,=current_position
	ldrb r5,[r4]
	cmp r5,#0x03
	ldreq r2,=lives
	ldrbeq r1,[r2]
	subeq r1,#1
	strbeq r1,[r2]
;-------------------------update bullets enable
	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]
	
	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;__________________________________	
en_shot_hit0x7C
	ldr r4,=current_position
	ldrb r5,[r4]
	cmp r5,#0x04
	ldreq r2,=lives
	ldrbeq r1,[r2]
	subeq r1,#1
	strbeq r1,[r2]
;-------------------------update bullets enable
	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]
	
	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;_________________________________	
en_shot_hit0x7D
	ldr r4,=current_position
	ldrb r5,[r4]
	cmp r5,#0x05
	ldreq r2,=lives
	ldrbeq r1,[r2]
	subeq r1,#1
	strbeq r1,[r2]
;-------------------------update bullets enable
	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]
	
	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;_______________________________	
en_shot_hit0x7E
	ldr r4,=current_position
	ldrb r5,[r4]
	cmp r5,#0x06
	ldreq r2,=lives
	ldrbeq r1,[r2]
	subeq r1,#1
	strbeq r1,[r2]
;-------------------------update bullets enable
	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]
	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;____________________________	
en_shot_hit0x7F
	ldr r4,=current_position
	ldrb r5,[r4]
	cmp r5,#0x07
	ldreq r2,=lives
	ldrbeq r1,[r2]
	subeq r1,#1
	strbeq r1,[r2]
;-------------------------update bullets enable
	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]
	
	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;________________________	
en_shot_hit0x80
	ldr r4,=current_position
	ldrb r5,[r4]
	cmp r5,#0x08
	ldreq r2,=lives
	ldrbeq r1,[r2]
	subeq r1,#1
	strbeq r1,[r2]
;-------------------------update bullets enable
   	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]
	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;_____________________	
en_shot_hit0x81
	ldr r4,=current_position
	ldrb r5,[r4]
	cmp r5,#0x09
	ldreq r2,=lives
	ldrbeq r1,[r2]
	subeq r1,#1
	strbeq r1,[r2]
;-------------------------update bullets enable
	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]
	
	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;_____________________	
en_shot_hit0x82	
	ldr r4,=current_position
	ldrb r5,[r4]
	cmp r5,#0x0A
	ldreq r2,=lives
	ldrbeq r1,[r2]
	subeq r1,#1
	strbeq r1,[r2]
	;-------------------------update bullets enable
	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]

	LDMFD sp!,{r0-r9,LR}
	BX LR
;_________________-	
en_shot_hit0x83	
	ldr r4,=current_position
	ldrb r5,[r4]
	cmp r5,#0x0B
	ldreq r2,=lives
	ldrbeq r1,[r2]
	subeq r1,#1
	strbeq r1,[r2]
;-------------------------update bullets enable
	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]
	
	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;_____________________	
en_shot_hit0x84	
	ldr r4,=current_position
	ldrb r5,[r4]
	cmp r5,#0x0C
	ldreq r2,=lives
	ldrbeq r1,[r2]
	subeq r1,#1
	strbeq r1,[r2]
;-------------------------update bullets enable
	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]
	
	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;_________________________	
en_shot_hit0x85	
	ldr r4,=current_position
	ldrb r5,[r4]
	cmp r5,#0x0D
	ldreq r2,=lives
	ldrbeq r1,[r2]
	subeq r1,#1
	strbeq r1,[r2]
;-------------------------update bullets enable
	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]
	
	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;__________________________	
en_shot_hit0x86	
	ldr r4,=current_position
	ldrb r5,[r4]
	cmp r5,#0x0E
	ldreq r2,=lives
	ldrbeq r1,[r2]
	subeq r1,#1
	strbeq r1,[r2]
;-------------------------update bullets enable
 	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]
	
	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;_______________________	
en_shot_hit0x87	
	ldr r4,=current_position
	ldrb r5,[r4]
	cmp r5,#0x0F
	ldreq r2,=lives
	ldrbeq r1,[r2]
	subeq r1,#1
	strbeq r1,[r2]
;-------------------------update bullets enable
	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]
	
	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;________________________-
en_shot_hit0x88
	ldr r4,=current_position
	ldrb r5,[r4]
	cmp r5,#0x10
	ldreq r2,=lives
	ldrbeq r1,[r2]
	subeq r1,#1
	strbeq r1,[r2]
;-------------------------update bullets enable
	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]
	
	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;_______________________________
en_shot_hit0x89	
	ldr r4,=current_position
	ldrb r5,[r4]
	cmp r5,#0x11
	ldreq r2,=lives
	ldrbeq r1,[r2]
	subeq r1,#1
	strbeq r1,[r2]
;-------------------------update bullets enable
	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]
	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;________________________________-	
en_shot_hit0x8A
	ldr r4,=current_position
	ldrb r5,[r4]
	cmp r5,#0x12
	ldreq r2,=lives
	ldrbeq r1,[r2]
	subeq r1,#1
	strbeq r1,[r2]
;-------------------------update bullets enable
	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]
	
	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;___________________________	
en_shot_hit0x8B
	ldr r4,=current_position
	ldrb r5,[r4]
	cmp r5,#0x14
	ldreq r2,=lives
	ldrbeq r1,[r2]
	subeq r1,#1
	strbeq r1,[r2]
;-------------------------update bullets enable
	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]
	
	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;__________________________-	

en_shot_hit0x8C
	ldr r4,=current_position
	ldrb r5,[r4]
	cmp r5,#0x15
	ldreq r2,=lives
	ldrbeq r1,[r2]
	subeq r1,#1
	strbeq r1,[r2]
;-------------------------update bullets enable
	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]
	
	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;----------------------------	

	
	
s_hit
	sub r5, #25
	ldrb r9,[r5,r6]
	cmp r9,#0x57
	beq done1
	mov r9,#0x20
	strb r9,[r5,r6]
	
;-------------------------update bullets enable
	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]
	
done1	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;----------------------------	

S_hit
	sub r5, #25
	ldrb r9,[r5,r6]
	cmp r9,#0x57
	beq done
	mov r9,#0x20
	strb r9,[r5,r6]
;-------------------------update bullets enable
	ldr r8,=en_shooted
	mov r9,#0
	strb r9,[r8]
	
done	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;----------------------------

bull_hit

	strb r9,[r6,r5]
	mov r9,#0x7E
	strb r9,[r6,r5]
	sub r5, #25
	mov r9,#0x20
;-------------------------update bullets enable

	
	LDMFD sp!,{r0-r9,LR}
	BX LR
;----------------------------
	END










