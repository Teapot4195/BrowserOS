#include <string.h>

#include <kernel/tty.h>

extern void panic_hang(void);

/*
 * Kernel panic routine.
 *
 * TODO: Collect relevant information to then display!
 */
void kpanic(const char* data) {
    terminal_panic(data, strlen(data));

    panic_hang();
}
