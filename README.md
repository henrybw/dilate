# Dilate

This is a Windows DLL built with [Detours](https://github.com/microsoft/Detours)
that hijacks the `QueryPerformanceFrequency` function and shrinks it by a factor
of 2^23 (i.e. shifted 23 bits to the right). I made it because I wanted to make
a dumb point about a certain game forcing people to wait for hours to complete
one of its puzzles.

## Dependencies

* [Build Tools for Visual Studio](https://visualstudio.microsoft.com/downloads/)

## Building

Run `nmake` from this directory:

    C:\dilate> nmake

## Using

After building, use the supplied `setdll` tool from Detours to inject the
time-dilation DLL into your .exe of choice:

    C:\dilate> bin.x86\setdll.exe /d:bin.x86\preload.dll bin.x86\test.exe
    C:\dilate> bin.x86\test.exe

To remove the injected DLL, use `setdll` with the `/r` switch:

    C:\dilate> bin.x86\setdll.exe /r /d:bin.x86\preload.dll bin.x86\test.exe

Alternatively, you can temporarily inject the time-dilation DLL using the
`withdll` tool from Detours:

    C:\dilate> bin.x86\withdll.exe /d:bin.x86\preload.dll bin.x86\test.exe

## Acknowledgments

All contents of the `include` and `lib.x86` directories, and `setdll.exe`
and `withdll.exe` from the `bin.x86` directory, are from the [Microsoft
Detours project](https://github.com/microsoft/Detours), and are licensed
under the terms of the MIT license (see `LICENSE.detours`).
