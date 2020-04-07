#!/bin/bash

#THIS IS A "HOT" VERSON OF gba-dev.sh
#THIS ASSUMES THERE IS ONLY ONE .c FILE IN SAME DIR TO COMPILE
#DOES NOT PROMPT FOR FILENAME
#DOES NOT PROMPT FOR Y/N
#DEFAULTS TO ADDING TO PATH AND REMOVING .obj AND .elf FILES

#Designed for use with devkitARM toolchain.
#Developed on PopOs(ubuntu) 19.10 - 2020
#YMMV.
#Author: nfgrep
#This script needs to be in the same directory as the C file you wish to convert.

f=./*.c

compile_c () {
    arm-none-eabi-gcc -c ./$1 -fno-strict-aliasing -mthumb-interwork -mthumb -O2 -o ${1//.c}.o
    arm-none-eabi-gcc ${1//.c}.o -mthumb-interwork -mthumb -specs=gba.specs -o ${1//.c}.elf
}

compile_c $f
COMP_RES=$?
if [ $COMP_RES = 1 ]
then
    echo "Does your C file have a \"Main\" function?"
    exit 1
elif [ $COMP_RES = 127 ]
then
    PATH=/opt/devkitpro/devkitARM/bin:$PATH
    echo "Added /opt/devkitpro/devkitARM/bin to PATH"
    echo "Retrying command..."
    compile_c $f
    if [ $? = 127 ]
    then
        echo "Still could not find command, check your installation"
        exit 1
    fi
fi

arm-none-eabi-objcopy -v -O binary ${f//.c}.elf ${f//.c}.gba
gbafix ${f//.c}.gba
if [ $? = 127 ]
then
    PATH=$PATH:/opt/devkitpro/tools/bin
    echo "/opt/devkitpro/tools/bin Added to PATH"
    echo "Retrying command..."
    gbafix ${f//.c}.gba
    if [ $? = !0 ]
    then
        echo "gbafix may be installed in a different location."
        echo "Exiting..."
        exit 1
    fi
fi
find ./ -wholename "${f//.c}.elf"  -o -wholename "${f//.c}.o" | xargs rm -v
echo ""
echo "Done..."
echo ""
