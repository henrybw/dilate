INCD = include
LIBD = lib.x86
BIND = bin.x86
OBJD = obj.x86

CFLAGS=/nologo /Zi /MT /Gm- /W3 /WX /Od /I$(INCD)
LINKFLAGS=/release /incremental:no /profile /nodefaultlib:oldnames.lib

LIBS= kernel32.lib gdi32.lib user32.lib shell32.lib advapi32.lib ole32.lib \
	  ws2_32.lib

all: dirs $(BIND)/preload.dll $(BIND)/test.exe

clean:
	-del /q $(BIND)\preload.* 2> nul
	-del /q $(BIND)/test.* 2> nul
	-rmdir /q /s $(OBJD) 2> nul

dirs:
	@if not exist $(OBJD) mkdir $(OBJD) && echo. Created $(OBJD)

.c{$(OBJD)}.obj::
    cl $(CFLAGS) /Fd$(OBJD)\vc.pdb /Fo$(OBJD)\ /c $<

.rc{$(OBJD)}.res:
    rc /fo$(@) /i$(INCD) $(*B).rc

$(OBJD)\preload.obj: preload.c
$(OBJD)\test.obj: test.c

$(OBJD)\preload.res : preload.rc

$(BIND)\preload.dll: $(OBJD)\preload.obj $(OBJD)\preload.res
	cl /LD $(CFLAGS) /Fe$(BIND)\preload.dll /Fd$(BIND)\preload.pdb \
		$(OBJD)\preload.obj $(OBJD)\preload.res /link $(LINKFLAGS) \
		/subsystem:console /export:DetourFinishHelperProcess,@1,NONAME \
		$(LIBD)\detours.lib $(LIBS)

$(BIND)\test.exe: $(OBJD)\test.obj
	cl $(CFLAGS) /Fe$(BIND)\test.exe /Fd$(BIND)\test.pdb $(OBJD)\test.obj \
		/link $(LINKFLAGS) /subsystem:console $(LIBS)
