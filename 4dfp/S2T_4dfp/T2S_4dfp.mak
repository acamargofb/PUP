#$Id: T2S_4dfp.mak,v 1.6 2009/02/25 21:29:25 avi Exp $
#$Log: T2S_4dfp.mak,v $
# Revision 1.6  2009/02/25  21:29:25  avi
# accommodate 64bit architecture
#
# Revision 1.5  2007/08/31  05:18:06  avi
# linux and X86 Solaris compliant
#
# Revision 1.4  2007/01/18  06:52:12  avi
# new TRX
#
# Revision 1.3  2004/11/24  21:12:51  rsachs
# Added 'writeifh.c' to C source list.
#
# Revision 1.2  2004/03/11  07:06:48  avi
# correct release prerequisite
#
# Revision 1.1  2004/03/11  07:03:53  avi
# Initial revision
#

PROG	= T2S_4dfp
CSRCS	= ${PROG}.c
FSRCS	= reorder.f
OBJS	= ${CSRCS:.c=.o} ${FSRCS:.f=.o}
TRX	= ${NILSRC}/TRX
FLP	= ${NILSRC}/flip_4dfp
LOBJS	= ${TRX}/rec.o ${TRX}/Getifh.o ${TRX}/endianio.o ${FLP}/cflip.o

CFLAGS	= -I${TRX} -O
ifeq (${OSTYPE}, linux)
	CC	= gcc ${CFLAGS}
	FC	= gcc -O -ffixed-line-length-132 -fno-second-underscore
	Q	= $(wildcard /usr/lib*/libgfortran.so.1)
	ifeq ($(Q), "")
		LIBS	= -lm -lg2c
	else
		LIBS	= -lm -lgfortran
	endif
else
	CC	= cc ${CFLAGS}
	FC	= f77 -O -I4 -e
	LIBS	= -lm
endif

${PROG}: $(OBJS)
	${FC} -o $@ ${OBJS} ${LOBJS} ${LIBS}

.c.o:
	${CC} -c $<
.f.o:
	${FC} -c $<

release: ${PROG}
	chmod 775 ${PROG}
	/bin/mv ${PROG} ${RELEASE}

clean:
	rm ${OBJS} ${PROG}

checkout:
	co $(CSRCS) 

checkin:
	ci $(CSRCS) 
