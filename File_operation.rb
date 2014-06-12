class File_operation
	def save
		if !$file_name then
			self.create
		end
		aFile = File.new($file_name, 'w')

		result = '';
		$buffer.each do |line|
			line.gsub '    ', "\t"
			#strip coloring and other garbage
			result += line
		end

		aFile.syswrite(result) if aFile
#check for exceptions
		$saved_buffer = $buffer

		aFile.close if aFile
	end

	def create
		print 'enter desired file name: '
		$file_name = gets.chomp
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
		if $file_name then
			aFile = File.open($file_name, 'r')
			$buffer = aFile.each_line
			aFile.close if aFile
		else
			$buffer = Array.new
		end
		$saved_buffer = $buffer
	end
end
