
#
# Ce Makefile contient les cibles suivantes :
#
# all   : compile le programme
# test  : lance les tests

EXEC_FILE = convert_pgm
OBJECTS = convert_pgm.o funct.o

CFLAGS = -c -g -Wall -Wextra # obligatoires

.PHONY: all clean

all: $(EXEC_FILE)

$(OBJECTS): %.o: %.c
	$(CC) $< $(CFLAGS)

$(EXEC_FILE): $(OBJECTS)
	$(CC) $^ -o $@

test: $(EXEC_FILE)
	./test.sh

clean:
	rm -f $(EXEC_FILE) *.o
	rm -f *.aux *.log *.out *.pdf
	rm -f moodle.tgz

