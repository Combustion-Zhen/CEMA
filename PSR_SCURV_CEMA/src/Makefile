# Zhen Lu 2017/03/12 <albert.lz07@gmail.com>
# Makefile for KIVA_CEMA

include vars.mk

# Files
CODE      = KC
MODULES   = PSR_CEMA
LIBRARIES = main cema ck

all: install

debug:
	make BUID_TYPE=debug
	@echo "THE CODE HAS BEEN BUILT UNDER THE DEBUG MODE" > DEBUG-MODE

install: build
	@make $(CODE)

build: build-libs

build-libs:
	@echo -e "\n>> BUILDING LIBRARIES";
	@for project in $(MODULES); \
	do \
		echo -e "\n>>> BUILDING: $$project"; \
		make -C $$project; \
	done

$(CODE):
	@echo -e "\n>> BUIDLING MAIN PROJECT";
	$(FC) PSR_CEMA/PSR_CEMA.o $(LIBRARIES:%=$(LIBDIR)/lib%.a) $(LAPACK_LIB) -o $(BINDIR)/$(CODE) $(LDFLAGS)

clean:
	@for i in $(MODULES); \
	do make clean -C $$i; done
	@for i in $(PROGRAM); \
	do make clean -C $$i; done
	$(RM) $(LIBDIR)/libmain; 
	$(RM) $(BINDIR)/*

