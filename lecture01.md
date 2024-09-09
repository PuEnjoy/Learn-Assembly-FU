# Lecture01 - Syscalls

- [Lecture01 - Syscalls](#lecture01---syscalls)
  - [Introduction](#introduction)
  - [Make](#make)
    - [Using Make](#using-make)
  - [Hello, World!](#hello-world)
    - [Code Sections](#code-sections)
    - [Syscalls - sys\_exit](#syscalls---sys_exit)
  - [Seemingly trivial syscalls](#seemingly-trivial-syscalls)
  - [Syscalls - stdout](#syscalls---stdout)
    - [Example Solution](#example-solution)
    - [More about memory adresses](#more-about-memory-adresses)

## Introduction

In this lecture will follow a more hands on approach. We will create our first standalone program, use some basic system calls and learn how to assemble and execute said program.

## Make

Until we learn how to assemble and link our code i.e. learn to create the actual executable file, I will provide you with a `make` file which will do all the heavy lifting. Make is required throughout the Computer Architecture lecture and is a usefull tool in general. Check if you already have make installed (it comes build in with many linux distributions):

```bash
make --version
```

If you don't have it preinstallt, run the following command: **For Red Hat-based distros like Fedora**

```bash
sudo dnf install make
```

or for **Debian-based distros like Ubuntu:**

```bash
sudo apt-get install build-essential
```

### Using Make

After installing Make you can run make files by simply running the `make` command in the directory of the make file. You can download the makefile [here](https://github.com/PuEnjoy/Learn-Assembly-FU/blob/main/makefile). Make sure that both the make file and your assembly `.asm` file are at the same location. *For this part it is actually important that you use `.asm` as file suffix.*

```graphic
myFolder/
    ├── helloworld.asm
    └── make
```

Navigate to that directory in your terminal. Then execute `make`.
If everything worked correctly, you should see no output in your terminal. Otherwise you might see some error message. Adjust your code and try `make` again. After each change you will have to execute the `make` command again to assemble the changed file.

If everything works your directory should look like this:

```graphic
myFolder/
    ├── helloworld.asm
    ├── helloworld.o
    ├── helloworld
    └── make
```

As you can see, there should be two new files in the directory. Next to your `.asm` file there should be an object file `yourfilename.o` and one without any suffix. That is the executable. To run it, go back to your terminal and execute `./` followed by that file name. In this example case:

```bash
./helloworld
```

**Note that your program will not produce any output if it does not print anything to the console. In that case, no respone from your terminal is a good sign.** During this lecture you will learn how to print to the console and why certain errors occour in your program. So don't worry about it now.

## Hello, World

Open up your prefered text editor. No special requirements are needed; Nano, Vim, VS Code, everything works fine. Just use whatever you are most comfortable with.

Create a new file (preferably with an Assembly style suffix like `.asm`, `.a` or `.as`) and you are good to go.

*To use the Make file the ending `.asm` is required!*

### Code Sections

Assembly Programs contain multiple sections like a datasection, read only data section and uninitialised data section. Your code that will be exectuted is written in the `.text` section.

- **Task01:** create the read only data section `.rodata` and `.text` section for your program

```asm
section .rodata

section .text
 ```

We will ignore the `.rodata` section for now and concentrate on the code in the `.text` section.

Within the text section we want to declare a new lable called `_start:`. This basically just creates a name for that memory address which we can use to jump to. This lable is important since by convention it will be the entry point for our program. We also have to make it visible to others by including the `global _start` directive which we can just put at the top of our program. Why this is important and more will be explained in the chapters about the Assembler. Your code should looke similar to this:

```asm
global _start

section .rodata

section .text

_start:
    
 ```

We can populate the space after the `_start` lable with whatever instructions we want.

- **Task02:** Try writing some functionality using the instructions from the previous lecture. (Use the [Make](#make) guide to run it.)

So now that we have some *hopefully* working code, we want to execute it. Well, that is easier said than done. Before we learn how to run assembly code, you should know that your programm will most definitely crash. Even if your code has no errors and can be assembled, it will execute your instructions and then crash due to a `Segmentation fault`.

This error message really does not tell you much and especially when you are used to interpreted languages like Python, it will not get you any closer to fixing the error.

The issue is that we have to properly exit the program. It sounds very trival but most developers can probably go through life without ever specifically exiting their programs. So how do we exit the program? Simple, we tell the operating system to do it for us.

### Syscalls - sys_exit

To tell the OS to do something for us, we need to use System Calls. For those of you that have already attended the Operatingsystems and Compuer Networks lecture (OSCN), this should sound very familiar. *If not, read through the [Operating Systems refresher](https://github.com/PuEnjoy/Learn-Assembly-FU/blob/main/protectionrings.md) lecture.* We remember that our operating system is split into three protection rings.

- Ring 0 - Kernel
- Ring 1 - Drivers, Servers etc. (Deprecated for most modern system)
- Ring 2 - User / application layer

The Kernel (ring 0) and the user / application layer (ring 2) being the important ones right now. Being in ring 2, we are not entitelt to much. For any privileged functions we need to use systemcalls, which work as gateways to the operating system, to ask the OS to do it for us. It sounds silly at first but exiting itself is one of those priviliged actions. It is not realy relevant for us right now but if you are interested in why a program ist not allowed to simply exit on its own, give this a quick read:
<details>
  <summary>Why exiting is a privelige</summary>
  
## Seemingly trivial syscalls

  Prosess privileges and system security are are overwhelmingly complex topics which go far beyond this lecture. Therefore I will keep these explainations rather short.

- Security
  - Controlled Access: Allowing a process to terminate it self at will can potentially bypass critical security checks.
  - Malicous behavior: Arbitrarily terminating themselves could allows prozesses to disrupt system operations or hide its potentially malicous behavior
- Resource Management
  - The operating system is responsible for cleaning up the ressources associated with the process which, when done improperly can prevent ressources from being released, affecting the system performance
  - Exiting without the operating system can lead to inconsistencies in ressource alloation. The operating system tries to ensure a consistent state at all times
- System Stability
- Diagnosis
- Error Handling
  
  And much more are the reasons for why a process in the application layer is not allowed to exit itself. If we were to be on a Kernel level however, we could execute the necessary operations for exiting the program without the operating system interfering. Though that also means that we do not get any help regarding the cleanup, ressource management and espically with the security precautions. That is a good example for why kernel level processes are so dangerous. Even minor mistakes in exiting your program can interupt the entire system functionability leading to our beloved blue screen of death.
  
</details>
<br>

Long story short: we want to ask the operating system to properly exit our program. Operating Systems have their own 'dialect' defined in a sys_call table. For us that is the Linux kernel for 64 bit systems. You can find a cleaned copy of the syscall table in the [linuxkernel_syscalltable_64bit_raw.md](https://github.com/PuEnjoy/Learn-Assembly-FU/blob/main/linuxkernel_syscalltable_64bit_raw.md) file. *If the table is outdated you can always refere to the [original source](https://github.com/torvalds/linux/blob/master/arch/x86/entry/syscalls/syscall_64.tbl) but that won't be fun.*
For 32 bit systems refere to the [32bit syscall Table](https://syscalls32.paolostivanin.com/).

For now I have included a drastically reduced syscall table here:

<details>
<summary>Reduced Syscall Table 64bit</summary>
<table>
  <tr>
    <th>%rax</th>
    <th>System call</th>
    <th>%rdi</th>
    <th>%rsi</th>
    <th>%rdx</th>
    <th>%r10</th>
    <th>%r8</th>
    <th>%r9</th>
  </tr>
  <tr>
    <td>0</td>
    <td>sys_read</td>
    <td>unsigned int fd</td>
    <td>char *buf</td>
    <td>size_t count</td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>1</td>
    <td>sys_write</td>
    <td>unsigned int fd</td>
    <td>const char *buf</td>
    <td>size_t count</td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>2</td>
    <td>sys_open</td>
    <td>const char *filename</td>
    <td>int flags</td>
    <td>int mode</td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>3</td>
    <td>sys_close</td>
    <td>unsigned int fd</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>4</td>
    <td>sys_stat</td>
    <td>const char *filename</td>
    <td>struct stat *statbuf</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>23</td>
    <td>sys_select</td>
    <td>int n</td>
    <td>fd_set *inp</td>
    <td>fd_set *outp</td>
    <td>fd_set *exp</td>
    <td>struct timeval *tvp</td>
    <td></td>
  </tr>
  <tr>
    <td>57</td>
    <td>sys_fork</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>58</td>
    <td>sys_vfork</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>59</td>
    <td>sys_execve</td>
    <td>const char *filename</td>
    <td>const char *const argv[]</td>
    <td>const char *const envp[]</td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>60</td>
    <td>sys_exit</td>
    <td>int error_code</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>61</td>
    <td>sys_wait4</td>
    <td>pid_t upid</td>
    <td>int *stat_addr</td>
    <td>int options</td>
    <td>struct rusage *ru</td>
    <td></td>
    <td></td>
  </tr>
  <tr>
    <td>62</td>
    <td>sys_kill</td>
    <td>pid_t pid</td>
    <td>int sig</td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
  </tr>
</table>

</details>
<br>

The system call we are looking for is `sys_exit`. To execute a syscall we need to set up the registers according to the syscall table. To select `sys_exit` we need to set `rax` to 60. As we can see in the table, `rdi` also expects a value 'error_code'. If our programms executed flawlessly and we want to exit without error, we set the value of `rdi` to 0.
| %rax | System call | %rdi | %rsi | %rdx | %r10 | %r8 | %r9 |
|------|-------------|------|------|------|------|-----|-----|
| 60   | sys_exit    | int error_code | | | | | |

After setting up the affected registers, we execute the system call itself `syscall` (in many 32bit systems we need to call a specific interupt instead of directly calling a syscall).

- **Task03:** Add a proper exit to your program. (Run it again using [make](#make) and see if the errors disappeared)

All together it should look somewhat like this:

```asm
_exit:
    mov rax, 60
    mov rdi, 0
    syscall
```

## Syscalls - stdout

As you may have noticed, we have no way of printing any output. That also requires a syscall. The syscall we are looking for is `sys_write`.
| %rax | System call | %rdi | %rsi | %rdx | %r10 | %r8 | %r9 |
|------|-------------|------|------|------|------|-----|-----|
| 1    | sys_write   | unsigned int fd | const char *buf | size_t count | | | |

- `rax`: set to 1
- `rdi`: set to filedescriptor - in our case 1 for std terminal output
- `rsi`: pointer to what we want to output
- `rdx`: the length of the output

**Warning:** we are in charge of handling memory etc. `rsi` is just a pointer to the memory adress at which we want to start taking the data to writing out. `rdx` tells the operating system how many bytes it is supposed to take. Selecting to much will print out the raw memory following our message. For obvious reason we want to strictly avoid that.

Before we setup the registers we need a message to print. Since the message does not change, we want to store it in the read only data `.rodata` section.

```asm
section .rodata
    msg: db "Hello, world!", 10
    msglen: equ $ - msg
```

We included way more than you might have expected. Why?

- `msg:` defines the lable we can reference instead of directly using memory adresses
- `db` 'define bytes' is the instruction to define bytes in our memory
- `"Hello, world!"` is our ascii string we want to print out
- `10` is also part of the ascii string. It represents a line break which improves the formatting of our output

So far so clear but why do we need the second line?

- `msglen:` again defines a lable
- `equ`stands for equate meaning something is calculated here
- `$`the dollar sign references the current position in our adresspace
- `-`substraction operator
- `msg` the msg lable we defined on the previous line

Therefore we defined a lable called 'msg' where we can find the message we want to print out. We also defined a lable at which we store the result of the subtraction of the adress of the msg lable from the current location. What remains and therefore is stored at that lable is the length of what we want saved at the 'msg' lable. This is a clever trick to have a *dynamic* length of the message. *Note that adding anything inbetween these 2 instructions will change the result.*

**We can only print out ASCII Strings. There is no direct way of printing something like the value of a register without converting it to ascii and loading it into a buffer first.** To see the state of registers for debugging, we will be using an actual debugger in later lectures.

- **Task04:** Write a program that prints out a message and exits properly. (Try running it using [make](#make))

<details>
<summary>Solution and memory addresses</summary>

### Example Solution

<pre><code>
global _start

section .rodata
    msg: db 'Hello, world!', 10
    msglen: equ $ - msg

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msglen
    syscall
    jmp _exit

_exit:
    mov rax, 60
    mov rdi, 0
    syscall
</code></pre>
excuse the bad formatting. I did not want to deal with HTML-codeblocks for that simple example.

As we can see, the `mov` instruction can also load the adress of a lable into a register.

### More about memory adresses

- `[` and `]` are used to indicate that we are giving a memory adress instead of a value directly but want to use the value. `mov al, byte [msg]` would load the first byte at the adress of 'msg' into `al` as a value.
- `lea` Load Effective Address can also be used when dealing with memory addresses. It allows for more complex instructions like computing memory addresses `lea rax, [msg+8+rdi]` would load the value at the adress of (msg + 8 + value_of_rdi)

</details>
