NJE-II for Linux
================

---> SEE SETUP_DIRECTIONS.TXT PLEASE <---

Compiling:
make
groupadd nje
make install

Configuring:
vi /usr/local/nje/etc/nje.cf
Change all the parameters therein, and make sure the spool directories exist!
vi /usr/local/nje/lib/msg-exit.cf
Change all occurrences of LINUX1 to your node name
vi /usr/local/nje/lib/file-exit.cf
Do the same, but also check the spool path!
To change the port, edit -DVMNET_IP_PORT in the Makefile!
Next, go to /usr/local/nje/lib and edit the njeroutes.* files, then invoke make to regenerate the nje.route routing table.

If you are using nonstandard configration file paths, edit unix_files.c accordingly.
Enter your node name into netinit.sh too, if you wish to use it.

If you don't have groups, use Makefile.nogroup.

Note that the `funetnje` executable has been renamed to `njed` to fit UNIX convention.

Troubleshooting:
If you are getting a permission died error using tell or sendfile, make sure that all files in the /usr/local/nje directory are at least mode 775. Some systems (eg OS X) require you to manually chown the files -- use this with care.
If you cannot get ucp to work, try using a FIFO file. Use mkfifo to create it and update your nje.cf file.
If you cannot qrdr, make the spool directories. 
