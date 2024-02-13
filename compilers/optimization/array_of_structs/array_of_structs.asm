
Dump of file array_of_structs.obj

File Type: COFF OBJECT

?arrayOfStructsUpdatingPointer@@YAXK@Z (void __cdecl arrayOfStructsUpdatingPointer(unsigned long)):
  0000000000000000: 89 4C 24 08        mov         dword ptr [rsp+8],ecx
  0000000000000004: 48 83 EC 38        sub         rsp,38h
  0000000000000008: 8B 44 24 40        mov         eax,dword ptr [rsp+40h]
  000000000000000C: 48 6B C0 30        imul        rax,rax,30h
  0000000000000010: 48 8B C8           mov         rcx,rax
  0000000000000013: E8 00 00 00 00     call        malloc
  0000000000000018: 48 89 44 24 28     mov         qword ptr [rsp+28h],rax
  000000000000001D: 48 83 7C 24 28 00  cmp         qword ptr [rsp+28h],0
  0000000000000023: 75 1B              jne         0000000000000040
  0000000000000025: 41 B8 18 00 00 00  mov         r8d,18h
  000000000000002B: 48 8D 15 00 00 00  lea         rdx,[$SG90942]
                    00
  0000000000000032: 48 8D 0D 00 00 00  lea         rcx,[$SG90943]
                    00
  0000000000000039: E8 00 00 00 00     call        _wassert
  000000000000003E: 33 C0              xor         eax,eax
  0000000000000040: C7 44 24 24 00 00  mov         dword ptr [rsp+24h],0
                    00 00
  0000000000000048: C7 44 24 20 00 00  mov         dword ptr [rsp+20h],0
                    00 00
  0000000000000050: EB 18              jmp         000000000000006A
  0000000000000052: 8B 44 24 20        mov         eax,dword ptr [rsp+20h]
  0000000000000056: FF C0              inc         eax
  0000000000000058: 89 44 24 20        mov         dword ptr [rsp+20h],eax
  000000000000005C: 48 8B 44 24 28     mov         rax,qword ptr [rsp+28h]
  0000000000000061: 48 83 C0 30        add         rax,30h
  0000000000000065: 48 89 44 24 28     mov         qword ptr [rsp+28h],rax
  000000000000006A: 8B 44 24 40        mov         eax,dword ptr [rsp+40h]
  000000000000006E: 39 44 24 20        cmp         dword ptr [rsp+20h],eax
  0000000000000072: 73 17              jae         000000000000008B
  0000000000000074: 48 8B 44 24 28     mov         rax,qword ptr [rsp+28h]
  0000000000000079: 0F B6 40 01        movzx       eax,byte ptr [rax+1]
  000000000000007D: 8B 4C 24 24        mov         ecx,dword ptr [rsp+24h]
  0000000000000081: 03 C8              add         ecx,eax
  0000000000000083: 8B C1              mov         eax,ecx
  0000000000000085: 89 44 24 24        mov         dword ptr [rsp+24h],eax
  0000000000000089: EB C7              jmp         0000000000000052
  000000000000008B: 48 83 C4 38        add         rsp,38h
  000000000000008F: C3                 ret
  0000000000000090: CC                 int         3
  0000000000000091: CC                 int         3
  0000000000000092: CC                 int         3
  0000000000000093: CC                 int         3
  0000000000000094: CC                 int         3
  0000000000000095: CC                 int         3
  0000000000000096: CC                 int         3
  0000000000000097: CC                 int         3
  0000000000000098: CC                 int         3
  0000000000000099: CC                 int         3
  000000000000009A: CC                 int         3
  000000000000009B: CC                 int         3
  000000000000009C: CC                 int         3
  000000000000009D: CC                 int         3
  000000000000009E: CC                 int         3
  000000000000009F: CC                 int         3
