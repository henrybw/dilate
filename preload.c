#define _WIN32_WINNT        0x400

#include <windows.h>
#include <detours.h>

static BOOL (WINAPI *Real_QueryPerformanceFrequency)(LARGE_INTEGER *lpFrequency)
    = QueryPerformanceFrequency;

static BOOL WINAPI Dilated_QueryPerformanceFrequency(LARGE_INTEGER *lpFrequency)
{
    if (!Real_QueryPerformanceFrequency(lpFrequency))
        return FALSE;

    lpFrequency->QuadPart >>= 1;
    return TRUE;
}

BOOL APIENTRY DllMain(HINSTANCE hModule, DWORD dwReason, PVOID lpReserved)
{
    (void)hModule;
    (void)lpReserved;

    if (DetourIsHelperProcess())
        return TRUE;

    if (dwReason == DLL_PROCESS_ATTACH)
        DetourRestoreAfterWith();

    DetourTransactionBegin();
    DetourUpdateThread(GetCurrentThread());
    if (dwReason == DLL_PROCESS_ATTACH) {
        DetourAttach((PVOID *)&Real_QueryPerformanceFrequency,
                     (PVOID)Dilated_QueryPerformanceFrequency);
    } else if (dwReason == DLL_PROCESS_DETACH) {
        DetourDetach((PVOID *)&Real_QueryPerformanceFrequency,
                     (PVOID)Dilated_QueryPerformanceFrequency);
    }
    DetourTransactionCommit();

    return TRUE;
}
