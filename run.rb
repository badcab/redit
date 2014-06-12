#!/usr/local/bin/ruby



 

#will need to get this set in insert mode
#will need to fix the text wrapping issue
#will need to modify the read and save since the $buffer is now a 2d array

#plan for tonight, first config to open an existing file
#then work on getting the menu mode to show and then saving
#tab seems to be broken
#need to supress the Interrupt in the do loop





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
	
	menu_string = "s = save \t u = unkill line\tf = find \tk = kill line\n"
	menu_string += "q = quit \tg = go to line \te = go to end \tt = go to top"

#menu should only be shown after the esc key is pressed
	menu_height = 3;
#	menu = Curses::Window.new(menu_height,0,0,0) #height,width,top,left
#	menu.addstr(menu_string)
#	menu.refresh

	screen = Curses::Window.new(Curses.lines - menu_height,0,0,0)	
}

loop do
	chr = screen.getch
	if chr.class == Fixnum then
#print ': ' 
#print chr 
#print ' :'
		if chr == Curses::Key::NPAGE then
			new_line_pos = $current_line + screen.lines
			if $buffer.length < new_line_pos then
				new_line_pos = $buffer.length
			end
			$current_line = new_line_pos
		elsif chr == Curses::Key::PPAGE then
			new_line_pos = $current_line - screen.lines
			if new_line_pos < 0 then
				new_line_pos = 0
			end
			$current_line = new_line_pos
		elsif chr == 127 then # Curses::Key::BACKSPACE
			if $current_col > 0 then
				$current_col -=1
				$buffer[$current_line].delete_at($current_col)
			elsif $current_line > 0
				$current_line -=1
				$current_col = $buffer[$current_line].length
			end 
		elsif chr == Curses::Key::UP then
			if $current_line > 0 then
				$current_line -=1
			end
		elsif chr == Curses::Key::DOWN then
			if $buffer.length > $current_line then
				$current_line +=1
			end
		elsif chr == Curses::Key::LEFT then
			if $current_col > 0 then
				current_col -=1
			end
		elsif chr == Curses::Key::RIGHT then
			if $buffer[$current_line].length > $current_col then
				$current_col +=1
			end 
		elsif chr == 27 then #escape EXIT? maybe
			#enter option mode, show the menu and wail for input
		elsif chr == 10 then # Curses::Key::ENTER
			$current_col = 0
			$current_line +=1
		#elsif chr ==  then #end
		#elsif chr ==  then #delete
		
		end
	elsif chr.class == String then
		if $buffer[$current_line].class == NilClass then
			$buffer[$current_line] = Array.new
		end
		$buffer[$current_line][$current_col] = chr
		$current_col +=1
	end
	screen.clear()
	$buffer.each do |line|
		line.each do |char|
			screen.addstr(char.to_s);
		end
		screen.addstr("\n")
	end
	screen.setpos($current_line,$current_col)
	screen.refresh  
end

END{
	screen.close_screen() 
}
