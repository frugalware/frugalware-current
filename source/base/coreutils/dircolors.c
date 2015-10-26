/*
   dircolors.c

   Parse a Slackware-style DIR_COLORS file

   Copyright (C) 1994, 1995 H. Peter Anvin

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  */


#include <config.h>

#include <sys/types.h>
#include <getopt.h>

#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <ctype.h>
#include <string.h>

#include "config.h"
#include "dircolors.h"


#define ETC_DIR "/etc"
#define USER_FILE ".dir_colors"	/* Versus user's home directory */
#define SYSTEM_FILE "/DIR_COLORS" /* System-wide file in directory SYSTEM_DIR
				    (defined on the cc command line) */

#define STRINGLEN 2048		/* Max length of a string */

enum modes { mo_sh, mo_csh, mo_ksh, mo_zsh, mo_unknown, mo_err };

const char *shells[] = { "sh", "ash", "csh", "tcsh", "bash", "ksh",
			 "zsh", NULL };

const int shell_mode[] = { mo_sh, mo_sh, mo_csh, mo_csh,
			   mo_ksh, mo_ksh, mo_zsh };

static int
figure_mode (me)
     char *me;
{
  char *shell, *shellv;
  int i;

  shellv = getenv("SHELL");
  if ( !shellv || !(*shellv) )
    {
      fprintf(stderr, "%s: No SHELL variable, and no mode option specified\n",
	      me);
      return mo_err;
    }

  if ( (shell = strrchr(shellv,'/')) != NULL )
    shell++;
  else
    shell = shellv;

  for ( i = 0 ; shells[i] ; i++ )
    {
      if ( strcmp(shell,shells[i]) == 0 )
	return shell_mode[i];
    }

  fprintf(stderr, "%s: Unknown shell `%s'\n", me, shell);
  return mo_err;
}

static void
parse_line(char **keyword, char **arg, char *line)
{
  char *p;

  *keyword = *arg = "";

  for ( p = line ; isspace(*p) ; p++ );

  if ( ! (*p) || *p == '#' )
    return;

  *keyword = p;

  for ( ; !isspace(*p) ; p++ )
    {
      if ( !(*p) )
	return;
    }

  *(p++) = '\0';

  for ( ; isspace(*p) ; p++ );
  
  if ( ! (*p) || *p == '#' )
    return;
  
  *arg = p;

  for ( ; *p != '\0' && *p != '#' ; p++ );
  for ( p-- ; isspace(*p) ; p-- );
  p++;

  *p = '\0';

  return;
}

/* Write a string to standard out, while watching for "dangerous"
   sequences like unescaped : and = characters */

static void
put_seq(str, follow)
     char *str;
     char follow;
{
  int danger = 1;

  for ( ; *str ; str++ )
    {
      switch ( *str )
	{
	case '\\':
	case '^':
	  danger = !danger;
	  break;

	case ':':
	case '=':
	  if ( danger )
	    putchar('\\');
	  /* Fall through */

	default:
	  danger = 1;
	  break;
	}

      putchar( *str );
    }

  putchar(follow);		/* The character that ends the sequence */
}    

/* Parser needs these state variables */
enum states { st_termno, st_termyes, st_termsure, st_global };

const char *slack_codes[] = {"NORMAL", "NORM", "FILE", "DIR", "LNK", "LINK",
"SYMLINK", "ORPHAN", "MISSING", "FIFO", "PIPE", "SOCK", "BLK", "BLOCK",
"CHR", "CHAR", "EXEC", "LEFT", "LEFTCODE", "RIGHT", "RIGHTCODE", "END",
"ENDCODE", NULL};

const char *ls_codes[] = {"no", "no", "fi", "di", "ln", "ln", "ln",
"or", "mi", "pi", "pi", "so", "bd", "bd", "cd", "cd", "ex", "lc", "lc", "rc",
"rc", "ec", "ec"};

enum color_opts { col_yes, col_no, col_tty };

