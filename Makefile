# NJE-II Makefile.

# Change these settings to what you want!
CDEFS=-DUSG -DNBCONNECT -DNBSTREAM -DUSE_XMIT_QUEUE -DUNIX \
	-DUSE_SOCKOPT -DSOCKBUFSIZE=8192 -DUSE_ENUM_TYPES -DDEBUG \
	-DCONFIG_FILE='"/usr/local/nje/etc/nje.cf"' \
	-DPID_FILE='"/usr/local/nje/etc/nje.pid"' \
	-DDEF_SPOOL_DIR_RULE='"/usr/local/nje/var/spool/bitnet/"' \
	-DDEF_POSTMAST_SPOOL_DIR='"/usr/local/nje/var/spool/bitnet/POSTMAST"' \
	-DVMNET_IP_PORT=175

# Compiler options:
CC=gcc
CPP=gcc -E
CFLAGS= -g -O2 -Wpacked -Wpadded ${CDEFS}
RANLIB=ranlib
INSTALL=install

# chgrp group name:
NJEGRP=nje
# Name for the send program (sometimes send is already in use):
SEND=tell
PRINT=njeprint

# Install locations.
PREFIXDIR=/usr/local/nje
MANDIR=${PREFIXDIR}/man
LIBDIR=${PREFIXDIR}/lib
BINDIR=${PREFIXDIR}/bin
ETCDIR=${PREFIXDIR}/etc

SRC= bcb_crc.c bmail.c file_queue.c headers.c io.c main.c \
	nmr.c protocol.c read_config.c recv_file.c send.c \
	send_file.c unix.c unix_brdcst.c unix_build.c gone_server.c \
	ucp.c unix_mail.c unix_route.c unix_tcp.c util.c detach.c \
	unix_files.c sendfile.c bitsend.c read_config.c qrdr.c bitcat.c \
	ndparse.c libndparse.c libreceive.c receive.c mailify.c \
	mailify.sh clientutils.h sysin.sh version.sh unix_msgs.c \
	bintree.c nje_fopen.c sysnerr.c maxlines.c
HDR=consts.h ebcdic.h headers.h site_consts.h unix_msgs.h
OBJ=file_queue.o headers.o io.o main.o \
	nmr.o nmr_unix.o protocol.o read_config.o recv_file.o send.o \
	send_file.o unix.o unix_brdcst.o unix_build.o gone_server.o \
	ucp.o unix_mail.o unix_route.o unix_tcp.o util.o \
	bcb_crc.o bmail.o detach.o unix_files.o sendfile.o bitsend.o \
	qrdr.o logger.o uread.o bitcat.o unix_msgs.o nje_fopen.o sysnerr.o maxlines.o
OBJmain= main.o headers.o unix.o file_queue.o read_config.o \
	io.o nmr.o unix_tcp.o bcb_crc.o unix_route.o \
	util.o protocol.o send_file.o recv_file.o logger.o \
	unix_brdcst.o unix_files.o gone_server.o detach.o \
	libustr.o liblstr.o unix_msgs.o rscsacct.o version.o \
	nmr_unix.o bintree.o nje_fopen.o sysnerr.o maxlines.o
CLIENTLIBobj=		\
	clientlib.a(libndparse.o)	clientlib.a(libdondata.o)  \
	clientlib.a(libetbl.o)		clientlib.a(libsendcmd.o)  \
	clientlib.a(libreadcfg.o)	clientlib.a(libexpnhome.o) \
	clientlib.a(liburead.o)		clientlib.a(libuwrite.o)   \
	clientlib.a(libsubmit.o)	clientlib.a(libasc2ebc.o)  \
	clientlib.a(libebc2asc.o)	clientlib.a(libpadbla.o)   \
	clientlib.a(libhdrtbx.o)	clientlib.a(libndfuncs.o)  \
	clientlib.a(libustr.o)		clientlib.a(liblstr.o)	   \
	clientlib.a(logger.o)		clientlib.a(libstrsave.o)  \
	clientlib.a(nje_fopen.o)	clientlib.a(libmcuserid.o) \
	clientlib.a(sysnerr.o)		clientlib.a(maxlines.o)
