		AREA bullet, CODE, READWRITE
		
		extern current_position
		extern Initial_board
		extern score
		extern en_amount
		extern update_en_status
		extern RPG_RED
		extern RPG_GREEN
		extern atoi
		extern itoa
		extern led_score
		extern div_and_mod		
		EXPORT shoot
		EXPORT bullet_up	
		EXPORT new_led_score	
player_bullet = 0x5E
	
	ALIGN
bullet_enable = 0x01;
	
	ALIGN
bullet_pos = 0x0001;

	ALIGN	
new_led_score = "0000",0x00	
	ALIGN

;###################3
;Shoot a bullets from player
;arg none
;retrn none
;####################
shoot
	STMFD SP!,{r4-r8,LR}
	;skip if shoot disable
	ldr r4,=bullet_enable
	ldrb r6,[r4]
	cmp r6,#0
	beq skip_shoot
	;initial bullets current_position
	ldr r4,= current_position
	ldrh r6,[r4];
	ldr r5,=Initial_board
	mov r7,#0x5E
	ldr r8,=0x15E
	add R5,r8
	add r6,#1 ; r6 is current position
	strb r7,[r5,r6]
	;save bullet position
	ldr r4,=bullet_pos
	ADD R6,R8;
	strh r6,[r4];
	;bullet disable
	ldr r4,=bullet_enable
	mov r6,#0x00;set 0 to disable
	strb r6,[r4];	
skip_shoot

	
	LDMFD SP!,{r4-r8,LR}
	BX lr
	
	
;#####mov bullet up	
;return none

;#################3
bullet_up
	;########move_bullet up
	STMFD SP!,{r4-r8,LR}
	BL RPG_GREEN
	ldr r4,=bullet_enable
	ldrb r6,[r4]
	cmp r6,#1
	beq skip_bulletup
	BL  RPG_RED
	;special case,see whats on the right
;	ldr r5,=Initial_board
;	ldr r4,=bullet_pos
;	ldrh r6,[r4]
;	sub r6,#1
	;see what on right
;	ldrb r8,[r5,r6]
;	cmp r8,#0x57
;	beq wr_hit
;	cmp r8,#0x4D
;	beq mr_hit
;	cmp r8,#0x4F
;	beq or_hit

	

	;special case,see whats on the left
;	ldr r5,=Initial_board
;	ldr r4,=bullet_pos
;	ldrh r6,[r4]
;	add r6,#1
	;see what on right
;	ldrb r8,[r5,r6]
;	cmp r8,#0x57
;	beq wr_hit
;	cmp r8,#0x4D
;	beq mr_hit
;	cmp r8,#0x4F
;	beq or_hit

	

	;REGULAR CHECK ON TOP
	ldr r5,=Initial_board
	ldr r4,=bullet_pos
	ldrh r6,[r4]
	;save position
	sub r6,#25
	strh r6,[r4]
	;see what on top
	ldrb r8,[r5,r6]
	cmp r8,#0x2D
	beq top_hit
	cmp r8,#0x53
	beq ss_hit
	cmp r8,#0x73
	beq bs_hit
	cmp r8,#0x57
	beq w_hit
	cmp r8,#0x4D
	beq m_hit
	cmp r8,#0x4F
	beq o_hit
	cmp r8,#0x5E
	beq b_hit
	;moving bullet up
	mov r7,#0x5E
	ldrb r8,[r5,r6]
	cmp r8, #0x20
	strbeq r7,[r5,r6]
	mov r7,#0x20
	ADD r6,#25
	ldrb r8,[r5,r6]
	cmp r8,#0x5E
	strbeq r7,[r5,r6]
	b bullet_done
	
top_hit
	ldr r4,=bullet_enable
	mov r8,#0x01;set 1 to ensable
	strb r8,[r4];
	add r6,#25
	mov r8,#0x20
	strb r8,[r5,r6]
