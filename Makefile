target = hello
cc = gcc
src = $(wildcard src/*.c)
obj = $(addsuffix .o,$(addprefix build/,$(subst /,!,$(src))))
cflags = -Wall -MD

build/$(target): $(obj)
	$(cc) $(cflags) -o $@ $^

build:
	@mkdir -p build

.SECONDEXPANSION:
build/%.o: $$(subst !,/,%) | build
	$(cc) $(cflags) -c -o $@ $<

.PHONY: clean
clean:
	rm -Rf build

include $(wildcard build/*.d)
