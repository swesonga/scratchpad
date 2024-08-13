#include "GetLargePageMinimum.h"
#include <Windows.h>

using namespace std;

int main()
{
    size_t large_page_min = GetLargePageMinimum();
    cout << "GetLargePageMinimum: " << large_page_min;
}
