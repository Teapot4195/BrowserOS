#include <stdio.h>

#include <kernel/tty.h>
#include <kernel/sys.h>

int check_a20(void);
int check_protected(void);

/**
 * Kernel C code that expects to be run in real mode, do it before we switch to
 * protected in kernel_main
 */
void kernel_real(void) {
    printf("Hello, real mode kernel World!\n");

    if (check_protected() == 0) {
        printf("protected is not enabled\n");
    } else {
        printf("protected is enabled\n");
    }

    if (check_a20() == 0) {
        printf("A20 is not enabled\n");
    } else {
        printf("A20 is enabled\n");
    }
}

/**
 * Actual main entrypoint of the kernel, this will be run in protected so make
 * sure all BIOS calls and other important real mode operations is performed in
 * kernel_real before control is transfered here by boot.S
 */
void kernel_main(void) {
    printf("Hello, protected mode kernel World!\n");

    kpanic("Kernel shutdown.");
}
