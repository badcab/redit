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
	
	def clean
		# remove \r and convert spaces to tabs and the like
	end

end
