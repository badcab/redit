class File_operation
	def save
		if !$file_name then
			self.create
		end
		aFile = File.new($file_name, 'w')
		result = $body.getstr #untested
		
		aFile.syswrite(result) if aFile
		
		aFile.close if aFile
	end

	def create 
		$screen.addstr('enter desired file name: ') #put this at the bottem
		$file_name = gets.chomp
		#should display this input on the screen
		$screen.setpos($screen.lines - 1,0)
		self.save
	end

	def open
		if $file_name then 
			aFile = File.open($file_name, 'r')
			aFile.each_line do |line|
				$body.addstr(line)
			end 
			aFile.close if aFile
		end
	end
end
