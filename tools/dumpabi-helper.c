#define PACKAGE         "dumpabi-helper"
#define PACKAGE_VERSION "1.0"
#define _GNU_SOURCE

#include <bfd.h>
#include <ftw.h>
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>
#include <sys/stat.h>

#define FTW_USED_FD 512

static int nftw_callback(const char *path,const struct stat *st,int type,struct FTW *fb)
{
  bfd *obj = 0;
  struct bfd_link_needed_list *list = 0;

  (void) st;
  (void) fb;

  if(type != FTW_F)
    goto bail;

  if((obj = bfd_openr(path,0)) == 0)
    goto bail;

  if(!bfd_check_format(obj,bfd_object))
    goto bail;

  if(!bfd_elf_get_bfd_needed_list(obj,&list))
    goto bail;

  for( ; list != 0 ; list = list->next )
    printf("%s: %s\n",path + ((strncmp(path,"./",2) == 0) ? 2 : 0),list->name);

  bail:

  if(obj != 0)
    bfd_close(obj);

  return 0;
}

extern int main(int argc,char **argv)
{
  struct stat st = {0};

  if(argc < 2 || stat(argv[1],&st) == -1 || !S_ISDIR(st.st_mode))
  {
    printf("Usage: %s <directory>\n",argv[0]);
    return EXIT_FAILURE;
  }

  chdir(argv[1]);

  nftw(".",nftw_callback,FTW_USED_FD,FTW_PHYS);

  return EXIT_SUCCESS;
}
