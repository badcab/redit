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
		if char.ord == 32 then
			true
		else
			false
		end
	end

	def end_of_line_x_pos(y = $body.cury, x = $body.maxx)
		while x > 0 do
			$body.setpos(y, x)
			current_char = $body.inch.ord 
			if current_char == 32 || current_char == 0  then #ascii space and null 
				x -= 1
			else 
				break
			end
		end
		x
	end

end
