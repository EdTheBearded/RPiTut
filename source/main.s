.section .init

.globl _start

_start:
b main

.section .text
main:
	mov 	sp, #0x8000
	pinNum .req r0
	pinFunc .req r1
	mov 	pinNum, #16
	mov 	pinFunc, #1
	bl   	SetGpioFunction
	.unreq pinNum
	.unreq pinFunc
	pinNum .req r0
	pinVal .req r1
	mov 	pinNum, #16
	mov 	pinVal, #1
	.unreq pinNum
	.unreq pinVal
	blink_loop$:
		push 	{r0, r1}
		add	sp, sp, #-8
		bl 	SetGpio
		ldr	r0, =0xF4240 @0xF4240 = 1000000d
		bl	SystemWait
		add 	sp, sp, #8
		pop 	{r0, r1}
		eor	r1, r1, #1
		b 	blink_loop$

