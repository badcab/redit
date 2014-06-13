class File_operation
	def save
		if !$file_name then
			self.create
		end
		aFile = File.new($file_name, 'w')
		result = $body.getstr #untested
		
#need to strip trailing white space		
		
		
		aFile.syswrite(result) if aFile
		
		aFile.close if aFile
	end

	def create 
		$sub_menu.clear
		option_select_message = 'enter desired file name: '
		$sub_menu.addstr(option_select_message) #put this at the bottem
		$sub_menu.setpos(0,option_select_message.length)
		$sub_menu.refresh 
		
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
