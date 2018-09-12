	AREA    lib, CODE, READWRITE



;***********Below this line are Exports***********************************************/	
;**********NEED TO TAB OVER FOR EXPORT****************************
;*notes for developer:see line 6
;*Please don't forget to Export~ onces a new subroutine is made.
;***************************************************************
	;/Export below
	EXPORT read_character
    EXPORT output_character
	EXPORT uart_init
	EXPORT pin_connect_block_setup_for_uart0
	EXPORT div_and_mod
	EXPORT read_string
	EXPORT output_string
	EXPORT hex_to_int
	EXPORT rng
	EXPORT RPG_WHITE
	EXPORT RPG_PURPLE
	EXPORT RPG_RED
	EXPORT RPG_GREEN
	EXPORT Display_life
	EXPORT Display_score
	EXPORT atoi
	EXPORT itoa		
	;/Export new subroutine above	
	



;***********Below this line are DECLARATION***********************************************/	
;********************************************
;/This block are Declare addresses 
;***********************************************
U0LSR EQU 0x14 ;add 14 to the U0BAS give Link Status Register
U0BAS EQU 0xE000C000;input and output address of UART0,sometime call the base address
PINSEL0 EQU 0xE002C000 ;This is address of pinselect0,used in pin_connect_block_setup_for_uart0
;/add new declaration above....
IO1PIN EQU 0XE0028010			
IO0PIN EQU 0XE0028000
IO0SET EQU 0XE0028004
IO1SET EQU 0XE0028014	
PINSEL1 EQU 0XE002C004
IO0DIR EQU 0XE0028008
IO1DIR EQU 0XE0028018
IO0CLR EQU 0XE002800C
IO1CLR EQU 0XE002801C
	
ALIGN

digits_SET

	DCD 0x00001F80  ; 0     0x00003780   ascii: 0x30
 	DCD 0x00003000  ; 1		0x00000300
    DCD 0x00009580  ; 2		0x00009580
 	DCD 0x00008780  ; 3
	DCD 0x0000A300  ; 4
 	DCD 0x0000A680  ; 5
    DCD 0x0000B680  ; 6
	DCD 0x00000380  ; 7
    DCD 0x0000B780  ; 8
 	DCD 0x0000A380  ; 9        ascii: 0x39
    DCD 0x0000B380  ; A        ascii: 0x41
 	DCD 0x0000B600  ; B
    DCD 0x00003480  ; C
 	DCD 0x00009700  ; D
    DCD 0x0000B480  ; E
	DCD 0x0000B080  ; F    0x0000B080    ascii: 0x46
	DCD 0x00008000  ; -

	ALIGN

;*************Below this line are the subroutines implementatio*******************************/

; ***************************
; Initialize UART0
; ARGS  : none
; RETURN: none 
; ***************************
uart_init
    STMFD   SP!, {lr}
    ; 8-bit word length, 1 stop bit, no parity
    ; Disable break control
    ; Enable divisor latch access
    MOV     r1, #131             
    LDR     r4, =0xE000C00C
    STR     r1, [r4]
    ; Set lower divisor latch for 1152000 baud
    MOV     r1, #1
    LDR     r4, =0xE000C000
    STR     r1, [r4]
    ; Set upper divisor latch for 1152000 baud
    MOV     r1, #0
    LDR     r4, =0xE000C004
    STR     r1, [r4]
    ; 8-bit word length, 1 stop bit, no parity
    ; Disable break control
    ; Disable divisor latch access
    MOV     r1, #3
    LDR     r4, =0xE000C00C
    STR     r1, [r4]
    LDMFD   SP!, {lr}
    BX      lr
;/*********Initialize UART0*****/
;/*************END*************/



;*************************/
;read char from base adress
;ARGS : NONE
;Return: R0 = char READ from uart,
;***********************/
read_character
	STMFD   SP!,{r1-r3,lr};
	LDR R0,=U0BAS;
