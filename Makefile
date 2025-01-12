MAKEFLAGS += --no-print-directory

all:
	@$(MAKE) compile && $(MAKE) link && $(MAKE) run
compile:
	@as shat.s -o shat.o
link:
	@gcc shat.o -o shat -nostdlib -static
run:
	@./shat

