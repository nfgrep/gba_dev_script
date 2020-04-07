#!/bin/bash
#This script simplifies the process of turning C code into a playable GBA ROM.
#Designed for use with devkitARM toolchain.
#Developed on MacOS Mojave - 2018
#Updated on PopOs(Ubuntu) 19.10 - 2020
#YMMV.
#Author: nfgrep
#This script needs to be in the same directory as the C file you wish to convert.


compile_c () {
    arm-none-eabi-gcc -c ./$1 -fno-strict-aliasing -mthumb-interwork -mthumb -O2 -o ${1//.c}.o
    arm-none-eabi-gcc ${1//.c}.o -mthumb-interwork -mthumb -specs=gba.specs -o ${1//.c}.elf
}

echo "Enter name of the file to convert:"
read f
echo ""

compile_c $f
COMP_RES=$?
if [ $COMP_RES = 1 ]
then
    echo "Does your C file have a \"Main\" function?"
    exit 1
elif [ $COMP_RES = 127 ]
then
    echo "Temporarily add it's location to your PATH? [y/n]"
    read q_arm
    echo ""
    if [ $q_arm = "y" ]
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
    else
        echo "exiting..."
        exit 1
    fi  
fi

arm-none-eabi-objcopy -v -O binary ${f//.c}.elf ${f//.c}.gba
gbafix ${f//.c}.gba
if [ $? = 127 ]
then
    echo "gbafix not found."
    echo "temporarily add it's location to PATH? [y/n]"
    read q_gbafix
    echo ""
    if [ $q_gbafix = "y" ]
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
fi

echo "Remove files other than the .gba rom and original C file? [y/n]"
read cln
if [ $cln = "y" ]
then
    echo ""
    echo "---Files to be removed---"
    find ./ -name "${f//.c}.elf"  -o -name "${f//.c}.o"
    echo "-------------------------"
    echo ""
    echo "Would you like to proceed? [y/n]"
    read rmyn
    echo ""
    if [ $rmyn = "y" ]
    then
        find ./ -name "${f//.c}.elf"  -o -name "${f//.c}.o" | xargs rm -v
        echo ""
        echo "Done..."
        echo ""
fi
fi
