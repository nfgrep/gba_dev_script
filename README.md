# gba-dev-script
This shell script uses the [devkitARM](https://github.com/devkitPro) toolchain to cross compile, link, strip, and fix a C file into a GBA ROM file.
The key commands are:

    arm-none-eabi-gcc -c main.c -fno-strict-aliasing -mthumb-interwork -mthumb -O2 -o main.o
    arm-none-eabi-gcc main.o -mthumb-interwork -mthumb -specs=gba.specs -o main.elf
    arm-none-eabi-objcopy -v -O binary main.elf main.gba
    gbafix main.gba

There is an example file, pong-example.c, included for testing.

## Requirements:
This script is intended for MacOS/UNIX environment.
This script requires devkitPro to be installed.
See the [devkitARM Getting Started](https://devkitpro.org/wiki/Getting_Started) page.

## Usage:
Place the gba-dev.sh file in the same folder as the C file you want to process, and run it. 

## Resources:
[Developing GBA games](https://www.reinterpretcast.com/writing-a-game-boy-advance-game).
[Installing devkitARM](https://devkitpro.org/wiki/Getting_Started).
