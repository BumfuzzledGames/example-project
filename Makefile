target = hello
cc = gcc
src = $(wildcard *.c)
obj = $(src:.c=.o)
cflags = -Wall -MD

$(target): $(obj)
	$(cc) $(cflags) -o $@ $^

.c.o:
	$(cc) $(cflags) -c -o $@ $<

.phony: clean
clean:
	rm -f $(obj) *.d $(target)

include $(wildcard *.d)
