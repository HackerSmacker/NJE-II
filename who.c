/* A UTMP reading demo hack.. */

#include <stdio.h>
#include <sys/types.h>
#include <pwd.h>
#include <utmp.h>
#include <fcntl.h>
#include <string.h>
#include <unistd.h>

#define UTMP_FILE  "/var/run/utmp"
#define LINESIZE 512

#ifndef USE_UTMPX
#include <utmp.h>
#else
#include <utmpx.h>
#endif


static void
list_users(Faddress, Taddress, UserName)
char	*Faddress, *Taddress, *UserName;
{
	char	line[LINESIZE];
	int	fd = 0, rc, lines;
#ifndef USE_UTMPX
	struct utmp	Utmp;
#else
	struct utmpx	Utmp;
#endif
	struct passwd	*pwd;

	printf("Reading %s\n", UTMP_FILE);
	fd = open(UTMP_FILE, O_RDONLY);
	if (fd == 0) {
	  sprintf(line,"Can't open '%s' for reading. No CPQ USER commands now.", UTMP_FILE);
	} else {
	  lines = 0;
	  while (read(fd,&Utmp,sizeof Utmp) == sizeof Utmp) {
	    putchar('.');
	    if (*Utmp.ut_user == 0) continue; /* Try next */
	    pwd = getpwnam(Utmp.ut_user);
	    if (pwd == NULL) continue;	/* Hmm ??? */
	    ++lines;
	    if (1 == lines) {
	      strcpy(line,"Login     Name");
	      printf("%s\n",line);
	    }
	    sprintf(line,"%-8s  %s",Utmp.ut_user,pwd->pw_gecos);
	    printf("%s\n",line);
	  }
	  close (fd);
	}
}

int main()
{
  list_users(0,0,0);
  return 0;
}
