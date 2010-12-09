ASM=xa

dist/nesmine.nes: header.o code.o video.o
	mkdir -p dist/
	cat header.o code.o video.o > dist/nesmine.nes

header.o: src/header.asm
	$(ASM) -o header.o src/header.asm
	@if [ `stat -c%s header.o` != 16 ]; then \
		exit 1; \
	fi

code.o: src/code.asm
	$(ASM) -o code.o src/code.asm
	@if [ `stat -c%s code.o` != 16384 ]; then \
		exit 1; \
	fi

video.o: src/video.asm
	$(ASM) -o video.o src/video.asm
	@if [ `stat -c%s video.o` != 8192 ]; then \
		exit 1; \
	fi

clean:
	rm -f header.o code.o video.o
	rm -Rf dist/

run: dist/nesmine.nes
	nes dist/nesmine.nes
