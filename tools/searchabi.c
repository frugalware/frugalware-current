#include <mysql.h>
#include <stdio.h>
#include <string.h>
#include <regex.h>
#include <errno.h>
#include <stdlib.h>
#include <stdbool.h>

#define error(S) printf("%s (%d): %s\n",__func__,__LINE__,S)

struct entry
{
	struct entry *prev;
	struct entry *next;
	int id;
	char *name;
	char *text;
};

static regex_t filter = {0};
static MYSQL *connection = 0;
static const char server[] = "localhost";
static const char user[] = "fpm2db";
static const char password[] = "C6fO?o3qy";
static const char database[] = "frugalware2";
static struct entry *list = 0;

static void cleanup(void)
{
	struct entry *p = 0;

	if(connection)
	{
		regfree(&filter);

		mysql_close(connection);

		while(list)
		{
			free(list->name);

			free(list->text);

			p = list->next;

			free(list);

			list = p;
		}
	}
}

static struct entry *pass1(void)
{
	static const char query[] = "select pkg_id,abi from abis where pkg_id in (select id from packages where fwver = 'current' and arch = 'x86_64')";
	MYSQL_RES *result = 0;
	MYSQL_ROW row = 0;
	const char *s = 0;
	struct entry *list = 0;

	if(mysql_query(connection,query))
	{
		error(mysql_error(connection));
		return 0;
	}

	if((result = mysql_use_result(connection)) == 0)
	{
		error(mysql_error(connection));
		return 0;
	}

	while((row = mysql_fetch_row(result)) != 0)
	{
		if((s = strstr(row[1],": ")) == 0)
			continue;

		if(regexec(&filter,s+2,0,0,0) != 0)
			continue;

		if(list == 0)
		{
			list = malloc(sizeof(struct entry));
			list->prev = 0;
			list->next = 0;
		}
		else
		{
			list->next = malloc(sizeof(struct entry));
			list->next->prev = list;
			list->next->next = 0;
			list = list->next;
		}
		
		list->id = atoi(row[0]);

		list->name = 0;

		list->text = strdup(row[1]);
	}

	mysql_free_result(result);

	for( ; list && list->prev ; list = list->prev )
		;

	return list;
}

static bool pass2(void)
{
	struct entry *p = 0;
	char query[128] = {0};
	MYSQL_RES *result = 0;
	MYSQL_ROW row = 0;

	for( p = list ; p ; p = p->next )
	{
		snprintf(query,128,"select pkgname from packages where id = %d",p->id);

		if(mysql_query(connection,query))
		{
			error(mysql_error(connection));
			return false;
		}

		if((result = mysql_use_result(connection)) == 0)
		{
			error(mysql_error(connection));
			return false;
		}

		if((row = mysql_fetch_row(result)) == 0)
		{
			error(mysql_error(connection));
			return false;
		}

		p->name = strdup(row[0]);

		mysql_free_result(result);
	}

	return true;
}

static void output(void)
{
	struct entry *p = 0;

	for( p = list ; p ; p = p->next )
	{
		printf("%s: %s\n",p->name,p->text);
	}
}

extern int main(int argc,char **argv)
{
	if(argc < 2)
	{
		printf("Usage: %s <extended regular expression>\n",argv[0]);
		return EXIT_FAILURE;
	}

	if(atexit(cleanup) != 0)
	{
		error("atexit failed");
		return EXIT_FAILURE;
	}

	if(regcomp(&filter,argv[1],REG_EXTENDED | REG_NOSUB) != 0)
	{
		error("invalid regular expression");
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

	if((list = pass1()) == 0)
		return EXIT_FAILURE;

	if(!pass2())
		return EXIT_FAILURE;

	output();

	return EXIT_SUCCESS;
}
