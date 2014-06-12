#!/usr/local/bin/ruby

#change $buffer to act as an array thus keeping things easer


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
		end
		$saved_buffer = $buffer
	end
end

class Buffer_mod
	@@line_buffer = ''
	def kill_line
		#ctrl - k
	end

	def unkill_line
		#ctrl + u
	end

	def find
		#ctrl + f
	end

	def indent
		#ctrl + i
	end

end

#need to add something for syntax highlighting

BEGIN {
	$current_line = 0;
	argv = ARGF.argv[0].to_s
	if argv.length > 0 then
		$file_name = argv
	else
		$file_name = false
	end
}

fo = File_operation.new
fo.open

#on ctrl + c || ctrl + q fo.exit

#on ctrl + s fo.save

#have menu on top of the screen with cmd that can be entered

#have rest of the screen be editable


END{

}
