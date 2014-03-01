all: searchabi checkabi dumpabi-helper

searchabi: searchabi.c
	$(CC) -O2 -Wall -Wextra -I/usr/include/mysql -lmysqlclient_r searchabi.c -o searchabi

checkabi: checkabi.c
	$(CC) -O2 -Wall -Wextra -I/usr/include/mysql -lmysqlclient_r checkabi.c -o checkabi

dumpabi-helper: dumpabi-helper.c
	$(CC) -O2 -Wall -Wextra -lbfd dumpabi-helper.c -o dumpabi-helper

clean:
	$(RM) searchabi checkabi dumpabi-helper