int
main (argc, argv)
     int argc;
     char *argv[];
{
  char *p, *q;
  char *file = NULL;
  int i;
  int mode = mo_unknown;
  FILE *fp = NULL;
  char *term;
  int state;

  char line[STRINGLEN];
  char useropts[2048] = "";
  char *keywd, *arg;

  int eightbit = 1;		/* Default to 8-bit */
  int color_opt = col_no;	/* Assume --color=no */

  int strict_slack = 0;		/* Strict Slackware compatibility */
  int no_path = 0;		/* Do not search PATH */

  char *copt, *bopt;
  
  /* Parse command line */

  for ( i = 1 ; i < argc ; i++ )
    {
      if ( argv[i][0] == '-' )
	{
	  for ( p = &argv[i][1] ; *p ; p++ )
	    {
	      switch ( *p )
		{
		case 'a':
		case 's':	/* Plain sh mode */
		  mode = mo_sh;
		  break;

		case 'c':
		case 't':
		  mode = mo_csh;
		  break;

		case 'b':
		case 'k':
		  mode = mo_ksh;
		  break;

		case 'z':
		  mode = mo_zsh;
		  break;

		case 'P':
		  no_path = 1;
		  break;

		case 'S':
		  strict_slack = 1;
		  eightbit = 0;	/* Default to 7-bit */
		  break;

		case 'v':
		  printf("For %s with color-ls patch %s\n",
			 "fileutils-3.16", "3.12.0.3");
		  exit(0);

		default:
		  fprintf(stderr, "%s: Unknown option -%c\n", argv[0], *p);
		  exit(1);
		}
	    }
	}
      else
	file = argv[i];
    }

  /* Use shell to determine mode, if not already done. */

  if ( mode == mo_unknown )
    {
      mode = figure_mode(argv[0]);
      if ( mode == mo_err )
	exit(1);
    }

  /* Open dir_colors file */

  if ( !file )
    {
      p = getenv("HOME");
      if ( p && *p )
	{
	  chdir(p);
	  fp = fopen(USER_FILE, "r");
	}

      if ( !fp )
	fp = fopen(ETC_DIR SYSTEM_FILE, "r");
    }
  else
    fp = fopen(file, "r");
  
  if ( !fp )
    {
      perror(argv[0]);
      exit(1);
    }

  /* Get terminal type */

  term = getenv("TERM");
  if ( !term || !(*term) )
    term = "none";

  /* Write out common start */

  switch ( mode )
    {
    case mo_csh:
      printf("set noglob;\n\
setenv LS_COLORS \':");
      break;
    case mo_sh:
    case mo_ksh:
    case mo_zsh:
      printf("LS_COLORS=\'");
      break;
    }

  /* Start parsing that sucker */

  state = st_global;

  while ( fgets(line,STRINGLEN,fp) != NULL )
    {
      parse_line(&keywd, &arg, line);
      if ( *keywd )
	{
	  if ( strcasecmp(keywd, "TERM") == 0 )
	    {
	      if ( strcmp(arg, term) == 0 )
		{
		  state = st_termsure;
		  strict_slack = 0; /* We've fulfilled the requirement */
		}
	      else if ( state != st_termsure )
		state = st_termno;
	    }
	  else
	    {
	      if ( state == st_termsure )
		state = st_termyes; /* Another TERM can cancel */
	      
	      if ( state != st_termno )
		{
		  if ( keywd[0] == '.' )
		    {
		      putchar('*');
		      put_seq(keywd,'=');
		      put_seq(arg,':');
		    }
		  else if ( keywd[0] == '*' )
		    {
		      put_seq(keywd,'=');
		      put_seq(arg,':');
		    }
		  else if ( strcasecmp(keywd, "OPTIONS") == 0 )
		    {
		      strcat(useropts, " ");
		      strcat(useropts, arg);
		    }
		  else if ( strcasecmp(keywd, "COLOR") == 0 )
		    {
		      switch ( arg[0] )
			{
			case 'a':
			case 'y':
			case '1':
			  color_opt = col_yes;
			  break;

			case 'n':
			case '0':
			  color_opt = col_no;
			  break;

			case 't':
			  color_opt = col_tty;
			  break;
			  
			default:
			  fprintf(stderr, "%s: Unknown COLOR option `%s'\n",
				  argv[0], arg);
			  break;
			}
		    }
		  else if ( strcasecmp(keywd, "EIGHTBIT") == 0 )
		    {
		      switch( arg[0] )
			{
			case 'y':
			case '1':
			  eightbit = 1;
			      break;
			  
			case 'n':
			case '0':
			  eightbit = 0;
			  break;
			  
			default:
			  fprintf(stderr, "%s: Unknown EIGHTBIT option `%s'\n",
				  argv[0], arg);
			  break;
			}
		    }
		  else
		    {
		      for ( i = 0 ; slack_codes[i] ; i++ )
			{
			  if ( strcasecmp(keywd, slack_codes[i]) == 0 )
			    break;
			}

		      if ( slack_codes[i] )
			{
			  printf("%s=", ls_codes[i]);
			  put_seq(arg,':');
			}
		      else
			fprintf(stderr, "%s: Unknown keyword %s\n",
				argv[0], keywd);
		    }
		}
	    }
	}
    }

  fclose(fp);

  /* If strict_slack is still set, we force COLOR to no */

  if ( strict_slack )
    color_opt = col_no;

  /* Decide on the options */
  
  switch ( color_opt )
    {
    case col_yes:
      copt = "--color=always";
      break;

    case col_no:
      copt = "--color=never";
      break;

    case col_tty:
      copt = "--color=auto";
      break;
    }

  /* bopt = eightbit ? "--8bit" : "--7bit"; */
  bopt = ""; /* obsolete; cruft */

  /* Find ls in the path */
  
  if ( !no_path )
    {
      no_path = 1;		/* Assume we won't find one */

      p = getenv("PATH");
      if ( p && *p )
	{
	  while ( *p )
	    {
	      while ( *p == ':' )
		p++;

	      if ( *p != '/' )	/* Skip relative path entries */
		while ( *p && *p != ':' )
		  p++;
	      else
		{
		  q = line;
		  while ( *p && *p != ':' )
		    *(q++) = *(p++);
		  /* Make sure it ends in slash */
		  if ( *(q-1) != '/' )
		    *(q++) = '/';

		  strcpy(q, "ls");
		  if ( access(line, X_OK) == 0 )
		    {
		      no_path = 0; /* Found it */
		      break;
		    }
		}
	    }
	}
    }
  
  /* Write it out */

  switch ( mode )
    {
    case mo_sh:
      if ( no_path )
	printf("\';\n\
export LS_COLORS;\n\
LS_OPTIONS='%s %s%s';\n\
export LS_OPTIONS;\n\
ls () { ( exec ls $LS_OPTIONS \"$@\" ) };\n\
dir () { ( exec dir $LS_OPTIONS \"$@\" ) };\n\
vdir () { ( exec vdir $LS_OPTIONS \"$@\" ) };\n\
d () { dir \"$@\" ; };\n\
v () { vdir \"$@\" ; };\n", bopt, copt, useropts);
      else
	printf("\';\n\
export LS_COLORS;\n\
LS_OPTIONS='%s %s%s';\n\
ls () { %s $LS_OPTIONS \"$@\" ; };\n\
dir () { %s $LS_OPTIONS --format=vertical \"$@\" ; };\n\
vdir () { %s $LS_OPTIONS --format=long \"$@\" ; };\n\
d () { dir \"$@\" ; };\n\
v () { vdir \"$@\" ; };\n", bopt, copt, useropts, line, line, line);
      break;

    case mo_csh:
      if ( no_path )
	printf("\';\n\
setenv LS_OPTIONS '%s %s%s';\n\
alias ls \'ls $LS_OPTIONS\';\n\
alias dir \'dir $LS_OPTIONS\';\n\
alias vdir \'vdir $LS_OPTIONS\';\n\
alias d dir;\n\
alias v vdir;\n\
unset noglob;\n", bopt, copt, useropts);
      else
	printf("\';\n\
setenv LS_OPTIONS '%s %s%s';\n\
alias ls \'%s $LS_OPTIONS\';\n\
alias dir \'%s $LS_OPTIONS --format=vertical\';\n\
alias vdir \'%s $LS_OPTIONS --format=long\';\n\
alias d dir;\n\
alias v vdir;\n\
unset noglob;\n", bopt, copt, useropts, line, line, line);
      break;

    case mo_ksh:
      if ( no_path )
      printf("\';\n\
export LS_COLORS;\n\
LS_OPTIONS='%s %s%s';\n\
export LS_OPTIONS;\n\
alias ls=\'ls $LS_OPTIONS\';\n\
alias dir=\'dir $LS_OPTIONS\';\n\
alias vdir=\'vdir $LS_OPTIONS\';\n\
alias d=dir;\n\
alias v=vdir;\n", bopt, copt, useropts);
      else
	printf("\';\n\
export LS_COLORS;\n\
LS_OPTIONS='%s %s%s';\n\
export LS_OPTIONS;\n\
alias ls=\'%s $LS_OPTIONS\';\n\
alias dir=\'%s $LS_OPTIONS --format=vertical\';\n\
alias vdir=\'%s $LS_OPTIONS --format=long\';\n\
alias d=dir;\n\
alias v=vdir;\n", bopt, copt, useropts, line, line, line);
      break;

    case mo_zsh:
      if ( no_path )
      printf("\';\n\
export LS_COLORS;\n\
LS_OPTIONS=(%s %s%s);\n\
export LS_OPTIONS;\n\
alias ls=\'ls $LS_OPTIONS\';\n\
alias dir=\'dir $LS_OPTIONS\';\n\
alias vdir=\'vdir $LS_OPTIONS\';\n\
alias d=dir;\n\
alias v=vdir;\n", bopt, copt, useropts);
      else
	printf("\';\n\
export LS_COLORS;\n\
LS_OPTIONS=(%s %s%s);\n\
export LS_OPTIONS;\n\
alias ls=\'%s $LS_OPTIONS\';\n\
alias dir=\'%s $LS_OPTIONS --format=vertical\';\n\
alias vdir=\'%s $LS_OPTIONS --format=long\';\n\
alias d=dir;\n\
alias v=vdir;\n", bopt, copt, useropts, line, line, line);
      break;
    }

  exit(0);
}
