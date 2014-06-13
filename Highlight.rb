class Highlight
	@@language = '';
	def initialize
		if $file_name.class == String then
			@@language = $file_name.split(".").last
		end
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
