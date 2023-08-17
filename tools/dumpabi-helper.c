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

struct bfd_link_needed_list
{
  struct bfd_link_needed_list *next;
  bfd *by;
  const char *name;
};

typedef struct bfd_link_needed_list bfd_list;

static inline int is_elf(const char *path)
{
  static const unsigned char sign[4] = { 0x7F, 'E', 'L', 'F' };
  int rv = 0;
  FILE *file = 0;
  unsigned char bytes[4] = {0};

  if((file = fopen(path,"rb")) == 0)
    goto bail;

  if(fread(bytes,1,4,file) != 4)
    goto bail;

  if(memcmp(bytes,sign,4) != 0)
    goto bail;

  rv = 1;

  bail:

  if(file != 0)
    fclose(file);

  return rv;
}

static inline bfd_list *bfd_list_get_nth_entry(bfd_list *p,size_t n)
{
  size_t i = 0;

  for( ; i < n && p != 0 ; ++i, p = p->next )
    ;

  return p;
}

static int nftw_callback(const char *path,const struct stat *st,int type,struct FTW *fb)
{
  bfd *obj = 0;
  bfd_list *list = 0;
  bfd_list *p = 0;
  size_t n = 0;

  (void) st;
  (void) fb;

  if(type != FTW_F)
    goto bail;

  if(strncmp(path,"./",2) == 0)
    path += 2;

  if(!is_elf(path))
    goto bail;

  if((obj = bfd_openr(path,0)) == 0)
    goto bail;

  if(!bfd_check_format(obj,bfd_object))
    goto bail;

  if(!bfd_elf_get_bfd_needed_list(obj,&list))
    goto bail;

  for( p = list ; p != 0 ; p = p->next, ++n )
    ;

  while(n > 0)
  {
    p = bfd_list_get_nth_entry(list,--n);

    printf("%s: %s\n",path,p->name);
  }

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
