#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <sys/wait.h>
#include <utmp.h>

extern int main(void)
{
  pid_t pid = -1;
  int status = 0;
  char tty[128] = {0};

  if(getuid() != 0 || geteuid() != 0)
  {
    puts("Must be run as root.");
    return EXIT_FAILURE;
  }

  if(!isatty(STDIN_FILENO) || !isatty(STDOUT_FILENO) || !isatty(STDERR_FILENO))
  {
    puts("Must be connected to a TTY.");
    return EXIT_FAILURE;
  }

  if(ttyname_r(STDIN_FILENO,tty,sizeof(tty)) != 0)
  {
    puts("Cannot find the TTY device.");
    return EXIT_FAILURE;
  }

  if((pid = fork()) == -1)
  {
    puts("Failed to fork.");
    return EXIT_FAILURE;
  }

  if(pid == 0)
  {
    execl("/bin/login","/bin/login",(void *) 0);
    _exit(EXIT_FAILURE);
  }

  waitpid(pid,&status,0);  

  if(strncmp(tty,"/dev/",5) == 0)
    logout(tty+5);
  else
    logout(tty);

  return EXIT_SUCCESS;
}
