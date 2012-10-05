all: searchabi checkabi

searchabi: searchabi.c
	$(CC) -O2 -Wall -Wextra -I/usr/include/mysql -lmysqlclient_r searchabi.c -o searchabi

checkabi: checkabi.c
	$(CC) -O2 -Wall -Wextra -I/usr/include/mysql -lmysqlclient_r checkabi.c -o checkabi

clean:
	$(RM) searchabi checkabi
