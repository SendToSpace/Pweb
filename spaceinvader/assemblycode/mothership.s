	AREA MOTHERSHIP,CODE, READWRITE
		
	extern Initial_board
	EXPORT MOTHERLEFT	
	EXPORT MOTHERRIGHT
	EXPORT mothermoving	
		
		
		
		
motherpos = 28
	ALIGN
mothermoving = 0x00
	ALIGN
	
MOTHERLEFT
	STMFD SP!,{r3-r6,LR}
	
	LDR R3,=mothermoving
	mov r4,1
	strb r4,[r3]
	CMP R4,#0
	BEQ MOTHERRIGHT
	
	ldr r4,=Initial_board
	ldr r3,=motherpos
	ldrb r6,[r3]
	cmp r6,#46
	beq doneleft
	cmp r6,#28
	beq spwanmotherleft
	sub r6,#1
	ldrb r5,[r4,r6]
	add r6,#1
	strb r5,[r4,r6]
	add r6,#1
	strb r6,[r3]
	mov r5,0x20
	sub r6,#2
	strb r5,[r4,r6]
doneleft
	ldreq r3,=mothermoving
	moveq r4,0
	strbeq r4,[r3]
	ldr r4,=Initial_board
	
	subeq R6,#1
	ldrbeq r5,[r4,r6]
	cmp r5,#0x58
	moveq r5,#0x20
	strbeq r5,[r4,r6]
	
	LDMFD SP!,{r3-r6,LR}
	BX LR


spwanmotherleft
	mov r5,0x58
	strb r5,[r4,r6]
	add r6,#1
	strb r6,[r3]
	LDMFD SP!,{r3-r6,LR}
	BX LR


MOTHERRIGHT
	STMFD SP!,{r3-r6,LR}
	LDR R3,=mothermoving
	mov r4,#0
	strb r4,[r3]
	
	
	ldr r4,=Initial_board
	ldr r3,=motherpos
	ldrb r6,[r3]
	cmp r6,#28
	beq doneRIGHT
	cmp r6,#46
	beq spwanmotherRIGHT
	add r6,#1
	ldrb r5,[r4,r6]
	sub r6,#1
	strb r5,[r4,r6]
	sub r6,#1
	strb r6,[r3]
	mov r5,0x20
	add r6,#2
	strb r5,[r4,r6]
doneRIGHT
	ldreq r3,=mothermoving
	moveq r4,1
	strbeq r4,[r3]
	ldr r4,=Initial_board
	
	addeq R6,#1

	ldrbeq r5,[r4,r6]
	cmp r5,#0x58
	moveq r5,#0x20
	strbeq r5,[r4,r6]
	LDMFD SP!,{r3-r6,LR}
	BX LR

spwanmotherRIGHT


	mov r5,0x58
	strb r5,[r4,r6]
	SUB r6,#1
	strb r6,[r3]
	LDMFD SP!,{r3-r6,LR}
	BX LR

	END