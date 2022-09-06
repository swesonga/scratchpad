- - - [BEGIN] - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Decoding UpcallStub 0x0000028389dafe10
--------------------------------------------------------------------------------
  0x0000028389dafec0:   	stp	x29, x30, [sp, #-0x10]!
  0x0000028389dafec4:   	mov	x29, sp
  0x0000028389dafec8:   	sub	sp, sp, #0x110
 ;; merged str pair
  0x0000028389dafecc:   	stp	x0, x1, [sp]
 ;; { preserve_callee_saved_regs 
 ;; merged str pair
  0x0000028389dafed0:   	stp	x8, x16, [sp, #0x10]
 ;; merged str pair
  0x0000028389dafed4:   	stp	x17, x18, [sp, #0x20]
 ;; merged str pair
  0x0000028389dafed8:   	stp	x19, x20, [sp, #0x30]
 ;; merged str pair
  0x0000028389dafedc:   	stp	x21, x22, [sp, #0x40]
 ;; merged str pair
  0x0000028389dafee0:   	stp	x23, x24, [sp, #0x50]
 ;; merged str pair
  0x0000028389dafee4:   	stp	x25, x26, [sp, #0x60]
 ;; merged str pair
  0x0000028389dafee8:   	stp	x27, x28, [sp, #0x70]
 ;; merged str pair
  0x0000028389dafeec:   	stp	x30, xzr, [sp, #0x80]
  0x0000028389dafef0:   	str	d8, [sp, #0x90]
  0x0000028389dafef4:   	str	d9, [sp, #0x98]
  0x0000028389dafef8:   	str	d10, [sp, #0xa0]
  0x0000028389dafefc:   	str	d11, [sp, #0xa8]
  0x0000028389daff00:   	str	d12, [sp, #0xb0]
  0x0000028389daff04:   	str	d13, [sp, #0xb8]
  0x0000028389daff08:   	str	d14, [sp, #0xc0]
  0x0000028389daff0c:   	str	d15, [sp, #0xc8]
  0x0000028389daff10:   	str	d24, [sp, #0xd0]
 ;; } preserve_callee_saved_regs 
 ;; { on_entry
  0x0000028389daff14:   	add	x0, sp, #0xd8
 ;; 0x7FFF153FDF00
  0x0000028389daff18:   	mov	x8, #0xdf00
  0x0000028389daff1c:   	movk	x8, #0x153f, lsl #16
  0x0000028389daff20:   	movk	x8, #0x7fff, lsl #32
  0x0000028389daff24:   	blr	x8
  0x0000028389daff28:   	mov	x28, x0
 ;; 0x0
  0x0000028389daff2c:   	mov	x27, #0x0
 ;; } on_entry
 ;; { argument shuffle
 ;; merged ldr pair
  0x0000028389daff30:   	ldp	x0, x1, [sp]
 ;; bt=long
  0x0000028389daff34:   	mov	x3, x1
 ;; bt=int
  0x0000028389daff38:   	sxtw	x2, w0
 ;; } argument shuffle
 ;; { receiver 
 ;; 0x28391DB4B08
  0x0000028389daff3c:   	mov	x19, #0x4b08
  0x0000028389daff40:   	movk	x19, #0x91db, lsl #16
  0x0000028389daff44:   	movk	x19, #0x283, lsl #32
  0x0000028389daff48:   	cbz	x19, #0xe8
  0x0000028389daff4c:   	tbz	w19, #0x0, #0xe0
  0x0000028389daff50:   	ldur	x19, [x19, #-0x1]
  0x0000028389daff54:   	stp	x29, x30, [sp, #-0x10]!
  0x0000028389daff58:   	mov	x29, sp
  0x0000028389daff5c:   	ldrb	w9, [x28, #0x40]
  0x0000028389daff60:   	cbz	w9, #0xc0
  0x0000028389daff64:   	cbz	x19, #0xbc
  0x0000028389daff68:   	ldr	x9, [x28, #0x28]
  0x0000028389daff6c:   	cbz	x9, #0x1c
  0x0000028389daff70:   	sub	x9, x9, #0x8
  0x0000028389daff74:   	str	x9, [x28, #0x28]
  0x0000028389daff78:   	ldr	x8, [x28, #0x38]
  0x0000028389daff7c:   	add	x9, x9, x8
  0x0000028389daff80:   	str	x19, [x9]
  0x0000028389daff84:   	b	#0x9c
  0x0000028389daff88:   	stp	x0, x1, [sp, #-0x80]!
  0x0000028389daff8c:   	stp	x2, x3, [sp, #0x10]
  0x0000028389daff90:   	stp	x4, x5, [sp, #0x20]
  0x0000028389daff94:   	stp	x6, x7, [sp, #0x30]
  0x0000028389daff98:   	stp	x10, x11, [sp, #0x40]
  0x0000028389daff9c:   	stp	x12, x13, [sp, #0x50]
  0x0000028389daffa0:   	stp	x14, x15, [sp, #0x60]
  0x0000028389daffa4:   	stp	x16, x17, [sp, #0x70]
  0x0000028389daffa8:   	sub	sp, sp, #0x20
 ;; 0xFFFFFFFFFFFFFFE0
  0x0000028389daffac:   	orr	x8, xzr, #0xffffffffffffffe0
  0x0000028389daffb0:   	st1	{ v28.1d, v29.1d, v30.1d, v31.1d }, [sp], x8
  0x0000028389daffb4:   	st1	{ v24.1d, v25.1d, v26.1d, v27.1d }, [sp], x8
  0x0000028389daffb8:   	st1	{ v20.1d, v21.1d, v22.1d, v23.1d }, [sp], x8
  0x0000028389daffbc:   	st1	{ v16.1d, v17.1d, v18.1d, v19.1d }, [sp], x8
  0x0000028389daffc0:   	st1	{ v4.1d, v5.1d, v6.1d, v7.1d }, [sp], x8
  0x0000028389daffc4:   	st1	{ v0.1d, v1.1d, v2.1d, v3.1d }, [sp]
  0x0000028389daffc8:   	mov	x1, x28
  0x0000028389daffcc:   	mov	x0, x19
  0x0000028389daffd0:   	stp	x8, x12, [sp, #-0x10]!
 ;; 0x7FFF14BDC548
  0x0000028389daffd4:   	mov	x8, #0xc548
  0x0000028389daffd8:   	movk	x8, #0x14bd, lsl #16
  0x0000028389daffdc:   	movk	x8, #0x7fff, lsl #32
  0x0000028389daffe0:   	blr	x8
  0x0000028389daffe4:   	ldp	x8, x12, [sp], #0x10
  0x0000028389daffe8:   	ld1	{ v0.1d, v1.1d, v2.1d, v3.1d }, [sp], #32
  0x0000028389daffec:   	ld1	{ v4.1d, v5.1d, v6.1d, v7.1d }, [sp], #32
  0x0000028389dafff0:   	ld1	{ v16.1d, v17.1d, v18.1d, v19.1d }, [sp], #32
  0x0000028389dafff4:   	ld1	{ v20.1d, v21.1d, v22.1d, v23.1d }, [sp], #32
  0x0000028389dafff8:   	ld1	{ v24.1d, v25.1d, v26.1d, v27.1d }, [sp], #32
  0x0000028389dafffc:   	ld1	{ v28.1d, v29.1d, v30.1d, v31.1d }, [sp], #32
  0x0000028389db0000:   	ldp	x2, x3, [sp, #0x10]
  0x0000028389db0004:   	ldp	x4, x5, [sp, #0x20]
  0x0000028389db0008:   	ldp	x6, x7, [sp, #0x30]
  0x0000028389db000c:   	ldp	x10, x11, [sp, #0x40]
  0x0000028389db0010:   	ldp	x12, x13, [sp, #0x50]
  0x0000028389db0014:   	ldp	x14, x15, [sp, #0x60]
  0x0000028389db0018:   	ldp	x16, x17, [sp, #0x70]
  0x0000028389db001c:   	ldp	x0, x1, [sp], #0x80
  0x0000028389db0020:   	mov	sp, x29
  0x0000028389db0024:   	ldp	x29, x30, [sp], #0x10
  0x0000028389db0028:   	b	#0x8
  0x0000028389db002c:   	ldr	x19, [x19]
  0x0000028389db0030:   	mov	x1, x19
 ;; } receiver 
 ;; 0x2839C90A778
  0x0000028389db0034:   	mov	x12, #0xa778
  0x0000028389db0038:   	movk	x12, #0x9c90, lsl #16
  0x0000028389db003c:   	movk	x12, #0x283, lsl #32
  0x0000028389db0040:   	str	x12, [x28, #0x360]
  0x0000028389db0044:   	ldr	x8, [x12, #0x58]
  0x0000028389db0048:   	blr	x8
 ;; { on_exit
  0x0000028389db004c:   	add	x0, sp, #0xd8
 ;; 0x7FFF153FE008
  0x0000028389db0050:   	mov	x8, #0xe008
  0x0000028389db0054:   	movk	x8, #0x153f, lsl #16
  0x0000028389db0058:   	movk	x8, #0x7fff, lsl #32
  0x0000028389db005c:   	blr	x8
 ;; } on_exit
 ;; { restore_callee_saved_regs 
 ;; merged ldr pair
  0x0000028389db0060:   	ldp	x8, x16, [sp, #0x10]
 ;; merged ldr pair
  0x0000028389db0064:   	ldp	x17, x18, [sp, #0x20]
 ;; merged ldr pair
  0x0000028389db0068:   	ldp	x19, x20, [sp, #0x30]
 ;; merged ldr pair
  0x0000028389db006c:   	ldp	x21, x22, [sp, #0x40]
 ;; merged ldr pair
  0x0000028389db0070:   	ldp	x23, x24, [sp, #0x50]
 ;; merged ldr pair
  0x0000028389db0074:   	ldp	x25, x26, [sp, #0x60]
 ;; merged ldr pair
  0x0000028389db0078:   	ldp	x27, x28, [sp, #0x70]
 ;; merged ldr pair
  0x0000028389db007c:   	ldp	x30, xzr, [sp, #0x80]
  0x0000028389db0080:   	ldr	d8, [sp, #0x90]
  0x0000028389db0084:   	ldr	d9, [sp, #0x98]
  0x0000028389db0088:   	ldr	d10, [sp, #0xa0]
  0x0000028389db008c:   	ldr	d11, [sp, #0xa8]
  0x0000028389db0090:   	ldr	d12, [sp, #0xb0]
  0x0000028389db0094:   	ldr	d13, [sp, #0xb8]
  0x0000028389db0098:   	ldr	d14, [sp, #0xc0]
  0x0000028389db009c:   	ldr	d15, [sp, #0xc8]
  0x0000028389db00a0:   	ldr	d24, [sp, #0xd0]
 ;; } restore_callee_saved_regs 
  0x0000028389db00a4:   	mov	sp, x29
  0x0000028389db00a8:   	ldp	x29, x30, [sp], #0x10
  0x0000028389db00ac:   	ret
 ;; { exception handler
 ;; 0x7FFF153FDD40
  0x0000028389db00b0:   	mov	x8, #0xdd40
  0x0000028389db00b4:   	movk	x8, #0x153f, lsl #16
  0x0000028389db00b8:   	movk	x8, #0x7fff, lsl #32
  0x0000028389db00bc:   	blr	x8
 ;; should not reach here
  0x0000028389db00c0:   	dcps1	#0xdeae
  0x0000028389db00c4:   	b	#0x58d2160
  0x0000028389db00c8:   	udf	#0x7fff
 ;; } exception handler
  0x0000028389db00cc:   	udf	#0x0
--------------------------------------------------------------------------------
- - - [END] - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -