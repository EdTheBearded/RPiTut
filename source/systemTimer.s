@ return in r0 system timer base
.globl GetSystemTimerBase
GetSystemTimerBase:
	ldr	r0, =0x20003000
	mov 	pc, lr


@ returns current timer counter
.globl GetTimeStamp
GetTimeStamp:
	push 	{lr}
	bl 	GetSystemTimerBase
	ldrd	r0, r1, [r0, #4]
	pop	{pc}

@ wait the amount specified in r0 in miliseconds
.globl SystemWait
SystemWait:
	endtime .req r2
	mov 	endtime, r0
	push	{lr}
	add	sp, sp, #-4
	bl 	GetTimeStamp
	add	endtime, endtime, r0
	SystemWait_loop$:
		bl 	GetTimeStamp
		cmp	r0, endtime
		blo	SystemWait_loop$
	.unreq endtime
	add 	sp, sp, #4
	pop {pc}
