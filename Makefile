MAKEFLAGS += --no-print-directory

all:
	@$(MAKE) compile && $(MAKE) link && $(MAKE) run
compile:
	@as meow.s -o out/meow.o
link:
	@gcc out/meow.o -o out/meow -nostdlib -static
run:
	@./out/meow
clean:
	@rm out/*

