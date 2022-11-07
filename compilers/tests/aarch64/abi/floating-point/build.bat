cl /c hfa.c
dumpbin /disasm /out:hfa.asm hfa.obj
dumpbin /all /out:hfa.txt hfa.obj
cl /c /O2 /Fo"hfa-optimized.obj" hfa.c
dumpbin /disasm /out:hfa-optimized.asm hfa-optimized.obj
dumpbin /all /out:hfa-optimized.txt hfa-optimized.obj
