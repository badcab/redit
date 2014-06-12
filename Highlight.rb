class Highlight
	@@language = '';
	def initialize
		#get the file ext from the edit file
		#check if it is php rb shell
	end
	
	def run
		if @@language == 'php' then
			self.php
		elsif @@language == 'rb' then
			self.ruby
		elsif @@language == 'sh' then
			self.sh
		end
	end
	
	private
	def php
		#set php highlighting
	end
	
	private
	def ruby
		#set ruby highlighting
	end
	
	private
	def shell
		#set sh highlighting
	end

end