OBJbmail=bmail.o clientlib.a
OBJsend=send.o clientlib.a
OBJsendfile=sendfile.o clientlib.a
OBJbitsend=bitsend.o clientlib.a
OBJtransfer=transfer.o clientlib.a
OBJqrdr=qrdr.o clientlib.a
OBJucp=ucp.o clientlib.a
OBJygone=ygone.o clientlib.a
OBJacctcat=acctcat.o clientlib.a
OBJreceive=receive.o libreceive.o clientlib.a
OBJmailify=mailify.o libreceive.o clientlib.a
OBJnjeroutes= njeroutes.o bintree.o nje_fopen.o sysnerr.o
OBJnamesfilter= namesfilter.o namesparser.o
PROGRAMS=njed receive bmail ${SEND} sendfile njeroutes bitsend \
	qrdr ygone transfer acctcat ucp $(MAILIFY) namesfilter mailify
ObsoletePROGRAMS= bitcat ndparse
OTHERFILES=example.cf exampleRt.header unix.install file-exit.cf msg-exit.cf
SOURCES=$(SRC) $(HDR) Makefile $(OTHERFILES) $(MAN1) $(MAN8)
MAN1=man/send.1 man/sendfile.1 man/transfer.1 man/ygone.1  \
 man/submit.1 man/print.1 man/punch.1 man/receive.1
# ObsoleteMAN1= man/bitcat.1 man/ndparse.1
MAN5=man/bitspool.5 man/ebcdictbl.5
MAN8=man/njed.8 man/qrdr.8 man/njeroutes.8 man/bmail.8 man/ucp.8	\
	man/mailify.8 man/sysin.8
MANSRCS= man/bitspool.5 man/bmail.8 man/ebcdictbl.5			\
	man/njed.8 man/mailify.8 man/njeroutes.8 man/qrdr.8		\
	man/receive.1 man/send.1 man/sendfile.1 man/ucp.8		\

all:	$(PROGRAMS)

info:	njed.info
dvi:	njed.dvi
html:	njed.html

.PRECIOUS:	clientlib.a

.c.o:
	$(CC) -c $(CFLAGS) $<

.c.a:
	$(CC) -c $(CFLAGS) $<
	ar rc clientlib.a $%
	$(RANLIB) clientlib.a

.c.s:
	$(CC) -S $(CFLAGS) $<

purge:	clean purgecode

purgecode:
	rm -f $(PROGRAMS)

clean:
	rm -f \#*\# core *.o *~ *.ln *.a

route:	nje.route

install-man:
	-cd $(MANDIR)/cat1 && (for x in $(MAN1); do rm -f `basename $$x`;done)
	-cd $(MANDIR)/cat5 && (for x in $(MAN5); do rm -f `basename $$x`;done)
	-cd $(MANDIR)/cat8 && (for x in $(MAN8); do rm -f `basename $$x`;done)
	for x in $(MAN1); do $(INSTALL) -c -m 644 $$x $(MANDIR)/man1;done
	for x in $(MAN5); do $(INSTALL) -c -m 644 $$x $(MANDIR)/man5;done
	for x in $(MAN8); do $(INSTALL) -c -m 644 $$x $(MANDIR)/man8;done

man-ps:
	for X in $(MANSRCS); do groff -man $$X >$$X.ps; done

nje.route: exampleRt.header exampleRt.netinit
	@echo "MAKE SURE YOU EDIT THE ROUTING TABLE, AND RERUN $(BINDIR)/njeroutes!"
	-rm nje.route*
	$(BINDIR)/njeroutes exampleRt.header exampleRt.netinit nje.route

routeinstall: nje.route
	@echo "Istalling new routing table. Remember to restart NJE-II after this!"
	-cp nje.route $(LIBDIR)/nje.route

