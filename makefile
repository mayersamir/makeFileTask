vpath %.c ./Src
vpath %.h ./Inc
vpath %.d ./Dependencies
vpath %.o ./obj
IDIR =Inc
CC=gcc
CFLAGS=-I$(IDIR)
LINKTARGET=hellomake
#i found that putting my object files so sloppy randomly
#so i have included a folder to generate my object files inside
ODIR=obj
LDIR =../lib
SRCDIR=Src
LIBS=-lm
DEPSPATH=Dependencies
_DEPS = code.h DIO.h LCD.h main.h test.h
DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))
LIBS_TO_BE_LINKED=
_OBJ = DIO.o LCD.o main.o code.o test.o
OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))

OBJS := DIO.o LCD.o main.o code.o test.o
#putting a target to be run if no target has been specified ! 
#which is bydefault is the first target at the make file !

SHELL = /bin/bash

#putting the all target as the first target here to be able to 
#write from the terminal make_S and everything will work just fine !
.PHONY= all
all:$(LINKTARGET)
	echo building is done !

DEPDIR := .deps
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.d
sources=main.c DIO.c LCD.c code.c test.c
ECHOING_SUCCESSFULLY=@echo building is done !
DeletingPhrase=@echo Deleting has been done successfully !
#for getting the version of the compiler !
UNAME_S:=$(shell uname -s)


#here i am specifying a rule for each object file and i have stated each dependency that the file
#requires to run successfully which is in our case not only the .c but also the .h file
#cause i want my file.c to recompiled if i changed the .h file that my .c file has included
#that's why i have written all the targets at that shape 

#yeah i know Eng/nayier it is so tedious when i have got huge amount of files with huge dependencies 
#that will lead to huge writing at the make file.
#so i quite found a work around you will find it at the bottom of the file
#so the problem has been solved here by writing those lines 
#whenever you change the .h file it will make the makefile sense the 


#note i did that for only studying and getting used to the syntax 
#it can be removed easily
$(ODIR)/test.o : test.c $(IDIR)/test.h
	$(CC) -c -o $@ $< $(CFLAGS) 


$(ODIR)/main.o : main.c $(IDIR)/LCD.h $(IDIR)/main.h
	$(CC) -c -o $@ $< $(CFLAGS) 


$(ODIR)/LCD.o : LCD.c $(IDIR)/DIO.h $(IDIR)/LCD.h
	$(CC) -c -o $@ $< $(CFLAGS) 


$(ODIR)/DIO.o : DIO.c $(IDIR)/DIO.h $(IDIR)/code.h
	$(CC) -c -o $@ $< $(CFLAGS) 


$(ODIR)/code.o : code.c $(IDIR)/code.h
	$(CC) -c -o $@ $< $(CFLAGS) 

#providing metadata about the packages and libraries that my project uses
#if it can be found 
#which eases and gives the required metadata for the packages that have been used

ifneq ($(LIBS_TO_BE_LINKED),)
	COMPILE_FLAGS += $(shell pkg-config --cflags $(LIBS_TO_BE_LINKED))
	LINK_FLAGS += $(shell pkg-config --libs $(LIBS_TO_BE_LINKED))
endif

#this one tells him implicitly if you can't find a specific file .o target to run 
#here how you can implicitly generate it from the make file 
# pull in dependency info for *existing* .o files


#-include $(OBJS:$(ODIR).o=$(DEPSPATH).d)


$(ODIR)/%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS) 
	#$(CC) -MM $(CFLAGS) $*.c > $*.d#for creating a dependency file for eache .c file 

#a general rult for automating the production of the .d files 
${DEPSPATH}/%.d: %.c
	@set -e; rm -f $@; \
	$(CC) -M $(CPPFLAGS) $< > $@.$$$$; \
	sed 's,\($*\)\.o[ :]*,\1.o $@ : ,g' < $@.$$$$ > $@; \
	rm -f $@.$$$$

# Detect operating system
#in order to be able to detect the extension of the files produced in compilation process
#cause each operating system has its own file extensions and i am trying to make the 
#make file generic as i could
    prorab_private_os := $(shell uname)
    prorab_private_os := $(patsubst MINGW%,Windows,$(prorab_private_os))
    prorab_private_os := $(patsubst MSYS%,Windows,$(prorab_private_os))
    prorab_private_os := $(patsubst CYGWIN%,Windows,$(prorab_private_os))

    ifeq ($(prorab_private_os), Windows)
        prorab_os := windows
    else ifeq ($(prorab_private_os), Darwin)
        prorab_os := macosx
    else ifeq ($(prorab_private_os), Linux)
        prorab_os := linux
    else
        $(info Warning: unknown OS, assuming linux)
        prorab_os := linux
    endif

    os := $(prorab_os)

    # set library extension
    ifeq ($(os), windows)
        prorab_lib_extension := .dll
    else ifeq ($(os), macosx)
        prorab_lib_extension := .dylib
    else
        prorab_lib_extension := .so
    endif

    soext := $(prorab_lib_extension)

    ifeq ($(os), windows)
        exeext := .exe
    else
		#assuming the operating system is linux or unix
        exeext := .elf
	endif

#to be able to invoke the target by both names its name or its name + the file extension
hellomake: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)
	${ECHOING_SUCCESSFULLY} ${UNAME_S}

hellomake${exeext}: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)
	${ECHOING_SUCCESSFULLY} ${UNAME_S}



-include $(patsubst %,$(DEPSPATH)/%,$(sources:.c=.d))



depend: $(sources)
	makedepend $(CFLAGS) $^
#-include $(OBJS:.o=.d)

#This prevents make from getting confused by an actual file called `clean' 
#and causes it to continue in spite of errors from rm.
#a rule like clean got to be not at the top of the file not to be run bydefault a quick note!
#that is why i wrote .PHONY:clean

.PHONY: clean

clean:
	rm -f hellomake.exe; \
	rm -f $(ODIR)/*.o *~ core $(IDIR)/*~; \
	rm -f $(DEPSPATH)/*.d
	${DeletingPhrase}

