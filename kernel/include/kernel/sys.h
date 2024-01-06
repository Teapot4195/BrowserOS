#ifndef _KERNEL_SYS_H
#define _KERNEL_SYS_H

/* Copyright (C) 2024 Alex Huang - All Rights Reserved
 * You may use, distribute and modify this code under the terms of the GPL license.
 *
 * File is part of the BrowserOS research project, all bug reports should be
 * submitted to teapot4195[at]gmail[dot]com.
 */

/**
 * Combined header for system information collection and system setup on boot.
 *
 * BEGIN: sys information methods.
 */



/**
 * END: sys information methods.
 *
 * BEGIN: sys setup methods.
 */



/**
 * END: sys setup methods.
 */

// KPANIC
void kpanic(const char* data);

#endif //_KERNEL_SYS_H
