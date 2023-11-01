NJE-II for Linux
================

Compiling:
make
groupadd nje
make install

Configuring:
vi /usr/local/nje/etc/nje.cf
Change all the parameters therein, and make sure the spool directories exist!
vi /usr/local/nje/lib/msg-exit.cf
Change all occurrences of FINFILES to your node name
vi /usr/local/nje/lib/file-exit.cf
Do the same, but also check the spool path!
To change the port, edit -DVMNET_IP_PORT in the Makefile!

If you are using nonstandard configration file paths, edit unix_files.c accordingly.
Enter your node name into netinit.sh too, if you wish to use it.

If you don't have groups, use Makefile.nogroup.

Note that the `funetnje` executable has been renamed to `njed` to fit UNIX convention.

If you're extremely brave, look in `sendmail_configs` and try to integrate it with
Sendmail like JNET on VMS.
