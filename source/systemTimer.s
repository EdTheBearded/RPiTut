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

@ wait the amount specified in r0 in microseconds
.globl SystemWait
SystemWait:
	endtime .req r2
	mov 	endtime, r0
	stmfd sp!, {lr}
	bl 	GetTimeStamp
	add	endtime, endtime, r0
	SystemWait_loop$:
		bl 	GetTimeStamp
		cmp	r0, endtime
		blo	SystemWait_loop$
	.unreq endtime
	ldmfd sp!, {pc}

@ wait the amount specified in r1, r0 in microseconds
.globl SystemWait64
SystemWait64:
	stmfd sp!, {r4, lr}
	mov r4, r1
	mov r3, r0
	bl GetTimeStamp
	add r3, r0, r3 @r4 and r4 will store the final time
	add r4, r1, r4
	SystemWait_loop64$:
		bl GetTimeStamp
		cmp r1, r4
		bmi SystemWait_loop64$
		bpl SystemWait_fim64$
		cmp r0, r3
		bmi SystemWait_loop64$
	SystemWait_fim64$:
	ldmfd sp!, {r4, pc}
