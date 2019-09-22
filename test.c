#include <windows.h>
#include <stdio.h>

int main(int argc, char **argv)
{
    LARGE_INTEGER lpCounter;
    QueryPerformanceCounter(&lpCounter);
    printf("QueryPerformanceCounter: %llu\n", lpCounter.QuadPart);

    LARGE_INTEGER lpFrequency;
    QueryPerformanceFrequency(&lpFrequency);
    printf("QueryPerformanceFrequency: %llu\n", lpFrequency.QuadPart);

    return 0;
}
