
Dump of file libVaList.obj

File Type: COFF OBJECT

sumInts:
  0000000000000000: D10083FF  sub         sp,sp,#0x20
  0000000000000004: B9000BE0  str         w0,[sp,#8]
  0000000000000008: F9000BE1  str         x1,[sp,#0x10]
  000000000000000C: 52800008  mov         w8,#0
  0000000000000010: B90007E8  str         w8,[sp,#4]
  0000000000000014: 52800008  mov         w8,#0
  0000000000000018: B90003E8  str         w8,[sp]
  000000000000001C: 14000004  b           $LN4
$LN2:
  0000000000000020: B94003E8  ldr         w8,[sp]
  0000000000000024: 11000508  add         w8,w8,#1
  0000000000000028: B90003E8  str         w8,[sp]
$LN4:
  000000000000002C: B9400BE9  ldr         w9,[sp,#8]
  0000000000000030: B94003E8  ldr         w8,[sp]
  0000000000000034: 6B09011F  cmp         w8,w9
  0000000000000038: 5400020A  bge         $LN3
  000000000000003C: D2800009  mov         x9,#0
  0000000000000040: F9400BE8  ldr         x8,[sp,#0x10]
  0000000000000044: CB080128  sub         x8,x9,x8
  0000000000000048: 92400508  and         x8,x8,#3
  000000000000004C: 91002109  add         x9,x8,#8
  0000000000000050: F9400BE8  ldr         x8,[sp,#0x10]
  0000000000000054: 8B090108  add         x8,x8,x9
  0000000000000058: F9000BE8  str         x8,[sp,#0x10]
  000000000000005C: F9400BE8  ldr         x8,[sp,#0x10]
  0000000000000060: D1002108  sub         x8,x8,#8
  0000000000000064: B94007E9  ldr         w9,[sp,#4]
  0000000000000068: B9400108  ldr         w8,[x8]
  000000000000006C: 0B080128  add         w8,w9,w8
  0000000000000070: B90007E8  str         w8,[sp,#4]
  0000000000000074: 17FFFFEB  b           $LN2
$LN3:
  0000000000000078: B94007E0  ldr         w0,[sp,#4]
  000000000000007C: 910083FF  add         sp,sp,#0x20
  0000000000000080: D65F03C0  ret
  0000000000000084: 00000000
sumDoubles:
  0000000000000088: D10083FF  sub         sp,sp,#0x20
  000000000000008C: B90007E0  str         w0,[sp,#4]
  0000000000000090: F90007E1  str         x1,[sp,#8]
  0000000000000094: 2F00E410  movi        d16,#0
  0000000000000098: FD000BF0  str         d16,[sp,#0x10]
  000000000000009C: 52800008  mov         w8,#0
  00000000000000A0: B90003E8  str         w8,[sp]
  00000000000000A4: 14000004  b           $LN4
$LN2:
  00000000000000A8: B94003E8  ldr         w8,[sp]
  00000000000000AC: 11000508  add         w8,w8,#1
  00000000000000B0: B90003E8  str         w8,[sp]
$LN4:
  00000000000000B4: B94007E9  ldr         w9,[sp,#4]
  00000000000000B8: B94003E8  ldr         w8,[sp]
  00000000000000BC: 6B09011F  cmp         w8,w9
  00000000000000C0: 5400020A  bge         $LN3
  00000000000000C4: D2800009  mov         x9,#0
  00000000000000C8: F94007E8  ldr         x8,[sp,#8]
  00000000000000CC: CB080128  sub         x8,x9,x8
  00000000000000D0: 92400908  and         x8,x8,#7
  00000000000000D4: 91002109  add         x9,x8,#8
  00000000000000D8: F94007E8  ldr         x8,[sp,#8]
  00000000000000DC: 8B090108  add         x8,x8,x9
  00000000000000E0: F90007E8  str         x8,[sp,#8]
  00000000000000E4: F94007E8  ldr         x8,[sp,#8]
  00000000000000E8: D1002108  sub         x8,x8,#8
  00000000000000EC: FD400111  ldr         d17,[x8]
  00000000000000F0: FD400BF0  ldr         d16,[sp,#0x10]
  00000000000000F4: 1E712A10  fadd        d16,d16,d17
  00000000000000F8: FD000BF0  str         d16,[sp,#0x10]
  00000000000000FC: 17FFFFEB  b           $LN2
$LN3:
  0000000000000100: FD400BE0  ldr         d0,[sp,#0x10]
  0000000000000104: 910083FF  add         sp,sp,#0x20
  0000000000000108: D65F03C0  ret
  000000000000010C: 00000000
getInt:
  0000000000000110: D10043FF  sub         sp,sp,#0x10
  0000000000000114: F90003E0  str         x0,[sp]
  0000000000000118: D2800009  mov         x9,#0
  000000000000011C: F94003E8  ldr         x8,[sp]
  0000000000000120: CB080128  sub         x8,x9,x8
  0000000000000124: 92400908  and         x8,x8,#7
  0000000000000128: 91002109  add         x9,x8,#8
  000000000000012C: F94003E8  ldr         x8,[sp]
  0000000000000130: 8B090108  add         x8,x8,x9
  0000000000000134: F90003E8  str         x8,[sp]
  0000000000000138: F94003E8  ldr         x8,[sp]
  000000000000013C: D1002108  sub         x8,x8,#8
  0000000000000140: F9400108  ldr         x8,[x8]
  0000000000000144: F90007E8  str         x8,[sp,#8]
  0000000000000148: F94007E8  ldr         x8,[sp,#8]
  000000000000014C: B9400100  ldr         w0,[x8]
  0000000000000150: 910043FF  add         sp,sp,#0x10
  0000000000000154: D65F03C0  ret
sumStruct:
  0000000000000158: D10083FF  sub         sp,sp,#0x20
  000000000000015C: F90003E0  str         x0,[sp]
  0000000000000160: D2800009  mov         x9,#0
  0000000000000164: F94003E8  ldr         x8,[sp]
  0000000000000168: CB080128  sub         x8,x9,x8
  000000000000016C: 92400508  and         x8,x8,#3
  0000000000000170: 91002109  add         x9,x8,#8
  0000000000000174: F94003E8  ldr         x8,[sp]
  0000000000000178: 8B090108  add         x8,x8,x9
  000000000000017C: F90003E8  str         x8,[sp]
  0000000000000180: F94003E8  ldr         x8,[sp]
  0000000000000184: D1002108  sub         x8,x8,#8
  0000000000000188: F9400108  ldr         x8,[x8]
  000000000000018C: F9000BE8  str         x8,[sp,#0x10]
  0000000000000190: F9400BE8  ldr         x8,[sp,#0x10]
  0000000000000194: F90007E8  str         x8,[sp,#8]
  0000000000000198: B9400BE9  ldr         w9,[sp,#8]
  000000000000019C: B9400FE8  ldr         w8,[sp,#0xC]
  00000000000001A0: 0B080120  add         w0,w9,w8
  00000000000001A4: 2A0003E0  mov         w0,w0
  00000000000001A8: 910083FF  add         sp,sp,#0x20
  00000000000001AC: D65F03C0  ret
sumBigStruct:
  00000000000001B0: A9BF7BFD  stp         fp,lr,[sp,#-0x10]!
  00000000000001B4: 910003FD  mov         fp,sp
  00000000000001B8: 94000000  bl          __security_push_cookie
  00000000000001BC: D100C3FF  sub         sp,sp,#0x30
  00000000000001C0: F90003E0  str         x0,[sp]
  00000000000001C4: D2800009  mov         x9,#0
  00000000000001C8: F94003E8  ldr         x8,[sp]
  00000000000001CC: CB080128  sub         x8,x9,x8
  00000000000001D0: 92400908  and         x8,x8,#7
  00000000000001D4: 91004109  add         x9,x8,#0x10
  00000000000001D8: F94003E8  ldr         x8,[sp]
  00000000000001DC: 8B090108  add         x8,x8,x9
  00000000000001E0: F90003E8  str         x8,[sp]
  00000000000001E4: F94003E8  ldr         x8,[sp]
  00000000000001E8: D1004108  sub         x8,x8,#0x10
  00000000000001EC: 3DC00110  ldr         q16,[x8]
  00000000000001F0: 3D8007F0  str         q16,[sp,#0x10]
  00000000000001F4: 3DC007F0  ldr         q16,[sp,#0x10]
  00000000000001F8: 3D800BF0  str         q16,[sp,#0x20]
  00000000000001FC: F94013E9  ldr         x9,[sp,#0x20]
  0000000000000200: F94017E8  ldr         x8,[sp,#0x28]
  0000000000000204: 8B080120  add         x0,x9,x8
  0000000000000208: 9100C3FF  add         sp,sp,#0x30
  000000000000020C: 94000000  bl          __security_pop_cookie
  0000000000000210: A8C17BFD  ldp         fp,lr,[sp],#0x10
  0000000000000214: D65F03C0  ret
sumHugeStruct:
  0000000000000218: A9BF7BFD  stp         fp,lr,[sp,#-0x10]!
  000000000000021C: 910003FD  mov         fp,sp
  0000000000000220: 94000000  bl          __security_push_cookie
  0000000000000224: D10143FF  sub         sp,sp,#0x50
  0000000000000228: F90003E0  str         x0,[sp]
  000000000000022C: F94003E8  ldr         x8,[sp]
  0000000000000230: 91002108  add         x8,x8,#8
  0000000000000234: F90003E8  str         x8,[sp]
  0000000000000238: F94003E8  ldr         x8,[sp]
  000000000000023C: D1002108  sub         x8,x8,#8
  0000000000000240: F9400108  ldr         x8,[x8]
  0000000000000244: 3DC00110  ldr         q16,[x8]
  0000000000000248: 3D8007F0  str         q16,[sp,#0x10]
  000000000000024C: F9400908  ldr         x8,[x8,#0x10]
  0000000000000250: F90013E8  str         x8,[sp,#0x20]
  0000000000000254: 3DC007F0  ldr         q16,[sp,#0x10]
  0000000000000258: 3D800FF0  str         q16,[sp,#0x30]
  000000000000025C: F94013E8  ldr         x8,[sp,#0x20]
  0000000000000260: F90023E8  str         x8,[sp,#0x40]
  0000000000000264: F9401BE9  ldr         x9,[sp,#0x30]
  0000000000000268: F9401FE8  ldr         x8,[sp,#0x38]
  000000000000026C: 8B080129  add         x9,x9,x8
  0000000000000270: F94023E8  ldr         x8,[sp,#0x40]
  0000000000000274: 8B080120  add         x0,x9,x8
  0000000000000278: 910143FF  add         sp,sp,#0x50
  000000000000027C: 94000000  bl          __security_pop_cookie
  0000000000000280: A8C17BFD  ldp         fp,lr,[sp],#0x10
  0000000000000284: D65F03C0  ret
sumFloatStruct:
  0000000000000288: D10083FF  sub         sp,sp,#0x20
  000000000000028C: F90003E0  str         x0,[sp]
  0000000000000290: D2800009  mov         x9,#0
  0000000000000294: F94003E8  ldr         x8,[sp]
  0000000000000298: CB080128  sub         x8,x9,x8
  000000000000029C: 92400508  and         x8,x8,#3
  00000000000002A0: 91002109  add         x9,x8,#8
  00000000000002A4: F94003E8  ldr         x8,[sp]
  00000000000002A8: 8B090108  add         x8,x8,x9
  00000000000002AC: F90003E8  str         x8,[sp]
  00000000000002B0: F94003E8  ldr         x8,[sp]
  00000000000002B4: D1002108  sub         x8,x8,#8
  00000000000002B8: F9400108  ldr         x8,[x8]
  00000000000002BC: F9000BE8  str         x8,[sp,#0x10]
  00000000000002C0: BD4017F0  ldr         s16,[sp,#0x14]
  00000000000002C4: BD000FF0  str         s16,[sp,#0xC]
  00000000000002C8: BD4013F0  ldr         s16,[sp,#0x10]
  00000000000002CC: BD000BF0  str         s16,[sp,#8]
  00000000000002D0: BD400BF1  ldr         s17,[sp,#8]
  00000000000002D4: BD400FF0  ldr         s16,[sp,#0xC]
  00000000000002D8: 1E302A20  fadd        s0,s17,s16
  00000000000002DC: 910083FF  add         sp,sp,#0x20
  00000000000002E0: D65F03C0  ret
  00000000000002E4: 00000000
sumStack:
  00000000000002E8: D100C3FF  sub         sp,sp,#0x30
  00000000000002EC: F90013E0  str         x0,[sp,#0x20]
  00000000000002F0: F90017E1  str         x1,[sp,#0x28]
  00000000000002F4: F90007E2  str         x2,[sp,#8]
  00000000000002F8: D2800008  mov         x8,#0
  00000000000002FC: F9000BE8  str         x8,[sp,#0x10]
  0000000000000300: 52800008  mov         w8,#0
  0000000000000304: B90003E8  str         w8,[sp]
  0000000000000308: 14000004  b           $LN4
$LN2:
  000000000000030C: B94003E8  ldr         w8,[sp]
  0000000000000310: 11000508  add         w8,w8,#1
  0000000000000314: B90003E8  str         w8,[sp]
$LN4:
  0000000000000318: B94003E8  ldr         w8,[sp]
  000000000000031C: 7100411F  cmp         w8,#0x10
  0000000000000320: 5400020A  bge         $LN3
  0000000000000324: D2800009  mov         x9,#0
  0000000000000328: F94007E8  ldr         x8,[sp,#8]
  000000000000032C: CB080128  sub         x8,x9,x8
  0000000000000330: 92400908  and         x8,x8,#7
  0000000000000334: 91002109  add         x9,x8,#8
  0000000000000338: F94007E8  ldr         x8,[sp,#8]
  000000000000033C: 8B090108  add         x8,x8,x9
  0000000000000340: F90007E8  str         x8,[sp,#8]
  0000000000000344: F94007E8  ldr         x8,[sp,#8]
  0000000000000348: D1002108  sub         x8,x8,#8
  000000000000034C: F9400BE9  ldr         x9,[sp,#0x10]
  0000000000000350: F9400108  ldr         x8,[x8]
  0000000000000354: 8B080128  add         x8,x9,x8
  0000000000000358: F9000BE8  str         x8,[sp,#0x10]
  000000000000035C: 17FFFFEC  b           $LN2
$LN3:
  0000000000000360: F94013E9  ldr         x9,[sp,#0x20]
  0000000000000364: F9400BE8  ldr         x8,[sp,#0x10]
  0000000000000368: F9000128  str         x8,[x9]
  000000000000036C: 2F00E410  movi        d16,#0
  0000000000000370: FD000FF0  str         d16,[sp,#0x18]
  0000000000000374: 52800008  mov         w8,#0
  0000000000000378: B90007E8  str         w8,[sp,#4]
  000000000000037C: 14000004  b           $LN7
$LN5:
  0000000000000380: B94007E8  ldr         w8,[sp,#4]
  0000000000000384: 11000508  add         w8,w8,#1
  0000000000000388: B90007E8  str         w8,[sp,#4]
$LN7:
  000000000000038C: B94007E8  ldr         w8,[sp,#4]
  0000000000000390: 7100411F  cmp         w8,#0x10
  0000000000000394: 5400020A  bge         $LN6
  0000000000000398: D2800009  mov         x9,#0
  000000000000039C: F94007E8  ldr         x8,[sp,#8]
  00000000000003A0: CB080128  sub         x8,x9,x8
  00000000000003A4: 92400908  and         x8,x8,#7
  00000000000003A8: 91002109  add         x9,x8,#8
  00000000000003AC: F94007E8  ldr         x8,[sp,#8]
  00000000000003B0: 8B090108  add         x8,x8,x9
  00000000000003B4: F90007E8  str         x8,[sp,#8]
  00000000000003B8: F94007E8  ldr         x8,[sp,#8]
  00000000000003BC: D1002108  sub         x8,x8,#8
  00000000000003C0: FD400111  ldr         d17,[x8]
  00000000000003C4: FD400FF0  ldr         d16,[sp,#0x18]
  00000000000003C8: 1E712A10  fadd        d16,d16,d17
  00000000000003CC: FD000FF0  str         d16,[sp,#0x18]
  00000000000003D0: 17FFFFEC  b           $LN5
$LN6:
  00000000000003D4: F94017E8  ldr         x8,[sp,#0x28]
  00000000000003D8: FD400FF0  ldr         d16,[sp,#0x18]
  00000000000003DC: FD000110  str         d16,[x8]
  00000000000003E0: 9100C3FF  add         sp,sp,#0x30
  00000000000003E4: D65F03C0  ret
passToUpcall:
  00000000000003E8: A9BD0FE2  stp         x2,x3,[sp,#-0x30]!
  00000000000003EC: A90117E4  stp         x4,x5,[sp,#0x10]
  00000000000003F0: A9021FE6  stp         x6,x7,[sp,#0x20]
  00000000000003F4: A9BD7BFD  stp         fp,lr,[sp,#-0x30]!
  00000000000003F8: 910003FD  mov         fp,sp
  00000000000003FC: F90013E0  str         x0,[sp,#0x20]
  0000000000000400: B90013E1  str         w1,[sp,#0x10]
  0000000000000404: 9100C3E8  add         x8,sp,#0x30
  0000000000000408: F9000FE8  str         x8,[sp,#0x18]
  000000000000040C: F9400FE0  ldr         x0,[sp,#0x18]
  0000000000000410: F94013E8  ldr         x8,[sp,#0x20]
  0000000000000414: D63F0100  blr         x8
  0000000000000418: D2800008  mov         x8,#0
  000000000000041C: F9000FE8  str         x8,[sp,#0x18]
  0000000000000420: A8C37BFD  ldp         fp,lr,[sp],#0x30
  0000000000000424: 9100C3FF  add         sp,sp,#0x30
  0000000000000428: D65F03C0  ret
  000000000000042C: 00000000
upcallInts:
  0000000000000430: A9BE7BFD  stp         fp,lr,[sp,#-0x20]!
  0000000000000434: 910003FD  mov         fp,sp
  0000000000000438: F9000BE0  str         x0,[sp,#0x10]
  000000000000043C: 52800284  mov         w4,#0x14
  0000000000000440: 528001E3  mov         w3,#0xF
  0000000000000444: 52800142  mov         w2,#0xA
  0000000000000448: 52800061  mov         w1,#3
  000000000000044C: F9400BE0  ldr         x0,[sp,#0x10]
  0000000000000450: 94000000  bl          passToUpcall
  0000000000000454: A8C27BFD  ldp         fp,lr,[sp],#0x20
  0000000000000458: D65F03C0  ret
  000000000000045C: 00000000
upcallDoubles:
  0000000000000460: A9BE7BFD  stp         fp,lr,[sp,#-0x20]!
  0000000000000464: 910003FD  mov         fp,sp
  0000000000000468: F9000BE0  str         x0,[sp,#0x10]
  000000000000046C: 58000124  ldr         x4,$LN3
  0000000000000470: 58000143  ldr         x3,$LN4
  0000000000000474: 58000162  ldr         x2,$LN5
  0000000000000478: 52800061  mov         w1,#3
  000000000000047C: F9400BE0  ldr         x0,[sp,#0x10]
  0000000000000480: 94000000  bl          passToUpcall
  0000000000000484: A8C27BFD  ldp         fp,lr,[sp],#0x20
  0000000000000488: D65F03C0  ret
  000000000000048C: D503201F  nop
$LN3:
  0000000000000490: 00000000
  0000000000000494: 40140000
$LN4:
  0000000000000498: 00000000
  000000000000049C: 40100000
$LN5:
  00000000000004A0: 00000000
  00000000000004A4: 40080000
upcallStack:
  00000000000004A8: A9BF7BFD  stp         fp,lr,[sp,#-0x10]!
  00000000000004AC: 910003FD  mov         fp,sp
  00000000000004B0: 94000000  bl          __security_push_cookie
  00000000000004B4: D10603FF  sub         sp,sp,#0x180
  00000000000004B8: F900B7E0  str         x0,[sp,#0x168]
  00000000000004BC: 528000A8  mov         w8,#5
  00000000000004C0: B90163E8  str         w8,[sp,#0x160]
  00000000000004C4: 52800148  mov         w8,#0xA
  00000000000004C8: B90167E8  str         w8,[sp,#0x164]
  00000000000004CC: D28001E8  mov         x8,#0xF
  00000000000004D0: F900BBE8  str         x8,[sp,#0x170]
  00000000000004D4: D2800288  mov         x8,#0x14
  00000000000004D8: F900BFE8  str         x8,[sp,#0x178]
  00000000000004DC: 910523E8  add         x8,sp,#0x148
  00000000000004E0: 3DC05FF0  ldr         q16,[sp,#0x170]
  00000000000004E4: 3D800110  str         q16,[x8]
  00000000000004E8: F940B3E8  ldr         x8,[sp,#0x160]
  00000000000004EC: F900A3E8  str         x8,[sp,#0x140]
  00000000000004F0: 1E659010  fmov        d16,#14
  00000000000004F4: FD009FF0  str         d16,[sp,#0x138]
  00000000000004F8: 1E655010  fmov        d16,#13
  00000000000004FC: FD009BF0  str         d16,[sp,#0x130]
  0000000000000500: D2800188  mov         x8,#0xC
  0000000000000504: F90097E8  str         x8,[sp,#0x128]
  0000000000000508: 52800168  mov         w8,#0xB
  000000000000050C: B90123E8  str         w8,[sp,#0x120]
  0000000000000510: 52800148  mov         w8,#0xA
  0000000000000514: B9011BE8  str         w8,[sp,#0x118]
  0000000000000518: 52800C48  mov         w8,#0x62
  000000000000051C: B90113E8  str         w8,[sp,#0x110]
  0000000000000520: 52800108  mov         w8,#8
  0000000000000524: B9010BE8  str         w8,[sp,#0x108]
  0000000000000528: 1E639010  fmov        d16,#7
  000000000000052C: FD0083F0  str         d16,[sp,#0x100]
  0000000000000530: 1E631010  fmov        d16,#6
  0000000000000534: FD007FF0  str         d16,[sp,#0xF8]
  0000000000000538: D28000A8  mov         x8,#5
  000000000000053C: F9007BE8  str         x8,[sp,#0xF0]
  0000000000000540: 52800088  mov         w8,#4
  0000000000000544: B900EBE8  str         w8,[sp,#0xE8]
  0000000000000548: 52800068  mov         w8,#3
  000000000000054C: B900E3E8  str         w8,[sp,#0xE0]
  0000000000000550: 52800C28  mov         w8,#0x61
  0000000000000554: B900DBE8  str         w8,[sp,#0xD8]
  0000000000000558: 52800028  mov         w8,#1
  000000000000055C: B900D3E8  str         w8,[sp,#0xD0]
  0000000000000560: 1E661010  fmov        d16,#16
  0000000000000564: FD0067F0  str         d16,[sp,#0xC8]
  0000000000000568: 1E65D010  fmov        d16,#15
  000000000000056C: FD0063F0  str         d16,[sp,#0xC0]
  0000000000000570: 1E659010  fmov        d16,#14
  0000000000000574: FD005FF0  str         d16,[sp,#0xB8]
  0000000000000578: 1E655010  fmov        d16,#13
  000000000000057C: FD005BF0  str         d16,[sp,#0xB0]
  0000000000000580: 1E651010  fmov        d16,#12
  0000000000000584: FD0057F0  str         d16,[sp,#0xA8]
  0000000000000588: 1E64D010  fmov        d16,#11
  000000000000058C: FD0053F0  str         d16,[sp,#0xA0]
  0000000000000590: 1E649010  fmov        d16,#10
  0000000000000594: FD004FF0  str         d16,[sp,#0x98]
  0000000000000598: 1E645010  fmov        d16,#9
  000000000000059C: FD004BF0  str         d16,[sp,#0x90]
  00000000000005A0: 1E641010  fmov        d16,#8
  00000000000005A4: FD0047F0  str         d16,[sp,#0x88]
  00000000000005A8: 1E639010  fmov        d16,#7
  00000000000005AC: FD0043F0  str         d16,[sp,#0x80]
  00000000000005B0: 1E631010  fmov        d16,#6
  00000000000005B4: FD003FF0  str         d16,[sp,#0x78]
  00000000000005B8: 1E629010  fmov        d16,#5
  00000000000005BC: FD003BF0  str         d16,[sp,#0x70]
  00000000000005C0: 1E621010  fmov        d16,#4
  00000000000005C4: FD0037F0  str         d16,[sp,#0x68]
  00000000000005C8: 1E611010  fmov        d16,#3
  00000000000005CC: FD0033F0  str         d16,[sp,#0x60]
  00000000000005D0: 1E601010  fmov        d16,#2
  00000000000005D4: FD002FF0  str         d16,[sp,#0x58]
  00000000000005D8: 1E6E1010  fmov        d16,#1
  00000000000005DC: FD002BF0  str         d16,[sp,#0x50]
  00000000000005E0: D2800208  mov         x8,#0x10
  00000000000005E4: F90027E8  str         x8,[sp,#0x48]
  00000000000005E8: D28001E8  mov         x8,#0xF
  00000000000005EC: F90023E8  str         x8,[sp,#0x40]
  00000000000005F0: D28001C8  mov         x8,#0xE
  00000000000005F4: F9001FE8  str         x8,[sp,#0x38]
  00000000000005F8: D28001A8  mov         x8,#0xD
  00000000000005FC: F9001BE8  str         x8,[sp,#0x30]
  0000000000000600: D2800188  mov         x8,#0xC
  0000000000000604: F90017E8  str         x8,[sp,#0x28]
  0000000000000608: D2800168  mov         x8,#0xB
  000000000000060C: F90013E8  str         x8,[sp,#0x20]
  0000000000000610: D2800148  mov         x8,#0xA
  0000000000000614: F9000FE8  str         x8,[sp,#0x18]
  0000000000000618: D2800128  mov         x8,#9
  000000000000061C: F9000BE8  str         x8,[sp,#0x10]
  0000000000000620: D2800108  mov         x8,#8
  0000000000000624: F90007E8  str         x8,[sp,#8]
  0000000000000628: D28000E8  mov         x8,#7
  000000000000062C: F90003E8  str         x8,[sp]
  0000000000000630: D28000C7  mov         x7,#6
  0000000000000634: D28000A6  mov         x6,#5
  0000000000000638: D2800085  mov         x5,#4
  000000000000063C: D2800064  mov         x4,#3
  0000000000000640: D2800043  mov         x3,#2
  0000000000000644: D2800022  mov         x2,#1
  0000000000000648: 528005C1  mov         w1,#0x2E
  000000000000064C: F940B7E0  ldr         x0,[sp,#0x168]
  0000000000000650: 94000000  bl          passToUpcall
  0000000000000654: 910603FF  add         sp,sp,#0x180
  0000000000000658: 94000000  bl          __security_pop_cookie
  000000000000065C: A8C17BFD  ldp         fp,lr,[sp],#0x10
  0000000000000660: D65F03C0  ret
  0000000000000664: 00000000
upcallMemoryAddress:
  0000000000000668: A9BE7BFD  stp         fp,lr,[sp,#-0x20]!
  000000000000066C: 910003FD  mov         fp,sp
  0000000000000670: F9000FE0  str         x0,[sp,#0x18]
  0000000000000674: 52800148  mov         w8,#0xA
  0000000000000678: B90013E8  str         w8,[sp,#0x10]
  000000000000067C: 910043E2  add         x2,sp,#0x10
  0000000000000680: 52800021  mov         w1,#1
  0000000000000684: F9400FE0  ldr         x0,[sp,#0x18]
  0000000000000688: 94000000  bl          passToUpcall
  000000000000068C: A8C27BFD  ldp         fp,lr,[sp],#0x20
  0000000000000690: D65F03C0  ret
  0000000000000694: 00000000
upcallStruct:
  0000000000000698: A9BE7BFD  stp         fp,lr,[sp,#-0x20]!
  000000000000069C: 910003FD  mov         fp,sp
  00000000000006A0: F9000FE0  str         x0,[sp,#0x18]
  00000000000006A4: 528000A8  mov         w8,#5
  00000000000006A8: B90013E8  str         w8,[sp,#0x10]
  00000000000006AC: 52800148  mov         w8,#0xA
  00000000000006B0: B90017E8  str         w8,[sp,#0x14]
  00000000000006B4: F9400BE2  ldr         x2,[sp,#0x10]
  00000000000006B8: 52800021  mov         w1,#1
  00000000000006BC: F9400FE0  ldr         x0,[sp,#0x18]
  00000000000006C0: 94000000  bl          passToUpcall
  00000000000006C4: A8C27BFD  ldp         fp,lr,[sp],#0x20
  00000000000006C8: D65F03C0  ret
  00000000000006CC: 00000000
upcallFloatStruct:
  00000000000006D0: A9BE7BFD  stp         fp,lr,[sp,#-0x20]!
  00000000000006D4: 910003FD  mov         fp,sp
  00000000000006D8: F9000FE0  str         x0,[sp,#0x18]
  00000000000006DC: 1E2E1010  fmov        s16,#1
  00000000000006E0: BD0013F0  str         s16,[sp,#0x10]
  00000000000006E4: 1E201010  fmov        s16,#2
  00000000000006E8: BD0017F0  str         s16,[sp,#0x14]
  00000000000006EC: F9400BE2  ldr         x2,[sp,#0x10]
  00000000000006F0: 52800021  mov         w1,#1
  00000000000006F4: F9400FE0  ldr         x0,[sp,#0x18]
  00000000000006F8: 94000000  bl          passToUpcall
  00000000000006FC: A8C27BFD  ldp         fp,lr,[sp],#0x20
  0000000000000700: D65F03C0  ret
  0000000000000704: 00000000
upcallBigStruct:
  0000000000000708: A9BF7BFD  stp         fp,lr,[sp,#-0x10]!
  000000000000070C: 910003FD  mov         fp,sp
  0000000000000710: 94000000  bl          __security_push_cookie
  0000000000000714: D10043FF  sub         sp,sp,#0x10
  0000000000000718: F90003E0  str         x0,[sp]
  000000000000071C: D2800108  mov         x8,#8
  0000000000000720: F90007E8  str         x8,[sp,#8]
  0000000000000724: D2800208  mov         x8,#0x10
  0000000000000728: F9000BE8  str         x8,[sp,#0x10]
  000000000000072C: F9400BE3  ldr         x3,[sp,#0x10]
  0000000000000730: F94007E2  ldr         x2,[sp,#8]
  0000000000000734: 52800021  mov         w1,#1
  0000000000000738: F94003E0  ldr         x0,[sp]
  000000000000073C: 94000000  bl          passToUpcall
  0000000000000740: 910043FF  add         sp,sp,#0x10
  0000000000000744: 94000000  bl          __security_pop_cookie
  0000000000000748: A8C17BFD  ldp         fp,lr,[sp],#0x10
  000000000000074C: D65F03C0  ret
upcallBigStructPlusScalar:
  0000000000000750: A9BF7BFD  stp         fp,lr,[sp,#-0x10]!
  0000000000000754: 910003FD  mov         fp,sp
  0000000000000758: 94000000  bl          __security_push_cookie
  000000000000075C: D10043FF  sub         sp,sp,#0x10
  0000000000000760: F90003E0  str         x0,[sp]
  0000000000000764: D2800108  mov         x8,#8
  0000000000000768: F90007E8  str         x8,[sp,#8]
  000000000000076C: D2800208  mov         x8,#0x10
  0000000000000770: F9000BE8  str         x8,[sp,#0x10]
  0000000000000774: 52800544  mov         w4,#0x2A
  0000000000000778: F9400BE3  ldr         x3,[sp,#0x10]
  000000000000077C: F94007E2  ldr         x2,[sp,#8]
  0000000000000780: 52800041  mov         w1,#2
  0000000000000784: F94003E0  ldr         x0,[sp]
  0000000000000788: 94000000  bl          passToUpcall
  000000000000078C: 910043FF  add         sp,sp,#0x10
  0000000000000790: 94000000  bl          __security_pop_cookie
  0000000000000794: A8C17BFD  ldp         fp,lr,[sp],#0x10
  0000000000000798: D65F03C0  ret
  000000000000079C: 00000000
upcallHugeStruct:
  00000000000007A0: A9BF7BFD  stp         fp,lr,[sp,#-0x10]!
  00000000000007A4: 910003FD  mov         fp,sp
  00000000000007A8: 94000000  bl          __security_push_cookie
  00000000000007AC: D10143FF  sub         sp,sp,#0x50
  00000000000007B0: F90003E0  str         x0,[sp]
  00000000000007B4: D2800028  mov         x8,#1
  00000000000007B8: F9001BE8  str         x8,[sp,#0x30]
  00000000000007BC: D2800048  mov         x8,#2
  00000000000007C0: F9001FE8  str         x8,[sp,#0x38]
  00000000000007C4: D2800068  mov         x8,#3
  00000000000007C8: F90023E8  str         x8,[sp,#0x40]
  00000000000007CC: 3DC00FF0  ldr         q16,[sp,#0x30]
  00000000000007D0: 3D8007F0  str         q16,[sp,#0x10]
  00000000000007D4: F94023E8  ldr         x8,[sp,#0x40]
  00000000000007D8: F90013E8  str         x8,[sp,#0x20]
  00000000000007DC: 910043E2  add         x2,sp,#0x10
  00000000000007E0: 52800021  mov         w1,#1
  00000000000007E4: F94003E0  ldr         x0,[sp]
  00000000000007E8: 94000000  bl          passToUpcall
  00000000000007EC: 910143FF  add         sp,sp,#0x50
  00000000000007F0: 94000000  bl          __security_pop_cookie
  00000000000007F4: A8C17BFD  ldp         fp,lr,[sp],#0x10
  00000000000007F8: D65F03C0  ret

  Summary

          38 .chks64
        1420 .debug$S
         59C .debug$T
         1A1 .drectve
          90 .pdata
         7FC .text$mn
          70 .xdata