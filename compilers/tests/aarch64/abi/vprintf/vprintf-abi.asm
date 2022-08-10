
Dump of file aarch64-abi-test-vprintf.obj

File Type: COFF OBJECT

?printmsg@@YAHPEBDZZ (int __cdecl printmsg(char const *,...)):
  0000000000000000: D10103FF  sub         sp,sp,#0x40
  0000000000000004: A9008BE1  stp         x1,x2,[sp,#8]
  0000000000000008: A90193E3  stp         x3,x4,[sp,#0x18]
  000000000000000C: A9029BE5  stp         x5,x6,[sp,#0x28]
  0000000000000010: F9001FE7  str         x7,[sp,#0x38]
  0000000000000014: A9BD7BFD  stp         fp,lr,[sp,#-0x30]!
  0000000000000018: 910003FD  mov         fp,sp
  000000000000001C: F90013E0  str         x0,[sp,#0x20]
  0000000000000020: 9100E3E8  add         x8,sp,#0x38
  0000000000000024: F9000FE8  str         x8,[sp,#0x18]
  0000000000000028: F9400FE1  ldr         x1,[sp,#0x18]
  000000000000002C: F94013E0  ldr         x0,[sp,#0x20]
  0000000000000030: 94000000  bl          vprintf
  0000000000000034: 2A0003E0  mov         w0,w0
  0000000000000038: B90013E0  str         w0,[sp,#0x10]
  000000000000003C: D2800008  mov         x8,#0
  0000000000000040: F9000FE8  str         x8,[sp,#0x18]
  0000000000000044: B94013E0  ldr         w0,[sp,#0x10]
  0000000000000048: A8C37BFD  ldp         fp,lr,[sp],#0x30
  000000000000004C: 910103FF  add         sp,sp,#0x40
  0000000000000050: D65F03C0  ret
  0000000000000054: 00000000
main:
  0000000000000058: A9BE7BFD  stp         fp,lr,[sp,#-0x20]!
  000000000000005C: 910003FD  mov         fp,sp
  0000000000000060: 90000008  adrp        x8,$SG5615
  0000000000000064: 91000104  add         x4,x8,$SG5615
  0000000000000068: 58000183  ldr         x3,$LN3
  000000000000006C: 58000162  ldr         x2,$LN3
  0000000000000070: 58000141  ldr         x1,$LN3
  0000000000000074: 90000008  adrp        x8,$SG5616
  0000000000000078: 91000100  add         x0,x8,$SG5616
  000000000000007C: 94000000  bl          ?printmsg@@YAHPEBDZZ
  0000000000000080: 2A0003E0  mov         w0,w0
  0000000000000084: B90013E0  str         w0,[sp,#0x10]
  0000000000000088: 52800000  mov         w0,#0
  000000000000008C: A8C27BFD  ldp         fp,lr,[sp],#0x20
  0000000000000090: D65F03C0  ret
  0000000000000094: D503201F  nop
$LN3:
  0000000000000098: 126E978D
  000000000000009C: 3FF3C083

__local_stdio_printf_options:
  0000000000000000: 90000008  adrp        x8,?_OptionsStorage@?1??__local_stdio_printf_options@@9@4_KA
  0000000000000004: 91000100  add         x0,x8,?_OptionsStorage@?1??__local_stdio_printf_options@@9@4_KA
  0000000000000008: D65F03C0  ret

_vfprintf_l:
  0000000000000000: A9BD7BFD  stp         fp,lr,[sp,#-0x30]!
  0000000000000004: 910003FD  mov         fp,sp
  0000000000000008: F90017E0  str         x0,[sp,#0x28]
  000000000000000C: F90013E1  str         x1,[sp,#0x20]
  0000000000000010: F9000FE2  str         x2,[sp,#0x18]
  0000000000000014: F9000BE3  str         x3,[sp,#0x10]
  0000000000000018: 94000000  bl          __local_stdio_printf_options
  000000000000001C: F9400BE4  ldr         x4,[sp,#0x10]
  0000000000000020: F9400FE3  ldr         x3,[sp,#0x18]
  0000000000000024: F94013E2  ldr         x2,[sp,#0x20]
  0000000000000028: F94017E1  ldr         x1,[sp,#0x28]
  000000000000002C: F9400000  ldr         x0,[x0]
  0000000000000030: 94000000  bl          __stdio_common_vfprintf
  0000000000000034: 2A0003E0  mov         w0,w0
  0000000000000038: 2A0003E0  mov         w0,w0
  000000000000003C: A8C37BFD  ldp         fp,lr,[sp],#0x30
  0000000000000040: D65F03C0  ret

vprintf:
  0000000000000000: A9BE7BFD  stp         fp,lr,[sp,#-0x20]!
  0000000000000004: 910003FD  mov         fp,sp
  0000000000000008: F9000FE0  str         x0,[sp,#0x18]
  000000000000000C: F9000BE1  str         x1,[sp,#0x10]
  0000000000000010: 52800020  mov         w0,#1
  0000000000000014: 94000000  bl          __acrt_iob_func
  0000000000000018: F9400BE3  ldr         x3,[sp,#0x10]
  000000000000001C: D2800002  mov         x2,#0
  0000000000000020: F9400FE1  ldr         x1,[sp,#0x18]
  0000000000000024: 94000000  bl          _vfprintf_l
  0000000000000028: 2A0003E0  mov         w0,w0
  000000000000002C: 2A0003E0  mov         w0,w0
  0000000000000030: A8C27BFD  ldp         fp,lr,[sp],#0x20
  0000000000000034: D65F03C0  ret

  Summary

           8 .bss
          68 .chks64
          AC .debug$S
          62 .drectve
          20 .pdata
          1A .rdata
         128 .text$mn
          10 .xdata
