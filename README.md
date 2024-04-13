NJE-II 
================

** ---> SEE SETUP_DIRECTIONS.TXT PLEASE <--- **

## Compiling
make
groupadd nje
make install

## Configuring
`vi /usr/local/nje/etc/nje.cf`
Change all the parameters therein, and make sure the spool directories exist!
`vi /usr/local/nje/lib/msg-exit.cf`
Change all occurrences of `LINUX1` to your node name:
`vi /usr/local/nje/lib/file-exit.cf`
Do the same, but also check the spool path!
To change the port, edit `-DVMNET_IP_PORT` in the Makefile!
Next, go to /usr/local/nje/lib and edit the `njeroutes.*` files, then invoke make to regenerate the nje.route routing table.

If you are using nonstandard configration file paths, edit `unix_files.c` accordingly.
Enter your node name into `netinit.sh` too, if you wish to use it.

Note that the `funetnje` executable has been renamed to `njed` to fit UNIX convention.

Troubleshooting:
If you are getting a permission died error using tell or sendfile, make sure that all files in the /usr/local/nje directory are at least mode 775. Some systems (eg OS X) require you to manually chown the files -- use this with care. The core issue here is that users need to be able to access /usr/local/nje/var/spool/bitnet/USERNAME, and files in the spool/bitnet dir -- without access there, nothing works.
If you cannot get ucp to work, try using a FIFO file. Use mkfifo to create it and update your nje.cf file.
If you cannot qrdr, make the spool directories. 
If you cannot compile this on UNIX systems with the acomp compiler, edit headers.h and look for the #pragma pack() lines.
If you get errors about socket library functions not being found (anything starting with inet or gethostbyname), edit the Makefile and uncomment LIBS.

Additional features:
1. The njemail.sh, which becomes $BINDIR/njemail, will allow you to send a NOTE-style message from UNIX. These notes are readable by both the RDRLIST command on VM and also OfficeVision/PROFS. Upon using Open The Mail on OV/PROFS, the sent message will be imported into the mail server file.
2. Sendmail config extensions are provided, but, they most likely do not work in the modern era. Exercise with care.

