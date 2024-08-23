# What is Assembler Language?
You are most likely already familiar with some form of a higher level programming language like Python, Java or even C. They offer a high level of abstraction, offer a lot of functionality with many predefined functions and work on almost any system and regardless of hardware. This is great but in reality our computers do not understand these languages natively. The only language they can speak is maschine language:
```asm
00000FFF  00B801000000    
00001005  BF01000000      
0000100A  488D342500204000
00001012  BA0D000000
00001017  0F05
```
This however is not so readable for us. Introducing Assembler Language, the human readable form of machine code:
```asm
add [rax+0x1],bh
mov edi,0x1
lea rsi,[0x402000]
mov edx,0xd
syscall
```
Depending on your preference, working on such a low level comes with many caviats or advantages. Besides some very basic support from the Assembler which we will introduce later, there is no one to hold your hands when it comes to memory allocation, variables or advanced controll structures. Your entire code has to function on the few basic instructions supported by your instruction set architecture (ISA). This makes learning the language quite easy but implementing complex problems rather hard.

# Basic Memory
I will not cover much about memory here since that will be a rather large part later in the lecture. I will however introduce some fundamentals which are required for understanding Assembly.
When talking about your computers memory or storage many people tend to refere to their long term persitant storage i.e. their SSD or HDD as main memory or main storage. The random access memory will then often be labled as RAM. While the RAM abbreviation is correct, the reference to your SSD is not. When it comes to computer architecture the random access memory (RAM) is what we refere to as main memory. Your slow but large persisten storage is irrelevant for us at the momement. Your computer uses more than just those to types of memory though. Next to some lesser know memory like caches your CPU has his own type of memory called registers. Registers are rather small, holding only a few bytes but are increadibly fast and located as close as possible to where they are needed at, which is inside the procressor itself. Depending on your systemarchitecture, these registers can be loaded with for example 16, 32 or 64 bit values. Instructions like calculations can then be performed on these registers.

# Differend Dialects 
There is not one Assembly language, rather there is many different dialects. The specifics are defined by your systemarchitecture and manufacturer as well as the operating system. For this course we will be using the Netwide Assembler for Intel x86-64 bit Linux kernel systems. You technically do not yet need to know what this means. If you are already running any Linuxdistribution on an Intel x86-64 bit native CPU, you are all set to follow the lecture. Following along on a 32-bit System should also be no problem as long as the proper conversions are done. Following along on different Operating System kernels or architectures resulting in different dialects and syscalls can be quite challenging and is not recommended. Try using the Universitiys Andora System instead.

# First NASM instructions
After the quite theoretical introduction I want to continue with a more learning by doing style attempt. After introducing some registers and instruction I will let you free on your first project with explainations only where they are needed.

### Setting up your enviornment
Create a new file called firstasm.asm `touch firstasm.asm` - other common file extentions are `.a` and `.as` but I will be using `.asm` during this lecture. <br>
Open the file with any text editor and you are good to go. 

## Registers
### Main registers

