class File_operation
	def save
		if !$file_name then
			self.create
		end
		aFile = File.new($file_name, 'w')

		aFile.syswrite($body_content) if aFile
		
		aFile.close if aFile
		return
	end

	def create 
		$sub_menu.clear
		option_select_message = 'enter desired file name: '
		$sub_menu.addstr(option_select_message) #put this at the bottem
		$sub_menu.setpos(0,option_select_message.length)
		$sub_menu.refresh 
		loop do
			chr = $screen.getch
			if chr.class == Fixnum then
				#if enter then check string name and save
				#if esc then exit this mode
			elsif chr.class == String then
				#add char to area
				#$sub_menu.refresh 
			end
		end
		#do something to wait for an enter from getch 
		#put a loop here to wait for an enter press, that would trigger the save action
		
		self.save
	end

	def open
		if $file_name && File.file?($file_name) then 
			y = $body.cury
			x = $body.curx
			aFile = File.open($file_name, 'r')
			aFile.each_line do |line|
				$body.addstr(line)
			end 
			aFile.close if aFile
			$body.setpos(y, x)
		end
	end
end
