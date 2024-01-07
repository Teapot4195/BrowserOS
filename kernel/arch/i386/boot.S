# Declare constants for the multiboot header.
.set ALIGN,    1<<0             # align loaded modules on page boundaries
.set MEMINFO,  1<<1             # provide memory map
.set FLAGS,    ALIGN | MEMINFO  # this is the Multiboot 'flag' field
.set MAGIC,    0x1BADB002       # 'magic number' lets bootloader find the header
.set CHECKSUM, -(MAGIC + FLAGS) # checksum of above, to prove we are multiboot

# Declare a header as in the Multiboot Standard.
.section .multiboot
.align 4
.long MAGIC
.long FLAGS
.long CHECKSUM

# Reserve a stack for the initial thread.
.section .bss
.align 16
stack_bottom:
.skip 16384 # 16 KiB
stack_top:

# The kernel entry point.
.section .text
.global _start
.type _start, @function
_start:
    movl $stack_top, %esp

    # Call the global constructors.
    call _init

    # BEGIN: Kernel init block

    # TODO: Ensure we are in real mode.

    # Terminal is initialized early so we can use it here and in kernel_real
    # that is, it will run even if the kernel initialization routine needs to
    # kpanic.
    call terminal_initialize

    # Call kernel real mode initializer
    call kernel_real

    # TODO: A20 Line

    # TODO: Ensure we are in protected mode.

    # END: Kernel init block

    # Transfer control to the main kernel.
    call kernel_main

    jmp panic_hang
.size _start, . - _start

# A bunch of utility functions.

.global panic_hang
.type panic_hang, @function
panic_hang:
    cli
2:  hlt
    jmp 2b

.global check_protected
.type check_protected, @function
check_protected:
    pushf
    cli

    mov %cr0, %eax
    and $0x1, %eax

    popf
    ret

.global check_a20
.type check_a20, @function
check_a20:
    pushf
    # disable interrupts
    cli

    mov %cr0, %eax
    and $0x1, %eax
    jz check_a20_real # if eax is zero, use protected mode check

check_a20_prot:
    # self contained submethod.
    push %edi
    push %esi

    mov $0x112345, %edi # odd mbyte addr
    mov $0x012345, %esi # even mbyte addr

    # save values at addr
    mov (%esi), %eax
    push %eax
    mov (%edi), %eax
    push %eax

    mov %esi, (%esi)
    mov %edi, (%edi)
    test %esi, %edi

    # restore values at addr
    pop %eax
    mov %eax, (%edi)
    pop %eax
    mov %eax, (%esi)

    mov $0x1, %eax
    jne check_a20_prot__exit
    xor %eax, %eax

check_a20_prot__exit:
    # restore clobbered registers to be self contained.
    pop %esi
    pop %edi
    popf
    ret

check_a20_real:
    # self contained submethod
    push %ds
    push %es
    push %di
    push %si

    # compare 0000:7DFE with FFFF:7E0E
    # DS has the segment for the original
    # ES has the segment for the higher value at FFFF:7E0E
    # DI stores the offset for DS
    # SI stores the offset for ES

    xor %ax, %ax # ax = 0
    mov %ax, %ds

    not %ax # ax = 0xFFFF
    mov %ax, %es

    mov $0x7DFE, %di
    mov $0x7E0E, %si

    mov %ds:(%di), %al
    push %ax
    mov %es:(%si), %al
    push %ax

    movb $0x00, %ds:(%di)
    movb $0xFF, %es:(%si)

    cmpb $0xFF, %ds:(%di)

    pop %ax
    movb %al, %es:(%si)
    pop %ax
    movb %al, %ds:(%di)

    mov $0x1, %eax

    jne check_a20_real__exit

    xor %eax, %eax

check_a20_real__exit:
    # restore clobbered registers to be self contained.
    pop %si
    pop %di
    pop %es
    pop %ds
    # save a jump by restoring here.
    popf
    ret
