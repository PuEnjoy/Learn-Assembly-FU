.PHONY: all clean
.PRECIOUS: %.o

ASM = nasm
ASMFLAGS = -f elf64  # 64-bit Linux
LD = ld
LDFLAGS = -m elf_x86_64  # 64-bit Linux

SRCS = $(wildcard *.asm)
OBJS = $(SRCS:.asm=.o)
TARGETS = $(SRCS:.asm=)

all: $(TARGETS)

%: %.o
	@$(LD) $(LDFLAGS) -o $@ $<

%.o: %.asm
	@$(ASM) $(ASMFLAGS) -o $@ $<

clean:
	rm -f $(OBJS) $(TARGETS)
