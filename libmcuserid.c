#include "consts.h"
#include "prototypes.h"
#include "clientutils.h"

char *
mcuserid(from)
char *from;
{
	char *USER = getenv("USER");
	char *LOGNAME = getenv("LOGNAME");
	uid_t uid = getuid();

	if (USER == NULL) USER = LOGNAME;
	if (USER != NULL) {
	  struct passwd *pw = getpwnam(USER);
	  if (pw != NULL &&
	      (uid == 0 || uid == pw->pw_uid)) {
	    strcpy(from,USER);
	  } else {
#ifndef UNIX
	    cuserid(from);
#endif
	  }
	} else {
#ifndef UNIX
	  cuserid(from);
#endif
	}
	return from;
}
