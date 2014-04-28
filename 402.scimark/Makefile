.SUFFIXES: .c .o

.c.o:
	$(CC) $(CFLAGS) -c $<

all: scimark2 

CC ?= cc
CFLAGS ?= -O2
LDFLAGS = 

OBJS = FFT.o kernel.o Stopwatch.o Random.o SOR.o SparseCompRow.o \
	array.o MonteCarlo.o LU.o scimark2.o 

scimark2 : $(OBJS)
	$(CC) $(CFLAGS) -o scimark2 $(OBJS) $(LDFLAGS) -lm

clean:
	rm $(OBJS) scimark2
