#include <mysql.h>
#include <stdio.h>
#include <string.h>
#include <regex.h>
#include <errno.h>
#include <stdlib.h>
#include <limits.h>
#include <libgen.h>
#include <stdbool.h>

#define error(S) printf("%s (%d): %s\n",__func__,__LINE__,S)

static MYSQL *connection = 0;
static const char server[] = "localhost";
static const char user[] = "fpm2db";
static const char password[] = "C6fO?o3qy";
static const char database[] = "frugalware2";
static char **abis = 0;
static int abis_size = 0;
static char **abis2 = 0;
static int abis2_size = 0;
static char **abis3 = 0;
static int abis3_size = 0;

static void freecp(char ***p,int *size)
{
	char **s = *p;
	int i = 0;
	int j = *size;
	
	for( ; i < j ; ++i )
		free(s[i]);

	free(s);

	*p = 0;

	*size = 0;
}

static void cleanup(void)
{
	if(abis)
		freecp(&abis,&abis_size);

	if(abis2)
		freecp(&abis2,&abis2_size);
		
	if(abis3)
		freecp(&abis3,&abis3_size);

	if(connection)
		mysql_close(connection);
}

static int compare(const void *A,const void *B)
{
	return strcmp( *(const char **)A, *(const char **)B);
}

static char *strvchr(const char *s)
{
	const char *p = 0;

	if(*s == '.')
	{
		++s;

		p = s + strspn(s,"0123456789");

		return (p == s) ? 0 : (char *) p;
	}

	return 0;
}

static void usort(char **p,int size,char ***outp,int *outsize)
{
	char **rv = 0;
	int i = 0;
	int j = 0;
	const char *s = 0;

	qsort(p,size,sizeof(char *),compare);

	rv = malloc(sizeof(char *) * size);

	for( ; i < size ; ++i )
	{
		if(s == 0 || strcmp(s,p[i]) != 0)
		{
			s = p[i];
			rv[j++] = strdup(s);
		}
	}

	for( i = 0 ; i < size ; ++i )
	{
		free(p[i]);
	}

	free(p);

	rv = realloc(rv,sizeof(char *) * j);

	*outp = rv;

	*outsize = j;
}

static bool pass1(void)
{
	static const char query[] = "select abi from abis where pkg_id in (select id from packages where fwver = 'current' and arch = 'x86_64')";
	MYSQL_RES *result = 0;
	MYSQL_ROW row = 0;
	int i = 0;
	int size = 128;
	char line[LINE_MAX] = {0};
	char *s = 0;
	char *abi = 0;

	if(mysql_query(connection,query))
	{
		error(mysql_error(connection));
		return true;
	}

	if((result = mysql_use_result(connection)) == 0)
	{
		error(mysql_error(connection));
		return true;
	}

	abis = malloc(size * sizeof(char *));

	while((row = mysql_fetch_row(result)) != 0)
	{
		snprintf(line,LINE_MAX,"%s",row[0]);

		if((s = strstr(line,": ")) == 0)
			continue;

		*s = 0;

		abi = s + 2;

		if(strstr(abi,".so") == 0)
			continue;

		if(i == size)
		{
			size *= 2;
			abis = realloc(abis,size * sizeof(char *));
		}

		abis[i++] = strdup(abi);
	}

	usort(abis,i,&abis,&abis_size);

	mysql_free_result(result);

	return true;
}

static bool pass2(void)
{
	static const char query[] = "select file from files where pkg_id in (select id from packages where fwver = 'current' and arch = 'x86_64')";
	MYSQL_RES *result = 0;
	MYSQL_ROW row = 0;
	int i = 0;
	int size = 128;
	char line[LINE_MAX] = {0};
	char *s = 0;
	char *abi = 0;
	void *p = 0;

	if(mysql_query(connection,query))
	{
		error(mysql_error(connection));
		return true;
	}

	if((result = mysql_use_result(connection)) == 0)
	{
		error(mysql_error(connection));
		return true;
	}

	abis2 = malloc(size * sizeof(char *));

	while((row = mysql_fetch_row(result)) != 0)
	{
		snprintf(line,LINE_MAX,"%s",row[0]);

		abi = basename(line);

		if((s = strstr(abi,".so")) == 0)
			continue;

		s += 3;

		p = bsearch(&abi,abis,abis_size,sizeof(char *),compare);

		if(p == 0)
			do
			{
				*s = 0;
	
				p = bsearch(&abi,abis,abis_size,sizeof(char *),compare);

				if(p != 0)
					break;

				*s = '.';
			}
			while((s = strvchr(s)) != 0);

		if(p == 0)
			continue;

		if(i == size)
		{
			size *= 2;
			abis2 = realloc(abis2,size * sizeof(char *));
		}

		abis2[i++] = strdup(abi);
	}

	usort(abis2,i,&abis2,&abis2_size);

	mysql_free_result(result);

	return true;
}

static void pass3(void)
{
	int i = 0;

	abis3 = malloc(abis_size * sizeof(char *));

	for( ; i < abis_size ; ++i )
	{
		if(bsearch(&abis[i],abis2,abis2_size,sizeof(char *),compare) == 0)
		{
			abis3[abis3_size++] = strdup(abis[i]);
		}
	}

	freecp(&abis,&abis_size);

	freecp(&abis2,&abis2_size);

	usort(abis3,abis3_size,&abis3,&abis3_size);
}

static void output(void)
{
	int i = 0;
	char command[_POSIX_ARG_MAX] = {0};

	for( i = 0 ; i < abis3_size ; ++i )
	{
		snprintf(command,_POSIX_ARG_MAX,"./searchabi '%s'",abis3[i]);
		system(command);
	}
}

extern int main(void)
{
	if(atexit(cleanup) != 0)
	{
		error("atexit failed");
		return EXIT_FAILURE;
	}

	if((connection = mysql_init(0)) == 0)
	{
		error(strerror(errno));
		return EXIT_FAILURE;
	}

	if(!mysql_real_connect(connection,server,user,password,database,0,0,0))
	{
		error(mysql_error(connection));
		return EXIT_FAILURE;
	}

	if(!pass1())
		return EXIT_FAILURE;

	if(!pass2())
		return EXIT_FAILURE;

	pass3();

	output();

	return EXIT_SUCCESS;
}
