
#!/bin/sh
#This script simplifies the process of turning C code into a playable GBA ROM.
#Designed for use with devkitARM toolchain.
#Developed on MacOS Mojave - 2018: YMMV.
#Author: nfgrep

#This script needs to be in the same directory as the C file you wish to convert.

echo "Enter name of the file to convert:"
read f
echo ""

arm-none-eabi-gcc -c ./$f -fno-strict-aliasing -mthumb-interwork -mthumb -O2 -o ${f//.c}.o
arm-none-eabi-gcc ${f//.c}.o -mthumb-interwork -mthumb -specs=gba.specs -o ${f//.c}.elf
if [ $? = 1 ]
then
    echo ""
    echo "Does your C file have a \"Main\" function?"
    echo ""
    exit 1
fi
arm-none-eabi-objcopy -v -O binary ${f//.c}.elf ${f//.c}.gba
gbafix ${f//.c}.gba
if [ $? = 127 ]
then
    echo ""
    echo "gbafix not found."
    echo "Possible fix is adding location of gbafix to PATH."
    echo "Default location is /opt/devkitpro/tools/bin"
    echo "Would you like to temporarily add gbafix location to PATH? [y/n]"
    read yn
    echo ""
    if [ $yn = "y" ]
    then
        PATH=$PATH:/opt/devkitpro/tools/bin
        echo ""
        echo "/opt/devkitpro/tools/bin Added to PATH"
        echo "Retry gbafix? [y/n]"
        read yn1
        echo ""
        if [ $yn1 = "y" ]
        then
            gbafix ${f//.c}.gba
            if [ $? = !0 ]
            then
                echo ""
                echo "gbafix may be installed in a different location."
                echo ""
fi
fi
fi
fi

echo ""
echo "Would you like to remove files other than the .gba rom and original C file? [y/n]"
read clninp
echo ""
if [ $clninp = "y" ]
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
