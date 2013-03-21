#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <limits.h>
#include <regex.h>

extern int main(void)
{
  int code = EXIT_FAILURE;
  FILE *file = 0;
  char line[LINE_MAX] = {0};
  char *video = 0;
  char *p = 0;
  regex_t re = {0};
  regmatch_t rm = {0};
  
  if((file = fopen("/proc/cmdline","rb")) == 0)
  {
    perror("fopen");
    goto bail;
  }
  
  if(fgets(line,sizeof(line),file) == 0)
  {
    perror("fgets");
    goto bail;
  }
  
  fclose(file);
  
  file = 0;
  
  if((video = strstr(line,"video=")) == 0)
  {
    remove("/etc/X11/xorg.conf.d/00-resolution.conf");
    code = EXIT_SUCCESS;
    goto bail;
  }

  if((p = strpbrk(video," \n")) != 0)
    *p = 0;

  if(regcomp(&re,"[0-9]+x[0-9]+",REG_EXTENDED) != 0)
  {
    perror("regcomp");
    goto bail;
  }
  
  if(regexec(&re,video,1,&rm,0) != 0)
  {
    remove("/etc/X11/xorg.conf.d/00-resolution.conf");
    code = EXIT_SUCCESS;
    goto bail;
  }
  
  if((file = fopen("/etc/X11/xorg.conf.d/00-resolution.conf","wb")) == 0)
  {
    perror("fopen");
    goto bail;
  }
  
  fprintf(file,
    "Section \"Screen\"\n"
    "\tIdentifier \"Screen0\"\n"
    "\tSubSection \"Display\"\n"
    "\t\tModes \"%.*s\"\n"
    "\tEndSubSection\n"
    "EndSection\n",
    rm.rm_eo - rm.rm_so,
    video + rm.rm_so
  );
  
  if(ferror(file) != 0)
  {
    perror("fwrite");
    goto bail;
  }
  
  code = EXIT_SUCCESS;
  
bail:  

  if(file != 0)
    fclose(file);

  regfree(&re);

  return code;
}

