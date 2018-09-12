extern int test(void);	
extern int pin_connect_block_setup_for_uart0(void);
extern int uart_init(void);
extern int board(void);
int main()

{ 	

	pin_connect_block_setup_for_uart0();
	uart_init();
	board();
	 
}

