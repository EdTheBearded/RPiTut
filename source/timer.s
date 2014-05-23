.globl wait
wait:
	mov r0,#0x3F0000
	wait_loop$:
		sub r0,#1
		cmp r0,#0
		bne wait_loop$
	mov pc, lr
