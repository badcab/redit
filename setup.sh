#!/bin/sh
if [ `whoami` != 'root' ] ; then
	echo 'Please run as root'
	exit
fi

if [ `uname` == 'Linux' ] || [ `uname` == 'FreeBSD' ] ; then
	if [ -x `which ruby` ] ; then
		echo 'Installing'
	else 
		echo 'You Must Have Ruby Installed to Proceed'
		exit
	fi

	if [ ! `gem which curses` ] ; then
		echo 'please install the curses gem'
		exit
	fi
	
	mkdir -p /usr/local/bin/ruby_text_edit
	cp *.rb /usr/local/bin/ruby_text_edit
	echo '#!/bin/sh'> /usr/local/bin/redit
	echo 'ruby /usr/local/bin/ruby_text_edit/run.rb $*'>> /usr/local/bin/redit
	chmod +x /usr/local/bin/redit
	chmod +x /usr/local/bin/ruby_text_edit/*.rb
	echo 'install finished type $ redit to use'
else
	echo 'Operating System Not Supported by Installer'
fi
