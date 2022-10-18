sumFloatStruct:
;;
;; allocate 32 bytes on the stack
;;
  0000000000000288: D10083FF  sub         sp,sp,#0x20
;;
;; store the "list" pointer at sp
;;
  000000000000028C: F90003E0  str         x0,[sp]
;;
;; x8 = "list" pointer
;;
  0000000000000290: D2800009  mov         x9,#0
  0000000000000294: F94003E8  ldr         x8,[sp]
;;
;; x8 = -list
;;
  0000000000000298: CB080128  sub         x8,x9,x8
;;
;; x8 = (-list) & 0x3
;;
  000000000000029C: 92400508  and         x8,x8,#3
;;
;; x9 = 8 + ((-list) & 0x3)
;;
  00000000000002A0: 91002109  add         x9,x8,#8
;;
;; x8 = list
;;
  00000000000002A4: F94003E8  ldr         x8,[sp]
;;
;; x8 = list + 8 + ((-list) & 0x3)
;;
  00000000000002A8: 8B090108  add         x8,x8,x9
;;
;; store aligned "list" pointer at sp
;;
  00000000000002AC: F90003E8  str         x8,[sp]
  00000000000002B0: F94003E8  ldr         x8,[sp]
;;
;; x8 = (aligned list) - 8
;;
  00000000000002B4: D1002108  sub         x8,x8,#8
;;
;; x8 = *(x8)
;;
  00000000000002B8: F9400108  ldr         x8,[x8]
;;
;; store loaded 64-bit value at sp+16
;;
  00000000000002BC: F9000BE8  str         x8,[sp,#0x10]
;;
;; load 32-bit float from sp+20
;;
  00000000000002C0: BD4017F0  ldr         s16,[sp,#0x14]
;;
;; store the 32-bit float at sp+12
;;
  00000000000002C4: BD000FF0  str         s16,[sp,#0xC]
;;
;; load 32-bit float from sp+16
;;
  00000000000002C8: BD4013F0  ldr         s16,[sp,#0x10]
;;
;; store the 32-bit float at sp+8
;;
  00000000000002CC: BD000BF0  str         s16,[sp,#8]
;;
;; load 32-bit float from sp+8
;;
  00000000000002D0: BD400BF1  ldr         s17,[sp,#8]
;;
;; load 32-bit float from sp+12
;;
  00000000000002D4: BD400FF0  ldr         s16,[sp,#0xC]
;;
;; add the 2 32-bit floats placing result in s0
;;
  00000000000002D8: 1E302A20  fadd        s0,s17,s16
;;
;; Free the 32 bytes allocated on the stack and return
;;
  00000000000002DC: 910083FF  add         sp,sp,#0x20
  00000000000002E0: D65F03C0  ret
  00000000000002E4: 00000000