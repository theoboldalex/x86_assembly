MAKEFLAGS += --no-print-directory

all:
	@$(MAKE) compile && $(MAKE) link && $(MAKE) run
compile:
	@as hello.s -o hello.o
link:
	@gcc hello.o -o hello -nostdlib -static
run:
	@./hello

