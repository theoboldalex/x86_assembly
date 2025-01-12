MAKEFLAGS += --no-print-directory

all:
	@$(MAKE) compile && $(MAKE) link && $(MAKE) run
compile:
	@as meow.s -o meow.o
link:
	@gcc meow.o -o meow -nostdlib -static
run:
	@./meow