?arrayOfStructsIndexingBasePointer@@YAXK@Z (void __cdecl arrayOfStructsIndexingBasePointer(unsigned long)):
  00000000000000A0: 89 4C 24 08        mov         dword ptr [rsp+8],ecx
  00000000000000A4: 48 83 EC 38        sub         rsp,38h
  00000000000000A8: 8B 44 24 40        mov         eax,dword ptr [rsp+40h]
  00000000000000AC: 48 6B C0 30        imul        rax,rax,30h
  00000000000000B0: 48 8B C8           mov         rcx,rax
  00000000000000B3: E8 00 00 00 00     call        malloc
  00000000000000B8: 48 89 44 24 28     mov         qword ptr [rsp+28h],rax
  00000000000000BD: 48 83 7C 24 28 00  cmp         qword ptr [rsp+28h],0
  00000000000000C3: 75 1B              jne         00000000000000E0
  00000000000000C5: 41 B8 22 00 00 00  mov         r8d,22h
  00000000000000CB: 48 8D 15 00 00 00  lea         rdx,[$SG90958]
                    00
  00000000000000D2: 48 8D 0D 00 00 00  lea         rcx,[$SG90959]
                    00
  00000000000000D9: E8 00 00 00 00     call        _wassert
  00000000000000DE: 33 C0              xor         eax,eax
  00000000000000E0: C7 44 24 24 00 00  mov         dword ptr [rsp+24h],0
                    00 00
  00000000000000E8: C7 44 24 20 00 00  mov         dword ptr [rsp+20h],0
                    00 00
  00000000000000F0: EB 0A              jmp         00000000000000FC
  00000000000000F2: 8B 44 24 20        mov         eax,dword ptr [rsp+20h]
  00000000000000F6: FF C0              inc         eax
  00000000000000F8: 89 44 24 20        mov         dword ptr [rsp+20h],eax
  00000000000000FC: 8B 44 24 40        mov         eax,dword ptr [rsp+40h]
  0000000000000100: 39 44 24 20        cmp         dword ptr [rsp+20h],eax
  0000000000000104: 73 20              jae         0000000000000126
  0000000000000106: 8B 44 24 20        mov         eax,dword ptr [rsp+20h]
  000000000000010A: 48 6B C0 30        imul        rax,rax,30h
  000000000000010E: 48 8B 4C 24 28     mov         rcx,qword ptr [rsp+28h]
  0000000000000113: 0F B6 44 01 01     movzx       eax,byte ptr [rcx+rax+1]
  0000000000000118: 8B 4C 24 24        mov         ecx,dword ptr [rsp+24h]
  000000000000011C: 03 C8              add         ecx,eax
  000000000000011E: 8B C1              mov         eax,ecx
  0000000000000120: 89 44 24 24        mov         dword ptr [rsp+24h],eax
  0000000000000124: EB CC              jmp         00000000000000F2
  0000000000000126: 48 83 C4 38        add         rsp,38h
  000000000000012A: C3                 ret
  000000000000012B: CC                 int         3
  000000000000012C: CC                 int         3
  000000000000012D: CC                 int         3
  000000000000012E: CC                 int         3
  000000000000012F: CC                 int         3
  0000000000000130: CC                 int         3
  0000000000000131: CC                 int         3
  0000000000000132: CC                 int         3
  0000000000000133: CC                 int         3
  0000000000000134: CC                 int         3
  0000000000000135: CC                 int         3
  0000000000000136: CC                 int         3
  0000000000000137: CC                 int         3
  0000000000000138: CC                 int         3
  0000000000000139: CC                 int         3
  000000000000013A: CC                 int         3
  000000000000013B: CC                 int         3
  000000000000013C: CC                 int         3
  000000000000013D: CC                 int         3
  000000000000013E: CC                 int         3
  000000000000013F: CC                 int         3
main:
  0000000000000140: 48 83 EC 38        sub         rsp,38h
  0000000000000144: C7 44 24 20 04 00  mov         dword ptr [rsp+20h],4
                    00 00
  000000000000014C: 8B 4C 24 20        mov         ecx,dword ptr [rsp+20h]
  0000000000000150: E8 00 00 00 00     call        ?arrayOfStructsUpdatingPointer@@YAXK@Z
  0000000000000155: 8B 4C 24 20        mov         ecx,dword ptr [rsp+20h]
  0000000000000159: E8 00 00 00 00     call        ?arrayOfStructsIndexingBasePointer@@YAXK@Z
  000000000000015E: 33 C0              xor         eax,eax
  0000000000000160: 48 83 C4 38        add         rsp,38h
  0000000000000164: C3                 ret

  Summary

          38 .chks64
          90 .debug$S
          5D .drectve
          24 .pdata
          BC .rdata
         165 .text$mn
          18 .xdata
