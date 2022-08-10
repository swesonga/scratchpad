
Dump of file aarch64-abi-test-printf-o2.obj

File Type: COFF OBJECT

__local_stdio_printf_options:
  0000000000000000: 90000008  adrp        x8,?_OptionsStorage@?1??__local_stdio_printf_options@@9@4_KA
  0000000000000004: 91000100  add         x0,x8,?_OptionsStorage@?1??__local_stdio_printf_options@@9@4_KA
  0000000000000008: D65F03C0  ret

_vfprintf_l:
  0000000000000000: A9BD53F3  stp         x19,x20,[sp,#-0x30]!
  0000000000000004: A9015BF5  stp         x21,x22,[sp,#0x10]
  0000000000000008: F90013FE  str         lr,[sp,#0x20]
  000000000000000C: AA0003F6  mov         x22,x0
  0000000000000010: AA0103F5  mov         x21,x1
  0000000000000014: AA0203F4  mov         x20,x2
  0000000000000018: AA0303F3  mov         x19,x3
  000000000000001C: 94000000  bl          __local_stdio_printf_options
  0000000000000020: F9400000  ldr         x0,[x0]
  0000000000000024: AA1303E4  mov         x4,x19
  0000000000000028: AA1403E3  mov         x3,x20
  000000000000002C: AA1503E2  mov         x2,x21
  0000000000000030: AA1603E1  mov         x1,x22
  0000000000000034: 94000000  bl          __stdio_common_vfprintf
  0000000000000038: F94013FE  ldr         lr,[sp,#0x20]
  000000000000003C: A9415BF5  ldp         x21,x22,[sp,#0x10]
  0000000000000040: A8C353F3  ldp         x19,x20,[sp],#0x30
  0000000000000044: D65F03C0  ret

main:
  0000000000000000: F81F0FFE  str         lr,[sp,#-0x10]!
  0000000000000004: 5C0001B0  ldr         d16,$LN4
  0000000000000008: 90000008  adrp        x8,??_C@_03OJMAPEGJ@str@
  000000000000000C: 91000104  add         x4,x8,??_C@_03OJMAPEGJ@str@
  0000000000000010: 90000008  adrp        x8,??_C@_0BC@OEIAMIIK@?$CF?44f?0?$CF?44f?0?$CF?44f?0?$CFs@
  0000000000000014: 91000100  add         x0,x8,??_C@_0BC@OEIAMIIK@?$CF?44f?0?$CF?44f?0?$CF?44f?0?$CFs@
  0000000000000018: 9E660203  fmov        x3,d16
  000000000000001C: 9E660202  fmov        x2,d16
  0000000000000020: 9E660201  fmov        x1,d16
  0000000000000024: 94000000  bl          printf
  0000000000000028: 52800000  mov         w0,#0
  000000000000002C: F84107FE  ldr         lr,[sp],#0x10
  0000000000000030: D65F03C0  ret
  0000000000000034: D503201F  nop
$LN4:
  0000000000000038: 126E978D
  000000000000003C: 3FF3C083

printf:
  0000000000000000: A9BA53F3  stp         x19,x20,[sp,#-0x60]!
  0000000000000004: A9017BF5  stp         x21,lr,[sp,#0x10]
  0000000000000008: A9028BE1  stp         x1,x2,[sp,#0x28]
  000000000000000C: A90393E3  stp         x3,x4,[sp,#0x38]
  0000000000000010: A9049BE5  stp         x5,x6,[sp,#0x48]
  0000000000000014: F9002FE7  str         x7,[sp,#0x58]
  0000000000000018: AA0003F4  mov         x20,x0
  000000000000001C: 52800020  mov         w0,#1
  0000000000000020: 9100A3F5  add         x21,sp,#0x28
  0000000000000024: 94000000  bl          __acrt_iob_func
  0000000000000028: AA0003F3  mov         x19,x0
  000000000000002C: 94000000  bl          __local_stdio_printf_options
  0000000000000030: F9400000  ldr         x0,[x0]
  0000000000000034: D2800003  mov         x3,#0
  0000000000000038: AA1403E2  mov         x2,x20
  000000000000003C: AA1303E1  mov         x1,x19
  0000000000000040: AA1503E4  mov         x4,x21
  0000000000000044: 94000000  bl          __stdio_common_vfprintf
  0000000000000048: A9417BF5  ldp         x21,lr,[sp,#0x10]
  000000000000004C: A8C653F3  ldp         x19,x20,[sp],#0x60
  0000000000000050: D65F03C0  ret

  Summary

           8 .bss
          70 .chks64
          AC .debug$S
          62 .drectve
          18 .pdata
          16 .rdata
          E8 .text$mn
           8 .xdata
