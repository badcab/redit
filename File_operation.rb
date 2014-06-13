class File_operation
	def save
		if !$file_name then
			self.create
		end
		aFile = File.new($file_name, 'w')
		result = '';
		$buffer.each do |line|
			line.each do |char|
				result += char.to_s
			end
			result += "\n"
		end
		aFile.syswrite(result) if aFile
		$saved_buffer = $buffer
		aFile.close if aFile
	end

	def create 
		$screen.addstr('enter desired file name: ') #put this at the bottem
		$file_name = gets.chomp
		#should display this input on the screen
		$screen.setpos($screen.lines - 1,0)
		self.save
	end

	def exit
		if $saved_buffer != $buffer then
			print 'unsaved content save? [y/n]: '
			if gets.chomp.downcase.strip.chars.first != 'n' then
				self.save
			end
		end
		exit
	end

	def open
		$buffer = Array.new
		if $file_name then
#need to do a check if the file exists
#there might be some path issues
			aFile = File.open($file_name, 'r')
			i = 0
			aFile.each_line do |line|
				$buffer[i] = Array.new
				$buffer[i] = line.split(//)
				i +=1
			end

			aFile.close if aFile
			
		end
		$saved_buffer = $buffer
	end
end
