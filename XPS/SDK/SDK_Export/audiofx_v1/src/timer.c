#include <xparameters.h>
#include <xtmrctr.h>
#include <xintc.h>

volatile int gv_one_sec_flag = 0;

static void (*m_watchdog_tripped)(void);
static volatile int m_watchdog_timer = -1;

void watchdog_kick(void) {
	m_watchdog_timer = 2;
}

void watchdog_enable(void (*func)(void)) {
	m_watchdog_tripped = func;
	watchdog_kick();
}

void watchdog_tick(void) {
	if (m_watchdog_timer == -1) return;	// Not enabled

	--m_watchdog_timer;
	//xil_printf("WD @ %d\r\n", m_watchdog_timer);

	if (m_watchdog_timer == 0) {
		m_watchdog_timer = -1;
		if (m_watchdog_tripped) {
			m_watchdog_tripped();
		}
	}
}

void timer_interrupt_handler(void* _unused) {
	u32 tcsr0;

	/* Read timer 0 CSR to see if it raised the interrupt */
	tcsr0 = XTmrCtr_GetControlStatusReg(XPAR_XPS_TIMER_0_BASEADDR, 0);

	/* If the interrupt occurred, then increment a counter and set one_second_flag */
	if (tcsr0 & XTC_CSR_INT_OCCURED_MASK) {
		/* Clear the timer interrupt */
		XTmrCtr_SetControlStatusReg(XPAR_XPS_TIMER_0_BASEADDR, 0, tcsr0);

		gv_one_sec_flag = 1;

		watchdog_tick();
	}
}

void init_timer(int period) {

	// Set the number of cycles the timer counts before interrupting
	XTmrCtr_SetLoadReg(XPAR_XPS_TIMER_0_BASEADDR, 0, period * XPAR_XPS_TIMER_0_CLOCK_FREQ_HZ / 1000);

	// Reset the timer, and clear the interrupt occurred flag
	XTmrCtr_SetControlStatusReg(XPAR_XPS_TIMER_0_BASEADDR, 0,
			XTC_CSR_INT_OCCURED_MASK |        // Clear T0INT
			XTC_CSR_LOAD_MASK                 // LOAD0 1 = Loads timer with value in TLR0
			);

	// Start the timers
	XTmrCtr_SetControlStatusReg(XPAR_XPS_TIMER_0_BASEADDR, 0,
			XTC_CSR_ENABLE_TMR_MASK |         // ENT0 Enable Timer0
			XTC_CSR_ENABLE_INT_MASK |         // ENIT Enable Interrupt for Timer0
			XTC_CSR_AUTO_RELOAD_MASK |        // ARHT0 1 = Auto reload Timer0 and continue running
			XTC_CSR_DOWN_COUNT_MASK           // UDT0  1 = Timer counts down
			);

	// Register the Timer interrupt handler in the vector table
	XIntc_RegisterHandler(
			XPAR_XPS_INTC_0_BASEADDR,                       // BaseAddress
			XPAR_XPS_INTC_0_XPS_TIMER_0_INTERRUPT_INTR,     // InterruptId
			timer_interrupt_handler,                        // Handler
			0);                                             // CallBackRef - parameter passed to Handler

	// Enable timer interrupts in the interrupt controller
	XIntc_EnableIntr(XPAR_XPS_INTC_0_BASEADDR, XPAR_XPS_TIMER_0_INTERRUPT_MASK);
}
