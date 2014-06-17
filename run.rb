#!/usr/local/bin/ruby

BEGIN {
	require 'curses'
	require "#{File.dirname(__FILE__)}/File_operation.rb"
	require "#{File.dirname(__FILE__)}/Buffer_mod.rb"
	require "#{File.dirname(__FILE__)}/Highlight.rb"

	include Curses
	Curses.init_screen() 
	Curses.TABSIZE = 4
	$menu_mode = false
	$screen = Curses::Window.new(0,0,0,0)
	$screen.keypad(true)
	$screen.setpos(3,0)
	$body = $screen.subwin(Curses.lines - 4,Curses.cols,3,0)
	#$body.scrollok(true) 
	#$body.setscrreg(0, 5)
	$body.setscrreg(3,Curses.lines - 1) 

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

	menu_string = "s = save \t\tu = unkill line \tk = kill line \tg = go to line \n"
	menu_string += "e = go to end \tt = go to top \t\t"
	menu_string += "esc = resume edit\n"
	menu_string += '=' * Curses.cols
	$menu = $screen.subwin(3,Curses.cols,0,0)
	$menu.addstr(menu_string)
	$sub_menu = $screen.subwin(1,Curses.cols,Curses.lines - 1,0)
}

loop do
	stty_save = `stty -g`.chomp
	trap('INT') { system('stty', stty_save); exit }
	chr = $screen.getch
	if !$menu_mode then
		if chr.class == Fixnum then
			#add something for tab here
			if chr == 338 then #PAGE down

				#do scrolling
				#$body.scrl() should be usiing Curses.lines for body -neg num scrolls down

			elsif chr == 339 then #PAGE up

				#do scrolling
				#$body.scrl() should be usiing Curses.lines for body +pos num scrolls up
				
			elsif chr == 360 then #end

				#go to end of file

			elsif chr == 127 then #BACKSPACE 
				if $body.curx == 0 then
					$body.setpos($body.cury - 1,10)#10 is made up, need to figure out how to get eol 
				end
				$body.setpos($body.cury,$body.curx - 1)
				$body.delch() 
			elsif chr == 259 then #UP 
				$body.setpos($body.cury - 1,$body.curx)
			elsif chr == 258 then #DOWN  
				$body.setpos($body.cury + 1,$body.curx)
			elsif chr == 260 then #LEFT 
				$body.setpos($body.cury,$body.curx - 1)
			elsif chr == 261 then #RIGHT 
				$body.setpos($body.cury,$body.curx + 1)
			elsif chr == 27 then #escape
				$menu_mode = true
				option_select_message = 'what would you like to do?: ' 
				$sub_menu.addstr(option_select_message)
				$sub_menu.setpos(0,option_select_message.length)
				$sub_menu.refresh
				next
			elsif chr == 10 then # Curses::Key::ENTER 
				$body.setpos($body.cury + 1,0)
			elsif chr == 330 then #delete
				$body.delch() 
			end
		elsif chr.class == String then
			$body.addch(chr)
		end 
		$body.refresh
	end
	if $menu_mode then
		if chr == 27 then #escape EXIT? maybe
			$menu_mode = false
			$sub_menu.clear
			$sub_menu.refresh 
			$body.refresh
			next
		elsif chr == 'e' then #eof 
			#setting possition easy, scrolling no so much
		elsif chr == 'g' then #go to
		elsif chr == 'k' then #kill
			#Curses.clrtoeol deleteln
			bm.kill_line
		elsif chr == 's' then
			fo.save
		elsif chr == 't' then #top of file
			#setting possition easy, scrolling no so much
		elsif chr == 'u' then #unkill
			bm.unkill_line
		end
	end
end

END{
	Curses.close_screen()
}