skip_bulletup
	
	LDMFD SP!,{r4-r8,LR}
	BX lr
	
bullet_done
	
	LDMFD SP!,{r4-r8,LR}
	BX lr
	
w_hit

	ldr r4,=bullet_enable
	mov r8,#0x01;set 1 to ensable
	strb r8,[r4];
	ldr r4,=score; update score
	ldrh r8,[r4]
	add r8,#10;
	strh r8,[r4]
	mov r7,#0x20
	strb r7,[r5,r6]
	
	
	;update 7seg display
	ldr r4,=led_score
	bl atoi
	add r0,#10;
	mov r1,r0
	mov r10,#3
div	mov r0,#10
	bl div_and_mod
;	cmp r0,#0
	mov r3,r0
	add r1,#48
	strb r1,[r4,r10]
	sub r10,#1
	cmp r10,#0
	mov r1,r3
	bne div
	bl div_and_mod
	add r1,#48
	strb r1,[r4]
	
	;find bullet and get rid of it
	add r6,#25
	ldrb r8,[r5,r6]
	cmp r8,#0x5E
	strbeq r7,[r5,r6]
	sub r6,#1
	ldrb r8,[r5,r6]
	cmp r8,#0x5E
	strbeq r7,[r5,r6]
	add r6,#2
	ldrb r8,[r5,r6]
	cmp r8,#0x5E
	strbeq r7,[r5,r6]
	
	;enemy amount -1
	ldr r4,=en_amount
	ldrb r5,[r4];
	sub r5,#1;
	strb r5,[r4]
	
	;update enemy_status
	bl update_en_status
	LDMFD SP!,{r4-r8,LR}
	BX lr
	
m_hit
	ldr r4,=bullet_enable
	mov r8,#0x01;set 1 to ensable
	strb r8,[r4];
 	ldr r4,=score
	ldrh r8,[r4]
	add r8,#20;
	strh r8,[r4]
	mov r7,#0x20
	strb r7,[r5,r6]
		
		
		
	ldr r4,=led_score
	bl atoi
	add r0,#20;
	mov r1,r0
	mov r10,#3
div2	
	mov r0,#10
	bl div_and_mod
;	cmp r0,#0
	mov r3,r0
	add r1,#48
	strb r1,[r4,r10]
	sub r10,#1
	cmp r10,#0
	mov r1,r3
	bne div2
	bl div_and_mod
	add r1,#48
	strb r1,[r4]	
		
	;find bullet and get rid of it
	add r6,#25
	ldrb r8,[r5,r6]
	cmp r8,#0x5E
	strbeq r7,[r5,r6]
	sub r6,#1
	ldrb r8,[r5,r6]
	cmp r8,#0x5E
	strbeq r7,[r5,r6]
	add r6,#2
	ldrb r8,[r5,r6]
	cmp r8,#0x5E
	strbeq r7,[r5,r6]
	
	;enemy amount -1
	ldr r4,=en_amount
	ldrb r5,[r4];
	sub r5,#1;
	strb r5,[r4]
	
	;update enemy_status
	bl update_en_status
	LDMFD SP!,{r4-r8,LR}
	BX lr

o_hit
	ldr r4,=bullet_enable
	mov r8,#0x01;set 1 to ensable
	strb r8,[r4];
	ldr r4,=score
	ldrh r8,[r4]
	add r8,#40;
	strh r8,[r4]
	mov r7,#0x20
	strb r7,[r5,r6]
	
	
	
	ldr r4,=led_score
	bl atoi
	add r0,#40;
	mov r1,r0
	mov r10,#3
div3	
	mov r0,#10
	bl div_and_mod
