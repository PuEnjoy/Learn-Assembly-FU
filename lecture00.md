# What is Assembler Language?
You are most likely already familiar with a higher-level programming language like Python, Java, or even C. These languages offer a high level of abstraction, provide extensive functionality with many predefined functions, and can run on almost any system regardless of hardware. However, computers do not understand these languages natively. The only language they truly understand is machine language, which looks like this:
```asm
00000FFF  00B801000000    
00001005  BF01000000      
0000100A  488D342500204000
00001012  BA0D000000
00001017  0F05
```
As you can see, machine code is not very readable for humans. This is where Assembly Language comes in—it's the human-readable form of machine code:
```asm
add [rax+0x1],bh
mov edi,0x1
lea rsi,[0x402000]
mov edx,0xd
syscall
```
Working at such a low level can have its advantages and drawbacks, depending on your preference. Apart from some very basic support from the assembler, which we will introduce later, you are largely on your own when it comes to tasks like memory allocation, variable management, or advanced control structures. Your entire code must be written using the few basic instructions supported by your system's instruction set architecture (ISA). While this makes learning the language relatively straightforward, solving complex problems can be quite challenging.

# Basic Memory
I won’t cover much about memory here since that will be a significant part of the lecture later. However, I will introduce some fundamentals necessary for understanding Assembly.

When people talk about computer memory or storage, they often refer to long-term persistent storage, such as their SSD or HDD, as "main memory" or "main storage." While the term RAM (Random Access Memory) is correct, referring to your SSD as "main memory" is not. In computer architecture, RAM is what we refer to as main memory. Your slow but large persistent storage, like an SSD, is not relevant for us at the moment.

Your computer uses more than just these two types of memory, though. In addition to lesser-known types like caches, your CPU has its own type of memory called registers. Registers are relatively small, holding only a few bytes, but they are incredibly fast and are located as close as possible to where they are needed—inside the processor itself. Depending on your system architecture, these registers can store values of 16, 32, or 64 bits. Operations such as calculations are performed on these registers.

# Differend Dialects 
There isn't just one Assembly language; rather, there are many different dialects. The specifics are defined by your system architecture, manufacturer, and operating system. For this course, we will be using the Netwide Assembler (NASM) for Intel x86-64 bit Linux kernel systems. You don't need to worry too much about what this means just yet. If you are already running any Linux distribution on an Intel x86-64 bit CPU, you are all set to follow the lecture. Following along on a 32-bit system should also be no problem as long as the proper conversions are done. However, using different operating systems, kernels, or architectures, which may result in different dialects and system calls, can be quite challenging and is not recommended. Instead, try using the university’s Andora System.