LSRLOOP
	LDRB R1,[R0, #U0LSR]
	ANDS R2,R1,#1     ; and with cmp in one line uing ANDS
	BEQ LSRLOOP       ;
	LDRB R3 ,[R0]     ;
	MOV R0,R3       	
	LDMFD   sp!, {r1-r3,lr}          
    BX      lr	
;/*********read_haracter*******/
;/*************END*************/	
	
	
	
; ***************************
; Output char to UART0
; ARGS  : r0 = char to output
; RETURN: none
; ***************************
output_character
	STMFD   SP!,{lr, r1-r3}     ; Store register lr on stack
    MOV     r3, r0              ; Store char argument into r3
    LDR     r0, =0xE000C000     ; Load UART0 Base Address
tstart
    LDRB    r1, [r0, #U0LSR]    ; Load Status Register Addresss
    ANDS    r2, r1, #32         ; test THRE in Status Register
    BEQ     tstart              ; if THRE == 0 -> tstart
    STRB    r3, [r0]            ; else Store byte in transmit register
    MOV     r0, r3
    LDMFD   sp!, {lr,r1-r3}
    BX      lr
;/*********output_haracter*******/
;/*************END**************/	


	
; ***************************
; div_and_mod
; ARGS  : r0=Divisor,R1=divident
; RETURN: r0=quotien,r1=remainder
; ***************************
;The result of this functions are in Hexdecimal/
div_and_mod
	STMFD sp!, {r2-r5,lr}
	MOV R5,#0          ;keep track of negative
	CMP	R1,#0          ;check if r1 is negative
	BLT	PR1            ;
CKN	CMP R0,#0          ;check if r0 is negative
	BLT PR0

STA	MOV R2,#15         ;Initialize Counter to 15
	MOV R3,#0          ;Initialize Quotient to 0
	MOV R0,R0, LSL #15 ;Logical Left Shift Divisor 15 Place
	MOV R4,R1          ;Initialze Remainder to Dividend
RMD	SUB R4,R4,R0       ;Remainder = remainder -Divisor
	CMP R4,#0          ;0-r4
	BLT RAD
	MOV	R3,R3, LSL #1  ;Quotient LS 1
	ADD R3,#1          ;LSB=1
MSB	MOV	R0,R0, LSR #1  ;Remainder RS 1
	CMP	R2,#0          ; counter>0?
	SUB R2,#1          ;Decrement Counter
	BGT	RMD
	B	CHK
RAD	ADD R4,r0
	MOV	R3,R3,LSL #1;
	B	MSB
	
	
PR1	NEG	R1,R1   ;negate r1
	ADD R5,#1   ;	
	B	CKN
PR0	NEG	R0,R0   ;
	ADD R5,#1   ;
	B	STA
	
NEA	NEG R3,R3   ;
	MOV R0,R3   ;
	MOV R1,R4   ;
	B	FIN
CHK	CMP R5,#1   ;check and change negative
	BEQ	NEA
	MOV R0,R3   ;R3 is quotien
	MOV R1,R4   ;r4 is remainder
	
FIN	LDMFD sp!, {r2-r5,lr}
	BX 	lr
;***********div_and_mod***********
;**********END*******************



; ***************************
; read_string(read user input)
; ARGS  : None
; RETURN: r2= contain user-input
; ***************************
read_string	
	STMFD SP!, {lr, r0, r2, r3}  
Rs_loop	
	BL read_character
	STRB r0,[r2],#1       ;store user input, and increment

	BL output_character   ;output to promt to see what user has inputed
	CMP r0,#0x0D		  ;check CR
	BNE Rs_loop			  ;keep reading until CR is inputted by user
	MOV r3,#0x00		  ;
	STRB R3 ,[R2, #-1]!	  ;replace CR with null
	MOV r0,#0x0A		  ;print newline, newline are not stored
	BL output_character	  ;
	LDMFD   sp!, {lr, r0, r2, r3}
    BX      lr
;***********read_string***********
;************END*****************

; ***************************
; output_string
; ARGS  : r2 = String to output
; RETURN: None
; ***************************
output_string
    STMFD   SP!, {lr, r0, r1, r2}
Os_loop
    LDRB    r0, [r2], #1        ; char loaded into r0, r4 post-indexed base updated 
    LDR     r1, =U0BAS           ; set r1 to UART0 Base Address
    BL      output_character    ; output char in r0 
    CMP     r0, #0              ; check if char is 0
    BNE     Os_loop				; loop if char != 0
	SUB		R2,R2,#1			;add new line to replace null
	MOV		r0,#0X0A				;
	BL		output_character	;
    LDMFD   sp!, {lr, r0, r1, r2}
    BX      lr
;***********output_string***********
;************END*****************

; ***************************
; Convert a single hexadecimal char to int
; ARGS  : r0 = hex char to convert
; RETURN: r0 = converted int, 16 on error
; ***************************
hex_to_int
    STMFD   SP!, {lr, r3, r4}
    MOV     r3, #0              
    MOV     r4, #0
    ; check if input == [0-9]
    SUBS    r3, r0, #48         
    RSBS    r4, r0, #57         
    CMP     r3, #0              ; if r0 >= '0'
    CMPPL   r4, #0              ; AND r <= '9'
    BPL     htoi_num
    ; check if input == [A-F]
    SUBS    r3, r0, #65
    RSBS    r4, r0, #70
    CMP     r3, #0              ; if r0 >= 'A'
    CMPPL   r4, #0              ; and r0 <= 'F'
    BPL     htoi_alpha  
    ; if error
    MOV     r0, #16             ; set return error, r0 = 16
    B       htoi_end
htoi_num    
    SUB   r0, r0, #48           ; if r0 == [0-9]
    B     htoi_end
htoi_alpha
    SUB     r0, r0, #55         ; else r0 == [A-F]
htoi_end
    LDMFD   SP!, {lr, r3, r4}
    BX      lr
;##############char to in##################

; ***************************
; Return random number 0-3
; ARGS  : r0 - range
; RETURN: r0 - random number
; ***************************
rng
	STMFD SP!, {r1-r2, r5 , lr}
    MOV r2, r0
    LDR r1, =0xE0008008;
    LDRB r0, [r1]
	MOV R1,R0;
    MOV r0, r2
    BL div_and_mod
    MOV r0, r1
	LDMFD SP!, {r1-r2, r5, lr}
	BX lr
;##########return random number######

;#######################
;RPG WHITE
;#######################
RPG_WHITE
	STMFD SP!,{R2-R4,LR}
	;SET DIR
	LDR R4,=IO0DIR
	LDR R2,=0X00260000
	LDR R3,[R4]
	ORR R3,R2
	STR R3,[R4]
	;CLR THE STUFF
	LDR R4,=IO0SET
	STR R2,[R4]
	;SET WHITE
	LDR R4,=IO0CLR
	STR R2,[R4]
	LDMFD SP!,{R2-R4,LR}
	BX LR
;#######################
;RPG PURPLE
;#######################
RPG_PURPLE
	STMFD SP!,{R2-R4,LR}
	;SET DIR
	LDR R4,=IO0DIR
	LDR R2,=0X00260000
	LDR R3,[R4]
	ORR R3,R2
	STR R3,[R4]
	;CLR THE STUFF
	LDR R4,=IO0SET
	STR R2,[R4]
	;SET WHITE
	LDR R2,=0X00060000
	LDR R4,=IO0CLR
	STR R2,[R4]
	LDMFD SP!,{R2-R4,LR}	
	BX LR
	
;#######################
;RPG RED
;#######################
RPG_RED
	STMFD SP!,{R2-R4,LR}
	;SET DIR
	LDR R4,=IO0DIR
	LDR R2,=0X00260000
	LDR R3,[R4]
	ORR R3,R2
	STR R3,[R4]
	;CLR THE STUFF
	LDR R4,=IO0SET
	STR R2,[R4]
	;SET WHITE
	LDR R2,=0X00020000
	LDR R4,=IO0CLR
	STR R2,[R4]
	LDMFD SP!,{R2-R4,LR}	
	BX LR
	
;#######################
;RPG GREEN
;#######################
RPG_GREEN
	STMFD SP!,{R2-R4,LR}
	;SET DIR
	LDR R4,=IO0DIR
	LDR R2,=0X00260000
	LDR R3,[R4]
	ORR R3,R2
	STR R3,[R4]
	;CLR THE STUFF
	LDR R4,=IO0SET
	STR R2,[R4]
	;SET WHITE
	LDR R2,=0X00200000
	LDR R4,=IO0CLR
	STR R2,[R4]
	LDMFD SP!,{R2-R4,LR}	
	BX LR	
	
;########################	
;Display Life
;arg r0 : 0 to 4
;return none
;###################
Display_life
	STMFD SP!,{R0,R4-R6,LR}
	LDR R4,=IO1DIR
	ldr r5,[r4]	
	ldr r6,=0x000F0000
	orr r5,r6
	str r5,[r4]
	LDR R4,=IO1SET
	STR R6,[R4]
	;LDR R6,=0X000F0000;L
	ldr r4,=IO1CLR
	;STR R6,[R4]
	CMP R0,#4
	LDREQ R6,=0X000F0000;all on
	CMP R0,#3
	LDREQ R6,=0X000E0000;one off
	CMP R0,#2
	LDREQ R6,=0X000C0000;two off
	CMP R0,#1
	LDREQ R6,=0X00080000;three off
	CMP R0,#0
	LDREQ R6,=0X00000000;four off
	LDR R5,[R4]
	ORR R5,R6
	STR R5,[R4]
	LDMFD SP!,{R0,R4-R6,LR}
	BX LR
	
	
;####################################
;r0:selecting digits; r1 digit to display
;return none
;######################################
Display_score	
	STMFD SP!,{R0,R4,r3,r2,LR}
	;set direction
	ldr r4,=IO0DIR
	ldr r2,=0x0000B7BC
	ldr r3,[r4]
	orr r2,r3
	str r2,[r4]
	ldr r4,=IO0CLR
	STR R2,[R4]
	LDR R4,=digits_SET
	lsl r1,#2
	ldr r3,[r4,r1];display the values
	;choose digit
	cmp r0,#0
	ldreq r5,=0x00000038
	cmp r0,#1
	ldreq r5,=0x00000034
	cmp r0,#2
	ldreq r5,=0x0000002C
	cmp r0,#3
	ldreq r5,=0x0000001C
	orr r3,r5
	LDR R4,=IO0SET
	str r3,[r4]
	LDMFD SP!,{R0,R4,r3,r2,LR}
	BX LR
	
;************************This below is for setting up pin_connect, declare new subroutine above this line***/
; ***************************
; Setting up pin0
; ARGS  : none
; RETURN: none
; ***************************
pin_connect_block_setup_for_uart0
    STMFD SP!, {lr, r0, r1}
    LDR r0, =PINSEL0            ; PINSEL0
    LDR r1, [r0]
    ORR r1, r1, #5
    BIC r1, r1, #0xA
    STR r1, [r0]
    LDMFD SP!, {lr, r0, r1}
    BX lr





atoi
    STMFD   SP!, {lr, r2-r4}
    MOV     r2, #0              ; initialize running total
    MOV     r3, #10             ; initialize multiplier
    ; Check sign
    MOV     r5, #0              ; initialize r5 to store sign flag
    LDRB    r0, [r4]            ; Load first char byte
    CMP     r0, #0x2D
    MOVEQ   r5, #1              ; Set r5 = 1 if negative, 0 if positive
    ADDEQ   r4, #1              ; increment place in address by 1
atoi_loop
    LDRB    r0, [r4], #1        ; Load next char byte
    CMP     r0, #0              ; if r0 == NULL terminator then
    BEQ     atoi_end            ; branch to end of subroutine
    SUB     r0, r0, #48         ; Conver to int
    MLA     r2, r3, r2, r0      ; r2 = (r3 * r2) + r0
    B       atoi_loop
atoi_end
    CMP     r5, #1              ; Convert to two's comp if negative
    MVNEQ   r2, r2              ; Take complement of r2
    ADDEQ   r2, r2, #1          ; then add 1
    MOV     r0, r2              ; Return in r0
    LDMFD   SP!, {lr, r2-r4}
    BX      lr
itoa
    ; Args r4 = base address to store result string
    ;      r0 = int to convert
    ; r1 = divisor 10
    ; r3 = counter
    STMFD   SP!, {lr, r1-r4}
    MOV     r3, #0
    MOV     r1, #10
    ; Check sign
    CMP     r0, #0
    MOV     r5, #0x2D       ; '-' char
    STRBMI  r5, [r4], #1    ; if negative, insert '-' char
    MVNMI   r0, r0          ; if negative, convert to two's comp
    ADDMI   r0, r0, #1
    
    CMP     r0, #0          ; if int == 0, store in memory to write and branch to end
    BNE     itoa_loop       
    ADD     r0, r0, #0x30   ; convert 0 to char '0'
    STRB    r0, [r4], #1    ; store 0 in memory
    B       itoa_end        ; branch to end
        
itoa_loop
    MOV     r1, #10
    BL      dnd    ; divide by 10

    CMP     r1, #0          ; if remainder == 0
    CMPEQ   r0, #0          ; and quotient == 0, branch to end
    BEQ     itoa_pop
    ADD     r1, r1, #48     ; Convert int to ASCII
    PUSH    {r1}            ; Push onto stack
    ADD     r3, r3, #1      ; Increment Counter
    B       itoa_loop
itoa_pop
    CMP     r3, #0          ; Pop from stack until counter == 0
    BEQ     itoa_end
    POP     {r1}
    STRB    r1, [r4], #1    ; Store popped char into memory
    SUB     r3, r3, #1
    B       itoa_pop
itoa_end
    MOV     r1, #0          ; append NULL char
    STRB    r1, [r4]
    LDMFD   sp!, {lr, r1-r4}
    BX      lr

dnd
    STMFD r13!, {r2-r12, r14}
            
    
    ; check sign of dividend
    CMP     r0, #0
    MOV     r5, #0
    MOVMI   r5, #1
    ; if dividend < 0, convert to two's comp
    MVNMI   r0, r0
    ADDMI   r0, r0, #1
    
    ; check sign of divisor
    CMP     r1, #0
    MOV     r6, #0
    MOVMI   r6, #1
    ; if divisor < 0, convert to two's comp
    MVNMI   r1, r1
    ADDMI   r1, r1, #1
    
    MOV     r2, #15         ; Init counter to 15
    MOV     r3, #0          ; Init quotient to 0
    LSL     r1, r1, #15         ; lsl divisor by 15
    ADD     r4, r0, #0          ; Set remainder to dividend
loop
    SUBS    r4, r4, r1          ; rem = rem - divis
    
    ; if(remainder < 0)
    ADDLT   r4, r4, r1          ; rem = rem + divis
    LSLLT   r3, #1              ; lsl quotient
    ; else
    LSLGE   r3, #1              ; lsl quotient
    ORRGE   r3, r3, #1          ; set LSB of quot = 1
    
    LSR     r1, r1, #1          ; right shift divis
    SUBS    r2, r2, #1          ; decrement counter
    BPL     loop                ; branch if count >= 0
    
    ADD     r0, r3, #0          ; set quot to r0
    ADD     r1, r4, #0          ; set remain to r1
    
    EOR     r7, r5, r6
    CMP     r7, #1              
    ; if dvnd != dvsr, convert answer to two's comp
    MVNEQ   r0, r0
    ADDEQ   r0, r0, #1
        
    LDMFD r13!, {r2-r12, r14}
    BX lr  

    END    