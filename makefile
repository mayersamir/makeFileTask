vpath %.c ./Src
vpath %.h ./Inc

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

_OBJ = DIO.o LCD.o main.o code.o test.o
OBJ = $(patsubst %,$(ODIR)/%,$(_OBJ))

OBJS := DIO.o LCD.o main.o code.o test.o
#putting a target to be run if no target has been specified ! 
#which is bydefault is the first target at the make file !
all:$(LINKTARGET) 
	echo building is done !

DEPDIR := .deps
DEPFLAGS = -MT $@ -MMD -MP -MF $(DEPDIR)/$*.d

#here i am specifying a rule for each object file and i have stated each dependency that the file
#requires to run successfully which is in our case not only the .c but also the .h file
#cause i want my file.c to recompiled if i changed the .h file that my .c file has included
#that's why i have written all the targets at that shape 

#yeah i know Eng/nayier it is so tedious when i have got huge amount of files with huge dependencies 
#that will lead to huge writing at the make file.
#so i quite found a work around you will find it at the bottom of the file
#so the problem has been solved here by writing those lines 
#whenever you change the .h file it will make the makefile sense the 
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

#this one tells him implicitly if you can't find a specific file .o target to run 
#here how you can implicitly generate it from the make file 
# pull in dependency info for *existing* .o files


#-include $(OBJS:$(ODIR).o=$(DEPSPATH).d)


$(ODIR)/%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(CFLAGS) 
	#$(CC) -MM $(CFLAGS) $*.c > $*.d#for creating a dependency file for eache .c file 


hellomake: $(OBJ)
	$(CC) -o $@ $^ $(CFLAGS) $(LIBS)

#-include $(OBJS:.o=.d)


#This prevents make from getting confused by an actual file called `clean' 
#and causes it to continue in spite of errors from rm.
#a rule like clean got to be not at the top of the file not to be run bydefault a quick note!
#that is why i wrote .PHONY:clean

.PHONY: clean

clean:
	rm -f hellomake.exe $(ODIR)/*.o *~ core $(IDIR)/*~ 




