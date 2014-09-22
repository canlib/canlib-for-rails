# http://easyramble.com/escape-like-on-rails-active-record.html

module ActiveRecord
	class Base
		def self.escape_like(string)
			string.gsub(/[\\%_]/){|m| "\\#{m}"}
		end
	end
end
