#!/bin/bash
#
# Please download wkhtmltoimage from the following links:
#
# 64bit - http://code.google.com/p/wkhtmltopdf/downloads/detail?name=wkhtmltoimage-0.11.0_rc1-static-amd64.tar.bz2
# 32bit - http://code.google.com/p/wkhtmltopdf/downloads/detail?name=wkhtmltoimage-0.11.0_rc1-static-i386.tar.bz2
#
# Extract and move to the following location: /usr/bin/wkhtmltoimage
#
echo
echo
echo "               ___.          .__            __    "
echo " __  _  __ ____\_ |__   _____|  |__   _____/  |_  "
echo " \ \/ \/ // __ \| __ \ /  ___/  |  \ /  _ \   __\ "
echo "  \     /\  ___/| \_\ \\\___ \|   Y  (  (_) )  |   "
echo "   \/\_/  \___  >___  /____  >___|  /\____/|__|   "
echo "              \/    \/     \/     \/              "
echo
echo "v.0.1.2 (c) Duncan Alderson 2013"
echo "Download: https://github.com/webantix/webshot  Twitter: @webantix"
echo
echo
echo "[*] Creates screenshots of all web servers found within a Nessus Scan"
echo
echo "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
echo 
# Error: missing file attribute. Show message then exit
if [ $# -lt 1 ]
then
echo `tput setf 4`[-] `tput sgr0`"Oops, Missing Nessus NBE parameter. Usage: ./webshot.sh path/to/nbe.file" 
echo
exit -1
fi
# Error: file does not exist
if [ ! -e "$1" ]
then
echo `tput setf 4`[-] `tput sgr0`"Oops, That NBE file is not there. Usage: ./webshot.sh path/to/nbe.file"
echo
exit -1
fi
#
# Get file a`nd cut/crop/strip and fook with
echo `tput setf 2`[+] `tput sgr0`"Starting Webshot 0.1.2 at `date`"
echo
echo `tput setf 2`[+] `tput sgr0`"Working..."
hosts=`cat $1 | grep 10107 | cut -f 3,4 -d "|" | sed 's/(/:/g' | sed 's/[^0-9.:]//g' `
dir=`basename "$1" .nbe`
if [ -d $dir ]
then
echo "[*] Directory already exists, Will save screenshots to this folder."
else
mkdir $dir
echo `tput setf 2`[+] `tput sgr0`"Creating directory" `$dir`
fi
for i in $hosts
do 
#added to help wkhtmltoimage not bork on HTTPAuth requests
port=${i#*:}
if [ $port -eq 443 ]
then
p='https://'
else
p='http://'
pi=$p$i
fi
echo `tput setf 2`[+] `tput sgr0`"Capturing $pi"
timeout 20 wkhtmltoimage -n $pi $dir\/screenshot-$i.png 
done
#
# Let people know the job is done.
#
 echo
 echo `tput setf 2`[+] `tput sgr0`"Completed scan creating webpage" $dir".htm"
 printf "<html><body><h1>Webshot v.0.1.2</h1><br>" > $dir.html
 printf "<h3>v.0.1.2 (c) Duncan Alderson 2013</h3>" >> $dir.html
 printf "<h3>Download: <a href='https://github.com/webantix/webshot'>https://github.com/webantix/webshot</a>  Twitter: <a href='http://twitter.com/webantix'>@webantix</a></h3>" >> $dir.html
 ls -1 $dir/*.png | awk -F : '{ print $1":"$2"\n<br><img src=\""$1"%3A"$2"\" width=400><br><br>"}'  >> $dir.html
 printf "</body></html>" >> $dir.html
echo
echo `tput setf 2`[+] `tput sgr0`"Completed."
echo