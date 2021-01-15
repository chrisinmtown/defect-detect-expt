# Program drivers

This directory holds the sources for two drivers:

- driver-args: capture and mail argument vector, then start pgm
- driver-file: capture and mail the input file,  then start pgm

The header file stores the name of the mailer and the target address.

These files are used by setting symbolic links to them from other dirs.
