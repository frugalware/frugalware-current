#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <termios.h>
#include <limits.h>
#include <sys/utsname.h>
#include <time.h>
#include <utmp.h>
#include <sys/wait.h>

#define error(S) fprintf(stderr,"%s: %s\n",__func__,S)

static int print_issue(void)
{
  struct utsname uts = {{0},{0},{0},{0},{0},{0}};
  char tty[128] = {0};
  char ttyline[128] = {0};
  int users = 0;
  struct utmp *ut = 0;
  char domainname[HOST_NAME_MAX+1] = {0};
  time_t now = 0;
  struct tm *tm = 0;
  static const char *weekdays[] =
  {
    "Sun",
    "Mon",
    "Tue",
    "Wed",
    "Thu",
    "Fri",
    "Sat"
  };
  static const char *months[] =
  {
    "Jan",
    "Feb",
    "Mar",
    "Apr",
    "May",
    "Jun",
    "Jul",
    "Aug",
    "Sep",
    "Oct",
    "Nov",
    "Dec"
  };
  static const char issue[] = "/etc/issue";
  FILE *file = 0;
  char line[LINE_MAX] = {0};
  char *s = 0;
  char c = 0;
  char pc = 0;

  uname(&uts);

  if(ttyname_r(STDIN_FILENO,tty,sizeof(tty)) != 0)
  {
    error(strerror(errno));
    return 1;
  }

  if(strncmp(tty,"/dev/",5) == 0)
    snprintf(ttyline,sizeof(ttyline),"%s",tty+5);
  else
    snprintf(ttyline,sizeof(ttyline),"%s",tty);

  setutent();

  while((ut = getutent()) != 0)
    if(ut->ut_type == USER_PROCESS)
      ++users;

  endutent();

  if(getdomainname(domainname,sizeof(domainname)) != 0)
  {
    error(strerror(errno));
    return 1;
  }

  time(&now);

  tm = localtime(&now);

  if((file = fopen(issue,"rb")) == 0)
  {
    error(strerror(errno));
    return 1;
  }

  while(fgets(line,sizeof(line),file))
  {
    for( s = line ; *s != 0 ; ++s, pc = c )
    {
      c = *s;

      if(c == '\\')
        continue;

      if(pc != '\\')
      {
        fputc(c,stdout);
        continue;
      }

      switch(c)
      {
        case 's':
          fprintf(stdout,"%s",uts.sysname);
          break;
        case 'n':
          fprintf(stdout,"%s",uts.nodename);
          break;
        case 'r':
          fprintf(stdout,"%s",uts.release);
          break;
        case 'v':
          fprintf(stdout,"%s",uts.version);
          break;
        case 'm':
          fprintf(stdout,"%s",uts.machine);
          break;
        case 'l':
          fprintf(stdout,"%s",ttyline);
          break;
        case 'u':
        case 'U':
          fprintf(stdout,"%d",users);
          if(c == 'U')
            fprintf(stdout," %s",(users > 1) ? "users" : "user");
          break;
        case 'o':
          fprintf(stdout,"%s",domainname);
          break;
        case 'd':
          fprintf(stdout,"%3.3s %3.3s %2.2d %4.4d",weekdays[tm->tm_wday],months[tm->tm_mon],tm->tm_mday,tm->tm_year+1900);
          break;
        case 't':
          fprintf(stdout,"%2.2d:%2.2d:%2.2d",tm->tm_hour,tm->tm_min,tm->tm_sec);
          break;
        default:
          fputc(c,stdout);
          break;
      }
    }
  }

  fclose(file);

  return 0;
}

extern int main(void)
{
  pid_t pid = -1;
  int status = 0;
  char tty[128] = {0};

  if(getuid() != 0 || geteuid() != 0)
  {
    error("Must be run as root.");
    return EXIT_FAILURE;
  }

  if(!isatty(STDIN_FILENO) || !isatty(STDOUT_FILENO) || !isatty(STDERR_FILENO))
  {
    error(strerror(errno));
    return EXIT_FAILURE;
  }

  if(ttyname_r(STDIN_FILENO,tty,sizeof(tty)) != 0)
  {
    error(strerror(errno));
    return EXIT_FAILURE;
  }

  if((pid = fork()) == -1)
  {
    error(strerror(errno));
    return EXIT_FAILURE;
  }

  if(pid == 0)
  {
    if(print_issue() == 1)
      _exit(EXIT_FAILURE);
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
