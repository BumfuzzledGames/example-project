target = hello
profiles = debug optimized tiny
cc = gcc
src = $(wildcard src/*.c)
cflags.base = -Wall -MD
cflags.debug = $(cflags.base) -g -O0 -fsanitize=address
cflags.optimized = $(cflags.base) -O3 -fomit-frame-pointer
cflags.tiny = $(cflags.base) -Os

define make-build-target
  build/$(target).$1: $(addsuffix .$1.o,$(addprefix build/,$(subst /,!,$(src))))
	$(cc) $(cflags.$1) -o $$@ $$^

  .phony: $1
  $1: build/$(target).$1
endef
$(foreach p,$(profiles), \
  $(eval $(call make-build-target,$p)))

define make-object-target
  build/$(subst /,!,$2).$1.o: $2 | build
	$(cc) $(cflags.$1) -c -o $$@ $$<
endef
$(foreach p,$(profiles), \
  $(eval $(foreach s,$(src), \
    $(eval $(call make-object-target,$p,$s)))))

build:
	@mkdir -p build

.PHONY: clean
clean:
	rm -Rf build

include $(wildcard build/*.d)
