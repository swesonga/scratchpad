#include <math.h>
#include <stdio.h>

int main()
{
    union SIXTY_FOUR_BIT_VALUE {
        unsigned long long sixty_four_bit_ull;
        double sixty_four_bit_double;
    };

    SIXTY_FOUR_BIT_VALUE v1, v2;
    v1.sixty_four_bit_ull = 0x7FEFFFFFFFFFFFFF; // 1.7976931348623157E308
    v2.sixty_four_bit_ull = 0x000000000007FFFF; // 2.59032E-318

    double first = v1.sixty_four_bit_double;
    double second = v2.sixty_four_bit_double;

    // https://learn.microsoft.com/en-us/cpp/c-runtime-library/reference/fmod-fmodf?view=msvc-170
    double result = fmod(first, second);

    // See https://en.cppreference.com/w/c/io/fprintf
    printf("%e fmod %e = %e\n", first, second, result);
}
