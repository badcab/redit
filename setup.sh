#!/bin/sh

if [ `whoami` != 'root' ] ; then
	echo 'Please run as root'
	exit
fi

if [ `uname` == 'FreeBSD' || `uname` == 'Linux' ] ; then
	if [ -x `which ruby` ] ; then
		#ruby installed
	else 
		echo 'You Must Have Ruby Installed to Proceed'
		exit
	fi
	
	#check if the curses gem is installed
	
	mkdir -p /usr/local/bin/ruby_text_edit
	mv *.rb /usr/local/bin/ruby_text_edit
	
	echo '#!/bin/sh'"\n" > /usr/local/bin/redit
	echo 'ruby /usr/local/bin/ruby_text_edit/run.rb'
	chmod +x /usr/local/bin/redit
	chmod +x /usr/local/bin/ruby_text_edit/*.rb
	
	echo 'install finished type $ redit to use'
	
else
	echo 'Operating System Not Supported by Installer'
fi
