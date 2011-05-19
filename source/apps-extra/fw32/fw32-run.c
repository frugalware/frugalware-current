#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <limits.h>
#include <errno.h>
#include <unistd.h>
#include <pwd.h>
#include <sys/stat.h>
#include <sys/mount.h>
#include <sys/personality.h>

#define FW32_ROOT "/usr/lib/fw32"

static void error(const char *msg) __attribute__ ((noreturn));
static void check_mounts(void);
static int check_home_directory(const char *dst);
static void make_home_directory(char *dst);
static void mount_home(const char *src);
extern int main(int argc,char **argv);

static void
error(const char *msg)
{
	fputs(msg,stderr);

	exit(EXIT_FAILURE);
}

static void
check_mounts(void)
{
	FILE *file;
	char line[LINE_MAX], *s, *e;
	int tmp, proc, sys, dev;

	file = fopen("/proc/mounts","r");

	if(!file)
		error("Failed to open /proc/mounts.\n");

	tmp = proc = sys = dev = 0;

	while(fgets(line,sizeof line,file))
	{
		s = strchr(line,' ');
		if(!s)
			continue;
		e = strchr(++s,' ');
		if(!e)
			continue;
		*e = 0;
		if(!strcmp(s,FW32_ROOT "/tmp"))
			tmp = 1;
		else if(!strcmp(s,FW32_ROOT "/proc"))
			proc = 1;
		else if(!strcmp(s,FW32_ROOT "/sys"))
			sys = 1;
		else if(!strcmp(s,FW32_ROOT "/dev"))
			dev = 1;
	}

	if(!tmp || !proc || !sys || !dev)
	{
		fclose(file);
		error("fw32 root directories are not mounted.\n");
	}

	fclose(file);
}

static int
check_home_directory(const char *dst)
{
	FILE *file;
	char line[LINE_MAX], *s, *e;
	int found;

	file = fopen("/proc/mounts","r");

	if(!file)
		error("Failed to open /proc/mounts.\n");

	found = 0;

	while(fgets(line,sizeof line,file))
	{
		s = strchr(line,' ');
		if(!s)
			continue;
		e = strchr(++s,' ');
		if(!e)
			continue;
		*e = 0;
		if(!strcmp(s,dst))
		{
			found = 1;
			break;
		}
	}

	fclose(file);

	return found;
}

static void
make_home_directory(char *dst)
{
	char *p;

	p = dst + 1;

	errno = 0;

	while(1)
	{
		p = strchr(p,'/');

		if(!p)
			break;

		*p = 0;

		mkdir(dst,0755);

		switch(errno)
		{
			case EEXIST:
				errno = 0;
				break;
			case 0:
				break;
			default:
				error("Failed to create home directory.\n");
		}

		*p = '/';

		++p;
	}

	errno = 0;

	mkdir(dst,0755);

	if(errno != 0 && errno != EEXIST)
		error("Failed to create home directory.\n");
}


static void
mount_home(const char *src)
{
	char dst[PATH_MAX];

	snprintf(dst,sizeof dst,"%s%s",FW32_ROOT,src);

	if(check_home_directory(dst))
		return;

	make_home_directory(dst);

	if(mount(src,dst,"",MS_BIND,""))
		error("Failed to mount home directory.\n");
}

extern int
main(int argc,char **argv)
{
	struct stat st;
	struct passwd *pwd;

	if(!getuid() || geteuid())
		error("This must be run as non-root, be SETUID, and owned by root.\n");

	if(stat(FW32_ROOT,&st))
		error("fw32 root directory does not exist.\n");

	check_mounts();

	pwd = getpwuid(getuid());

	if(!pwd)
		error("Failed to retrieve password entry.\n");

	mount_home(pwd->pw_dir);

	if(personality(PER_LINUX32))
		error("Failed to enable 32 bit emulation.\n");

	if(chroot(FW32_ROOT))
		error("Failed to enter chroot.\n");

	if(setuid(getuid()))
		error("Failed to drop root permissions.\n");

	if(argc < 2)
		execl(pwd->pw_shell,pwd->pw_shell,(char *) 0);
	else
		execvp(argv[1],argv+1);

	return EXIT_SUCCESS;
}
