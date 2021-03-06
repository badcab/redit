#!/usr/local/bin/ruby

BEGIN {
	require 'curses'
	require "#{File.dirname(__FILE__)}/File_operation.rb"
	require "#{File.dirname(__FILE__)}/Buffer_mod.rb"
	require "#{File.dirname(__FILE__)}/Highlight.rb"

	include Curses
	Curses.init_screen()
	Curses.TABSIZE = 4
	Curses.ESCDELAY = 0
	TOP_MENU_LINES = 3
	BOTTOM_MENU_LINES = 1
	$menu_mode = false
	$screen = Curses::Window.new(0,0,0,0)
	$screen.keypad(true)
	$body = $screen.subwin(Curses.lines - TOP_MENU_LINES,Curses.cols,TOP_MENU_LINES,0)
	$body_content = ''

	#$body.scrollok(true) 
	#$body.setscrreg(0, 5)
	#$body.setscrreg(3,Curses.lines - 1) 

	Curses.noecho
	Curses.mousemask(ALL_MOUSE_EVENTS)

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

	menu_string = "u = unkill line \te = go to end \tg = go to line \t\ts = save\n"   
	menu_string += "k = kill line \t\tt = go to top\t"
	menu_string += "esc = resume edit\n"
	menu_string += '=' * Curses.cols
	$menu = $screen.subwin(TOP_MENU_LINES,Curses.cols,0,0)
	$menu.addstr(menu_string)
	$sub_menu = $screen.subwin(BOTTOM_MENU_LINES,Curses.cols,Curses.lines - BOTTOM_MENU_LINES,0)

	$screen.setpos(TOP_MENU_LINES,0) 
}

loop do
	stty_save = `stty -g`.chomp
	trap('INT') { system('stty', stty_save); exit }
	chr = $screen.getch
	if !$menu_mode then
		if chr.class == Fixnum then
			if chr == 338 then #PAGE down

				#do scrolling
				#$body.scrl() should be usiing Curses.lines for body -neg num scrolls down

			elsif chr == 339 then #PAGE up

				#do scrolling
				#$body.scrl() should be usiing Curses.lines for body +pos num scrolls up
				
			elsif chr == 360 then #end

				#go to end of file

			elsif chr == 9 then #tab
				$body.insch("\t")
				$body.setpos($body.cury, $body.curx + Curses.TABSIZE) 
			elsif chr == 127 then #BACKSPACE 
				if $body.curx == 0 then
					if $body.cury > 0 then 
						$body.setpos($body.cury - 1, bm.end_of_line_x_pos($body.cury - 1) + 1)
					end
				else
					#backspace will need to do a check for a tab
					$body.setpos($body.cury,$body.curx - 1)
					$body.delch()
				end
			elsif chr == 409 then #MOUSE
				m = getmouse
				$body.setpos(m.y - TOP_MENU_LINES,m.x)
			elsif chr == 259 then #UP 
				$body.setpos($body.cury - 1,$body.curx)
			elsif chr == 258 then #DOWN  
				$body.setpos($body.cury + 1,$body.curx)
			elsif chr == 260 then #LEFT 
				#backspace will need to do a check for a tab
				$body.setpos($body.cury,$body.curx - 1)
			elsif chr == 261 then #RIGHT 
				#backspace will need to do a check for a tab
				$body.setpos($body.cury,$body.curx + 1)
			elsif chr == 27 then #escape
				$menu_mode = true

				$body_content = ''
				origional_x = $body.curx
				origional_y = $body.cury

				window_cols = (0..$body.maxx()).to_a
				window_rows = (TOP_MENU_LINES..($body.maxy() + TOP_MENU_LINES)).to_a

				window_rows.each do |row|
					window_cols.each do |col|
						$body.setpos(row,col)
						$body_content.concat($body.inch())
					end
					$body_content.sub(/\s+\Z/, "") #strip trailing whitespace
					$body_content.gsub(/\s\s\s\s/, "\t") #convert spaces to tabs
					$body_content.concat("\n")
				end
				$body.setpos(origional_y, origional_x)

				option_select_message = 'what would you like to do?: ' 
				$sub_menu.addstr(option_select_message)
				$sub_menu.setpos(0,option_select_message.length)
				$sub_menu.refresh
				next
			elsif chr == 10 then #ENTER 
				$body.setpos($body.cury + 1,0)
			elsif chr == 330 then #delete
				$body.delch() 
			end
		elsif chr.class == String then
			$body.insch(chr)
			$body.setpos($body.cury,$body.curx + 1)
		end 
		$body.refresh
	end
	if $menu_mode then
		if chr == 27 then #escape
			$menu_mode = false
		elsif chr == 'e' then #eof 
			#setting possition easy, scrolling no so much
		elsif chr == 'g' then #go to
			#$menu_mode = false
			bm.go_to_line
		elsif chr == 'k' then #kill
			#Curses.clrtoeol deleteln
			bm.kill_line
			#$menu_mode = false
		elsif chr == 's' then
			fo.save
			$menu_mode = false
		elsif chr == 't' then #top of file
			#setting possition easy, scrolling no so much
			#$menu_mode = false
		elsif chr == 'u' then #unkill
			bm.unkill_line
			#$menu_mode = false
		end
		
		if !$menu_mode then
			$sub_menu.clear
			$sub_menu.refresh 
			$body.refresh
			next
		end
	end
end

END{
	Curses.close_screen()
}
