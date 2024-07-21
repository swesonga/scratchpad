
Dump of file segfault.obj

File Type: COFF OBJECT

main:
  0000000000000000: 48 83 EC 38        sub         rsp,38h
  0000000000000004: 48 B8 DE C0 00 00  mov         rax,0DEAD00000000C0DEh
                    00 00 AD DE
  000000000000000E: 48 89 44 24 28     mov         qword ptr [rsp+28h],rax
  0000000000000013: 48 8B 44 24 28     mov         rax,qword ptr [rsp+28h]
  0000000000000018: 8B 00              mov         eax,dword ptr [rax]
  000000000000001A: 89 44 24 20        mov         dword ptr [rsp+20h],eax
  000000000000001E: 8B 54 24 20        mov         edx,dword ptr [rsp+20h]
  0000000000000022: 48 8D 0D 00 00 00  lea         rcx,[$SG9539]
                    00
  0000000000000029: E8 00 00 00 00     call        printf
  000000000000002E: 90                 nop
  000000000000002F: 33 C0              xor         eax,eax
  0000000000000031: 48 83 C4 38        add         rsp,38h
  0000000000000035: C3                 ret

__local_stdio_printf_options:
  0000000000000000: 48 8D 05 00 00 00  lea         rax,[?_OptionsStorage@?1??__local_stdio_printf_options@@9@9]
                    00
  0000000000000007: C3                 ret

_vfprintf_l:
  0000000000000000: 4C 89 4C 24 20     mov         qword ptr [rsp+20h],r9
  0000000000000005: 4C 89 44 24 18     mov         qword ptr [rsp+18h],r8
  000000000000000A: 48 89 54 24 10     mov         qword ptr [rsp+10h],rdx
  000000000000000F: 48 89 4C 24 08     mov         qword ptr [rsp+8],rcx
  0000000000000014: 48 83 EC 38        sub         rsp,38h
  0000000000000018: E8 00 00 00 00     call        __local_stdio_printf_options
  000000000000001D: 48 8B 4C 24 58     mov         rcx,qword ptr [rsp+58h]
  0000000000000022: 48 89 4C 24 20     mov         qword ptr [rsp+20h],rcx
  0000000000000027: 4C 8B 4C 24 50     mov         r9,qword ptr [rsp+50h]
  000000000000002C: 4C 8B 44 24 48     mov         r8,qword ptr [rsp+48h]
  0000000000000031: 48 8B 54 24 40     mov         rdx,qword ptr [rsp+40h]
  0000000000000036: 48 8B 08           mov         rcx,qword ptr [rax]
  0000000000000039: E8 00 00 00 00     call        __stdio_common_vfprintf
  000000000000003E: 48 83 C4 38        add         rsp,38h
  0000000000000042: C3                 ret

printf:
  0000000000000000: 48 89 4C 24 08     mov         qword ptr [rsp+8],rcx
  0000000000000005: 48 89 54 24 10     mov         qword ptr [rsp+10h],rdx
  000000000000000A: 4C 89 44 24 18     mov         qword ptr [rsp+18h],r8
  000000000000000F: 4C 89 4C 24 20     mov         qword ptr [rsp+20h],r9
  0000000000000014: 48 83 EC 38        sub         rsp,38h
  0000000000000018: 48 8D 44 24 48     lea         rax,[rsp+48h]
  000000000000001D: 48 89 44 24 28     mov         qword ptr [rsp+28h],rax
  0000000000000022: B9 01 00 00 00     mov         ecx,1
  0000000000000027: E8 00 00 00 00     call        __acrt_iob_func
  000000000000002C: 4C 8B 4C 24 28     mov         r9,qword ptr [rsp+28h]
  0000000000000031: 45 33 C0           xor         r8d,r8d
  0000000000000034: 48 8B 54 24 40     mov         rdx,qword ptr [rsp+40h]
  0000000000000039: 48 8B C8           mov         rcx,rax
  000000000000003C: E8 00 00 00 00     call        _vfprintf_l
  0000000000000041: 89 44 24 20        mov         dword ptr [rsp+20h],eax
  0000000000000045: 48 C7 44 24 28 00  mov         qword ptr [rsp+28h],0
                    00 00 00
  000000000000004E: 8B 44 24 20        mov         eax,dword ptr [rsp+20h]
  0000000000000052: 48 83 C4 38        add         rsp,38h
  0000000000000056: C3                 ret

  Summary

          70 .chks64
           8 .data
          7C .debug$S
          2F .drectve
          24 .pdata
          D8 .text$mn
          18 .xdata
