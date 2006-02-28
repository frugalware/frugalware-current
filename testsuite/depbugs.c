/*
 *  depbugs.c for Frugalware
 * 
 *  Copyright (c) 2006 by Miklos Vajna <vmiklos@frugalware.org>
 * 
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, 
 *  USA.
 */

#include <stdio.h>
#include <string.h>
#include <alpm.h>

int main(int argc, char **argv)
{
	PM_DB *local, *repo;
	PM_LIST *i, *j, *k, *l;

	if(argc<2)
	{
		fprintf(stderr, "%s: find deps which requires pkgs from other repos\n", argv[0]);
		fprintf(stderr, "usage: %s <repo>\n", argv[0]);
		return(0);
	}
	if(alpm_initialize("/") == -1)
	{
		fprintf(stderr, "failed to initilize alpm library (%s)\n",
			alpm_strerror(pm_errno));
		return(1);
	}
	if(alpm_set_option(PM_OPT_DBPATH, (long)PM_DBPATH) == -1)
	{
		fprintf(stderr, "failed to set option DBPATH (%s)\n",
			alpm_strerror(pm_errno));
		return(1);
	}
	local = alpm_db_register("local");
	if(local==NULL)
	{
		fprintf(stderr, "could not register 'local' database (%s)\n",
			alpm_strerror(pm_errno));
		return(1);
	}
	repo = alpm_db_register(argv[1]);
	if(repo==NULL)
	{
		fprintf(stderr, "could not register '%s' database (%s)\n",
			argv[1], alpm_strerror(pm_errno));
		return(1);
	}

	for(i=alpm_db_getpkgcache(repo); i; i=alpm_list_next(i))
	{
		PM_PKG *pkg=alpm_list_getdata(i);
		char *pkgname = alpm_pkg_getinfo(pkg, PM_PKG_NAME);

		for(j=alpm_pkg_getinfo(pkg, PM_PKG_DEPENDS); j; j=alpm_list_next(j))
		{
			int found=0;
			char *ptr, *str = strdup(alpm_list_getdata(j));

			if((ptr = strchr(str, '>')) || (ptr = strchr(str, '<')) || (ptr = strchr(str, '=')))
				*ptr = '\0';
			for(k=alpm_db_getpkgcache(repo); !found&&k; k=alpm_list_next(k))
			{
				PM_PKG *p=alpm_list_getdata(k);
				if(!strcmp(alpm_pkg_getinfo(p, PM_PKG_NAME), str))
					found=1;
				else
					for(l=alpm_pkg_getinfo(p, PM_PKG_PROVIDES); !found&&l; l=alpm_list_next(l))
					{
						PM_PKG *pr=alpm_list_getdata(l);
						if(!strcmp(alpm_pkg_getinfo(pr, PM_PKG_NAME), str))
							found=1;
					}
			}
			if(!found)
				printf("%s (%s)\n", pkgname, alpm_list_getdata(j));
			free(str);
		}
	}
	return(0);
}
