
#!/bin/sh
#This script simplifies the process of turning C code into a playable GBA ROM.
#Designed for use with devkitARM toolchain.
#Developed on MacOS Mojave - 2018: YMMV.
#Author: nfgrep

#This script needs to be in the same directory as the C file you wish to convert.

echo "Enter name of the file to convert:"
read f


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
  echo "gbafix not found."
  echo "Possible fix is adding location of gbafix to PATH."
  echo "Default location is /opt/devkitpro/tools/bin"
  echo "Would you like to temporarily add gbafix location to PATH? [y/n]"
  read yn
  if [ $yn = "y" ]
  then
    PATH=$PATH:/opt/devkitpro/tools/bin
    echo "/opt/devkitpro/tools/bin Added to PATH"
    echo "Retry gbafix? [y/n]"
    read yn1
    if [ $yn1 = "y" ]
    then
      gbafix ${f//.c}.gba
      if [ $? = !0 ]
      then
        echo "gbafix may be installed in a different location."
      fi
    fi

  fi
fi