install:
	@echo "Installing everything."
	@echo "Must propably be root for this also."
	-mkdir ${PREFIXDIR}
	-mkdir ${BINDIR}
	-mkdir ${BINDIR}
	-mkdir ${MANDIR}
	-mkdir ${ETCDIR}
	-mkdir ${LIBDIR}
	-mkdir -p ${PREFIXDIR}/var/spool/bitnet
	-mkdir -p ${PREFIXDIR}/var/log
	$(INSTALL) -s -m 755 njed ${BINDIR}/njed.x
	mv ${BINDIR}/njed.x ${BINDIR}/njed
	$(INSTALL) -s -m 755 bitsend ${BINDIR}
	$(INSTALL) -s -m 755 qrdr ${BINDIR}
	$(INSTALL) -m 755 njewrite.sh ${BINDIR}
	$(INSTALL) -s -g ${NJEGRP} -m 750 ucp ${BINDIR}
	$(INSTALL) -s -g ${NJEGRP} -m 755 sendfile ${BINDIR}
	rm -f ${BINDIR}/${PRINT} ${BINDIR}/submit ${BINDIR}/punch
	rm -f ${BINDIR}/sf ${BINDIR}/bitprt
	ln ${BINDIR}/sendfile ${BINDIR}/sf
	ln ${BINDIR}/sendfile ${BINDIR}/${PRINT}
	ln ${BINDIR}/sendfile ${BINDIR}/bitprt
	ln ${BINDIR}/sendfile ${BINDIR}/punch
	ln ${BINDIR}/sendfile ${BINDIR}/submit
	$(INSTALL) -s -g ${NJEGRP} -m 755 tell ${BINDIR}/${SEND}
	ln ${BINDIR}/tell ${BINDIR}/send
	# If you want to call 'send' with command 'tell'
	# rm -f ${BINDIR}/tell
	# ln ${BINDIR}/${SEND} ${BINDIR}/tell
	$(INSTALL) -s -g ${NJEGRP} -m 755 ygone ${BINDIR}
	$(INSTALL) -s -g ${NJEGRP} -m 755 receive ${BINDIR}
	$(INSTALL) -s -g ${NJEGRP} -m 750 bmail ${BINDIR}
	-mkdir -p /var/spool/bitnet
	chgrp ${NJEGRP} /var/spool/bitnet
	chmod g+w  /var/spool/bitnet
	chmod g+s ${BINDIR}/sendfile ${BINDIR}/tell ${BINDIR}/ygone \
		 ${BINDIR}/bmail
	$(INSTALL) -s -m 755 transfer ${BINDIR}/transfer
	$(INSTALL) -s -m 755 njeroutes ${BINDIR}/njeroutes
	$(INSTALL) -s -m 755 namesfilter ${BINDIR}/namesfilter
	$(INSTALL) -s -g ${NJEGRP} -m 750 mailify ${BINDIR}/mailify
	$(INSTALL) -c -g ${NJEGRP} -m 750 sysin.sh ${BINDIR}/sysin
	$(INSTALL) -c -g ${NJEGRP} -m 750 njemail.sh ${BINDIR}/njemail
	cp cmd-help.txt $(LIBDIR)
	cp example.cf $(ETCDIR)/nje.cf
	cp nje.route* ${LIBDIR}
	cp file-exit.cf ${LIBDIR}/file-exit.cf
	cp msg-exit.cf ${LIBDIR}/msg-exit.cf
	cp exampleRt.header ${LIBDIR}/njeroutes.header
	cp exampleRt.netinit ${LIBDIR}/njeroutes.netinit
	cp exampleRt.makefile ${LIBDIR}/Makefile
	cp ${MANSRCS} ${MANDIR}

