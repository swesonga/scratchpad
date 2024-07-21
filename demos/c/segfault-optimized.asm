
Dump of file segfault-optimized.obj

File Type: COFF OBJECT

__local_stdio_printf_options:
  0000000000000000: 48 8D 05 00 00 00  lea         rax,[?_OptionsStorage@?1??__local_stdio_printf_options@@9@9]
                    00
  0000000000000007: C3                 ret

_vfprintf_l:
  0000000000000000: 48 89 5C 24 08     mov         qword ptr [rsp+8],rbx
  0000000000000005: 48 89 6C 24 10     mov         qword ptr [rsp+10h],rbp
  000000000000000A: 48 89 74 24 18     mov         qword ptr [rsp+18h],rsi
  000000000000000F: 57                 push        rdi
  0000000000000010: 48 83 EC 30        sub         rsp,30h
  0000000000000014: 49 8B D9           mov         rbx,r9
  0000000000000017: 49 8B F8           mov         rdi,r8
  000000000000001A: 48 8B F2           mov         rsi,rdx
  000000000000001D: 48 8B E9           mov         rbp,rcx
  0000000000000020: E8 00 00 00 00     call        __local_stdio_printf_options
  0000000000000025: 4C 8B CF           mov         r9,rdi
  0000000000000028: 48 89 5C 24 20     mov         qword ptr [rsp+20h],rbx
  000000000000002D: 4C 8B C6           mov         r8,rsi
  0000000000000030: 48 8B D5           mov         rdx,rbp
  0000000000000033: 48 8B 08           mov         rcx,qword ptr [rax]
  0000000000000036: E8 00 00 00 00     call        __stdio_common_vfprintf
  000000000000003B: 48 8B 5C 24 40     mov         rbx,qword ptr [rsp+40h]
  0000000000000040: 48 8B 6C 24 48     mov         rbp,qword ptr [rsp+48h]
  0000000000000045: 48 8B 74 24 50     mov         rsi,qword ptr [rsp+50h]
  000000000000004A: 48 83 C4 30        add         rsp,30h
  000000000000004E: 5F                 pop         rdi
  000000000000004F: C3                 ret

main:
  0000000000000000: 48 83 EC 28        sub         rsp,28h
  0000000000000004: 48 BA DE C0 00 00  mov         rdx,0DEAD00000000C0DEh
                    00 00 AD DE
  000000000000000E: 48 8D 0D 00 00 00  lea         rcx,[??_C@_07HBCNHMCC@x?5?$DN?5?$CFd?6@]
                    00
  0000000000000015: 8B 12              mov         edx,dword ptr [rdx]
  0000000000000017: E8 00 00 00 00     call        printf
  000000000000001C: 33 C0              xor         eax,eax
  000000000000001E: 48 83 C4 28        add         rsp,28h
  0000000000000022: C3                 ret

printf:
  0000000000000000: 48 89 4C 24 08     mov         qword ptr [rsp+8],rcx
  0000000000000005: 48 89 54 24 10     mov         qword ptr [rsp+10h],rdx
  000000000000000A: 4C 89 44 24 18     mov         qword ptr [rsp+18h],r8
  000000000000000F: 4C 89 4C 24 20     mov         qword ptr [rsp+20h],r9
  0000000000000014: 53                 push        rbx
  0000000000000015: 56                 push        rsi
  0000000000000016: 57                 push        rdi
  0000000000000017: 48 83 EC 30        sub         rsp,30h
  000000000000001B: 48 8B F9           mov         rdi,rcx
  000000000000001E: 48 8D 74 24 58     lea         rsi,[rsp+58h]
  0000000000000023: B9 01 00 00 00     mov         ecx,1
  0000000000000028: E8 00 00 00 00     call        __acrt_iob_func
  000000000000002D: 48 8B D8           mov         rbx,rax
  0000000000000030: E8 00 00 00 00     call        __local_stdio_printf_options
  0000000000000035: 45 33 C9           xor         r9d,r9d
  0000000000000038: 48 89 74 24 20     mov         qword ptr [rsp+20h],rsi
  000000000000003D: 4C 8B C7           mov         r8,rdi
  0000000000000040: 48 8B D3           mov         rdx,rbx
  0000000000000043: 48 8B 08           mov         rcx,qword ptr [rax]
  0000000000000046: E8 00 00 00 00     call        __stdio_common_vfprintf
  000000000000004B: 48 83 C4 30        add         rsp,30h
  000000000000004F: 5F                 pop         rdi
  0000000000000050: 5E                 pop         rsi
  0000000000000051: 5B                 pop         rbx
  0000000000000052: C3                 ret

  Summary

          70 .chks64
          84 .debug$S
          2F .drectve
          24 .pdata
           8 .rdata
          CE .text$mn
          28 .xdata
