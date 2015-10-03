# picorg
Script to rename image files based on date and to distribute date-named files
into date-based directory tree

Rename specified files using YYYYMMDDHHMMSS.ext format using either the time
the image was taken, extracted from the EXIF info, or the time the image file
was saved, taken from the modified date/time file info.  Also, option to
change EXIF taken time to match time image file was written (for naughty
cameras).  And it will distribute the files into a year/month/day directory
structure.

BEWARE! Little error checking is done. Make sure you are INSIDE the directory
of image files on which you are working.  Make sure you have renamed the files
to the date format before distributing.  And make sure that your command line
is correct before hitting enter!

Requirements:
jhead

Cmds: taken, modified, fixnaughty, distribute

Usage:

 mvdt taken <files>
Renames files listed (including wildcards) to match date/time the EXIF/JPEG
was taken, according to the EXIF header information.  Resulting format is
YYYYMMDDHHMMSS.ext.

 mvdt modified <files>
Renames files listed (including wildcards) to match date/time the file was
created, according to file system information.  Resulting format is
YYYYMMDDHHMMSS.ext.

 mvdt fixnaughty "2002:12:08 12:00:00" <files>
Modifies EXIF headers of files listed (including wildcards) to match date/time
the file was created, according to file system information.  Name of file is
not changed.

 mvdt distribute <rootdir> <datenamedfiles>
Distributes (moves) specified files (including wildcards) into date-based
directory tree.  Tree is created as needed.  Tree is organized as:
  year
    mo
     dy