<table style="background-color: ##364452;color: ##364452;margin: 1em 0;border: 1px solid #a2a9b1;border-collapse: collapse;">
<tbody>
  <tr><th>Register</th><th style="width: 12%;" colspan="8">Accumulator</th><th style="width: 12%;" colspan="8">Counter</th><th style="width: 12%;" colspan="8">Data</th><th style="width: 12%;" colspan="8">Base</th><th style="width: 12%;" colspan="8">Stack Pointer</th><th style="width: 12%;" colspan="8">Stack Base Pointer</th><th style="width: 12%;" colspan="8">Source</th><th style="width: 12%;" colspan="8">Destination</th></tr>
  <tr style="text-align: center;"><th scope="row">64-bit</th><td colspan="8">rax</td><td colspan="8">rcx</td><td colspan="8">rdx</td><td colspan="8">rbx</td><td colspan="8">rsp</td><td colspan="8">rbp</td><td colspan="8">rsi</td><td colspan="8">rdi</td></tr>
  <tr style="text-align: center;"><th scope="row">32-bit</th><td style="width: 6%;" colspan="4"></td><td style="width: 6%;" colspan="4">eax</td><td style="width: 6%;" colspan="4"></td><td style="width: 6%;" colspan="4">ecx</td><td style="width: 6%;" colspan="4"></td><td style="width: 6%;" colspan="4">edx</td><td style="width: 6%;" colspan="4"></td><td style="width: 6%;" colspan="4">ebx</td><td style="width: 6%;" colspan="4"></td><td style="width: 6%;" colspan="4">esp</td><td style="width: 6%;" colspan="4"></td><td style="width: 6%;" colspan="4">ebp</td><td style="width: 6%;" colspan="4"></td><td style="width: 6%;" colspan="4">esi</td><td style="width: 6%;" colspan="4"></td><td style="width: 6%;" colspan="4">edi</td></tr>
  <tr style="text-align: center;"><th scope="row">16-bit</th><td style="width: 9%;" colspan="6"></td><td style="width: 3%;" colspan="2">ax</td><td style="width: 9%;" colspan="6"></td><td style="width: 3%;" colspan="2">cx</td><td style="width: 9%;" colspan="6"></td><td style="width: 3%;" colspan="2">dx</td><td style="width: 9%;" colspan="6"></td><td style="width: 3%;" colspan="2">bx</td><td style="width: 9%;" colspan="6"></td><td style="width: 3%;" colspan="2">sp</td><td style="width: 9%;" colspan="6"></td><td style="width: 3%;" colspan="2">bp</td><td style="width: 9%;" colspan="6"></td><td style="width: 3%;" colspan="2">si</td><td style="width: 9%;" colspan="6"></td><td style="width: 3%;" colspan="2">di</td></tr>
  <tr style="text-align: center;"><th scope="row">8-bit</th><td style="width: 9%;" colspan="6"></td><td style="width: 1.5%;" colspan="1">ah</td><td style="width: 1.5%;" colspan="1">al</td><td style="width: 9%;" colspan="6"></td><td style="width: 1.5%;" colspan="1">ch</td><td style="width: 1.5%;" colspan="1">cl</td><td style="width: 9%;" colspan="6"></td><td style="width: 1.5%;" colspan="1">dh</td><td style="width: 1.5%;" colspan="1">dl</td><td style="width: 9%;" colspan="6"></td><td style="width: 1.5%;" colspan="1">bh</td><td style="width: 1.5%;" colspan="1">bl</td><td style="width: 9%;" colspan="7"></td><td style="width: 1.5%;" colspan="1">spl</td><td style="width: 9%;" colspan="7"></td><td style="width: 1.5%;" colspan="1">bpl</td><td style="width: 9%;" colspan="7"></td><td style="width: 1.5%;" colspan="1">sil</td><td style="width: 9%;" colspan="7"></td><td style="width: 1.5%;" colspan="1">dil</td></tr>
</tbody>
<caption></caption>
</table>
I borrowed this table from [Siedlers NASM-Cheat-Sheet]
(https://github.com/Siedler/NASM-Assembly-Cheat-Sheet/blob/master/Cheat-Sheet.md) which I will probably keep referencing to during this lecture and can not recommend enough. I will be working on a reworked english version soon. <br>
The table shows the most important registers which are by convention linked to certain functionalities. Note that you can break that convention and use them freely as long as you avoid the "forbidden" registers from the table below.<br> 
The following registers should not be used. Later we might get to know some expections to this rule but for now just avoid them all together.
<table style="background-color: ##364452;color: ##364452;margin: 1em 0;border: 1px solid #a2a9b1;border-collapse: collapse;">
<tbody>
<tr><th>Register</th><th>Related</th><th>Reason</th></tr>
<tr><td>rbp</td><td>ebp, bp, bpl</td><td>Pointer to previous stackframe.</td></tr>
<tr><td>rsp</td><td>esp, sp, sple</td><td>Marks position to first stackentrie.</td></tr>
<tr><td>rbx</td><td>ebx, bx, bh, bl</td><td>Needed for programm execution.</td></tr>
<tr><td>r12</td><td>r12d, r12w, r12b</td><td>Reserved for internal programflow.</td></tr>
<tr><td>r13</td><td>r13d, r13w, r13b</td><td>Reserved by definition.</td></tr>
<tr><td>r14</td><td>r14d, r14w, r14b</td><td>Reserved by definition.</td></tr>
<tr><td>r15</td><td>r15d, r15w, r15b</td><td>Reserved by definition.</td></tr>
<tr><td>rip</td><td>ip</td><td>Program counter.</td></tr>
<tr><td>rflags</td><td>eflags, flags</td><td>zero flag, carry flag, etc.</td></tr>
</tbody>
<caption></caption>
</table>

This leaves you with the following scratch registers which you can use freely:
<table style="border-collapse: collapse;">
  <tr>
    <td style="border: 1px solid black; padding: 8px;">rax</td>
    <td style="border: 1px solid black; padding: 8px;">rcx</td>
    <td style="border: 1px solid black; padding: 8px;">rdx</td>
    <td style="border: 1px solid black; padding: 8px;">rsi</td>
    <td style="border: 1px solid black; padding: 8px;">rdi</td>
    <td style="border: 1px solid black; padding: 8px;">r8</td>
    <td style="border: 1px solid black; padding: 8px;">r9</td>
    <td style="border: 1px solid black; padding: 8px;">r10</td>
    <td style="border: 1px solid black; padding: 8px;">r11</td>
  </tr>
</table>