;	cmp r0,#0
	mov r3,r0
	add r1,#48
	strb r1,[r4,r10]
	sub r10,#1
	cmp r10,#0
	mov r1,r3
	bne div3
	bl div_and_mod
	add r1,#48
	strb r1,[r4]	
	
	;find bullet and get rid of it
	add r6,#25
	ldrb r8,[r5,r6]
	cmp r8,#0x5E
	strbeq r7,[r5,r6]
	sub r6,#1
	ldrb r8,[r5,r6]
	cmp r8,#0x5E
	strbeq r7,[r5,r6]
	add r6,#2
	ldrb r8,[r5,r6]
	cmp r8,#0x5E
	strbeq r7,[r5,r6]
	
	;enemy amount -1
	ldr r4,=en_amount
	ldrb r5,[r4];
	sub r5,#1;
	strb r5,[r4]
	
	;update enemy_status
	bl update_en_status
	
	LDMFD SP!,{r4-r8,LR}
	BX lr	
	
b_hit	
	mov r8,#0x01;set 1 to ensable
	strb r8,[r4];
	mov r7,#0x20
	strb r7,[r5,r6]
	add r6,#25
	strb r7,[r5,r6]
	
	;find bullet and get rid of it
	add r6,#25
	ldrb r8,[r5,r6]
	cmp r8,#0x5E
	strbeq r7,[r5,r6]
	sub r6,#1
	ldrb r8,[r5,r6]
	cmp r8,#0x5E
	strbeq r7,[r5,r6]
	add r6,#2
	ldrb r8,[r5,r6]
	cmp r8,#0x5E
	strbeq r7,[r5,r6]
	
	;update enemy_status
	bl update_en_status
	
	LDMFD SP!,{r4-r8,LR}
	BX lr
	
	
bs_hit

	ldr r4,=bullet_enable
	mov r8,#0x01;set 1 to ensable
	strb r8,[r4];
	mov r7,#0x20
	strb r7,[r5,r6]
	
	;find bullet and get rid of it
	add r6,#25
	strbeq r7,[r5,r6]
	
	LDMFD SP!,{r4-r8,LR}
	BX lr
	
	
ss_hit

	ldr r4,=bullet_enable
	mov r8,#0x01;set 1 to ensable
	strb r8,[r4];
	mov r7,#0x73
	strb r7,[r5,r6]
	
	;find bullet and get rid of it
	add r6,#25
	strbeq r7,[r5,r6]


	LDMFD SP!,{r4-r8,LR}
	BX lr	
	
	END
;special situation	
;wr_hit
;	ldr r5,=Initial_board
;	ldr r4,=bullet_pos
;	ldrh r6,[r4]
;	sub r6,25
;	ldr r4,=bullet_enable
;	mov r8,#0x01;set 1 to ensable
;	strb r8,[r4];
;	ldr r4,=score
;	ldrh r8,[r4]
;	add r8,#10;
;	strh r8,[r4]
;	mov r7,#0x20
;	strb r7,[r5,r6]
;	
;	LDMFD SP!,{r4-r8,LR}
;	BX lr
;
;mr_hit
;	ldr r5,=Initial_board
;	ldr r4,=bullet_pos
;	ldrh r6,[r4]
;	sub r6,25
;;	ldr r4,=bullet_enable
	;mov r8,#0x01;set 1 to ensable
	;strb r8,[r4];
;	;ldr r4,=score
;	ldrh r8,[r4]
;	add r8,#20;
;	strh r8,[r4]
;	mov r7,#0x20
;	strb r7,[r5,r6]
;	LDMFD SP!,{r4-r8,LR}
;	BX lr
;	
;or_hit
;	ldr r5,=Initial_board
;	ldr r4,=bullet_pos
;	ldrh r6,[r4]
;	sub r6,25
;	ldr r4,=bullet_enable
;	mov r8,#0x01;set 1 to ensable
;	strb r8,[r4];
;	ldr r4,=score
;	ldrh r8,[r4]
;	add r8,#40;
;	strh r8,[r4]
;	mov r7,#0x20
;	strb r7,[r5,r6]
;	LDMFD SP!,{r4-r8,LR}
;	BX lr
	

	