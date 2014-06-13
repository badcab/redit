#!/usr/local/bin/ruby

#need to insert in stead of over writing text
#tab is not working
#enter overwrites the below line instead of inseting
#need to add scrolling to $body, scroll up at least, and ensure pos sync with buffer

#when that is done work on general saving and editing of files
#add auto trim of trailing white space

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
	$screen = Curses::Window.new(0,0,0,0)
	$screen.keypad(true)
	$screen.setpos(4,0)
	$body = $screen.subwin(Curses.lines - 5,Curses.cols,4,0)
	$body.scrollok(true)
	$body.setscrreg(4,Curses.lines - 1) 

	Curses.noecho

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

	menu_string = "s = save \tu = unkill line\tf = find \tk = kill line\n"
	menu_string += "q = quit \tg = go to line \te = go to end \tt = go to top\n"
	menu_string += "(press esc again to return to editing)\n"
	menu_string += '=' * Curses.cols
	$menu = $screen.subwin(4,Curses.cols,0,0)
	$menu.addstr(menu_string)
	#$sub_menu = $screen.subwin(1,Curses.cols,Curses.lines - 1,0)

}

loop do
	stty_save = `stty -g`.chomp
	trap('INT') { system('stty', stty_save); exit }

	chr = $screen.getch
	if !$menu_mode then
		if chr.class == Fixnum then
			if chr == 338 then #Curses::Key::NPAGE
				new_line_pos = $current_line + Curses.lines
				if $buffer.length < new_line_pos then
					new_line_pos = $buffer.length
				end
				$current_line = new_line_pos
			elsif chr == 339 then #Curses::Key::PPAGE
				new_line_pos = $current_line - Curses.lines
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
			elsif chr == 259 then #Curses::Key::UP
				if $current_line > 0 then
					$current_line -=1
					if $current_col > $buffer[$current_line].length then
						$current_col = $buffer[$current_line].length
					end
				end
			elsif chr == 258 then #Curses::Key::DOWN 
				if $buffer.length - 1 > $current_line then
					$current_line +=1
					if $current_col > $buffer[$current_line].length then
						$current_col = $buffer[$current_line].length
					end
				end
			elsif chr == 260 then #Curses::Key::LEFT
				if $current_col > 0 then
					$current_col -=1
				end
			elsif chr == 261 then #Curses::Key::RIGHT
				if $buffer[$current_line].class == NilClass then
					$buffer[$current_line] = Array.new
				end
				if $buffer[$current_line].length > $current_col then
					$current_col +=1
				end
			elsif chr == 27 then #escape EXIT? maybe
				$menu_mode = true
				option_select_message = 'what would you like to do?: '
				$sub_menu.addstr(option_select_message)
				
				$body.setpos(0,option_select_message.length)
				$sub_menu.refresh
				next
			elsif chr == 10 then # Curses::Key::ENTER
				$current_col = 0
				$current_line +=1
				$buffer[$current_line] = Array.new
			#elsif chr == 360 then #end
			#elsif chr == 330 then #delete

			end
		elsif chr.class == String then
			if $buffer[$current_line].class == NilClass then
				$buffer[$current_line] = Array.new
			end
			$buffer[$current_line][$current_col] = chr
			$current_col +=1
		end
		$body.clear
		$buffer.each do |line|
			line.each do |char|
				$body.addstr(char.to_s)
			end
			$body.addstr("\n")
		end
		$body.setpos($current_line,$current_col)
		$body.refresh
	end
	if $menu_mode then
		if chr == 27 then #escape EXIT? maybe
			$menu_mode = false
			$sub_menu.clear
			$sub_menu.refresh
			$body.setpos($current_line,$current_col)
			$body.refresh
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
	end
end

END{
	Curses.close_screen()
}
