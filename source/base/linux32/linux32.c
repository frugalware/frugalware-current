/* 
 * Copyright 2002 Andi Kleen, SuSE Labs.
 * This file is subject to the GNU General Public License v.2 
 */
#include <linux/personality.h>
#undef personality
#include <string.h>
#include <errno.h>
#include <stdio.h>

/* Make --3gb the default for buggy Java */
#define STUPID_DEFAULT 1

#ifdef STUPID_DEFAULT 
#define DFL_PER PER_LINUX32_3GB
#else
#define DFL_PER PER_LINUX32
#endif

#define  ADDR_LIMIT_3GB        0x8000000
#define  PER_LINUX32_3GB       (0x0008 | ADDR_LIMIT_3GB)

int main(int ac, char **av) 
{ 
	int pers = DFL_PER; 
	if (!av[1]) { 
		fprintf(stderr, "usage: %s [--3gb] [--4gb] program args ...\n", av[0]); 
#if DFL_PER == PER_LINUX32_3GB
		fprintf(stderr, "Default is --3gb to limit the address space of the 32bit children to 3GB\n"); 
#endif
		exit(1); 
	} 
	if (!strcmp(av[0],"linux64")) pers= PER_LINUX;
	else if (!strcmp(av[0],"linux32")) pers = DFL_PER;

	if (!strcmp(av[1], "--3gb")) {
		pers = PER_LINUX32_3GB; 
		av++; 
	}	
	if (!strcmp(av[1], "--4gb")) {
		pers = PER_LINUX32; 
		av++; 
	}	

	if (personality(pers) < 0) {
		fprintf(stderr, "Cannot set %x personality: %s\n", pers,
			strerror(errno));
		exit(1);
	} 
	execvp(av[1],av+1);
	fprintf(stderr, "Cannot execute %s: %s\n", av[1], strerror(errno)); 
	exit(1); 
} 
