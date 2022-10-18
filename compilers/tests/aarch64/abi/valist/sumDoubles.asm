sumDoubles:
;;
;; Allocate 32 bytes on the stack
;;
  0000000000000088: D10083FF  sub         sp,sp,#0x20
;;
;; Store argNum at sp+4
;;
  000000000000008C: B90007E0  str         w0,[sp,#4]
;;
;; Store the "list" pointer at sp+8
;;
  0000000000000090: F90007E1  str         x1,[sp,#8]
;;
;; Initialize sum to 0
;;
  0000000000000094: 2F00E410  movi        d16,#0
;;
;; Store sum at sp+16
;;
  0000000000000098: FD000BF0  str         d16,[sp,#0x10]
;;
;; int i = 0
;;
  000000000000009C: 52800008  mov         w8,#0
;;
;; Store i at sp
;;
  00000000000000A0: B90003E8  str         w8,[sp]
;;
;; Start the loop body
;;
  00000000000000A4: 14000004  b           $LN4
$LN2:
  00000000000000A8: B94003E8  ldr         w8,[sp]
  00000000000000AC: 11000508  add         w8,w8,#1
  00000000000000B0: B90003E8  str         w8,[sp]
$LN4:
;;
;; w9 = argNum
;;
  00000000000000B4: B94007E9  ldr         w9,[sp,#4]
;;
;; w8 = i
;;
  00000000000000B8: B94003E8  ldr         w8,[sp]
;;
;; Is i < argNum?
;;
  00000000000000BC: 6B09011F  cmp         w8,w9
;;
;; exit loop if not
;;
  00000000000000C0: 5400020A  bge         $LN3
  00000000000000C4: D2800009  mov         x9,#0
;;
;; x8 = "list" pointer
;;
  00000000000000C8: F94007E8  ldr         x8,[sp,#8]
;;
;; x8 = -list
;;
  00000000000000CC: CB080128  sub         x8,x9,x8
;;
;; x8 = (-list) & 0x7
;;
  00000000000000D0: 92400908  and         x8,x8,#7
;;
;; x9 = 8 + ((-list) & 0x7)
;;
  00000000000000D4: 91002109  add         x9,x8,#8
;;
;; x8 = "list" pointer
;;
  00000000000000D8: F94007E8  ldr         x8,[sp,#8]
;;
;; x8 = list + 8 + ((-list) & 0x7)
;;
  00000000000000DC: 8B090108  add         x8,x8,x9
;;
;; Store aligned "list" pointer at sp+8
;;
  00000000000000E0: F90007E8  str         x8,[sp,#8]
  00000000000000E4: F94007E8  ldr         x8,[sp,#8]
;;
;; x8 = (aligned list) - 8
;;
  00000000000000E8: D1002108  sub         x8,x8,#8
;;
;; d17 = [list - 8]
;;
  00000000000000EC: FD400111  ldr         d17,[x8]
;;
;; d16 = sum
;;
  00000000000000F0: FD400BF0  ldr         d16,[sp,#0x10]
;;
;; d16 = sum + [list - 8]
;;
  00000000000000F4: 1E712A10  fadd        d16,d16,d17
;;
;; sum = d16
;;
  00000000000000F8: FD000BF0  str         d16,[sp,#0x10]
  00000000000000FC: 17FFFFEB  b           $LN2
$LN3:
;;
;; Load sum into d0
;;
  0000000000000100: FD400BE0  ldr         d0,[sp,#0x10]
;;
;; Free the 32 bytes allocated on the stack and return
;;
  0000000000000104: 910083FF  add         sp,sp,#0x20
  0000000000000108: D65F03C0  ret
  000000000000010C: 00000000