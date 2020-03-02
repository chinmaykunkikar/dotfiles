#!/bin/bash

# run the script in sudo mode
if ! [ $(id -u) = 0 ]; then
   echo -e "The script needs to be run as root. Run by using -- \n\t\t "sudo `basename "$0"`"" >&2
   exit 1
fi

# variables
DESKTOPFILE="/usr/share/applications/google-chrome.desktop"

# remove existing .desktop file
rm -f $DESKTOPFILE

tee -a $FILE << 'EOF' > /dev/null
[Desktop Entry]
Version=1.0
Name=Google Chrome
GenericName=Web Browser
Comment=Access the Internet
Exec=/usr/bin/google-chrome-stable --force-device-scale-factor=1.25 --password-store=basic %U
StartupNotify=true
Terminal=false
Icon=google-chrome
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml_xml;image/webp;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/ftp;
Actions=new-window;new-private-window;

[Desktop Action new-window]
Name=New Window
Exec=/usr/bin/google-chrome-stable --force-device-scale-factor=1.25 --password-store=basic

[Desktop Action new-private-window]
Name=New Incognito Window
Exec=/usr/bin/google-chrome-stable --force-device-scale-factor=1.25 --password-store=basic --incognito
EOF
