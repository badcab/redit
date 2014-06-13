#!/usr/local/bin/ruby

#I should rethink this whole buffer thing and just let curse take care of it, should make it go a little faster

#need to insert in stead of over writing text
#tab is not working
#enter needs to insert a line
#scrolling needs to be turned on

#when that is done work on general saving and editing of files
#add auto trim of trailing white space

BEGIN {
	require 'curses'
	require './File_operation.rb'
	require './Buffer_mod.rb'
	require './Highlight.rb'

	include Curses
	Curses.init_screen() 
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

	menu_string = "s = save \tu = unkill line \tk = kill line\n"
	menu_string += "g = go to line \te = go to end \tt = go to top\n"
	menu_string += "(press esc again to return to editing)\n"
	menu_string += '=' * Curses.cols
	$menu = $screen.subwin(4,Curses.cols,0,0)
	$menu.addstr(menu_string)
	$sub_menu = $screen.subwin(1,Curses.cols,Curses.lines - 1,0)

}

loop do
	stty_save = `stty -g`.chomp
	trap('INT') { system('stty', stty_save); exit }

	chr = $screen.getch
	if !$menu_mode then
		if chr.class == Fixnum then
			
			if chr == 338 then #Curses::Key::NPAGE

				#do scrolling


			elsif chr == 339 then #Curses::Key::PPAGE

				#do scrolling


			elsif chr == 127 then # Curses::Key::BACKSPACE 
				$body.setpos($body.cury,$body.curx - 1)
				$body.delch() 
			elsif chr == 259 then #Curses::Key::UP 
				$body.setpos($body.cury - 1,$body.curx)
			elsif chr == 258 then #Curses::Key::DOWN  
				$body.setpos($body.cury + 1,$body.curx)
			elsif chr == 260 then #Curses::Key::LEFT 
				$body.setpos($body.cury,$body.curx - 1)
			elsif chr == 261 then #Curses::Key::RIGHT 
				$body.setpos($body.cury,$body.curx + 1)
			elsif chr == 27 then #escape EXIT? maybe
				$menu_mode = true
				option_select_message = 'what would you like to do?: ' 
				$sub_menu.addstr(option_select_message)
				$sub_menu.setpos(0,option_select_message.length)
				$sub_menu.refresh
				next
			elsif chr == 10 then # Curses::Key::ENTER 
				$body.setpos($body.cury + 1,0)
			#elsif chr == 360 then #end
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
		elsif chr == 'g' then #go to
		elsif chr == 'k' then #kill
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