install_nouid:
	@echo "Installing everything."
	-mkdir ${PREFIXDIR}
	-mkdir ${BINDIR}
	-mkdir ${MANDIR}
	-mkdir ${ETCDIR}
	-mkdir ${LIBDIR}
	cp njed ${BINDIR}/njed
	cp bitsend ${BINDIR}
	cp qrdr ${BINDIR}
	cp njewrite.sh ${BINDIR}
	cp ucp ${BINDIR}
	cp sendfile ${BINDIR}
	rm -f ${BINDIR}/${PRINT} ${BINDIR}/submit ${BINDIR}/punch
	rm -f ${BINDIR}/sf ${BINDIR}/bitprt
	ln ${BINDIR}/sendfile ${BINDIR}/sf
	ln ${BINDIR}/sendfile ${BINDIR}/${PRINT}
	ln ${BINDIR}/sendfile ${BINDIR}/bitprt
	ln ${BINDIR}/sendfile ${BINDIR}/punch
	ln ${BINDIR}/sendfile ${BINDIR}/submit
	cp tell ${BINDIR}/${SEND}
	ln ${BINDIR}/tell ${BINDIR}/send
	# If you want to call 'send' with command 'tell'
	# rm -f ${BINDIR}/tell
	# ln ${BINDIR}/${SEND} ${BINDIR}/tell
	cp ygone ${BINDIR}
	cp receive ${BINDIR}
	cp bmail ${BINDIR}
	cp transfer ${BINDIR}/transfer
	cp njeroutes ${BINDIR}/njeroutes
	cp namesfilter ${BINDIR}/namesfilter
	cp mailify ${BINDIR}/mailify
	cp sysin.sh ${BINDIR}/sysin
	cp njemail.sh ${BINDIR}/njemail
	cp cmd-help.txt $(LIBDIR)
	cp example.cf $(ETCDIR)/nje.cf
	cp nje.route* ${LIBDIR}
	cp file-exit.cf ${LIBDIR}/file-exit.cf
	cp msg-exit.cf ${LIBDIR}/msg-exit.cf
	cp exampleRt.header ${LIBDIR}/njeroutes.header
	cp exampleRt.netinit ${LIBDIR}/njeroutes.netinit
	cp exampleRt.makefile ${LIBDIR}/Makefile
	cp ${MANSRCS} ${MANDIR}

update:
	$(INSTALL) -s -m 755 njed ${BINDIR}/njed
	$(INSTALL) -s -m 755 bitsend ${BINDIR}
	$(INSTALL) -s -m 755 qrdr ${BINDIR}
	$(INSTALL) -m 755 njewrite.sh ${BINDIR}
	$(INSTALL) -s -g ${NJEGRP} -m 750 ucp ${BINDIR}
	$(INSTALL) -s -g ${NJEGRP} -m 755 sendfile ${BINDIR}
	rm -f ${BINDIR}/${PRINT} ${BINDIR}/submit ${BINDIR}/punch
	rm -f ${BINDIR}/sf ${BINDIR}/bitprt
	-ln ${BINDIR}/sendfile ${BINDIR}/sf
	-ln ${BINDIR}/sendfile ${BINDIR}/${PRINT}
	-ln ${BINDIR}/sendfile ${BINDIR}/bitprt
	-ln ${BINDIR}/sendfile ${BINDIR}/punch
	-ln ${BINDIR}/sendfile ${BINDIR}/submit
	$(INSTALL) -s -g ${NJEGRP} -m 755 tell ${BINDIR}/${SEND}
	-ln ${BINDIR}/tell ${BINDIR}/send
	$(INSTALL) -s -g ${NJEGRP} -m 755 ygone ${BINDIR}
	$(INSTALL) -s -g ${NJEGRP} -m 755 receive ${BINDIR}
	$(INSTALL) -s -g ${NJEGRP} -m 750 bmail ${BINDIR}
	chmod g+s ${BINDIR}/sendfile ${BINDIR}/tell ${BINDIR}/ygone \
		 ${BINDIR}/bmail
	$(INSTALL) -s -m 755 transfer ${BINDIR}/transfer
	$(INSTALL) -s -m 755 njeroutes ${BINDIR}/njeroutes
	$(INSTALL) -s -m 755 namesfilter ${BINDIR}/namesfilter
	$(INSTALL) -s -g ${NJEGRP} -m 750 mailify ${BINDIR}/mailify
	$(INSTALL) -c -g ${NJEGRP} -m 750 sysin.sh ${BINDIR}/sysin
	cp ${MANSRCS} ${MANDIR}

