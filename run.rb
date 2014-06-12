#!/usr/local/bin/ruby

BEGIN {
	require 'curses'
	require './File_operation.rb'
	require './Buffer_mod.rb'
	require './Highlight.rb'
	
	include Curses
	Curses.init_screen()
	$current_line = 0;
	$current_col = 0
	argv = ARGF.argv[0].to_s
	if argv.length > 0 then
		$file_name = argv
	else
		$file_name = false
	end
	
	fo = File_operation.new
	bm = Buffer_mod.new
	highlight = Highlight.new #check if terminal suports color otherwise this is pointless
	
	fo.open
	Curses.noecho
	#menu should only be shown after the esc key is pressed
	menu_height = 3;
#	menu = Curses::Window.new(menu_height,0,0,0) #height,width,top,left
	screen = Curses::Window.new(Curses.lines - menu_height,0,0,0)
	
	
#	menu.refresh
	
}

 



loop do
	chr = screen.getch
	if chr.class == Fixnum then
		print chr;
		#print Curses::Key::NPAGE
		if chr == Curses::Key::NPAGE then
		
		elsif chr == Curses::Key::PPAGE then
		elsif chr == Curses::Key::BACKSPACE then
			if $current_col > 0 then
				$current_col -=1
			end
			#delete char at new possition
		
		elsif chr == Curses::Key::UP then
			if $current_line > 0 then
				$current_line -=1
			end
		elsif chr == Curses::Key::DOWN then
			$current_line +=1
		elsif chr == Curses::Key::LEFT then
			if $current_col > 0 then
				current_col -=1
			end
		elsif chr == Curses::Key::RIGHT then
			$current_col +=1
		elsif chr == 27 then #escape
		elsif chr == 10 then #enter
			$current_col = 0
			$current_line +=1
		#elsif chr ==  then #end
		#elsif chr ==  then #delete
		
		end
		
	elsif chr.class == String then
		screen.addstr(chr)
		$current_col +=1
		#modify buffer
	end
	screen.refresh 
end

=begin


when escape key is hit enter action mode
s = save action
q = quit action
f = find action
k = kill line action
u = unkill line action
g = go to line
e = go to end of file
t = go to top of file
=end




END{
	screen.close_screen() 
}
