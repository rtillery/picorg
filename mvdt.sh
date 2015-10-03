#! /bin/bash
# Rename specified files using YYMMDDHHMMSS.ext format
# using either the time the image was taken, extracted
# from the EXIF info, or the time the image file was
# saved, taken from the modified date/time file info.
# Also, option to change EXIF taken time to match time
# image file was written (for naughty cameras).
# And it will distribute the files into a year/month/day
# directory structure.
#
# BEWARE! Little error checking is done. Make sure you
# are INSIDE the directory of image files on which you
# are working.  Make sure you have renamed the files to
# the date format before distributing.  And make sure that
# your command line is correct before hitting enter!

# taken, modified, fixnaughty, distribute
if [ "$1" = "taken" ]; then
# mvdt taken <files>
  for file in ${@:2} ;
  do
    jhead -n%Y%m%d%H%M%S "$file"
  done
elif [ "$1" = "modified" ]; then
# mvdt modified <files>
  for file in ${@:2} ;
  do
    ext="${file##*.}"
    out=$(stat -c %y "$file" | cut -c "1-4,6-7,9-10,12-13,15-16,18-19" | sed "s/$/.$ext/")
    echo "$file --> $out"
    mv -n "$file" "$out"
  done
elif [ "$1" = "fixnaughty" ]; then
# mvdt fixnaughty "2002:12:08 12:00:00" <files>
  missing="missing"
  baddate="$2"
  echo Searching for files with EXIF date of "$baddate"
  count=0
  for file in ${@:3} ;
  do
    filedate=$(stat -c %y "$file" | cut -c "-19" | sed "s/-/:/g" | sed "s/ /-/")
    origdate=$(exif -t=0x9003 -m "$file" 2>/dev/null)
    digidate=$(exif -t=0x9004 -m "$file" 2>/dev/null)
    if [ "$origdate" = "$baddate" ]; then
      if [ "$digidate" = "$baddate" ]; then
        count=$((count+1));
#        echo "Replacing both dates in $file with $filedate"
        jhead -ts"$filedate" "$file"
#      else
#        echo "Bad original date ($origdate) (good digital date ($digidate))"
      fi
#    else
#      if [ "$digidate" = "$baddate" ]; then
#        echo "Bad digital date ($digidate) (good original date ($origdate))"
#      fi
    fi
#2013-08-17 14:20:15
#yyyy:mm:dd-hh:mm:ss
  done
elif [ "$1" = "distribute" ]; then
# mvdt distribute <rootdir> <datenamedfiles>
  for file in ${@:3} ;
  do
    if [ $(expr length "$file") -ge "18" ]; then
      dest="$2/"$(echo $file | sed "s/\([0-9][0-9][0-9][0-9]\)\([0-9][0-9]\)\([0-9][0-9]\).*/\1\/\2\/\3/")
      if [ ! -d "$dest" ]; then
        tmp1=$(echo $dest | rev | cut -c "4-" | rev)
        if [ ! -d "$tmp1" ]; then
          tmp2=$(echo $tmp1 | rev | cut -c "4-" | rev)
          if [ ! -d "$tmp2" ]; then
            mkdir "$tmp2"
          fi
          mkdir "$tmp1"
        fi
        mkdir "$dest"
      fi
      echo "$file --> $dest/"
      mv -n "$file" "$dest/"
    else
      echo \""$file"\" does not have the correct file name format.
    fi
  done
  
else
  echo First option should be taken, modified, fixnaughty, or distribute
  exit
fi

#130309175725.jpg
#


