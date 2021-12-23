#define _CRT_SECURE_NO_WARNINGS

#include <stdio.h>
#include <string.h>

int main(int argc, char** argv)
{
    if (argc < 3)
    {
        printf("Usage: argtofile outputfile outputstring\n");
        return 0;
    }

    FILE* fileHandle;

    if ((fileHandle = fopen(argv[1], "w+")) == NULL)
    {
        printf("fopen failed!\n%s\n", strerror(errno));
        return -1;
    }

    int retcode = 0;

    // Write a string to the file.
    if (fputs(argv[2], fileHandle) != 0)
    {
        printf("fwrite failed!\n%s\n", strerror(errno));
        retcode = -1;
    }

    if (fclose(fileHandle))
    {
        printf("fclose failed!\n%s\n", strerror(errno));
        retcode = -1;
    }

    if (retcode == 0)
    {
        printf("Successfully wrote to output file %s\n", argv[1]);
    }

    return retcode;
}