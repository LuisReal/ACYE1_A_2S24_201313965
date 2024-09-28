#!/usr/bin/bash
set -e 

echo -e Enter the name of the file 1:
read file1

echo -e Enter the name of the file 2:
read file2

echo --------------- ASSEMBLING ----------------
echo Assembling file1: $file1.s - $(date +%H:%M:%S)
aarch64-linux-gnu-as -o $file1.o $file1.s

echo Assembling file2: $file2.s - $(date +%H:%M:%S)
aarch64-linux-gnu-as -o $file2.o $file2.s

if [ $? -eq 0 ]; then
    echo Assembling successful
else
    echo Assembling failed
    exit 1
fi

echo ==========================================

echo ---------------- LINKING -----------------
echo Linking file1: $file1.o - $(date +%H:%M:%S)
echo Linking file2: $file2.o - $(date +%H:%M:%S)
aarch64-linux-gnu-ld -o programa $file1.o $file2.o

if [ $? -eq 0 ]; then
    echo Object file created
else
    echo Object file not created
    exit 1
fi

echo ==========================================

echo Done compiling and linking file: programa - $(date +%H:%M:%S)

if [ -z "$1" ]; then
    echo Running the file: programa - $(date +%H:%M:%S)
    qemu-aarch64 ./programa
    rm programa.o programa

elif [ "debug" == "$1" ]; then
    echo Debugging the file: programa - $(date +%H:%M:%S)
    qemu-aarch64 -g 1234 ./programa &
    gnome-terminal --window --maximize -- bash -c "gdb-multiarch -q --nh -ex 'set architecture aarch64' -ex 'file programa' -ex 'target remote localhost:1234' -ex 'layout split' -ex 'layout regs'; rm programa.o programa"

else 
    echo Invalid argument
    exit 1
fi