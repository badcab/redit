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

	def go_to_line
		#esc + g
		#will set the current possition to the set row
	end

	def whitespace? (char)
		if char.ord == 32 || char.ord == 0 || char.ord == 9 then
			true
		else
			false
		end
	end

	def end_of_line_x_pos
		#get curr y on $body
		#recurse backward walking over white space
			#do this using a loop
		#return value should be the int of the X at end of line
		25
	end

end
