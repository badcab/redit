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
	$current_line = 0
	$current_col = 0
	$menu_mode = false
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

	menu_string = "s = save \tu = unkill line\tf = find \tk = kill line\n"
	menu_string += "q = quit \tg = go to line \te = go to end \tt = go to top\n"
	menu_string += "(press esc again to return to editing"

	screen = Curses::Window.new(0,0,0,0)
}

loop do
	chr = screen.getch
	if !$menu_mode then
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
				$menu_mode = true
				screen.clear()
				screen.addstr(menu_string)
				screen.setpos(3,0)
				screen.refresh
				next
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
				screen.addstr(char.to_s)
			end
			screen.addstr("\n")
		end
		screen.setpos($current_line,$current_col)
		screen.refresh
	end
	if $menu_mode then
		if chr == 27 then #escape EXIT? maybe
			$menu_mode = false
			next
		elsif chr == 'e' then #eof
		elsif chr == 'f' then #find
		elsif chr == 'g' then #go to
		elsif chr == 'k' then #kill
		elsif chr == 'q' then
			fo.exit
		elsif chr == 's' then
			fo.save
		elsif chr == 't' then #top of file
		elsif chr == 'u' then #unkill

		end

		#have conditionals searching for input
	end
end

END{
	screen.close_screen()
}
