# Zhen Lu 2017/03/12 <albert.lz07@gmail.com>

# Directories
HOMEDIR = $(shell pwd | sed -e 's/\/src.*//')
WORKDIR = $(HOMEDIR)

LIBDIR  = $(HOMEDIR)/lib
MODDIR  = $(HOMEDIR)/mod
OBJDIR  = $(HOMEDIR)/obj
BINDIR  = $(WORKDIR)/bin
VPATH   = $(LIBDIR) $(BINDIR) $(OBJDIR)

# Compiler and Archiver
#FC  = ifort
#ifeq ($(shell which mpiifort &> /dev/null; echo $$?), 0)
#    FC = mpiifort
#    LINK_SYS_LIBS = -Bdynamic
#endif
#ifeq ($(shell which ftn &> /dev/null; echo $$?), 0)
#    FC = ftn
#    LINK_SYS_LIBS = -Bstatic
#endif
FC  = ifort
CC  = icc
CXX = icc
F90 = ifort
F77 = ifort
LD  = ar rcv
AR  = ar crs
RL  = ranlib

# Compiler flags
# set debug/optimiza modes
ifeq ($(BUILD_TYPE),debug)
    FCFLAGS = -fp-stack-check -traceback -g -debug all -debug-parameters all -fPIC -vec-report0 -DDEBUG -D_DEBUG
else
    #FCFLAGS = -O2 -fPIC -vec-report0
    FCFLAGS = -O2 -fPIC
endif

LINK_LIBS = -Bstatic

CFLAGS   =
F90FLAGS =
LDFLAGS  =
INCFLAGS =
MODFLAGS = -module $(MODDIR)
DBGFLAGS = -O0 -g -CA -CB -CS -CV -traceback -debug all -ftrapuv -check all -WB -warn all
OPTFLAGS = -O3

LN = ln -s
CP = cp
RM = rm -f
RMDIR = rm -rf
OBJ = o
MAKE = make BUIDL_TYPE=$(BUILD_TYPE)
CREAT_LIBS = $(LIB_NAME).a #$(LIB_NAME).so

# External libraries
LAPACK_LIB = -mkl
