class Buffer_mod
	@@line_buffer = ''
	def kill_line
		#get the current line and store it in the class var before deliting
	end

	def unkill_line
		#esc + u
	end

	def find
		#esc + f
	end 

	def whitespace? (char)
		if char.ord == 32 || char.ord == 0 || char.ord == 9 then
			true
		else
			false
		end 
	end

end
