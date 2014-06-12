#!/usr/local/bin/ruby
class File_operation
	def save
#if no $file_name then run create
		aFile = File.new($file_name, 'w')
		$buffer.gsub '    ', "\t"
		aFile.syswrite($buffer) if aFile
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
		#if file name not set then this should return nil
		aFile = File.open($file_name, 'r')
		aFile.each_line do |line|
			$buffer += line  
		end
		$buffer.gsub '    ', "\t"
		aFile.close if aFile
		$saved_buffer = $buffer
	end
end

BEGIN {
	argv = ARGF.argv[0].to_s
	$buffer = '';
	$saved_buffer = $buffer
	if argv.length > 0 then
		$file_name = argv 
	else
		$file_name = false
	end
}

	fo = File_operation.new
	
	
		if File.file?($file_name) then
			fo.open
		end  
	
	


END{
	
}




# ctrl + s should save
# if no file passed then a prompt should ask for file name
# ctrl + c or ctrl + q should quit

#auto convert spaces to tabs
