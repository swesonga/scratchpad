
Dump of file array_of_structs-optimized.obj

File Type: COFF OBJECT

?arrayOfStructsIndexingBasePointer@@YAXK@Z (void __cdecl arrayOfStructsIndexingBasePointer(unsigned long)):
  0000000000000000: 48 83 EC 28        sub         rsp,28h
  0000000000000004: 8B C1              mov         eax,ecx
  0000000000000006: 48 8D 0C 40        lea         rcx,[rax+rax*2]
  000000000000000A: 48 C1 E1 04        shl         rcx,4
  000000000000000E: E8 00 00 00 00     call        malloc
  0000000000000013: 48 85 C0           test        rax,rax
  0000000000000016: 75 1B              jne         0000000000000033
  0000000000000018: 44 8D 40 22        lea         r8d,[rax+22h]
  000000000000001C: 48 8D 15 00 00 00  lea         rdx,[??_C@_1CK@FBCAGIBG@?$AAa?$AAr?$AAr?$AAa?$AAy?$AA_?$AAo?$AAf?$AA_?$AAs?$AAt?$AAr?$AAu?$AAc?$AAt@]
                    00
  0000000000000023: 48 8D 0D 00 00 00  lea         rcx,[??_C@_1CM@NDFELJCE@?$AAg?$AAr?$AAo?$AAu?$AAp?$AA_?$AAi?$AAn?$AAf?$AAo?$AA?5?$AA?$CB?$AA?$DN?$AA?5?$AAn@]
                    00
  000000000000002A: 48 83 C4 28        add         rsp,28h
  000000000000002E: E9 00 00 00 00     jmp         _wassert
  0000000000000033: 48 83 C4 28        add         rsp,28h
  0000000000000037: C3                 ret

?arrayOfStructsUpdatingPointer@@YAXK@Z (void __cdecl arrayOfStructsUpdatingPointer(unsigned long)):
  0000000000000000: 48 83 EC 28        sub         rsp,28h
  0000000000000004: 8B C1              mov         eax,ecx
  0000000000000006: 48 8D 0C 40        lea         rcx,[rax+rax*2]
  000000000000000A: 48 C1 E1 04        shl         rcx,4
  000000000000000E: E8 00 00 00 00     call        malloc
  0000000000000013: 48 85 C0           test        rax,rax
  0000000000000016: 75 1B              jne         0000000000000033
  0000000000000018: 44 8D 40 18        lea         r8d,[rax+18h]
  000000000000001C: 48 8D 15 00 00 00  lea         rdx,[??_C@_1CK@FBCAGIBG@?$AAa?$AAr?$AAr?$AAa?$AAy?$AA_?$AAo?$AAf?$AA_?$AAs?$AAt?$AAr?$AAu?$AAc?$AAt@]
                    00
  0000000000000023: 48 8D 0D 00 00 00  lea         rcx,[??_C@_1CM@NDFELJCE@?$AAg?$AAr?$AAo?$AAu?$AAp?$AA_?$AAi?$AAn?$AAf?$AAo?$AA?5?$AA?$CB?$AA?$DN?$AA?5?$AAn@]
                    00
  000000000000002A: 48 83 C4 28        add         rsp,28h
  000000000000002E: E9 00 00 00 00     jmp         _wassert
  0000000000000033: 48 83 C4 28        add         rsp,28h
  0000000000000037: C3                 ret

main:
  0000000000000000: 48 83 EC 28        sub         rsp,28h
  0000000000000004: B9 C0 00 00 00     mov         ecx,0C0h
  0000000000000009: E8 00 00 00 00     call        malloc
  000000000000000E: 48 85 C0           test        rax,rax
  0000000000000011: 75 1D              jne         0000000000000030
  0000000000000013: 44 8D 40 18        lea         r8d,[rax+18h]
  0000000000000017: 48 8D 15 00 00 00  lea         rdx,[??_C@_1CK@FBCAGIBG@?$AAa?$AAr?$AAr?$AAa?$AAy?$AA_?$AAo?$AAf?$AA_?$AAs?$AAt?$AAr?$AAu?$AAc?$AAt@]
                    00
  000000000000001E: 48 8D 0D 00 00 00  lea         rcx,[??_C@_1CM@NDFELJCE@?$AAg?$AAr?$AAo?$AAu?$AAp?$AA_?$AAi?$AAn?$AAf?$AAo?$AA?5?$AA?$CB?$AA?$DN?$AA?5?$AAn@]
                    00
  0000000000000025: E8 00 00 00 00     call        _wassert
  000000000000002A: 66 0F 1F 44 00 00  nop         word ptr [rax+rax]
  0000000000000030: B9 C0 00 00 00     mov         ecx,0C0h
  0000000000000035: E8 00 00 00 00     call        malloc
  000000000000003A: 48 85 C0           test        rax,rax
  000000000000003D: 75 17              jne         0000000000000056
  000000000000003F: 44 8D 40 22        lea         r8d,[rax+22h]
  0000000000000043: 48 8D 15 00 00 00  lea         rdx,[??_C@_1CK@FBCAGIBG@?$AAa?$AAr?$AAr?$AAa?$AAy?$AA_?$AAo?$AAf?$AA_?$AAs?$AAt?$AAr?$AAu?$AAc?$AAt@]
                    00
  000000000000004A: 48 8D 0D 00 00 00  lea         rcx,[??_C@_1CM@NDFELJCE@?$AAg?$AAr?$AAo?$AAu?$AAp?$AA_?$AAi?$AAn?$AAf?$AAo?$AA?5?$AA?$CB?$AA?$DN?$AA?5?$AAn@]
                    00
  0000000000000051: E8 00 00 00 00     call        _wassert
  0000000000000056: 33 C0              xor         eax,eax
  0000000000000058: 48 83 C4 28        add         rsp,28h
  000000000000005C: C3                 ret

  Summary

          70 .chks64
          9C .debug$S
          5D .drectve
          24 .pdata
          56 .rdata
          CD .text$mn
          18 .xdata
