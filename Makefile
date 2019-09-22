INCD = include
LIBD = lib.x86
BIND = bin.x86
OBJD = obj.x86

CFLAGS=/nologo /Zi /MT /Gm- /W3 /WX /Od /I$(INCD)
LINKFLAGS=/release /incremental:no /profile /nodefaultlib:oldnames.lib

LIBS= $(LIBD)\detours.lib kernel32.lib gdi32.lib user32.lib shell32.lib \
	  advapi32.lib ole32.lib ws2_32.lib

all: dirs $(BIND)/preload.dll

clean:
	-del /q $(BIND)\preload.* 2> nul
	-rmdir /q /s $(OBJD) 2> nul

dirs:
	@if not exist $(OBJD) mkdir $(OBJD) && echo. Created $(OBJD)

.c{$(OBJD)}.obj::
    cl $(CFLAGS) /Fd$(OBJD)\vc.pdb /Fo$(OBJD)\ /c $<

.rc{$(OBJD)}.res:
    rc /fo$(@) /i$(INCD) $(*B).rc

$(OBJD)\preload.obj: preload.c

$(OBJD)\preload.res : preload.rc

$(BIND)\preload.dll: $(OBJD)\preload.obj $(OBJD)\preload.res
	cl /LD $(CFLAGS) /Fe$(BIND)\preload.dll /Fd$(BIND)\preload.pdb \
		$(OBJD)\preload.obj $(OBJD)\preload.res /link $(LINKFLAGS) \
		/subsystem:console /export:DetourFinishHelperProcess,@1,NONAME \
		$(LIBS)