acctcat:	$(OBJacctcat)
	$(CC) $(CFLAGS) -o $@ $(OBJacctcat) $(LIBS)

bmail:	$(OBJbmail)
	$(CC) $(CFLAGS) -o $@ $(OBJbmail) $(LIBS)

njed:	$(OBJmain)
	$(CC) $(CFLAGS) -o $@.x $(OBJmain) $(LIBS) $(DEBUG_LIBMALLOC)
	-mv $@ $2.old
	mv $@.x $@

clientlib.a: $(CLIENTLIBobj)

ygone:	$(OBJygone)
	$(CC) $(CFLAGS) -o $@ $(OBJygone) $(LIBS)

${SEND}:	$(OBJsend)
	$(CC) $(CFLAGS) -o $@ $(OBJsend) $(LIBS)

sendfile:	$(OBJsendfile)
	$(CC) $(CFLAGS) -o $@ $(OBJsendfile) $(LIBS)

bitsend:	$(OBJbitsend)
	$(CC) $(CFLAGS) -o $@ $(OBJbitsend) $(LIBS)

njeroutes:	$(OBJnjeroutes)
	$(CC) $(CFLAGS) -o $@ $(OBJnjeroutes)

ucp:	$(OBJucp)
	$(CC) $(CFLAGS) -o $@ $(OBJucp) $(LIBS)

mailify:	$(OBJmailify)
	$(CC) $(MAILIFYCFLAGS) -o $@ $(OBJmailify) $(LIBS) $(LIBMAILIFY)

transfer:	$(OBJtransfer)
	$(CC) $(CFLAGS) -o $@ $(OBJtransfer) $(LIBS)

qrdr:		$(OBJqrdr)
	$(CC) $(CFLAGS) -o $@ $(OBJqrdr) $(LIBS)

receive:	$(OBJreceive)
	$(CC) $(CFLAGS) -o $@ $(OBJreceive) $(LIBS)

namesfilter:	$(OBJnamesfilter)
	$(CC) $(CFLAGS) -o $@ $(OBJnamesfilter) $(LIBS)

bintest:	bintest.o bintree.o
	$(CC) $(CFLAGS) -o $@ bintree.o bintest.o

version.c:
	@echo "** BUG!  version.c  is created at 'make dist',"
	@echo "**       and should be present all the time!"
	exit 1

version.o:	version.c
bcb_crc.o:	bcb_crc.c consts.h site_consts.h ebcdic.h
bitsend.o:	bitsend.c consts.h site_consts.h headers.h ebcdic.h
bmail.o:	bmail.c site_consts.h clientutils.h ndlib.h
detach.o:	detach.c
file_queue.o:	file_queue.c consts.h site_consts.h
gone_server.o:	gone_server.c consts.h site_consts.h
headers.o:	headers.c headers.h consts.h site_consts.h ebcdic.h
bintree.o:	bintree.c
bintest.o:	bintest.c bintree.h
io.o:		io.c headers.h consts.h site_consts.h ebcdic.h prototypes.h
clientlib.a(libasc2ebc.o):	libasc2ebc.c	clientutils.h ebcdic.h
clientlib.a(libdondata.o):	libdondata.c	clientutils.h ebcdic.h prototypes.h ndlib.h
clientlib.a(libebc2asc.o):	libebc2asc.c	clientutils.h ebcdic.h
clientlib.a(libetbl.o):		libetbl.c		ebcdic.h
clientlib.a(libexpnhome.o):	libexpnhome.c	clientutils.h
clientlib.a(libhdrtbx.o):	libhdrtbx.c		clientutils.h prototypes.h
clientlib.a(libndfuncs.o):	libndfuncs.c	clientutils.h prototypes.h ebcdic.h ndlib.h
clientlib.a(libndparse.o):	libndparse.c	clientutils.h prototypes.h ebcdic.h ndlib.h
clientlib.a(libpadbla.o):	libpadbla.c		clientutils.h ebcdic.h
clientlib.a(libreadcfg.o):	libreadcfg.c	clientutils.h prototypes.h consts.h
clientlib.a(libsendcmd.o):	libsendcmd.c	clientutils.h prototypes.h consts.h
clientlib.a(libsubmit.o):	libsubmit.c		clientutils.h prototypes.h
clientlib.a(liburead.o):	liburead.c		clientutils.h prototypes.h
clientlib.a(libuwrite.o):	libuwrite.c		clientutils.h prototypes.h
clientlib.a(libstrsave.o):	libstrsave.c	clientutils.h prototypes.h
clientlib.a(libmcuserid.o):	libmcuserid.c	clientutils.h prototypes.h

