/* Copyright (C) 2024 Alex Huang - All Rights Reserved
 * You may use, distribute and modify this code under the terms of the GPL license.
 *
 * File is part of the BrowserOS research project, all bug reports should be
 * submitted to teapot4195[at]gmail[dot]com.
 */

#include <string.h>

#include <kernel/tty.h>

extern _Noreturn void panic_hang(void);

/*
 * Kernel panic routine.
 *
 * TODO: Collect relevant information to then display!
 */
void kpanic(const char* data) {
    terminal_panic(data, strlen(data));

    panic_hang();
}
