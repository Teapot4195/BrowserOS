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

.global panic_hang
.type panic_hang, @function
panic_hang:
    cli
2:  hlt
    jmp 2b

.size _start, . - _start
