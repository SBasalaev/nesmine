set XA=xa.exe
%XA% -o header.o src/header.asm
%XA% -o code.o src/code.asm
%XA% -o video.o src/video.asm
copy /B /Y header.o+code.o+video.o dist/nesmine.nes
