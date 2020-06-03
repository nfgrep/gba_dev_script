# gba-dev.sh
This shell script uses the [devkitARM](https://github.com/devkitPro) toolchain to cross compile, link, strip, and fix a C file into a GBA ROM file.
The key commands are:

    arm-none-eabi-gcc -c main.c -fno-strict-aliasing -mthumb-interwork -mthumb -O2 -o main.o
    arm-none-eabi-gcc main.o -mthumb-interwork -mthumb -specs=gba.specs -o main.elf
    arm-none-eabi-objcopy -v -O binary main.elf main.gba
    gbafix main.gba

# gh.sh
This is a trimmed version of gba-dev.sh, it runs the same commands without any prompts.
It is meant for rapid prototyping/compiling.

It defaults to:
    
    -Using whatever .c file is in the same directory (./*.c)
    -Adding default location of command to path if not found
    -Removing .obj and .elf files 

## Requirements:
This script is intended for MacOS/UNIX environment.
This script requires devkitPro to be installed.
See the [devkitARM Getting Started](https://devkitpro.org/wiki/Getting_Started) page.

## Usage:
Place the gba-dev.sh file in the same folder as the C file you want to process, and run it. 

## Resources:
### Using devkitARM to make GBA ROMS/General GBA-dev info:
[Developing GBA games](https://www.reinterpretcast.com/writing-a-game-boy-advance-game).
### Installing devkitARM/gba-dev tools
[Installing devkitARM](https://devkitpro.org/wiki/Getting_Started).
