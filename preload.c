#define _WIN32_WINNT        0x400

#include <windows.h>
#include <detours.h>

BOOL APIENTRY DllMain(HINSTANCE hModule, DWORD dwReason, PVOID lpReserved)
{
    (void)hModule;
    (void)lpReserved;

    if (DetourIsHelperProcess())
        return TRUE;

    if (dwReason == DLL_PROCESS_ATTACH)
        DetourRestoreAfterWith();

    return TRUE;
}
