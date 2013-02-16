#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <unistd.h>
#include <sys/stat.h>
#include <limits.h>

struct args
{
  const char *input;
  const char *language;
};

static bool mode1_args(int argc,char **argv,struct args *args)
{
  FILE *f = 0;

  if(argc != 3)
    return false;
  
  args->input = argv[2];
  
  args->language = 0;

  if((f = fopen(args->input,"rb")) == 0 || fclose(f) == EOF)
    return false;

  return true;
}

static bool mode2_args(int argc,char **argv,struct args *args)
{
  FILE *f = 0;

  if(argc != 6)
    return false;
  
  args->input = argv[5];
  
  args->language = argv[4];

  if((f = fopen(args->input,"rb")) == 0 || fclose(f) == EOF)
    return false;

  return true;  
}

static void normal_output(void)
{
  char line[LINE_MAX] = {0};
  
  while(fgets(line,sizeof(line),stdin))
    fprintf(stdout,"%s",line);
}

static void highlight_output(struct args *args)
{
  char cmd[_POSIX_ARG_MAX] = {0};

  if(args->language == 0)
    snprintf(cmd,sizeof(cmd),"/usr/bin/source-highlight --input=%s --output=STDOUT --failsafe --out-format=esc --style-file=esc.style --infer-lang",args->input);
  else
    snprintf(cmd,sizeof(cmd),"/usr/bin/source-highlight --input=%s --output=STDOUT --failsafe --out-format=esc --style-file=esc.style --lang-def=%s.lang",args->input,args->language);

  system(cmd);
}

extern int main(int argc,char **argv)
{
  struct args args = {0};
  struct stat st = {0};
 
  if(stat("/usr/bin/source-highlight",&st) == -1 || (!mode1_args(argc,argv,&args) && !mode2_args(argc,argv,&args)))
    normal_output();
  else
    highlight_output(&args);

  return EXIT_SUCCESS;
}
