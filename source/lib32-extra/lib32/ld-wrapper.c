#include <stdlib.h>
#include <unistd.h>

typedef struct {
	char *key;
	char *value;
} table_pair_t;

static void prepare_environment(void) {
	static const table_pair_t table[] = {
		{ "LIBGL_DRIVERS_PATH",  "/usr/lib32/dri" },
		{        "WINEDLLPATH", "/usr/lib32/wine" },
		{                 NULL,             NULL  }
	};
	size_t i;

	for( i = 0 ; table[i].key != NULL ; ++i ) {
		setenv(table[i].key, table[i].value, 1);
	}
}

static void launch_binary(char **argv) {
	static const char ld[] = "/lib32/ld-linux.so.2";

	execv(ld, argv);
}

int main(int argc, char **argv) {
	(void) argc;

	prepare_environment();

	launch_binary(&argv[0]);

	return 1;
}
