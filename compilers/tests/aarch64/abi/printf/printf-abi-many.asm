
Dump of file aarch64-abi-test-printf-manyargs.obj

File Type: COFF OBJECT

main:
  0000000000000000: A9BE7BFD  stp         fp,lr,[sp,#-0x20]!
  0000000000000004: 910003FD  mov         fp,sp
  0000000000000008: D100C3FF  sub         sp,sp,#0x30
  000000000000000C: 90000008  adrp        x8,$SG5571
  0000000000000010: 91000108  add         x8,x8,$SG5571
  0000000000000014: F90017E8  str         x8,[sp,#0x28]
  0000000000000018: 5C0003D0  ldr         d16,$LN3
  000000000000001C: FD0013F0  str         d16,[sp,#0x20]
  0000000000000020: 5C000390  ldr         d16,$LN3
  0000000000000024: FD000FF0  str         d16,[sp,#0x18]
  0000000000000028: 90000008  adrp        x8,$SG5572
  000000000000002C: 91000108  add         x8,x8,$SG5572
  0000000000000030: F9000BE8  str         x8,[sp,#0x10]
  0000000000000034: 5C0002F0  ldr         d16,$LN3
  0000000000000038: FD0007F0  str         d16,[sp,#8]
  000000000000003C: 5C0002B0  ldr         d16,$LN3
  0000000000000040: FD0003F0  str         d16,[sp]
  0000000000000044: 90000008  adrp        x8,$SG5573
  0000000000000048: 91000107  add         x7,x8,$SG5573
  000000000000004C: 58000226  ldr         x6,$LN3
  0000000000000050: 58000205  ldr         x5,$LN3
  0000000000000054: 90000008  adrp        x8,$SG5574
  0000000000000058: 91000104  add         x4,x8,$SG5574
  000000000000005C: 580001A3  ldr         x3,$LN3
  0000000000000060: 58000182  ldr         x2,$LN3
  0000000000000064: 58000161  ldr         x1,$LN3
  0000000000000068: 90000008  adrp        x8,$SG5575
  000000000000006C: 91000100  add         x0,x8,$SG5575
  0000000000000070: 94000000  bl          printf
  0000000000000074: 2A0003E0  mov         w0,w0
  0000000000000078: B90043E0  str         w0,[sp,#0x40]
  000000000000007C: 52800000  mov         w0,#0
  0000000000000080: 9100C3FF  add         sp,sp,#0x30
  0000000000000084: A8C27BFD  ldp         fp,lr,[sp],#0x20
  0000000000000088: D65F03C0  ret
  000000000000008C: D503201F  nop
$LN3:
  0000000000000090: 126E978D
  0000000000000094: 3FF3C083

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

printf:
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
  0000000000000028: 52800020  mov         w0,#1
  000000000000002C: 94000000  bl          __acrt_iob_func
  0000000000000030: F9400FE3  ldr         x3,[sp,#0x18]
  0000000000000034: D2800002  mov         x2,#0
  0000000000000038: F94013E1  ldr         x1,[sp,#0x20]
  000000000000003C: 94000000  bl          _vfprintf_l
  0000000000000040: 2A0003E0  mov         w0,w0
  0000000000000044: B90013E0  str         w0,[sp,#0x10]
  0000000000000048: D2800008  mov         x8,#0
  000000000000004C: F9000FE8  str         x8,[sp,#0x18]
  0000000000000050: B94013E0  ldr         w0,[sp,#0x10]
  0000000000000054: A8C37BFD  ldp         fp,lr,[sp],#0x30
  0000000000000058: 910103FF  add         sp,sp,#0x40
  000000000000005C: D65F03C0  ret

  Summary

           8 .bss
          68 .chks64
          B0 .debug$S
          62 .drectve
          18 .pdata
          59 .rdata
         148 .text$mn
          10 .xdata
