
Dump of file hfa.obj

File Type: COFF OBJECT

func_S_F:
  0000000000000000: D10043FF  sub         sp,sp,#0x10
  0000000000000004: B90007E0  str         w0,[sp,#4]
  0000000000000008: BD0003E0  str         s0,[sp]
  000000000000000C: BD4003E0  ldr         s0,[sp]
  0000000000000010: 910043FF  add         sp,sp,#0x10
  0000000000000014: D65F03C0  ret
variadic_func_S_F:
  0000000000000018: D10103FF  sub         sp,sp,#0x40
  000000000000001C: A9008BE1  stp         x1,x2,[sp,#8]
  0000000000000020: A90193E3  stp         x3,x4,[sp,#0x18]
  0000000000000024: A9029BE5  stp         x5,x6,[sp,#0x28]
  0000000000000028: F9001FE7  str         x7,[sp,#0x38]
  000000000000002C: D10083FF  sub         sp,sp,#0x20
  0000000000000030: B9000BE0  str         w0,[sp,#8]
  0000000000000034: 9100A3E8  add         x8,sp,#0x28
  0000000000000038: F9000BE8  str         x8,[sp,#0x10]
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
  0000000000000064: B9400108  ldr         w8,[x8]
  0000000000000068: B90003E8  str         w8,[sp]
  000000000000006C: BD4003F0  ldr         s16,[sp]
  0000000000000070: BD0007F0  str         s16,[sp,#4]
  0000000000000074: D2800008  mov         x8,#0
  0000000000000078: F9000BE8  str         x8,[sp,#0x10]
  000000000000007C: BD4007E0  ldr         s0,[sp,#4]
  0000000000000080: 910083FF  add         sp,sp,#0x20
  0000000000000084: 910103FF  add         sp,sp,#0x40
  0000000000000088: D65F03C0  ret
  000000000000008C: 00000000
call_S_F:
  0000000000000090: A9BE7BFD  stp         fp,lr,[sp,#-0x20]!
  0000000000000094: 910003FD  mov         fp,sp
  0000000000000098: 1C000110  ldr         s16,$LN3
  000000000000009C: BD0013F0  str         s16,[sp,#0x10]
  00000000000000A0: BD4013E0  ldr         s0,[sp,#0x10]
  00000000000000A4: 180000C0  ldr         w0,$LN4
  00000000000000A8: 94000000  bl          func_S_F
  00000000000000AC: A8C27BFD  ldp         fp,lr,[sp],#0x20
  00000000000000B0: D65F03C0  ret
  00000000000000B4: D503201F  nop
$LN3:
  00000000000000B8: 449A522C
$LN4:
  00000000000000BC: CAFE0123  eon         x3,x9,lr,ror #0
call_variadic_S_F:
  00000000000000C0: A9BE7BFD  stp         fp,lr,[sp,#-0x20]!
  00000000000000C4: 910003FD  mov         fp,sp
  00000000000000C8: 1C000110  ldr         s16,$LN3
  00000000000000CC: BD0013F0  str         s16,[sp,#0x10]
  00000000000000D0: B94013E1  ldr         w1,[sp,#0x10]
  00000000000000D4: 180000C0  ldr         w0,$LN4
  00000000000000D8: 94000000  bl          variadic_func_S_F
  00000000000000DC: A8C27BFD  ldp         fp,lr,[sp],#0x20
  00000000000000E0: D65F03C0  ret
  00000000000000E4: D503201F  nop
$LN3:
  00000000000000E8: 449A522C
$LN4:
  00000000000000EC: CAFE0123  eon         x3,x9,lr,ror #0
func_S_FF:
  00000000000000F0: D10043FF  sub         sp,sp,#0x10
  00000000000000F4: B90003E0  str         w0,[sp]
  00000000000000F8: BD000BE0  str         s0,[sp,#8]
  00000000000000FC: BD000FE1  str         s1,[sp,#0xC]
  0000000000000100: BD400BF1  ldr         s17,[sp,#8]
  0000000000000104: BD400FF0  ldr         s16,[sp,#0xC]
  0000000000000108: 1E302A20  fadd        s0,s17,s16
  000000000000010C: 910043FF  add         sp,sp,#0x10
  0000000000000110: D65F03C0  ret
  0000000000000114: 00000000
variadic_func_S_FF:
  0000000000000118: D10103FF  sub         sp,sp,#0x40
  000000000000011C: A9008BE1  stp         x1,x2,[sp,#8]
  0000000000000120: A90193E3  stp         x3,x4,[sp,#0x18]
  0000000000000124: A9029BE5  stp         x5,x6,[sp,#0x28]
  0000000000000128: F9001FE7  str         x7,[sp,#0x38]
  000000000000012C: D10083FF  sub         sp,sp,#0x20
  0000000000000130: B90003E0  str         w0,[sp]
  0000000000000134: 9100A3E8  add         x8,sp,#0x28
  0000000000000138: F90007E8  str         x8,[sp,#8]
  000000000000013C: D2800009  mov         x9,#0
  0000000000000140: F94007E8  ldr         x8,[sp,#8]
  0000000000000144: CB080128  sub         x8,x9,x8
  0000000000000148: 92400508  and         x8,x8,#3
  000000000000014C: 91002109  add         x9,x8,#8
  0000000000000150: F94007E8  ldr         x8,[sp,#8]
  0000000000000154: 8B090108  add         x8,x8,x9
  0000000000000158: F90007E8  str         x8,[sp,#8]
  000000000000015C: F94007E8  ldr         x8,[sp,#8]
  0000000000000160: D1002108  sub         x8,x8,#8
  0000000000000164: F9400108  ldr         x8,[x8]
  0000000000000168: F9000FE8  str         x8,[sp,#0x18]
  000000000000016C: BD401FF0  ldr         s16,[sp,#0x1C]
  0000000000000170: BD0017F0  str         s16,[sp,#0x14]
  0000000000000174: BD401BF0  ldr         s16,[sp,#0x18]
  0000000000000178: BD0013F0  str         s16,[sp,#0x10]
  000000000000017C: D2800008  mov         x8,#0
  0000000000000180: F90007E8  str         x8,[sp,#8]
  0000000000000184: BD4013F1  ldr         s17,[sp,#0x10]
  0000000000000188: BD4017F0  ldr         s16,[sp,#0x14]
  000000000000018C: 1E302A20  fadd        s0,s17,s16
  0000000000000190: 910083FF  add         sp,sp,#0x20
  0000000000000194: 910103FF  add         sp,sp,#0x40
  0000000000000198: D65F03C0  ret
  000000000000019C: 00000000
call_S_FF:
  00000000000001A0: A9BE7BFD  stp         fp,lr,[sp,#-0x20]!
  00000000000001A4: 910003FD  mov         fp,sp
  00000000000001A8: 1C000150  ldr         s16,$LN3
  00000000000001AC: BD0013F0  str         s16,[sp,#0x10]
  00000000000001B0: 1C000130  ldr         s16,$LN4
  00000000000001B4: BD0017F0  str         s16,[sp,#0x14]
  00000000000001B8: BD4017E1  ldr         s1,[sp,#0x14]
  00000000000001BC: BD4013E0  ldr         s0,[sp,#0x10]
  00000000000001C0: 180000C0  ldr         w0,$LN5
  00000000000001C4: 94000000  bl          func_S_FF
  00000000000001C8: A8C27BFD  ldp         fp,lr,[sp],#0x20
  00000000000001CC: D65F03C0  ret
$LN3:
  00000000000001D0: 449A522C
$LN4:
  00000000000001D4: 43700000
$LN5:
  00000000000001D8: CAFE1234  eon         x20,xip1,lr,ror #4
  00000000000001DC: 00000000
call_variadic_S_FF:
  00000000000001E0: A9BE7BFD  stp         fp,lr,[sp,#-0x20]!
  00000000000001E4: 910003FD  mov         fp,sp
  00000000000001E8: 1C000150  ldr         s16,$LN3
  00000000000001EC: BD0013F0  str         s16,[sp,#0x10]
  00000000000001F0: 1C000130  ldr         s16,$LN4
  00000000000001F4: BD0017F0  str         s16,[sp,#0x14]
  00000000000001F8: F9400BE1  ldr         x1,[sp,#0x10]
  00000000000001FC: 180000E0  ldr         w0,$LN5
  0000000000000200: 94000000  bl          variadic_func_S_FF
  0000000000000204: A8C27BFD  ldp         fp,lr,[sp],#0x20
  0000000000000208: D65F03C0  ret
  000000000000020C: D503201F  nop
$LN3:
  0000000000000210: 449A522C
$LN4:
  0000000000000214: 43700000
$LN5:
  0000000000000218: CAFE1234  eon         x20,xip1,lr,ror #4
  000000000000021C: 00000000
func_S_FFF:
  0000000000000220: D10083FF  sub         sp,sp,#0x20
  0000000000000224: B90003E0  str         w0,[sp]
  0000000000000228: BD000BE0  str         s0,[sp,#8]
  000000000000022C: BD000FE1  str         s1,[sp,#0xC]
  0000000000000230: BD0013E2  str         s2,[sp,#0x10]
  0000000000000234: BD400BF1  ldr         s17,[sp,#8]
  0000000000000238: BD400FF0  ldr         s16,[sp,#0xC]
  000000000000023C: 1E302A31  fadd        s17,s17,s16
  0000000000000240: BD4013F0  ldr         s16,[sp,#0x10]
  0000000000000244: 1E302A20  fadd        s0,s17,s16
  0000000000000248: 910083FF  add         sp,sp,#0x20
  000000000000024C: D65F03C0  ret
variadic_func_S_FFF:
  0000000000000250: D10103FF  sub         sp,sp,#0x40
  0000000000000254: A9008BE1  stp         x1,x2,[sp,#8]
  0000000000000258: A90193E3  stp         x3,x4,[sp,#0x18]
  000000000000025C: A9029BE5  stp         x5,x6,[sp,#0x28]
  0000000000000260: F9001FE7  str         x7,[sp,#0x38]
  0000000000000264: D100C3FF  sub         sp,sp,#0x30
  0000000000000268: B90003E0  str         w0,[sp]
  000000000000026C: 9100E3E8  add         x8,sp,#0x38
  0000000000000270: F90007E8  str         x8,[sp,#8]
  0000000000000274: D2800009  mov         x9,#0
  0000000000000278: F94007E8  ldr         x8,[sp,#8]
  000000000000027C: CB080128  sub         x8,x9,x8
  0000000000000280: 92400508  and         x8,x8,#3
  0000000000000284: 91004109  add         x9,x8,#0x10
  0000000000000288: F94007E8  ldr         x8,[sp,#8]
  000000000000028C: 8B090108  add         x8,x8,x9
  0000000000000290: F90007E8  str         x8,[sp,#8]
  0000000000000294: F94007E8  ldr         x8,[sp,#8]
  0000000000000298: D1004109  sub         x9,x8,#0x10
  000000000000029C: F9400128  ldr         x8,[x9]
  00000000000002A0: F90013E8  str         x8,[sp,#0x20]
  00000000000002A4: B9400928  ldr         w8,[x9,#8]
  00000000000002A8: B9002BE8  str         w8,[sp,#0x28]
  00000000000002AC: BD402BF0  ldr         s16,[sp,#0x28]
  00000000000002B0: BD001BF0  str         s16,[sp,#0x18]
  00000000000002B4: BD4027F0  ldr         s16,[sp,#0x24]
  00000000000002B8: BD0017F0  str         s16,[sp,#0x14]
  00000000000002BC: BD4023F0  ldr         s16,[sp,#0x20]
  00000000000002C0: BD0013F0  str         s16,[sp,#0x10]
  00000000000002C4: D2800008  mov         x8,#0
  00000000000002C8: F90007E8  str         x8,[sp,#8]
  00000000000002CC: BD4013F1  ldr         s17,[sp,#0x10]
  00000000000002D0: BD4017F0  ldr         s16,[sp,#0x14]
  00000000000002D4: 1E302A31  fadd        s17,s17,s16
  00000000000002D8: BD401BF0  ldr         s16,[sp,#0x18]
  00000000000002DC: 1E302A20  fadd        s0,s17,s16
  00000000000002E0: 9100C3FF  add         sp,sp,#0x30
  00000000000002E4: 910103FF  add         sp,sp,#0x40
  00000000000002E8: D65F03C0  ret
  00000000000002EC: 00000000
call_S_FFF:
  00000000000002F0: A9BE7BFD  stp         fp,lr,[sp,#-0x20]!
  00000000000002F4: 910003FD  mov         fp,sp
  00000000000002F8: 1C0001D0  ldr         s16,$LN3
  00000000000002FC: BD0013F0  str         s16,[sp,#0x10]
  0000000000000300: 1C0001B0  ldr         s16,$LN4
  0000000000000304: BD0017F0  str         s16,[sp,#0x14]
  0000000000000308: 1C000190  ldr         s16,$LN5
  000000000000030C: BD001BF0  str         s16,[sp,#0x18]
  0000000000000310: BD401BE2  ldr         s2,[sp,#0x18]
  0000000000000314: BD4017E1  ldr         s1,[sp,#0x14]
  0000000000000318: BD4013E0  ldr         s0,[sp,#0x10]
  000000000000031C: 18000100  ldr         w0,$LN6
  0000000000000320: 94000000  bl          func_S_FFF
  0000000000000324: A8C27BFD  ldp         fp,lr,[sp],#0x20
  0000000000000328: D65F03C0  ret
  000000000000032C: D503201F  nop
$LN3:
  0000000000000330: 449A522C
$LN4:
  0000000000000334: 45160000
$LN5:
  0000000000000338: 44960000
$LN6:
  000000000000033C: CAFE2345  eon         x5,x26,lr,ror #8
call_variadic_S_FFF:
  0000000000000340: A9BE7BFD  stp         fp,lr,[sp,#-0x20]!
  0000000000000344: 910003FD  mov         fp,sp
  0000000000000348: 1C000190  ldr         s16,$LN3
  000000000000034C: BD0013F0  str         s16,[sp,#0x10]
  0000000000000350: 1C000170  ldr         s16,$LN4
  0000000000000354: BD0017F0  str         s16,[sp,#0x14]
  0000000000000358: 1C000150  ldr         s16,$LN5
  000000000000035C: BD001BF0  str         s16,[sp,#0x18]
  0000000000000360: B9401BE2  ldr         w2,[sp,#0x18]
  0000000000000364: F9400BE1  ldr         x1,[sp,#0x10]
  0000000000000368: 180000E0  ldr         w0,$LN6
  000000000000036C: 94000000  bl          variadic_func_S_FFF
  0000000000000370: A8C27BFD  ldp         fp,lr,[sp],#0x20
  0000000000000374: D65F03C0  ret
$LN3:
  0000000000000378: 449A522C
$LN4:
  000000000000037C: 45160000
$LN5:
  0000000000000380: 44960000
$LN6:
  0000000000000384: CAFE2345  eon         x5,x26,lr,ror #8
func_S_FFFF:
  0000000000000388: D10083FF  sub         sp,sp,#0x20
  000000000000038C: B90003E0  str         w0,[sp]
  0000000000000390: BD000BE0  str         s0,[sp,#8]
  0000000000000394: BD000FE1  str         s1,[sp,#0xC]
  0000000000000398: BD0013E2  str         s2,[sp,#0x10]
  000000000000039C: BD0017E3  str         s3,[sp,#0x14]
  00000000000003A0: BD400BF1  ldr         s17,[sp,#8]
  00000000000003A4: BD400FF0  ldr         s16,[sp,#0xC]
  00000000000003A8: 1E302A31  fadd        s17,s17,s16
  00000000000003AC: BD4013F0  ldr         s16,[sp,#0x10]
  00000000000003B0: 1E302A31  fadd        s17,s17,s16
  00000000000003B4: BD4017F0  ldr         s16,[sp,#0x14]
  00000000000003B8: 1E302A20  fadd        s0,s17,s16
  00000000000003BC: 910083FF  add         sp,sp,#0x20
  00000000000003C0: D65F03C0  ret
  00000000000003C4: 00000000
variadic_func_S_FFFF:
  00000000000003C8: D10103FF  sub         sp,sp,#0x40
  00000000000003CC: A9008BE1  stp         x1,x2,[sp,#8]
  00000000000003D0: A90193E3  stp         x3,x4,[sp,#0x18]
  00000000000003D4: A9029BE5  stp         x5,x6,[sp,#0x28]
  00000000000003D8: F9001FE7  str         x7,[sp,#0x38]
  00000000000003DC: D100C3FF  sub         sp,sp,#0x30
  00000000000003E0: B90003E0  str         w0,[sp]
  00000000000003E4: 9100E3E8  add         x8,sp,#0x38
  00000000000003E8: F90007E8  str         x8,[sp,#8]
  00000000000003EC: D2800009  mov         x9,#0
  00000000000003F0: F94007E8  ldr         x8,[sp,#8]
  00000000000003F4: CB080128  sub         x8,x9,x8
  00000000000003F8: 92400508  and         x8,x8,#3
  00000000000003FC: 91004109  add         x9,x8,#0x10
  0000000000000400: F94007E8  ldr         x8,[sp,#8]
  0000000000000404: 8B090108  add         x8,x8,x9
  0000000000000408: F90007E8  str         x8,[sp,#8]
  000000000000040C: F94007E8  ldr         x8,[sp,#8]
  0000000000000410: D1004108  sub         x8,x8,#0x10
  0000000000000414: 3DC00110  ldr         q16,[x8]
  0000000000000418: 3D800BF0  str         q16,[sp,#0x20]
  000000000000041C: BD402FF0  ldr         s16,[sp,#0x2C]
  0000000000000420: BD001FF0  str         s16,[sp,#0x1C]
  0000000000000424: BD402BF0  ldr         s16,[sp,#0x28]
  0000000000000428: BD001BF0  str         s16,[sp,#0x18]
  000000000000042C: BD4027F0  ldr         s16,[sp,#0x24]
  0000000000000430: BD0017F0  str         s16,[sp,#0x14]
  0000000000000434: BD4023F0  ldr         s16,[sp,#0x20]
  0000000000000438: BD0013F0  str         s16,[sp,#0x10]
  000000000000043C: D2800008  mov         x8,#0
  0000000000000440: F90007E8  str         x8,[sp,#8]
  0000000000000444: BD4013F1  ldr         s17,[sp,#0x10]
  0000000000000448: BD4017F0  ldr         s16,[sp,#0x14]
  000000000000044C: 1E302A31  fadd        s17,s17,s16
  0000000000000450: BD401BF0  ldr         s16,[sp,#0x18]
  0000000000000454: 1E302A31  fadd        s17,s17,s16
  0000000000000458: BD401FF0  ldr         s16,[sp,#0x1C]
  000000000000045C: 1E302A20  fadd        s0,s17,s16
  0000000000000460: 9100C3FF  add         sp,sp,#0x30
  0000000000000464: 910103FF  add         sp,sp,#0x40
  0000000000000468: D65F03C0  ret
  000000000000046C: 00000000
call_S_FFFF:
  0000000000000470: A9BE7BFD  stp         fp,lr,[sp,#-0x20]!
  0000000000000474: 910003FD  mov         fp,sp
  0000000000000478: 1C000210  ldr         s16,$LN3
  000000000000047C: BD0013F0  str         s16,[sp,#0x10]
  0000000000000480: 1C0001F0  ldr         s16,$LN4
  0000000000000484: BD0017F0  str         s16,[sp,#0x14]
  0000000000000488: 1C0001D0  ldr         s16,$LN5
  000000000000048C: BD001BF0  str         s16,[sp,#0x18]
  0000000000000490: 1C0001B0  ldr         s16,$LN6
  0000000000000494: BD001FF0  str         s16,[sp,#0x1C]
  0000000000000498: BD401FE3  ldr         s3,[sp,#0x1C]
  000000000000049C: BD401BE2  ldr         s2,[sp,#0x18]
  00000000000004A0: BD4017E1  ldr         s1,[sp,#0x14]
  00000000000004A4: BD4013E0  ldr         s0,[sp,#0x10]
  00000000000004A8: 18000100  ldr         w0,$LN7
  00000000000004AC: 94000000  bl          func_S_FFFF
  00000000000004B0: A8C27BFD  ldp         fp,lr,[sp],#0x20
  00000000000004B4: D65F03C0  ret
$LN3:
  00000000000004B8: 449A522C
$LN4:
  00000000000004BC: 46BB8000
$LN5:
  00000000000004C0: 463B8000
$LN6:
  00000000000004C4: 40490FDB
$LN7:
  00000000000004C8: CAFE4567  eon         x7,x11,lr,ror #0x11
  00000000000004CC: 00000000
call_variadic_S_FFFF:
  00000000000004D0: A9BE7BFD  stp         fp,lr,[sp,#-0x20]!
  00000000000004D4: 910003FD  mov         fp,sp
  00000000000004D8: 1C0001D0  ldr         s16,$LN3
  00000000000004DC: BD0013F0  str         s16,[sp,#0x10]
  00000000000004E0: 1C0001B0  ldr         s16,$LN4
  00000000000004E4: BD0017F0  str         s16,[sp,#0x14]
  00000000000004E8: 1C000190  ldr         s16,$LN5
  00000000000004EC: BD001BF0  str         s16,[sp,#0x18]
  00000000000004F0: 1C000170  ldr         s16,$LN6
  00000000000004F4: BD001FF0  str         s16,[sp,#0x1C]
  00000000000004F8: F9400FE2  ldr         x2,[sp,#0x18]
  00000000000004FC: F9400BE1  ldr         x1,[sp,#0x10]
  0000000000000500: 18000100  ldr         w0,$LN7
  0000000000000504: 94000000  bl          variadic_func_S_FFFF
  0000000000000508: A8C27BFD  ldp         fp,lr,[sp],#0x20
  000000000000050C: D65F03C0  ret
$LN3:
  0000000000000510: 449A522C
$LN4:
  0000000000000514: 46BB8000
$LN5:
  0000000000000518: 463B8000
$LN6:
  000000000000051C: 40490FDB
$LN7:
  0000000000000520: CAFE4567  eon         x7,x11,lr,ror #0x11
  0000000000000524: 00000000
func_S_D:
  0000000000000528: D10043FF  sub         sp,sp,#0x10
  000000000000052C: B90003E0  str         w0,[sp]
  0000000000000530: FD0007E0  str         d0,[sp,#8]
  0000000000000534: FD4007E0  ldr         d0,[sp,#8]
  0000000000000538: 910043FF  add         sp,sp,#0x10
  000000000000053C: D65F03C0  ret
variadic_func_S_D:
  0000000000000540: D10103FF  sub         sp,sp,#0x40
  0000000000000544: A9008BE1  stp         x1,x2,[sp,#8]
  0000000000000548: A90193E3  stp         x3,x4,[sp,#0x18]
  000000000000054C: A9029BE5  stp         x5,x6,[sp,#0x28]
  0000000000000550: F9001FE7  str         x7,[sp,#0x38]
  0000000000000554: D10083FF  sub         sp,sp,#0x20
  0000000000000558: B90003E0  str         w0,[sp]
  000000000000055C: 9100A3E8  add         x8,sp,#0x28
  0000000000000560: F90007E8  str         x8,[sp,#8]
  0000000000000564: D2800009  mov         x9,#0
  0000000000000568: F94007E8  ldr         x8,[sp,#8]
  000000000000056C: CB080128  sub         x8,x9,x8
  0000000000000570: 92400908  and         x8,x8,#7
  0000000000000574: 91002109  add         x9,x8,#8
  0000000000000578: F94007E8  ldr         x8,[sp,#8]
  000000000000057C: 8B090108  add         x8,x8,x9
  0000000000000580: F90007E8  str         x8,[sp,#8]
  0000000000000584: F94007E8  ldr         x8,[sp,#8]
  0000000000000588: D1002108  sub         x8,x8,#8
  000000000000058C: F9400108  ldr         x8,[x8]
  0000000000000590: F9000BE8  str         x8,[sp,#0x10]
  0000000000000594: FD400BF0  ldr         d16,[sp,#0x10]
  0000000000000598: FD000FF0  str         d16,[sp,#0x18]
  000000000000059C: D2800008  mov         x8,#0
  00000000000005A0: F90007E8  str         x8,[sp,#8]
  00000000000005A4: FD400FE0  ldr         d0,[sp,#0x18]
  00000000000005A8: 910083FF  add         sp,sp,#0x20
  00000000000005AC: 910103FF  add         sp,sp,#0x40
  00000000000005B0: D65F03C0  ret
  00000000000005B4: 00000000
call_S_D:
  00000000000005B8: A9BE7BFD  stp         fp,lr,[sp,#-0x20]!
  00000000000005BC: 910003FD  mov         fp,sp
  00000000000005C0: 5C000110  ldr         d16,$LN3
  00000000000005C4: FD000BF0  str         d16,[sp,#0x10]
  00000000000005C8: FD400BE0  ldr         d0,[sp,#0x10]
  00000000000005CC: 180000E0  ldr         w0,$LN4
  00000000000005D0: 94000000  bl          func_S_D
  00000000000005D4: A8C27BFD  ldp         fp,lr,[sp],#0x20
  00000000000005D8: D65F03C0  ret
  00000000000005DC: D503201F  nop
$LN3:
  00000000000005E0: 84FD0FC2  ld1sh       {z2.s},p3/z,[lr,z29.s sxtw #1]
  00000000000005E4: 40934A45
$LN4:
  00000000000005E8: CAFE5678  eon         x24,x19,lr,ror #0x15
  00000000000005EC: 00000000
call_variadic_S_D:
  00000000000005F0: A9BE7BFD  stp         fp,lr,[sp,#-0x20]!
  00000000000005F4: 910003FD  mov         fp,sp
  00000000000005F8: 5C000110  ldr         d16,$LN3
  00000000000005FC: FD000BF0  str         d16,[sp,#0x10]
  0000000000000600: F9400BE1  ldr         x1,[sp,#0x10]
  0000000000000604: 180000E0  ldr         w0,$LN4
  0000000000000608: 94000000  bl          variadic_func_S_D
  000000000000060C: A8C27BFD  ldp         fp,lr,[sp],#0x20
  0000000000000610: D65F03C0  ret
  0000000000000614: D503201F  nop
$LN3:
  0000000000000618: 84FD0FC2  ld1sh       {z2.s},p3/z,[lr,z29.s sxtw #1]
  000000000000061C: 40934A45
$LN4:
  0000000000000620: CAFE5678  eon         x24,x19,lr,ror #0x15
  0000000000000624: 00000000
func_S_DD:
  0000000000000628: D10083FF  sub         sp,sp,#0x20
  000000000000062C: B90003E0  str         w0,[sp]
  0000000000000630: FD0007E0  str         d0,[sp,#8]
  0000000000000634: FD000BE1  str         d1,[sp,#0x10]
  0000000000000638: FD4007F1  ldr         d17,[sp,#8]
  000000000000063C: FD400BF0  ldr         d16,[sp,#0x10]
  0000000000000640: 1E702A20  fadd        d0,d17,d16
  0000000000000644: 910083FF  add         sp,sp,#0x20
  0000000000000648: D65F03C0  ret
  000000000000064C: 00000000
variadic_func_S_DD:
  0000000000000650: D10103FF  sub         sp,sp,#0x40
  0000000000000654: A9008BE1  stp         x1,x2,[sp,#8]
  0000000000000658: A90193E3  stp         x3,x4,[sp,#0x18]
  000000000000065C: A9029BE5  stp         x5,x6,[sp,#0x28]
  0000000000000660: F9001FE7  str         x7,[sp,#0x38]
  0000000000000664: D100C3FF  sub         sp,sp,#0x30
  0000000000000668: B90003E0  str         w0,[sp]
  000000000000066C: 9100E3E8  add         x8,sp,#0x38
  0000000000000670: F90007E8  str         x8,[sp,#8]
  0000000000000674: D2800009  mov         x9,#0
  0000000000000678: F94007E8  ldr         x8,[sp,#8]
  000000000000067C: CB080128  sub         x8,x9,x8
  0000000000000680: 92400908  and         x8,x8,#7
  0000000000000684: 91004109  add         x9,x8,#0x10
  0000000000000688: F94007E8  ldr         x8,[sp,#8]
  000000000000068C: 8B090108  add         x8,x8,x9
  0000000000000690: F90007E8  str         x8,[sp,#8]
  0000000000000694: F94007E8  ldr         x8,[sp,#8]
  0000000000000698: D1004108  sub         x8,x8,#0x10
  000000000000069C: 3DC00110  ldr         q16,[x8]
  00000000000006A0: 3D800BF0  str         q16,[sp,#0x20]
  00000000000006A4: FD4017F0  ldr         d16,[sp,#0x28]
  00000000000006A8: FD000FF0  str         d16,[sp,#0x18]
  00000000000006AC: FD4013F0  ldr         d16,[sp,#0x20]
  00000000000006B0: FD000BF0  str         d16,[sp,#0x10]
  00000000000006B4: D2800008  mov         x8,#0
  00000000000006B8: F90007E8  str         x8,[sp,#8]
  00000000000006BC: FD400BF1  ldr         d17,[sp,#0x10]
  00000000000006C0: FD400FF0  ldr         d16,[sp,#0x18]
  00000000000006C4: 1E702A20  fadd        d0,d17,d16
  00000000000006C8: 9100C3FF  add         sp,sp,#0x30
  00000000000006CC: 910103FF  add         sp,sp,#0x40
  00000000000006D0: D65F03C0  ret
  00000000000006D4: 00000000
call_S_DD:
  00000000000006D8: A9BE7BFD  stp         fp,lr,[sp,#-0x20]!
  00000000000006DC: 910003FD  mov         fp,sp
  00000000000006E0: 5C000150  ldr         d16,$LN3
  00000000000006E4: FD000BF0  str         d16,[sp,#0x10]
  00000000000006E8: 5C000150  ldr         d16,$LN4
  00000000000006EC: FD000FF0  str         d16,[sp,#0x18]
  00000000000006F0: FD400FE1  ldr         d1,[sp,#0x18]
  00000000000006F4: FD400BE0  ldr         d0,[sp,#0x10]
  00000000000006F8: 18000100  ldr         w0,$LN5
  00000000000006FC: 94000000  bl          func_S_DD
  0000000000000700: A8C27BFD  ldp         fp,lr,[sp],#0x20
  0000000000000704: D65F03C0  ret
$LN3:
  0000000000000708: 84FD0FC2  ld1sh       {z2.s},p3/z,[lr,z29.s sxtw #1]
  000000000000070C: 40934A45
$LN4:
  0000000000000710: 00000000
  0000000000000714: 406E0000
$LN5:
  0000000000000718: CAFE6789  eon         x9,x28,lr,ror #0x19
  000000000000071C: 00000000
call_variadic_S_DD:
  0000000000000720: A9BE7BFD  stp         fp,lr,[sp,#-0x20]!
  0000000000000724: 910003FD  mov         fp,sp
  0000000000000728: 5C000150  ldr         d16,$LN3
  000000000000072C: FD000BF0  str         d16,[sp,#0x10]
  0000000000000730: 5C000150  ldr         d16,$LN4
  0000000000000734: FD000FF0  str         d16,[sp,#0x18]
  0000000000000738: F9400FE2  ldr         x2,[sp,#0x18]
  000000000000073C: F9400BE1  ldr         x1,[sp,#0x10]
  0000000000000740: 18000100  ldr         w0,$LN5
  0000000000000744: 94000000  bl          variadic_func_S_DD
  0000000000000748: A8C27BFD  ldp         fp,lr,[sp],#0x20
  000000000000074C: D65F03C0  ret
$LN3:
  0000000000000750: 84FD0FC2  ld1sh       {z2.s},p3/z,[lr,z29.s sxtw #1]
  0000000000000754: 40934A45
$LN4:
  0000000000000758: 00000000
  000000000000075C: 406E0000
$LN5:
  0000000000000760: CAFE6789  eon         x9,x28,lr,ror #0x19
  0000000000000764: 00000000
func_S_DDD:
  0000000000000768: D10083FF  sub         sp,sp,#0x20
  000000000000076C: B90003E0  str         w0,[sp]
  0000000000000770: FD0007E0  str         d0,[sp,#8]
  0000000000000774: FD000BE1  str         d1,[sp,#0x10]
  0000000000000778: FD000FE2  str         d2,[sp,#0x18]
  000000000000077C: FD4007F1  ldr         d17,[sp,#8]
  0000000000000780: FD400BF0  ldr         d16,[sp,#0x10]
  0000000000000784: 1E702A31  fadd        d17,d17,d16
  0000000000000788: FD400FF0  ldr         d16,[sp,#0x18]
  000000000000078C: 1E702A20  fadd        d0,d17,d16
  0000000000000790: 910083FF  add         sp,sp,#0x20
  0000000000000794: D65F03C0  ret
variadic_func_S_DDD:
  0000000000000798: D10103FF  sub         sp,sp,#0x40
  000000000000079C: A9008BE1  stp         x1,x2,[sp,#8]
  00000000000007A0: A90193E3  stp         x3,x4,[sp,#0x18]
  00000000000007A4: A9029BE5  stp         x5,x6,[sp,#0x28]
  00000000000007A8: F9001FE7  str         x7,[sp,#0x38]
  00000000000007AC: D10143FF  sub         sp,sp,#0x50
  00000000000007B0: B90003E0  str         w0,[sp]
  00000000000007B4: 910163E8  add         x8,sp,#0x58
  00000000000007B8: F90007E8  str         x8,[sp,#8]
  00000000000007BC: F94007E8  ldr         x8,[sp,#8]
  00000000000007C0: 91002108  add         x8,x8,#8
  00000000000007C4: F90007E8  str         x8,[sp,#8]
  00000000000007C8: F94007E8  ldr         x8,[sp,#8]
  00000000000007CC: D1002108  sub         x8,x8,#8
  00000000000007D0: F9400108  ldr         x8,[x8]
  00000000000007D4: 3DC00110  ldr         q16,[x8]
  00000000000007D8: 3D800FF0  str         q16,[sp,#0x30]
  00000000000007DC: F9400908  ldr         x8,[x8,#0x10]
  00000000000007E0: F90023E8  str         x8,[sp,#0x40]
  00000000000007E4: FD4023F0  ldr         d16,[sp,#0x40]
  00000000000007E8: FD0013F0  str         d16,[sp,#0x20]
  00000000000007EC: FD401FF0  ldr         d16,[sp,#0x38]
  00000000000007F0: FD000FF0  str         d16,[sp,#0x18]
  00000000000007F4: FD401BF0  ldr         d16,[sp,#0x30]
  00000000000007F8: FD000BF0  str         d16,[sp,#0x10]
  00000000000007FC: D2800008  mov         x8,#0
  0000000000000800: F90007E8  str         x8,[sp,#8]
  0000000000000804: FD400BF1  ldr         d17,[sp,#0x10]
  0000000000000808: FD400FF0  ldr         d16,[sp,#0x18]
  000000000000080C: 1E702A31  fadd        d17,d17,d16
  0000000000000810: FD4013F0  ldr         d16,[sp,#0x20]
  0000000000000814: 1E702A20  fadd        d0,d17,d16
  0000000000000818: 910143FF  add         sp,sp,#0x50
  000000000000081C: 910103FF  add         sp,sp,#0x40
  0000000000000820: D65F03C0  ret
  0000000000000824: 00000000
call_S_DDD:
  0000000000000828: A9BD7BFD  stp         fp,lr,[sp,#-0x30]!
  000000000000082C: 910003FD  mov         fp,sp
  0000000000000830: 5C0001D0  ldr         d16,$LN3
  0000000000000834: FD000BF0  str         d16,[sp,#0x10]
  0000000000000838: 5C0001D0  ldr         d16,$LN4
  000000000000083C: FD000FF0  str         d16,[sp,#0x18]
  0000000000000840: 5C0001D0  ldr         d16,$LN5
  0000000000000844: FD0013F0  str         d16,[sp,#0x20]
  0000000000000848: FD4013E2  ldr         d2,[sp,#0x20]
  000000000000084C: FD400FE1  ldr         d1,[sp,#0x18]
  0000000000000850: FD400BE0  ldr         d0,[sp,#0x10]
  0000000000000854: 18000160  ldr         w0,$LN6
  0000000000000858: 94000000  bl          func_S_DDD
  000000000000085C: A8C37BFD  ldp         fp,lr,[sp],#0x30
  0000000000000860: D65F03C0  ret
  0000000000000864: D503201F  nop
$LN3:
  0000000000000868: 84FD0FC2  ld1sh       {z2.s},p3/z,[lr,z29.s sxtw #1]
  000000000000086C: 40934A45
$LN4:
  0000000000000870: 00000000
  0000000000000874: 40A2C000
$LN5:
  0000000000000878: 00000000
  000000000000087C: 4092C000
$LN6:
  0000000000000880: CAFE7890  eon         xip0,x4,lr,ror #0x1E
  0000000000000884: 00000000
call_variadic_S_DDD:
  0000000000000888: A9BB7BFD  stp         fp,lr,[sp,#-0x50]!
  000000000000088C: 910003FD  mov         fp,sp
  0000000000000890: 5C000250  ldr         d16,$LN3
  0000000000000894: FD000BF0  str         d16,[sp,#0x10]
  0000000000000898: 5C000250  ldr         d16,$LN4
  000000000000089C: FD000FF0  str         d16,[sp,#0x18]
  00000000000008A0: 5C000250  ldr         d16,$LN5
  00000000000008A4: FD0013F0  str         d16,[sp,#0x20]
  00000000000008A8: FD4013F0  ldr         d16,[sp,#0x20]
  00000000000008AC: FD0023F0  str         d16,[sp,#0x40]
  00000000000008B0: FD400FF0  ldr         d16,[sp,#0x18]
  00000000000008B4: FD001FF0  str         d16,[sp,#0x38]
  00000000000008B8: FD400BF0  ldr         d16,[sp,#0x10]
  00000000000008BC: FD001BF0  str         d16,[sp,#0x30]
  00000000000008C0: 9100C3E1  add         x1,sp,#0x30
  00000000000008C4: 18000160  ldr         w0,$LN6
  00000000000008C8: 94000000  bl          variadic_func_S_DDD
  00000000000008CC: A8C57BFD  ldp         fp,lr,[sp],#0x50
  00000000000008D0: D65F03C0  ret
  00000000000008D4: D503201F  nop
$LN3:
  00000000000008D8: 84FD0FC2  ld1sh       {z2.s},p3/z,[lr,z29.s sxtw #1]
  00000000000008DC: 40934A45
$LN4:
  00000000000008E0: 00000000
  00000000000008E4: 40A2C000
$LN5:
  00000000000008E8: 00000000
  00000000000008EC: 4092C000
$LN6:
  00000000000008F0: CAFE7890  eon         xip0,x4,lr,ror #0x1E
  00000000000008F4: 00000000
func_S_DDDD:
  00000000000008F8: D100C3FF  sub         sp,sp,#0x30
  00000000000008FC: B90003E0  str         w0,[sp]
  0000000000000900: FD0007E0  str         d0,[sp,#8]
  0000000000000904: FD000BE1  str         d1,[sp,#0x10]
  0000000000000908: FD000FE2  str         d2,[sp,#0x18]
  000000000000090C: FD0013E3  str         d3,[sp,#0x20]
  0000000000000910: FD4007F1  ldr         d17,[sp,#8]
  0000000000000914: FD400BF0  ldr         d16,[sp,#0x10]
  0000000000000918: 1E702A31  fadd        d17,d17,d16
  000000000000091C: FD400FF0  ldr         d16,[sp,#0x18]
  0000000000000920: 1E702A31  fadd        d17,d17,d16
  0000000000000924: FD4013F0  ldr         d16,[sp,#0x20]
  0000000000000928: 1E702A20  fadd        d0,d17,d16
  000000000000092C: 9100C3FF  add         sp,sp,#0x30
  0000000000000930: D65F03C0  ret
  0000000000000934: 00000000
variadic_func_S_DDDD:
  0000000000000938: D10103FF  sub         sp,sp,#0x40
  000000000000093C: A9008BE1  stp         x1,x2,[sp,#8]
  0000000000000940: A90193E3  stp         x3,x4,[sp,#0x18]
  0000000000000944: A9029BE5  stp         x5,x6,[sp,#0x28]
  0000000000000948: F9001FE7  str         x7,[sp,#0x38]
  000000000000094C: D10143FF  sub         sp,sp,#0x50
  0000000000000950: B90003E0  str         w0,[sp]
  0000000000000954: 910163E8  add         x8,sp,#0x58
  0000000000000958: F90007E8  str         x8,[sp,#8]
  000000000000095C: F94007E8  ldr         x8,[sp,#8]
  0000000000000960: 91002108  add         x8,x8,#8
  0000000000000964: F90007E8  str         x8,[sp,#8]
  0000000000000968: F94007E8  ldr         x8,[sp,#8]
  000000000000096C: D1002108  sub         x8,x8,#8
  0000000000000970: F9400108  ldr         x8,[x8]
  0000000000000974: 3DC00110  ldr         q16,[x8]
  0000000000000978: 3D800FF0  str         q16,[sp,#0x30]
  000000000000097C: 3DC00510  ldr         q16,[x8,#0x10]
  0000000000000980: 3D8013F0  str         q16,[sp,#0x40]
  0000000000000984: FD4027F0  ldr         d16,[sp,#0x48]
  0000000000000988: FD0017F0  str         d16,[sp,#0x28]
  000000000000098C: FD4023F0  ldr         d16,[sp,#0x40]
  0000000000000990: FD0013F0  str         d16,[sp,#0x20]
  0000000000000994: FD401FF0  ldr         d16,[sp,#0x38]
  0000000000000998: FD000FF0  str         d16,[sp,#0x18]
  000000000000099C: FD401BF0  ldr         d16,[sp,#0x30]
  00000000000009A0: FD000BF0  str         d16,[sp,#0x10]
  00000000000009A4: D2800008  mov         x8,#0
  00000000000009A8: F90007E8  str         x8,[sp,#8]
  00000000000009AC: FD400BF1  ldr         d17,[sp,#0x10]
  00000000000009B0: FD400FF0  ldr         d16,[sp,#0x18]
  00000000000009B4: 1E702A31  fadd        d17,d17,d16
  00000000000009B8: FD4013F0  ldr         d16,[sp,#0x20]
  00000000000009BC: 1E702A31  fadd        d17,d17,d16
  00000000000009C0: FD4017F0  ldr         d16,[sp,#0x28]
  00000000000009C4: 1E702A20  fadd        d0,d17,d16
  00000000000009C8: 910143FF  add         sp,sp,#0x50
  00000000000009CC: 910103FF  add         sp,sp,#0x40
  00000000000009D0: D65F03C0  ret
  00000000000009D4: 00000000
call_S_DDDD:
  00000000000009D8: A9BD7BFD  stp         fp,lr,[sp,#-0x30]!
  00000000000009DC: 910003FD  mov         fp,sp
  00000000000009E0: 5C000210  ldr         d16,$LN3
  00000000000009E4: FD000BF0  str         d16,[sp,#0x10]
  00000000000009E8: 5C000210  ldr         d16,$LN4
  00000000000009EC: FD000FF0  str         d16,[sp,#0x18]
  00000000000009F0: 5C000210  ldr         d16,$LN5
  00000000000009F4: FD0013F0  str         d16,[sp,#0x20]
  00000000000009F8: 5C000210  ldr         d16,$LN6
  00000000000009FC: FD0017F0  str         d16,[sp,#0x28]
  0000000000000A00: FD4017E3  ldr         d3,[sp,#0x28]
  0000000000000A04: FD4013E2  ldr         d2,[sp,#0x20]
  0000000000000A08: FD400FE1  ldr         d1,[sp,#0x18]
  0000000000000A0C: FD400BE0  ldr         d0,[sp,#0x10]
  0000000000000A10: 18000180  ldr         w0,$LN7
  0000000000000A14: 94000000  bl          func_S_DDDD
  0000000000000A18: A8C37BFD  ldp         fp,lr,[sp],#0x30
  0000000000000A1C: D65F03C0  ret
$LN3:
  0000000000000A20: 84FD0FC2  ld1sh       {z2.s},p3/z,[lr,z29.s sxtw #1]
  0000000000000A24: 40934A45
$LN4:
  0000000000000A28: 00000000
  0000000000000A2C: 40D77000
$LN5:
  0000000000000A30: 00000000
  0000000000000A34: 40C77000
$LN6:
  0000000000000A38: 54442D18
  0000000000000A3C: 400921FB
$LN7:
  0000000000000A40: CAFE890A  eon         x10,x8,lr,ror #0x22
  0000000000000A44: 00000000
call_variadic_S_DDDD:
  0000000000000A48: A9BB7BFD  stp         fp,lr,[sp,#-0x50]!
  0000000000000A4C: 910003FD  mov         fp,sp
  0000000000000A50: 5C0002D0  ldr         d16,$LN3
  0000000000000A54: FD000BF0  str         d16,[sp,#0x10]
  0000000000000A58: 5C0002D0  ldr         d16,$LN4
  0000000000000A5C: FD000FF0  str         d16,[sp,#0x18]
  0000000000000A60: 5C0002D0  ldr         d16,$LN5
  0000000000000A64: FD0013F0  str         d16,[sp,#0x20]
  0000000000000A68: 5C0002D0  ldr         d16,$LN6
  0000000000000A6C: FD0017F0  str         d16,[sp,#0x28]
  0000000000000A70: FD4017F0  ldr         d16,[sp,#0x28]
  0000000000000A74: FD0027F0  str         d16,[sp,#0x48]
  0000000000000A78: FD4013F0  ldr         d16,[sp,#0x20]
  0000000000000A7C: FD0023F0  str         d16,[sp,#0x40]
  0000000000000A80: FD400FF0  ldr         d16,[sp,#0x18]
  0000000000000A84: FD001FF0  str         d16,[sp,#0x38]
  0000000000000A88: FD400BF0  ldr         d16,[sp,#0x10]
  0000000000000A8C: FD001BF0  str         d16,[sp,#0x30]
  0000000000000A90: 9100C3E1  add         x1,sp,#0x30
  0000000000000A94: 180001A0  ldr         w0,$LN7
  0000000000000A98: 94000000  bl          variadic_func_S_DDDD
  0000000000000A9C: A8C57BFD  ldp         fp,lr,[sp],#0x50
  0000000000000AA0: D65F03C0  ret
  0000000000000AA4: D503201F  nop
$LN3:
  0000000000000AA8: 84FD0FC2  ld1sh       {z2.s},p3/z,[lr,z29.s sxtw #1]
  0000000000000AAC: 40934A45
$LN4:
  0000000000000AB0: 00000000
  0000000000000AB4: 40D77000
$LN5:
  0000000000000AB8: 00000000
  0000000000000ABC: 40C77000
$LN6:
  0000000000000AC0: 54442D18
  0000000000000AC4: 400921FB
$LN7:
  0000000000000AC8: CAFE890A  eon         x10,x8,lr,ror #0x22
  0000000000000ACC: 00000000
main:
  0000000000000AD0: 52800000  mov         w0,#0
  0000000000000AD4: D65F03C0  ret

  Summary

          30 .chks64
          9C .debug$S
          2F .drectve
         100 .pdata
         AD8 .text$mn
          80 .xdata
