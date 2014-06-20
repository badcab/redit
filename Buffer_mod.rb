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













	def end_of_line_x_pos(x = $body.maxx, y = $body.cury)
		
	
		$body.setpos(y, x)
		current_char = $body.inch.ord 

#puts current_char
#$body.addstr(current_char.to_s.concat("-#{x}:"))
#print "#{current_char.to_s}-#{x}:"
#problem seems to be this is not working, x is not dropping like I would expect, might be due to overwriting text or something

		if current_char == 32 || current_char == 0  then #ascii space and null
			self.end_of_line_x_pos(x - 1, y)
		else
			x
		end
	end

end
