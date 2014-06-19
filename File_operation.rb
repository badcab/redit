class File_operation
	def save (body_top_offset)
		if !$file_name then
			self.create
		end
		aFile = File.new($file_name, 'w')
		result = ""
#========================================
		origional_x = $body.curx
		origional_y = $body.cury

		window_cols = (0..$body.maxx()).to_a
		window_rows = (body_top_offset..($body.maxy() + body_top_offset)).to_a

		window_rows.each do |row|
			window_cols.each do |col|
				$body.setpos(row,col)
				result.concat($body.inch())
			end
			#here is where I should cycle through and remove whitespace from the end, use a loop and array reverse or something
			result.concat("\n")
		end

		$body.setpos(origional_y, origional_x)
#======================================== 
		aFile.syswrite(result) if aFile
		
		aFile.close if aFile
		return
	end

	def create 
		$sub_menu.clear
		option_select_message = 'enter desired file name: '
		$sub_menu.addstr(option_select_message) #put this at the bottem
		$sub_menu.setpos(0,option_select_message.length)
		$sub_menu.refresh 
		#do something to wait for an enter from getch 
		#put a loop here to wait for an enter press, that would trigger the save action
		
		self.save
	end

	def open
		if $file_name && File.file?($file_name) then 
			aFile = File.open($file_name, 'r')
			aFile.each_line do |line|
				$body.addstr(line)
			end 
			aFile.close if aFile
		end
	end
end
