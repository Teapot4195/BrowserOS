/* Copyright (C) 2024 Alex Huang - All Rights Reserved
 * You may use, distribute and modify this code under the terms of the GPL license.
 *
 * File is part of the BrowserOS research project, all bug reports should be
 * submitted to teapot4195[at]gmail[dot]com.
 */

#ifndef _KERNEL_IASM_H
#define _KERNEL_IASM_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

////////////////////
// Memory
////////////////////

inline uint32_t farpeekl(uint16_t sel, void* off);

inline void farpokeb(uint16_t sel, void* off, uint8_t v);

////////////////////
// I/O Access
////////////////////

inline void outb(uint16_t port, uint8_t val);

inline uint8_t inb(uint16_t port);

inline void io_wait(void);

////////////////////
// Interrupts
////////////////////

inline bool are_interrupts_enabled();

inline unsigned long save_irqdisable(void);

inline void irqrestore(unsigned long flags);

inline void lidt(void* base, uint16_t size);

////////////////////
// CPU-related
////////////////////

// MANY ARE DIFFERENT FOR X86_64!!!

inline uint64_t rdtsc();

inline unsigned long read_cr0(void);

inline void invlpg(void* m);

inline void wrmsr(uint32_t msr_id, uint64_t msr_value);

inline uint64_t rdmsr(uint32_t msr_id);

#endif
