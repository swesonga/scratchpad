cd printf

cl /c /Od aarch64-abi-test-printf.cpp
dumpbin /disasm /out:printf-abi.asm aarch64-abi-test-printf.obj
dumpbin /all /out:printf-abi.txt aarch64-abi-test-printf.obj

cl /c /O2 /Fo"aarch64-abi-test-printf-o2.obj" aarch64-abi-test-printf.cpp
dumpbin /disasm /out:printf-abi-o2.asm aarch64-abi-test-printf-o2.obj
dumpbin /all /out:printf-abi-o2.txt aarch64-abi-test-printf-o2.obj

cl /c /Od aarch64-abi-test-printf-manyargs.cpp
dumpbin /disasm /out:printf-abi-many.asm aarch64-abi-test-printf-manyargs.obj
dumpbin /all /out:printf-abi-many.txt aarch64-abi-test-printf-manyargs.obj

cl /c /O2 /Fo"aarch64-abi-test-printf-manyargs-o2.obj" aarch64-abi-test-printf-manyargs.cpp
dumpbin /disasm /out:printf-abi-many-o2.asm aarch64-abi-test-printf-manyargs-o2.obj
dumpbin /all /out:printf-abi-many-o2.txt aarch64-abi-test-printf-manyargs-o2.obj

cd ../vprintf

cl /c /Od aarch64-abi-test-vprintf.cpp
dumpbin /disasm /out:vprintf-abi.asm aarch64-abi-test-vprintf.obj
dumpbin /all /out:vprintf-abi.txt aarch64-abi-test-vprintf.obj

cl /c /O2 /Fo"aarch64-abi-test-vprintf-o2.obj" aarch64-abi-test-vprintf.cpp
dumpbin /disasm /out:vprintf-abi-o2.asm aarch64-abi-test-vprintf-o2.obj
dumpbin /all /out:vprintf-abi-o2.txt aarch64-abi-test-vprintf-o2.obj

cd ..
