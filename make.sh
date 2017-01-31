#!/bin/bash
xa -o header.o src/header.asm
xa -o code.o src/code.asm
xa -o video.o src/video.asm
cat header.o code.o video.o > nesmine.nes
