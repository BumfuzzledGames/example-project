target = hello
cc = gcc
src = $(wildcard src/*.c)
obj.base = $(addprefix build/,$(subst /,!,$(src)))
obj.debug = $(addsuffix .debug.o,$(obj.base))
obj.optimized = $(addsuffix .optimized.o,$(obj.base))
cflags.base = -Wall -MD
cflags.debug = -g -O0 -fsanitize=address
cflags.optimized = -O3 -fomit-frame-pointer

build/$(target).debug: $(obj.debug)
	$(cc) $(cflags.base) $(cflags.debug) -o $@ $^

build/$(target).optimized: $(obj.optimized)
	$(cc) $(cflags.base) $(cflags.optimized) -o $@ $^

build:
	@mkdir -p build

.SECONDEXPANSION:
build/%.debug.o: $$(subst !,/,%) | build
	$(cc) $(cflags.base) $(cflags.debug) -c -o $@ $<

.SECONDEXPANSION:
build/%.optimized.o: $$(subst !,/,%) | build
	$(cc) $(cflags.base) $(cflags.optimized) -c -o $@ $<

.PHONY: clean
clean:
	rm -Rf build

include $(wildcard build/*.d)