# First NASM instructions
This lecture will be a rather theoretical introduction to all the fundamental instruction you need for your first program. You should try to memorize some basics but there is no need to learn this lecture by heart. You will automatically learn the details during the later more learning by doing style lectures. *If you are having a hard time understanding the lecture and want to try out some examples and run some simple assembly code before compleading the following lectures, you can jump to the [Setting up your playground](#setting-up-your-playground) section and return to this point after.* - Currently not finished

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

I borrowed this table from Siedler's [NASM-Cheat-Sheet](https://github.com/Siedler/NASM-Assembly-Cheat-Sheet/blob/master/Cheat-Sheet.md), which I will likely reference throughout this lecture. I highly recommend it as a resource. I will be working on a reworked English version soon.

The table shows the most important registers, which are conventionally linked to certain functionalities. Note that while you can break these conventions and use registers freely, you should avoid using the "forbidden" registers listed below.
<table style="background-color: ##364452;color: ##364452;margin: 1em 0;border: 1px solid #a2a9b1;border-collapse: collapse;">
<tbody>
<tr><th>Register</th><th>Related</th><th>Reason</th></tr>
<tr><td>rbp</td><td>ebp, bp, bpl</td><td>Pointer to the previous stack frame.</td></tr>
<tr><td>rsp</td><td>esp, sp, sple</td><td>Marks the position of the first stack entry.</td></tr>
<tr><td>rbx</td><td>ebx, bx, bh, bl</td><td>Often needed for program execution.</td></tr>
<tr><td>r12</td><td>r12d, r12w, r12b</td><td>Reserved for internal program flow.</td></tr>
<tr><td>r13</td><td>r13d, r13w, r13b</td><td>Reserved by convention.</td></tr>
<tr><td>r14</td><td>r14d, r14w, r14b</td><td>Reserved by convention.</td></tr>
<tr><td>r15</td><td>r15d, r15w, r15b</td><td>Reserved by convention.</td></tr>
<tr><td>rip</td><td>ip</td><td>Program counter.</td></tr>
<tr><td>rflags</td><td>eflags, flags</td><td>Holds status flags (zero flag, carry flag, etc.).</td></tr>
</tbody>
<caption></caption>
</table>

This leaves you with the following scratch registers, which you can use freely:
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

### Related registers
As you may have already noticed in the previous tables, each register has related sub-registers. For example, the `rax` register has the following related registers:

<table style="border-collapse: collapse;">
  <tr>
    <td style="border: 1px solid black; padding: 8px;">rax</td>
    <td style="border: 1px solid black; padding: 8px;">eax</td>
    <td style="border: 1px solid black; padding: 8px;">ax</td>
    <td style="border: 1px solid black; padding: 8px;">ah</td>
    <td style="border: 1px solid black; padding: 8px;">al</td>
  </tr>
</table>

All of these registers are part of the `rax` register. The difference is which part they refer to:

- `rax` refers to the full 64-bit register.
- `eax` refers to the lower 32 bits of the same register.
- `ax` refers to the lower 16 bits.
- `al` refers to the lowest 8 bits.
- `ah` refers to the higher 8 bits of the 16-bit `ax` register, **not** the highest 8 bits of the 64-bit rax register.

## Basic Instructions
In the following section, I will introduce some very basic NASM instructions. We will cover more as needed throughout the course.
```asm
mov rax, 365         ;set the value of rax to 365
mov rcx, rax         ;set the value of rcx to the value of rax (365)
mov al, 8            ;set the lower 8 bit of rax to 8 !since rax was 365 which takes up more than 8bit, the value of rax is NOT 8 but 264

add rax, 5          ;adds 5 to rax (264) and store the result in rax
add rcx, rax        ;adds the value of rax to the value of rcx and store in rcx

sub rax, 5          ;subtracts 5 from rax and stores the result in rax
sub rax, rcx        ;subtracts rcx from rax and stores the result in rax
```
These instructions are straightforward and should be memorized. While these instructions can be used with either a value or a register as the second parameter, some instructions have more specific rules:
```asm
mul rsi             ;will multiply the value in rax by the value in rsi.
div rsi             ;divides the value in rdx:rax by rsi (unsigned interger division)
```
**Note to multiplication:** `mul rsi` will multiply the value in rax with rsi and stores the result in rax. Since multiplications tend to overflow the size of the registers, the result will overflow into rdx if needed. <br>
**Note to division:** `div rsi` will devide rdx:rax (where rdx hold the high part and rax the low part of the number) and saves the result of the unsigned integer division to rax and the remainder to rdx. It is crutial to check that there is no value unrelated to the division stored in rdx and that a potentially important value in rdx is safed before clearing it!
## Conditional controll flow
The instructions we've covered so far are a good start, but to implement more complex logic, we need a way to manipulate the flow and execution of the code based on certain conditions—in other words, we need "if statements."

Unfortunately, NASM does not offer the type of if statements you might already know from higher-level languages. For example, in Assembly, conditional instructions like:
```python
if (i < my_value):
    print(f"some value smaller 5: {i}")
```
 or simple loops like:
```python
for (i in range(len(my_arr))): 
    print(my_arr[i])
```
are not possible in the same form. As you will see later, even a simple `print` statement requires multiple instructions. <br>
So how can we implement these instructions?
### Jumps and flags
In many modern high-level programming languages, the `goto` or `jump` operation is considered deprecated or discouraged. However, in Assembly, jumps are essential. They allow us to jump to specific memory locations and continue executing the program from there. Thanks to the assembler (which we will cover in later lectures), we can set labels in our code to mark these locations, making our lives easier since we don't have to deal with raw memory addresses directly. 
```asm
my_lable:
    add rax, 1
    jmp my_lable
```
The above code snippet creates an endless loop of incrementing the rax register.

[addGraphic]

With only the jmp instruction, we can either skip over some code by jumping to a later instruction or create an endless loop by jumping to a previous part of the code. However, we need a way to jump only when certain conditions are met.

Besides the registers used for loading and manipulating data, there are certain status flags we can use. These flags are set based on the results of previous operations and can help us create conditional branches.
### Comparing registers and conditional jumps
| Flag | Flagname      | Usecase                       |
| ---- | ------------- | ----------------------------- |
| `sf` | "signed flag" | set for negative values       |
| `zf` | "zero flag"   | set if result is 0            |


The table shows some of the most frequently used flags. Lesser used flags include:
   - CF (carry flag),
   - OF (overflow flag),
   - AF (auxiliary carry flag / adjust flag)
   - PF (parity flag)

These flags are set by preceeding comparison instructions.
#### Compare Instruction
The compare instruction `cmp reg1, reg2/value` subtracts the values without storing the result and sets the processors status bits in the flags  register accordingly. 
```asm
cmp rax, rdi        ;compares value of rax with value of rdi
cmp rax, 9          ;compares value of rax with 9
```
#### Test Instruction
The test instruction `test reg1, reg2/value` performs a logical AND ($\land$) operations and sets the flags mentioned in the previous table.
```asm
test rax, rdi        ;bitwise rax AND rdi
test rax, 9          ;bitwise rax AND 9
```
#### Conditional jumps
With the status bit in the flags register set, we can now use conditional jumps to controll our program flow.

| Instruction         | Jump name                                | Usecase                                                                |
| ------------------- | ---------------------------------------- | ---------------------------------------------------------------------- |
| `je`                | "Jump equal"                             | jump if comparison was equal                                           |
| `jne`               | "Jump not equal"                         | jump if comparison was not equal                                       |
| `jb`                | "Jump below"                             | jump for $\text{reg1} < \text{reg2}$ or $\text{reg1} < \text{value}$   |
| `ja`                | "Jump above"                             | jump for $\text{reg1} > \text{reg2}$ or $\text{reg1} > \text{value}$   |
| `jl`                | "Jump less"                              | jump for $\text{reg1} < \text{reg2}$ or $\text{reg1} < \text{value}$   |
| `jg`                | "Jump greater"                           | jump for $\text{reg1} > \text{reg2}$ oder $\text{reg1} > \text{value}$ |
| `jz`                | "Jump zero"                              | same as `je`                                                           |
| `jnz`               | "Jump not zero"                          | same as `jne`                                                          |
| `jle` / `jge` / ... | "Jump less equal" / "Jump greater equal" | same as other jumps but includes equal                                 |

#### Conditional jumps example
```asm
_start:
    xor rax, rax            ;zero out rax
    mov rdi, 21
    add rax, 17
    cmp rax, rdi            ;compare rax (17) and rdi (21)
    je .equalLable          ;jump if equal -> no jump -> next instruction executes
    add rax, 1              ;add 1 to rax
    jle .lessEqualLable     ;jump if rax is less or equal to rdi -> jump
    add rax, 1              ;NOT executed since we jumped over it
    jmp _end                ;NOT executed

    .equalLable:            ;Also not executed
        mov rax, 69         ;
        jmp _end            ;
        
    .lessEqualLable:        ;destination of jump -> following code will execute
        mov rax, 42         ;set rax to 42
        jmp _end            ;jump to _end lable (regardless of any flags)

_end:
    ;exit the program       
    
```
## End of the Lecture
In this lecture, you received a brief introduction to Assembly language and learned about the basic instructions needed to start writing your first program. I don’t expect anyone to have memorized all the instructions and details on the first read—this lecture is meant to introduce you to the fundamentals. For the first few programs you create, you will need to frequently reference documentation until these details become second nature. For this, I recommend Siedler's [NASM-Assembly-Cheat-Sheet](https://github.com/Siedler/NASM-Assembly-Cheat-Sheet/blob/master/Cheat-Sheet.md), which provides an excellent overview of registers, volatile vs. non-volatile registers, arithmetic instructions, coding conventions, and much more. Currently, only a German version of this Cheat-Sheet is available, but I will be working on an English version soon. Once completed, you will find a reference to it here.

Please note that as of right now, you are still missing some crucial information to create your first running program. In particular, you need to learn how to communicate with your operating system. This knowledge is essential for performing privileged tasks, including properly exiting the program. We will cover these topics in the next lecture: [lecture01-Syscalls](linktolecture).



 ## [optional] Setting up your playground (Under construction)
 In previous lectures of the Computer Architectures class, you never learned how to create standalone programs in Assembly. Instead for each exercise sheet you were provided a wrapper written in C. You would simply create a function in Assembly which would then be linked to the wrapper which created the actual runable program. This was because you had never heard of any operating system functionality before and creating a functional Assembly program requires quite a lot of interaction which your OS. You will learn more about these steps in the next lecture. After compleading this course and learning how to create stand alone programs, we will go back to the old exercise sheets which will hide all kinds of OS-functions from you. The playground will do the same. I will provide you with a C-Wrapper and a Makefile below. You simply don't ask any questions and those tools will do all the heavy lifting for you, until we learn to understand them. <br>
 I only recommend setting up and using the playground if you struggle to understand the basic instructions and use of registers. If these concepts are clear, simply continue with the theoretical lectures until you learn to write your first Assembly program. <br>
 The provides makefile will compile, link and assemble the the C-Wrapper and your code. The C-Wrapper provides the functionality to print out the values of some registers. You can try out some instructions and then view the affected registers. If you are good with theoretical learning and want to save time, simply continue the lectures. We will learn how to write and debug programs later.
 ### Cloning the playground
 Go to the following [repository]() and clone it to your prefered location. More details are available on the repo itself.
 ### Direct download
 Directly download the [C-Wrapper]() and [Makefile]() to the same location.
 ### Using the playground
 Make sure that you do not change the name of the `playground.asm` file. Open the file with any texteditor. It will look something like this:
 ```asm
section text
global _start:

_start:
    ;your code goes here
 ``` 
After writing your code save the file. Navigate to the file location in your terminal. Execute the Makefile by typing `MAKE`. You will see some new files appear including one named `result`. This is an executable file which you can run with `./result`.