clientlib.a(liblstr.o):	liblstr.c clientutils.h
	$(CC) -c $(CFLAGS) $<
	ar rc clientlib.a $%
	$(RANLIB) clientlib.a
clientlib.a(libustr.o):	libustr.c clientutils.h
	$(CC) -c $(CFLAGS) $<
	ar rc clientlib.a $%
	$(RANLIB) clientlib.a

mailify.o:	mailify.c consts.h clientutils.h prototypes.h ndlib.h
	$(CC) -c $(MAILIFYCFLAGS) mailify.c

namesfilter.o:	namesfilter.c
namesparser.o:	namesparser.c
locks.o:	locks.c
logger.o:	logger.c prototypes.h consts.h ebcdic.h
main.o:		main.c prototypes.h headers.h consts.h site_consts.h
ndparse.o:	ndparse.c consts.h prototypes.h clientutils.h ndlib.h
njeroutes.o:	njeroutes.c consts.h prototypes.h site_consts.h bintree.h
nmr.o:		nmr.c headers.h consts.h site_consts.h prototypes.h
nmr_unix.o:	nmr_unix.c headers.h consts.h site_consts.h prototypes.h
protocol.o:	protocol.c headers.h consts.h site_consts.h prototypes.h
qrdr.o:		qrdr.c consts.h headers.h
read_config.o:	read_config.c consts.h site_consts.h
receive.o:	receive.c clientutils.h prototypes.h ndlib.h
libreceive.o:	libreceive.c clientutils.h prototypes.h ndlib.h
recv_file.o:	recv_file.c headers.h consts.h site_consts.h
send.o:		send.c clientutils.h prototypes.h
send_file.o:	send_file.c headers.h consts.h site_consts.h
sendfile.o:	sendfile.c clientutils.h prototypes.h ndlib.h
transfer.o:	transfer.c clientutils.h prototypes.h
ucp.o:		ucp.c clientutils.h prototypes.h
unix.o:		unix.c headers.h consts.h site_consts.h prototypes.h
unix_brdcst.o:	unix_brdcst.c consts.h site_consts.h prototypes.h
unix_files.o:	unix_files.c consts.h prototypes.h
unix_build.o:	unix_build.c consts.h site_consts.h prototypes.h
unix_msgs.o:	unix_msgs.c unix_msgs.h consts.h site_consts.h prototypes.h
unix_route.o:	unix_route.c consts.h site_consts.h prototypes.h bintree.h
unix_tcp.o:	unix_tcp.c headers.h consts.h site_consts.h prototypes.h
util.o:		util.c consts.h site_consts.h ebcdic.h prototypes.h bintree.h

njed.info:	njed.texinfo
	makeinfo njed.texinfo

njed.dvi:	njed.texinfo
	tex njed.texinfo

njed.html:	njed.texinfo
	texi2html njed.texinfo

lint:	lintlib
	lint -hc $(CDEFS) llib-lhuji.ln $(SRC)

lintlib:	llib-lhuji.ln

locktest: locktest.o locks.o
	$(CC) -o locktest locktest.o locks.o
