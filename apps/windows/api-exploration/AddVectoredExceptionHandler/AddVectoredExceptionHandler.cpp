#include <Windows.h>
#include <stdio.h>

LONG WINAPI vectored_exception_handler(struct _EXCEPTION_POINTERS* exception_info) {
    printf("Executing vectored_exception_handler\n");

    PEXCEPTION_RECORD exception_record = exception_info->ExceptionRecord;
    DWORD exception_code = exception_record->ExceptionCode;
    printf("exception_code in vectored_exception_handler: %d\n", exception_code);

    //return EXCEPTION_EXECUTE_HANDLER;
    //return EXCEPTION_CONTINUE_EXECUTION;
    return EXCEPTION_CONTINUE_SEARCH;
}


int main(int argc, char* argv[])
{
    PVOID exception_handler = AddVectoredExceptionHandler(1, vectored_exception_handler);
    if (exception_handler == NULL) {
        printf("Failed to add vectored exception handler\n");
        return 1;
    }

    for (int i = 1; i < argc; i++) {
        printf("Loading %s... ", argv[i]);
        HMODULE module = LoadLibraryA(argv[i]);
        if (module == NULL) {
            printf("failed.\n");
        }
        else {
            printf("succeeded.\n");
        }
    }

    volatile int* write_addr = nullptr;
    printf("Writing to nullptr... ");
    *write_addr = 0;
    printf("Done.\n");
}
